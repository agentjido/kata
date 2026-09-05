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

    baseline_results =
      if command == "tune",
        do: Enum.map(cases.train ++ cases.validation ++ cases.test, &evaluate(ctx, baseline, &1)),
        else: [baseline_result]

    report = Store.report(ctx, baseline, best, results, baseline_results)

    if command == "tune" do
      path = Path.join(ctx.dir, "search-#{ctx.key}.json")

      Store.write(
        path,
        Store.read(path) |> Map.put("pending", false) |> Map.put("selected", best)
      )
    end

    report
  end

  def check(opts \\ []) do
    profile = opts[:profile]
    if profile, do: Store.profile(profile)
    scope = profile || "**"
    records = Path.wildcard(Path.join(root(), "results/setup/#{scope}/cases/*.json"))

    for path <- records do
      result = Store.read(path) |> Store.recheck()
      IO.puts("#{Path.basename(path)}: #{result["status"]}, #{result["feedback"]}")
    end

    %{records: length(records), mode: "offline; rechecks saved outcomes, no model calls"}
  end

  def tune(ctx, baseline, baseline_result, attempts) do
    path = Path.join(ctx.dir, "search-#{ctx.key}.json")
    state = if File.exists?(path), do: Store.read(path), else: %{"proposals" => []}
    count = length(state["proposals"])

    target =
      if state["pending"],
        do: state["target_proposals"] || count + attempts - 1,
        else: count + attempts

    state = Map.merge(state, %{"target_proposals" => target, "pending" => true})
    Store.write(path, state)

    # Recheck saved training evidence; resume the same budget after an interruption.
    {best, result, proposals} =
      Enum.reduce(state["proposals"], {baseline, baseline_result, []}, fn proposal,
                                                                          {best, result, done} ->
        {best, result, proposal} = compare(ctx, proposal, best, result)
        {best, result, done ++ [proposal]}
      end)

    state = Map.put(state, "proposals", proposals)
    Store.write(path, state)

    {best, _result, _state} =
      Enum.reduce(List.duplicate(:attempt, max(target - count, 0)), {best, result, state}, fn _,
                                                                                              {best,
                                                                                               result,
                                                                                               state} ->
        round = length(state["proposals"]) + 1
        IO.puts("Tuning round #{round}/#{target}")
        feedback = training_feedback(ctx, state, result)
        {candidate, metrics} = propose(ctx, best, feedback)
        proposal = %{"parent" => best, "candidate" => candidate, "metrics" => metrics}
        state = Map.update!(state, "proposals", &(&1 ++ [proposal]))
        Store.write(path, state)

        {best, result, proposal} = compare(ctx, proposal, best, result)
        state = Map.update!(state, "proposals", &List.replace_at(&1, -1, proposal))
        Store.write(path, state)
        IO.puts("Round #{round}: #{proposal["decision"]}")
        {best, result, state}
      end)

    best
  end

  defp compare(ctx, proposal, best, result) do
    candidate = proposal["candidate"]

    cond do
      Skill.validate(Store.text(ctx, candidate)) != :ok ->
        {best, result, Map.put(proposal, "decision", "invalid")}

      candidate == best ->
        {best, result, Map.put(proposal, "decision", "unchanged")}

      true ->
        observed = evaluate(ctx, candidate, hd(Fixture.cases().train))

        if better?(observed, result),
          do: {candidate, observed, Map.put(proposal, "decision", "kept")},
          else: {best, result, Map.put(proposal, "decision", "rejected")}
    end
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
      The runner sets optimized_for metadata to the active profile after this edit.
      Keep the scope and safeguards: inspect first, preserve instructions and local edits,
      fixed consumers, collision-safe moves, relative links, intake provenance, and safe repeats.
      Do not add fixture-specific paths or test-specific rules. Do not run setup here.
      Write the complete replacement to SKILL.md. No JSON response is required.
      """

      case ctx.execute.(limits(ctx), prompt, workspace) do
        {:ok, %{metrics: metrics}} ->
          text = File.read!(Path.join(workspace, "SKILL.md")) |> Skill.mark_optimized(ctx.profile)
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
