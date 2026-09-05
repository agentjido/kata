defmodule KataEvolve do
  @moduledoc "One resumable, feedback-driven loop for kata-setup."
  alias KataEvolve.{Fixture, Skill, Snapshot, Store}

  def root, do: Path.expand("..", __DIR__)

  def run(command, opts \\ []) do
    ctx = Store.context(opts)
    baseline = Store.skill(ctx, ctx.seed)
    baseline_result = evaluate(ctx, baseline, hd(Fixture.cases().train))

    best =
      if command == "tune",
        do: tune(ctx, baseline, baseline_result, opts[:attempts] || 1),
        else: baseline

    cases = Fixture.cases()

    results =
      if command == "tune",
        do: Enum.map(cases.train ++ cases.validation ++ cases.test, &evaluate(ctx, best, &1)),
        else: [baseline_result]

    report = Store.report(ctx, baseline, best, results)

    if command == "tune" do
      path = Path.join(ctx.dir, "search-#{ctx.key}.json")

      Store.write(
        path,
        Store.read(path) |> Map.put("pending", false) |> Map.put("selected", best)
      )
    end

    report
  end

  def check do
    records = Path.wildcard(Path.join(root(), "results/setup/cases/*.json"))

    for path <- records do
      result = Store.read(path) |> Store.recheck()
      IO.puts("#{Path.basename(path)}: #{result["status"]}, #{result["feedback"]}")
    end

    %{records: length(records), mode: "offline; rechecks saved outcomes, no model calls"}
  end

  def tune(ctx, baseline, baseline_result, attempts) do
    path = Path.join(ctx.dir, "search-#{ctx.key}.json")
    state = if File.exists?(path), do: Store.read(path), else: %{"proposals" => []}
    pending = state["pending"] == true

    # Recheck saved training evidence before selecting a parent.
    {best, result} =
      Enum.reduce(state["proposals"], {baseline, baseline_result}, fn proposal, {best, result} ->
        candidate = proposal["candidate"]

        if Skill.validate(Store.text(ctx, candidate)) == :ok do
          observed = evaluate(ctx, candidate, hd(Fixture.cases().train))
          if better?(observed, result), do: {candidate, observed}, else: {best, result}
        else
          {best, result}
        end
      end)

    # Completing a saved pending proposal counts as this invocation's first attempt.
    count = if pending, do: attempts - 1, else: attempts
    Store.write(path, state)

    {best, _result, _state} =
      Enum.reduce_while(List.duplicate(:attempt, max(count, 0)), {best, result, state}, fn _,
                                                                                           {best,
                                                                                            result,
                                                                                            state} ->
        feedback = training_feedback(ctx, state, result)
        {candidate, metrics} = propose(ctx, best, feedback)
        proposal = %{"parent" => best, "candidate" => candidate, "metrics" => metrics}
        state = Map.update!(state, "proposals", &(&1 ++ [proposal])) |> Map.put("pending", true)
        Store.write(path, state)

        if Skill.validate(Store.text(ctx, candidate)) == :ok and candidate != best do
          observed = evaluate(ctx, candidate, hd(Fixture.cases().train))
          improved = better?(observed, result)

          IO.puts(
            if improved,
              do: "Keep shorter passing candidate.",
              else: "Reject candidate; keep parent."
          )

          if improved,
            do: {:cont, {candidate, observed, state}},
            else: {:halt, {best, result, state}}
        else
          IO.puts("Reject unchanged or invalid proposal.")
          {:halt, {best, result, state}}
        end
      end)

    best
  end

  def better?(candidate, parent) do
    candidate["status"] == "completed" and Enum.all?(candidate["checks"], &elem(&1, 1)) and
      (not Enum.all?(parent["checks"], &elem(&1, 1)) or
         candidate["skill_words"] < parent["skill_words"])
  end

  def evaluate(ctx, id, item) do
    path = Store.case_path(ctx, id, item.id)
    saved = if File.exists?(path), do: Store.read(path)

    reusable =
      saved && saved["status"] == "completed" &&
        (not ctx.fresh or saved["recorded_at"] >= ctx.started_at)

    if reusable do
      IO.puts("Reuse #{item.id}: #{id}")
      Store.recheck(saved)
    else
      skill = Store.text(ctx, id)
      IO.puts("Run #{item.id}: #{Skill.words(skill)} words")

      record =
        workspace(fn workspace ->
          initial = Fixture.prepare(workspace, item, skill, ctx.template)

          prompt =
            "Use kata-setup in this repository. Read .agents/skills/kata-setup/SKILL.md and its template. #{item.input} Complete setup and check the result."

          execution = ctx.execute.(limits(ctx), prompt, workspace)

          {status, metrics, error} =
            case execution do
              {:ok, %{metrics: metrics}} ->
                {"completed", metrics, nil}

              {:error, error} ->
                {"error", if(is_map(error), do: Map.get(error, :metrics)),
                 inspect(error, limit: 8, printable_limit: 1000)}
            end

          %{
            "case_id" => item.id,
            "skill" => id,
            "skill_words" => Skill.words(skill),
            "status" => status,
            "metrics" => metrics,
            "error" => error,
            "recorded_at" => DateTime.to_iso8601(DateTime.utc_now()),
            "context" => ctx.key,
            "initial" => initial,
            "final" => Snapshot.take(workspace)
          }
        end)
        |> Jason.encode!()
        |> Jason.decode!()
        |> Store.recheck()

      Store.write(path, record)

      if record["status"] == "error",
        do: raise("Codex execution failed; saved result. Run the same command to retry.")

      IO.puts(record["feedback"])
      record
    end
  end

  defp training_feedback(ctx, state, result) do
    previous = List.last(state["proposals"])

    path =
      if previous, do: Store.case_path(ctx, previous["candidate"], hd(Fixture.cases().train).id)

    last = if path && File.exists?(path), do: Store.read(path) |> Store.recheck()

    Enum.reject([result, last], &is_nil/1)
    |> Enum.uniq()
    |> Enum.map(&Map.take(&1, ~w(skill_words checks feedback metrics)))
  end

  defp propose(ctx, parent, feedback) do
    IO.puts("Propose a shorter skill.")

    workspace(fn workspace ->
      File.write!(Path.join(workspace, "SKILL.md"), Store.text(ctx, parent))
      File.write!(Path.join(workspace, "feedback.json"), Jason.encode!(feedback, pretty: true))

      prompt = """
      Edit only SKILL.md to improve this kata-setup skill. Read feedback.json for observed
      training checks and measurements. Use failures to correct behavior; otherwise shorten it.
      Aim for 200-500 words. A shorter intermediate version above 500 words is allowed.
      Keep name and description frontmatter and the templates/docs-agents.md reference.
      Keep the scope and safeguards: inspect first, preserve instructions and local edits,
      fixed consumers, collision-safe moves, relative links, intake provenance, and safe repeats.
      Do not add fixture-specific paths or test-specific rules. Do not run setup here.
      Write the complete replacement to SKILL.md. No JSON response is required.
      """

      case ctx.execute.(limits(ctx), prompt, workspace) do
        {:ok, %{metrics: metrics}} ->
          text = File.read!(Path.join(workspace, "SKILL.md"))
          {Store.skill(ctx, text), metrics}

        {:error, error} ->
          Store.write(Path.join(ctx.dir, "last-error.json"), %{
            stage: "proposal",
            error: inspect(error, limit: 8, printable_limit: 1000)
          })

          raise "Proposal call failed. Saved work is available; run the same command to retry."
      end
    end)
  end

  defp limits(ctx) do
    remaining = ctx.deadline - System.monotonic_time(:millisecond)

    if remaining <= 0,
      do: raise("Time budget reached. Saved work is available; run the same command to resume.")

    ctx.profile
    |> Map.update!(:runtime_timeout_ms, &min(&1, remaining))
    |> Map.update!(:idle_timeout_ms, &min(&1, remaining))
  end

  defp workspace(fun) do
    path = Path.join(System.tmp_dir!(), "kata-setup-#{System.os_time(:microsecond)}")
    File.mkdir_p!(path)

    try do
      fun.(path)
    after
      File.rm_rf!(path)
    end
  end
end
