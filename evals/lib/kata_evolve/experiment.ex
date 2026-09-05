defmodule KataEvolve.Experiment do
  @moduledoc "Finite skill experiments with immutable evidence and fixed references."
  alias KataEvolve.{
    Access,
    Evidence,
    Harness,
    Skill,
    Profile,
    Suite,
    Score,
    Assessment,
    Usage,
    Proposal
  }

  def context(module, suite_path, opts \\ []) do
    spec = module.spec()
    profile_name = opts[:profile] || Profile.default()
    profile = Profile.fetch!(profile_name)
    {cli_version, 0} = System.cmd(profile.provider_options.cli_path, ["--version"])
    source = File.read!(spec.source)

    harness = Mix.Project.deps_paths()[:jido_harness]

    identity = %{
      runner: "skill-experiment-v3",
      profile_name: profile_name,
      suite: spec.id,
      source: Skill.hash(source),
      contract: execution_contract(module),
      cases: spec.cases,
      prompts: Map.new(spec.cases, &{&1.id, module.prompt(&1)}),
      profile: profile,
      cli: String.trim(cli_version),
      harness: Evidence.fingerprint([Path.join(harness, "lib")]),
      runner_code:
        Evidence.portable_fingerprint(
          Enum.map(
            ~w(access.ex answer.ex harness.ex metrics.ex evidence.ex experiment.ex),
            &Path.join(__DIR__, &1)
          ) ++
            [Path.join(KataEvolve.root(), "mix.lock")],
          KataEvolve.root()
        ),
      execution: %{
        limit_ms: profile.runtime_timeout_ms,
        host_config: "ignored; fresh CODEX_HOME auth-only; outer macOS access rules"
      },
      runtimes: %{
        elixir: System.version(),
        otp: to_string(:erlang.system_info(:otp_release)),
        path: System.get_env("PATH"),
        os: inspect(:os.type())
      }
    }

    id = Evidence.identity(identity)
    dir = results_dir(module, opts)
    path = Path.join(dir, "contexts/#{id}.json")
    unless File.exists?(path), do: Evidence.write_new!(path, identity)

    ctx = %{
      module: module,
      id: id,
      dir: dir,
      profile: profile,
      source: source,
      identity: identity,
      assessment: Assessment.identity(module, suite_path),
      retry_errors: opts[:retry_errors] == true,
      limits: limits(opts)
    }

    save_skill(ctx, source)
    IO.puts("Context #{id}; results #{dir}")
    ctx
  end

  def run(module, path, command, opts) do
    unless command in ~w(baseline train tune verify score check status),
      do: raise(ArgumentError, "Use baseline, train, tune, verify, score, check or status")

    unless (opts[:attempts] || 5) in 1..5,
      do: raise(ArgumentError, "Use 1–5 proposal rounds")

    if command == "verify" and not is_binary(opts[:candidate]),
      do: raise(ArgumentError, "verify requires --candidate PATH")

    if command == "score" and not is_binary(opts[:batch]),
      do: raise(ArgumentError, "score requires --batch NAME")

    if command not in ~w(score check status) and opts[:context],
      do: raise(ArgumentError, "--context selects saved evidence for check or score only")

    cond do
      command == "status" ->
        dir = opts[:results] || results_dir(module, opts)
        Usage.summary(dir, opts[:context] || "*")

      command == "check" and opts[:record] ->
        # Diagnostic replay works for old contexts too. It grants no score or reuse permission.
        ctx = %{
          module: module,
          dir: results_dir(module, opts),
          assessment: Assessment.identity(module, path)
        }

        r = Assessment.read!(ctx, opts[:record])
        [%{path: opts[:record], outcome: r["outcome_test"], assessment: r["assessment"]}]

      true ->
        ctx =
          if command in ~w(check score),
            do: saved_context(module, path, opts),
            else: context(module, path, opts)

        dispatch(ctx, command, opts)
    end
  end

  defp dispatch(ctx, command, opts) do
    case command do
      name when name in ["baseline", "train"] ->
        batch(ctx, ctx.source, "source-train", :train, 1)

      "verify" ->
        verify(ctx, File.read!(Keyword.fetch!(opts, :candidate)), opts)

      "tune" ->
        batch(ctx, ctx.source, "source-train", :train, 1)
        tune(ctx, opts[:attempts] || 5)

      "score" ->
        score_batch(ctx, Keyword.fetch!(opts, :batch), opts[:reference] || "source-full", :all, 3)

      "check" ->
        (Path.wildcard(Path.join(ctx.dir, "batches/#{ctx.id}/*/cases/*.json")) ++
           Path.wildcard(Path.join(ctx.dir, "batches/#{ctx.id}/*/retries/*/*.json")))
        |> Enum.map(fn p ->
          r = Assessment.read!(ctx, p)
          %{path: p, outcome: r["outcome_test"], assessment: r["assessment"]}
        end)
    end
  end

  def verify(ctx, text, opts \\ []) do
    unless Suite.validate(ctx.module, text) == :ok and Skill.words(text) <= 500,
      do: raise("Candidate must be valid and at most 500 words before verification")

    if text == ctx.source, do: raise("No changed candidate to verify")
    require_reference!(ctx, "source-train", :train, 1)
    hash = Skill.hash(text)
    # Reuse the selected training evidence, or screen an externally supplied candidate once.
    training =
      Path.wildcard(Path.join(ctx.dir, "batches/#{ctx.id}/*/batch.json"))
      |> Enum.find(fn p ->
        m = Evidence.read(p)

        m["skill"] == hash and m["case_ids"] == Enum.map(cases(ctx, :train), & &1.id) and
          m["repetitions"] == 1
      end)

    train_name =
      if training,
        do: Path.basename(Path.dirname(training)),
        else: "screen-#{String.slice(hash, 0, 12)}"

    unless training, do: batch(ctx, text, train_name, :train, 1)
    score = score_batch(ctx, train_name, "source-train", :train, 1)

    unless score.eligible and score.score_units > 50_000_000,
      do: raise("No measured training improvement; skip full verification")

    name = opts[:batch] || "candidate-full-#{String.slice(hash, 0, 12)}"
    # Once final cases are opened, this search must not propose more candidates.
    seal = Path.join(ctx.dir, "search/#{ctx.id}/verification.json")
    unless File.exists?(seal), do: Evidence.write_new!(seal, %{candidate: hash, batch: name})

    unless Evidence.read(seal) == %{"candidate" => hash, "batch" => name},
      do:
        raise(
          "Verification candidate and batch are fixed; resume that batch or use a new benchmark"
        )

    batch(ctx, ctx.source, "source-full", :all, 3)
    batch(ctx, text, name, :all, 3)
    score_batch(ctx, name, "source-full", :all, 3)
  end

  def batch(ctx, text, name, split, repetitions) do
    unless Regex.match?(~r/\A[a-zA-Z0-9_-]+\z/, name), do: raise("Invalid batch name")
    save_skill(ctx, text)
    items = cases(ctx, split)
    dir = batch_dir(ctx, name)

    manifest = %{
      context: ctx.id,
      skill: Skill.hash(text),
      case_ids: Enum.map(items, & &1.id),
      repetitions: repetitions
    }

    manifest_path = Path.join(dir, "batch.json")

    if File.exists?(manifest_path) do
      unless Evidence.read(manifest_path) == Evidence.json(manifest),
        do: raise("Batch identity changed")
    else
      Evidence.write_new!(manifest_path, manifest)
    end

    for rep <- 1..repetitions, item <- items do
      base = Path.join(dir, "cases/#{item.id}-#{rep}.json")
      path = latest_attempt!(base)

      if File.exists?(path) do
        record = Assessment.read!(ctx, path)

        record =
          if Map.get(ctx, :retry_errors, false) and retryable?(record) do
            retry_dir = retry_dir(base)
            number = length(Path.wildcard(Path.join(retry_dir, "*.json"))) + 1
            dest = Path.join(retry_dir, "#{String.pad_leading(to_string(number), 6, "0")}.json")

            retried =
              execute_case(ctx, text, item, rep) |> Map.put("retry_of", record["execution_id"])

            Evidence.write_new!(dest, retried)
            Assessment.read!(ctx, dest)
          else
            record
          end

        stop_if_needed!(record, name)
        record
      else
        IO.puts("Live #{name}: #{item.id} repetition #{rep}")
        record = execute_case(ctx, text, item, rep)
        Evidence.write_new!(base, record)
        record = Assessment.read!(ctx, base)
        IO.puts("Saved #{path}: #{record["outcome_test"]["status"]}")
        stop_if_needed!(record, name)

        record
      end
    end
  end

  def execute_case(ctx, text, item, rep) do
    workspace(fn project, runtime ->
      ctx.module.prepare(project, item)
      Suite.package!(ctx.module, project, text)
      initial = Evidence.take(project)

      prompt =
        "Use #{ctx.module.spec().id}. Read .agents/skills/#{ctx.module.spec().id}/SKILL.md.\n" <>
          ctx.module.prompt(item)

      execute = Map.get(ctx, :execute, &call/5)
      execution_id = random_id()

      result =
        invoke(ctx, execution_id, "case", fn ->
          execute.(ctx.profile, prompt, project, runtime, item.writable)
        end)

      {status, output} =
        case result do
          {:ok, output} ->
            {"completed", output}

          {:error, error} ->
            {"error", if(is_map(error), do: error, else: %{error: inspect(error)})}
        end

      record =
        %{
          "case_id" => item.id,
          "context" => ctx.id,
          "skill" => Skill.hash(text),
          "execution_id" => execution_id,
          "harness_run_id" => output[:run_id],
          "repetition" => rep,
          "recorded_at" => DateTime.to_iso8601(DateTime.utc_now()),
          "status" => status,
          "answer" => output[:answer] || "",
          "answer_complete" => output[:answer_complete] == true,
          "answer_capture" => output[:answer_capture],
          "metrics" => output[:metrics],
          "error" =>
            if(status == "error", do: inspect(output[:error] || output[:status]), else: nil),
          "initial" => initial,
          "final" => Evidence.take(project),
          "workspace_path" => project,
          "workspace" => project
        }
        |> Evidence.json()
        |> then(&Suite.recheck(ctx.module, &1))

      Map.delete(record, "workspace")
    end)
  end

  def score_batch(ctx, candidate_name, reference_name, split, repetitions) do
    candidate = load_batch(ctx, candidate_name)
    reference = load_batch(ctx, reference_name)
    protocol = protocol(ctx, split, repetitions)

    result =
      Score.calculate(candidate, reference, protocol, &Suite.validate(ctx.module, &1))
      |> Map.merge(%{
        candidate: Skill.hash(candidate.text),
        reference: Skill.hash(reference.text),
        input_hashes: %{
          candidate: Score.input_hashes(candidate.records),
          reference: Score.input_hashes(reference.records)
        }
      })

    path = Path.join(ctx.dir, "scores/#{Evidence.identity(result)}.json")
    unless File.exists?(path), do: Evidence.write_new!(path, result)
    IO.puts("Score #{candidate_name}: #{inspect(result.score)}; #{path}")
    result
  end

  def tune(ctx, attempts) when attempts in 1..5 do
    if File.exists?(Path.join(ctx.dir, "search/#{ctx.id}/verification.json")),
      do: raise("Verification has started. No further proposals for these final cases.")

    freeze_search!(ctx)
    require_reference!(ctx, "source-train", :train, 1)
    reference = load_batch(ctx, "source-train")
    protocol = protocol(ctx, :train, 1)
    initial = %{text: ctx.source, score: 50_000_000, records: reference.records}

    Enum.reduce_while(1..attempts, initial, fn round, parent ->
      path = Path.join(ctx.dir, "search/#{ctx.id}/round-#{round}.json")

      if File.exists?(path) do
        saved = Evidence.read(path)

        cond do
          saved["decision"] == "unchanged" ->
            {:cont, parent}

          saved["decision"] == "kept" ->
            data = load_batch(ctx, saved["training_batch"])
            {:cont, %{text: data.text, records: data.records, score: saved["score_units"]}}

          true ->
            {:cont, parent}
        end
      else
        {history, previous} = proposal_history(ctx, round)
        feedback = Proposal.feedback(ctx, parent, reference, previous, history, round)
        proposal = propose(ctx, parent.text, previous, feedback, round)
        candidate = proposal["candidate"]
        validation = Suite.validate(ctx.module, candidate)
        valid = validation == :ok and Skill.words(candidate) <= 500

        training_batch = "training-#{String.slice(Skill.hash(candidate), 0, 16)}"

        data =
          if valid and candidate != parent.text do
            records = batch(ctx, candidate, training_batch, :train, 1)
            %{text: candidate, records: records}
          end

        score =
          if data,
            do: Score.calculate(data, reference, protocol, &Suite.validate(ctx.module, &1))

        keep = score && score.eligible && score.score_units > parent.score

        reason =
          cond do
            candidate == parent.text -> "No change for this approach"
            validation != :ok -> elem(validation, 1)
            Skill.words(candidate) > 500 -> "Candidate exceeds 500 words after metadata"
            keep -> "Training cost improved"
            score -> score[:reason] || "Training cost did not beat the parent"
            true -> "Candidate was not evaluated"
          end

        Evidence.write_new!(path, %{
          reason: reason,
          parent: Skill.hash(parent.text),
          approach: feedback.search_approach.id,
          outcome_contract: feedback.outcome_contract.sha256,
          candidate: Skill.hash(candidate),
          decision:
            cond do
              candidate == parent.text -> "unchanged"
              keep -> "kept"
              true -> "rejected"
            end,
          score_units: if(score, do: score.score_units),
          score: score,
          training_batch: if(data, do: training_batch),
          proposal_record: "proposal-#{round}.json"
        })

        cond do
          candidate == parent.text -> {:cont, parent}
          keep -> {:cont, %{text: candidate, records: data.records, score: score.score_units}}
          true -> {:cont, parent}
        end
      end
    end)
    |> then(fn selected ->
      %{
        context: ctx.id,
        candidate_path: save_skill(ctx, selected.text),
        sha256: Skill.hash(selected.text),
        words: Skill.words(selected.text),
        training_score_units: selected.score,
        improved: selected.text != ctx.source,
        stop_reason: Map.get(selected, :stop_reason),
        full_verification_required: selected.text != ctx.source
      }
    end)
  end

  defp propose(ctx, parent, previous, feedback, round) do
    path = Path.join(ctx.dir, "search/#{ctx.id}/proposal-#{round}.json")

    if File.exists?(path) do
      saved = Evidence.read(path)

      unless saved["status"] == "completed" and saved["allowed_changes"] == true,
        do: raise("Failed proposal is immutable; end this experiment or start a new series")

      unless saved["parent"] == Skill.hash(parent) and
               saved["feedback"] == Evidence.json(feedback),
             do: raise("Saved proposal inputs differ; do not reuse it")

      saved
    else
      policy = freeze_search!(ctx)

      workspace(fn project, runtime ->
        File.write!(Path.join(project, "SKILL.md"), parent)
        File.write!(Path.join(project, "reference.md"), ctx.source)
        if previous, do: File.write!(Path.join(project, "previous.md"), previous.text)
        File.write!(Path.join(project, "feedback.json"), Jason.encode!(feedback, pretty: true))
        initial = Evidence.files(project)

        execute = Map.get(ctx, :execute, &call/5)
        execution_id = random_id()

        result =
          invoke(ctx, execution_id, "proposal", fn ->
            execute.(ctx.profile, policy.proposal.prompt, project, runtime, ["SKILL.md"])
          end)

        final = Evidence.files(project)
        raw = File.read!(Path.join(project, "SKILL.md"))
        text = if raw == parent, do: parent, else: Suite.stamp(raw, ctx.profile)

        {status, output} =
          case result do
            {:ok, out} -> {"completed", out}
            {:error, out} -> {"error", if(is_map(out), do: out, else: %{error: inspect(out)})}
          end

        preserved = Map.delete(initial, "SKILL.md") == Map.delete(final, "SKILL.md")

        record = %{
          parent: Skill.hash(parent),
          feedback: feedback,
          prompt_sha256: Skill.hash(policy.proposal.prompt),
          candidate: text,
          candidate_sha256: Skill.hash(text),
          status: status,
          allowed_changes: preserved,
          metrics: output[:metrics],
          answer: output[:answer],
          answer_complete: output[:answer_complete],
          error: output[:error],
          execution_id: execution_id
        }

        Evidence.write_new!(path, record)
        unless status == "completed" and preserved, do: raise("Proposal failed; retained #{path}")
        save_skill(ctx, text)
        Evidence.json(record)
      end)
    end
  end

  defp proposal_history(_ctx, 1), do: {[], nil}

  defp proposal_history(ctx, round) do
    history =
      for number <- 1..(round - 1) do
        dir = Path.join(ctx.dir, "search/#{ctx.id}")
        decision = Evidence.read(Path.join(dir, "round-#{number}.json"))
        proposal = Evidence.read(Path.join(dir, "proposal-#{number}.json"))

        Map.merge(decision, %{
          "round" => number,
          "note" => String.slice(proposal["answer"] || "", 0, 600)
        })
      end

    last = List.last(history)
    text = File.read!(Path.join(ctx.dir, "skills/#{last["candidate"]}.md"))

    records =
      if last["training_batch"], do: load_batch(ctx, last["training_batch"]).records, else: []

    {history, %{text: text, records: records}}
  end

  defp require_reference!(ctx, name, split, reps) do
    data = load_batch(ctx, name)
    p = protocol(ctx, split, reps)

    unless data.text == ctx.source and Suite.validate(ctx.module, data.text) == :ok and
             Score.complete?(data, p) and Score.passing?(data.records, p) and
             Enum.all?(data.records, &Score.metrics?/1),
           do:
             raise("#{name} must have complete passing source outcomes and metrics before search")
  end

  def load_batch(ctx, name) do
    dir = batch_dir(ctx, name)
    manifest = Evidence.read(Path.join(dir, "batch.json"))
    text = File.read!(Path.join(ctx.dir, "skills/#{manifest["skill"]}.md"))

    records =
      Path.wildcard(Path.join(dir, "cases/*.json"))
      |> Enum.map(&(latest_attempt!(&1) |> then(fn p -> Assessment.read!(ctx, p) end)))

    %{text: text, records: records}
  end

  defp protocol(ctx, split, repetitions) do
    ids = Enum.map(cases(ctx, split), & &1.id)

    %{
      context: ctx.id,
      assessment: Map.get(ctx, :assessment, "test"),
      case_ids: ids,
      checks: Map.take(Suite.checks(ctx.module), ids),
      repetitions: repetitions
    }
  end

  defp cases(ctx, :all), do: ctx.module.spec().cases
  defp cases(ctx, split), do: Enum.filter(cases(ctx, :all), &(&1.split == split))
  defp batch_dir(ctx, name), do: Path.join(ctx.dir, "batches/#{ctx.id}/#{name}")

  defp save_skill(ctx, text) do
    path = Path.join(ctx.dir, "skills/#{Skill.hash(text)}.md")
    unless File.exists?(path), do: Evidence.write_new!(path, text)
    path
  end

  defp call(profile, prompt, project, runtime, writable) do
    {wrapper, env} = Access.prepare(runtime, project, writable, profile.provider_options.cli_path)

    profile
    |> put_in([:provider_options, :cli_path], wrapper)
    |> Map.merge(%{
      sandbox_mode: :unrestricted,
      env: env,
      system_prompt:
        "Use simple technical English. Read only the supplied project and skill package. Do not use other skills or delegate. Return your answer in the final response."
    })
    |> Harness.execute(prompt, project)
  end

  defp saved_context(module, suite_path, opts) do
    profile_name = opts[:profile] || Profile.default()
    Profile.fetch!(profile_name)
    spec = module.spec()
    dir = results_dir(module, opts)

    id =
      opts[:context] ||
        raise ArgumentError, "check and score require --context ID from a saved run"

    unless Regex.match?(~r/\A[0-9a-f]{64}\z/, id),
      do: raise(ArgumentError, "Use the complete saved context ID")

    identity = Evidence.read(Path.join(dir, "contexts/#{id}.json"))

    matches =
      if identity["runner"] == "skill-experiment-v3" do
        identity["contract"] == Evidence.json(execution_contract(module))
      else
        inputs =
          [Path.expand(suite_path) | spec.inputs] ++
            Enum.map(spec.support, &Path.join(Path.dirname(spec.source), &1))

        identity["inputs"] == Evidence.fingerprint(Enum.uniq(inputs)) and
          identity["checks"] == Evidence.json(Suite.checks(module))
      end

    unless identity["suite"] == spec.id and identity["profile_name"] == profile_name and matches,
      do:
        raise(
          ArgumentError,
          "Saved execution inputs differ. Use check --record PATH for diagnostic replay; do not reuse costs."
        )

    source = File.read!(Path.join(dir, "skills/#{identity["source"]}.md"))

    unless Skill.hash(source) == identity["source"],
      do: raise(ArgumentError, "Saved source hash does not match the context")

    %{
      module: module,
      id: id,
      dir: dir,
      source: source,
      identity: identity,
      assessment: Assessment.identity(module, suite_path)
    }
  end

  def execution_contract(module) do
    spec = module.spec()

    inputs =
      Map.get(spec, :execution_inputs) ||
        raise ArgumentError,
              "Declare execution_inputs: fixture data and preparation code, separate from checks"

    support = Enum.map(spec.support, &Path.join(Path.dirname(spec.source), &1))

    %{
      cases: spec.cases,
      prompts: Map.new(spec.cases, &{&1.id, module.prompt(&1)}),
      inputs: Evidence.portable_fingerprint(inputs ++ support, Path.dirname(KataEvolve.root()))
    }
  end

  defp results_dir(module, opts),
    do:
      opts[:results] ||
        Path.join(
          KataEvolve.root(),
          "results/#{module.spec().id}/#{opts[:profile] || Profile.default()}"
        )

  defp limits(opts) do
    limits = %{calls: opts[:max_calls] || 30, tokens: opts[:max_tokens] || 2_000_000}

    unless Enum.all?(limits, fn {_, v} -> is_integer(v) and v > 0 end),
      do: raise("Budgets must be positive integers")

    limits
  end

  defp invoke(ctx, id, kind, fun) do
    Usage.start!(ctx, id, kind)
    result = fun.()
    Usage.finish!(ctx, id, result)
    result
  end

  defp stop_if_needed!(record, name) do
    status = record["outcome_test"]["status"]

    cond do
      status in ~w(execution_error capture_error checker_error review) ->
        raise("#{status}: saved evidence needs diagnosis; no automatic retries")

      status == "passed" and not Score.metrics?(record) ->
        raise("Missing or invalid metrics; diagnose before more calls")

      status != "passed" and not Regex.match?(~r/\A(?:training-|screen-)/, name) ->
        raise(
          "Source outcome failed or verification failed; saved immutable evidence. Diagnose before more calls."
        )

      true ->
        :ok
    end
  end

  defp retryable?(record), do: record["status"] == "error" or record["answer_complete"] != true

  defp retry_dir(base),
    do: Path.join([Path.dirname(Path.dirname(base)), "retries", Path.basename(base, ".json")])

  defp latest_attempt!(base) do
    attempts = Path.wildcard(Path.join(retry_dir(base), "*.json")) |> Enum.sort()

    Enum.reduce(attempts, base, fn next, previous ->
      old = Evidence.read(previous)
      new = Evidence.read(next)

      unless retryable?(old) and new["retry_of"] == old["execution_id"] and
               Map.take(old, ~w(case_id repetition skill context)) ==
                 Map.take(new, ~w(case_id repetition skill context)),
             do: raise("Invalid retry chain; completed outcomes cannot be replaced")

      next
    end)
  end

  defp freeze_search!(ctx) do
    path = Path.join(ctx.dir, "search/#{ctx.id}/policy.json")

    policy = %{
      assessment: Map.get(ctx, :assessment, "test"),
      proposal: Proposal.policy(ctx.module),
      score: Score.version()
    }

    unless File.exists?(path), do: Evidence.write_new!(path, policy)

    unless Evidence.read(path) == Evidence.json(policy),
      do:
        raise(
          "Search checks changed, or the proposal prompt/feedback builder changed. Inspect saved evidence; do not restart live search automatically."
        )

    policy
  end

  defp workspace(fun) do
    base = Path.join(System.tmp_dir!(), "kata-eval-#{random_id()}")
    project = Path.join(base, "project")
    runtime = Path.join(base, "runtime")
    File.mkdir_p!(project)
    File.mkdir_p!(runtime)

    try do
      fun.(project, runtime)
    after
      File.rm_rf!(base)
    end
  end

  defp random_id, do: :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
end
