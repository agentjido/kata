defmodule KataEvolve.Setup.Store do
  @moduledoc "Git-friendly skills, final files, measurements, and resumable proposals."
  alias KataEvolve.Harness
  alias KataEvolve.Setup.{Fixture, Skill}

  defdelegate profile(name), to: KataEvolve.Profile, as: :fetch!

  def context(opts) do
    root = KataEvolve.root()
    profile_name = opts[:profile] || "codex-astra-xhigh"
    profile = profile(profile_name)

    {cli, 0} = System.cmd(profile.provider_options.cli_path, ["--version"])
    seed = File.read!(Path.expand("../skills/kata-setup/SKILL.md", root))
    template = File.read!(Path.expand("../skills/kata-setup/templates/docs-agents.md", root))

    inputs =
      Path.wildcard(Path.join(root, "test/fixtures/setup/input/**/*"))
      |> Enum.filter(&File.regular?/1)

    harness_files =
      Path.wildcard(Path.join(Mix.Project.deps_paths()[:jido_harness], "lib/**/*.ex"))

    identity = %{
      "runner" => "setup-v3",
      "profile_name" => profile_name,
      "baseline" => Skill.hash(seed),
      "template" => Skill.hash(template),
      "inputs" => fingerprint(inputs),
      "profile" => profile,
      "cli" => String.trim(cli),
      "harness" => fingerprint(harness_files),
      "config_scope" =>
        "Normal Codex execution inherits host config. Refresh after changing that config."
    }

    dir = opts[:dir] || Path.join(root, "results/setup/#{profile_name}")
    key = save_context(dir, identity)

    %{
      dir: dir,
      key: key,
      seed: seed,
      template: template,
      profile: profile,
      profile_name: profile_name,
      execute: &Harness.execute/3,
      fresh: opts[:fresh] || false,
      started_at: DateTime.to_iso8601(DateTime.utc_now()),
      deadline: System.monotonic_time(:millisecond) + (opts[:minutes] || 30) * 60_000
    }
  end

  def save_context(dir, identity) do
    # JSON removes atom ordering differences between VM instances. Match old
    # records by content so their saved executions remain available.
    normalized = identity |> Jason.encode!() |> Jason.decode!()

    existing =
      Path.wildcard(Path.join(dir, "context-*.json"))
      |> Enum.find(&(read(&1) == normalized))

    if existing do
      existing |> Path.basename(".json") |> String.replace_prefix("context-", "")
    else
      key =
        normalized
        |> :erlang.term_to_binary([:deterministic])
        |> Skill.hash()
        |> String.slice(0, 12)

      write(Path.join(dir, "context-#{key}.json"), identity)
      key
    end
  end

  def skill(ctx, text) do
    id = Skill.hash(text) |> String.slice(0, 12)
    path = Path.join(ctx.dir, "skills/#{id}.md")
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, text)
    id
  end

  def text(ctx, id), do: File.read!(Path.join(ctx.dir, "skills/#{id}.md"))

  def case_path(ctx, id, case_id),
    do: Path.join(ctx.dir, "cases/#{ctx.key}-#{id}-#{case_id}.json")

  def read(path), do: path |> File.read!() |> Jason.decode!()

  def recheck(record) do
    cases = Fixture.cases()
    item = Enum.find(cases.train ++ cases.validation ++ cases.test, &(&1.id == record["case_id"]))
    initial = %{files: record["initial"]["files"], index: record["initial"]["index"]}
    final = %{files: record["final"]["files"], index: record["final"]["index"]}
    checked = Fixture.check_snapshot(final, item, initial)

    outcome =
      try do
        Fixture.assert_outcome!(checked)
        %{"framework" => "ExUnit", "case_id" => item.id, "status" => "passed"}
      rescue
        error in ExUnit.AssertionError ->
          %{
            "framework" => "ExUnit",
            "case_id" => item.id,
            "status" => "failed",
            "failure" => error.message
          }
      end

    Map.merge(record, %{
      "checks" => checked.checks,
      "feedback" => checked.feedback,
      "outcome_test" => outcome
    })
  end

  def report(ctx, baseline, best, records, baseline_records \\ nil) do
    text = text(ctx, best)

    passed =
      Enum.all?(records, fn r ->
        r["status"] == "completed" and Enum.all?(r["checks"], &elem(&1, 1))
      end)

    full_suite = length(records) == 3
    ready = full_suite and passed and Skill.validate(text) == :ok and Skill.words(text) <= 500

    baseline_records =
      baseline_records ||
        [read(case_path(ctx, baseline, hd(Fixture.cases().train).id)) |> recheck()]

    comparison =
      Enum.map(baseline_records, &{"baseline", &1}) ++ Enum.map(records, &{"selected", &1})

    lines =
      for {label, r} <- comparison do
        m = r["metrics"] || %{}

        "| #{label} | #{r["case_id"]} | #{Enum.count(r["checks"], &elem(&1, 1))}/#{map_size(r["checks"])} | #{get_in(m, ["usage", "total_tokens"]) || "unknown"} | #{m["tool_calls"] || "unknown"} | #{m["elapsed_ms"] || "unknown"} |"
      end

    report = """
    # Setup evaluation

    Profile: #{ctx.profile_name} (#{ctx.profile.model}, #{ctx.profile.reasoning_effort}).
    Source skills target Codex / gpt-6-astra / xhigh. Other profiles are experiments.
    Baseline: #{baseline} (#{Skill.words(text(ctx, baseline))} words).
    Selected: [#{best}](skills/#{best}.md) (#{Skill.words(text)} words).
    Ready for review: #{ready}. Full suite checked: #{full_suite}. Original skill is unchanged.

    | Skill | Case | Checks | Total tokens | Tool calls | Milliseconds |
    | --- | --- | --- | --- | --- | --- |
    #{Enum.join(lines, "\n")}

    #{rounds(ctx)}

    Measurements are from saved executions; reuse does not measure the model again.
    This is one small suite, not a general reliability claim. Token subsets and proposal
    costs are in the case JSON and search JSON. Context: context-#{ctx.key}.json.
    """

    File.write!(Path.join(ctx.dir, "report.md"), report)
    IO.puts(report)
    IO.puts("Saved #{Path.relative_to(Path.join(ctx.dir, "report.md"), KataEvolve.root())}")
    %{passed: passed, ready: ready, candidate: best, records: records}
  end

  defp rounds(ctx) do
    path = Path.join(ctx.dir, "search-#{ctx.key}.json")
    proposals = if File.exists?(path), do: read(path)["proposals"], else: []

    rows =
      proposals
      |> Enum.with_index(1)
      |> Enum.map(fn {p, number} ->
        path = case_path(ctx, p["candidate"], hd(Fixture.cases().train).id)
        observed = if File.exists?(path), do: read(path), else: %{}
        metrics = observed["metrics"] || %{}

        "| #{number} | [#{p["candidate"]}](skills/#{p["candidate"]}.md) | #{observed["skill_words"] || "not run"} | #{p["decision"] || "pending"} | #{get_in(metrics, ["usage", "total_tokens"]) || "unknown"} | #{metrics["tool_calls"] || "unknown"} | #{metrics["elapsed_ms"] || "unknown"} | #{get_in(p, ["metrics", "usage", "total_tokens"]) || "unknown"} |"
      end)

    "Tuning rounds: #{length(proposals)}.\n\n| Round | Candidate | Words | Training decision | Task tokens | Tool calls | Milliseconds | Proposal tokens |\n| --- | --- | --- | --- | --- | --- | --- | --- |\n" <>
      Enum.join(rows, "\n")
  end

  def write(path, data) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path <> ".tmp", Jason.encode!(data, pretty: true) <> "\n")
    File.rename!(path <> ".tmp", path)
  end

  defp fingerprint(files),
    do: files |> Enum.sort() |> Enum.map_join(&File.read!/1) |> Skill.hash()
end
