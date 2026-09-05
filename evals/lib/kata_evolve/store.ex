defmodule KataEvolve.Store do
  @moduledoc "Git-friendly skills, final files, measurements, and resumable proposals."
  alias KataEvolve.{Fixture, Harness, Skill}

  def context(opts) do
    root = KataEvolve.root()
    {profiles, _} = Code.eval_file(Path.join(root, "config/profiles.exs"))
    profile = profiles["codex-astra-xhigh"]
    {cli, 0} = System.cmd(profile.provider_options.cli_path, ["--version"])
    seed = File.read!(Path.expand("../skills/kata-setup/SKILL.md", root))
    template = File.read!(Path.expand("../skills/kata-setup/templates/docs-agents.md", root))

    inputs =
      Path.wildcard(Path.join(root, "test/fixtures/setup/input/**/*"))
      |> Enum.filter(&File.regular?/1)

    harness_files =
      Path.wildcard(Path.join(Mix.Project.deps_paths()[:jido_harness], "lib/**/*.ex"))

    identity = %{
      "runner" => "setup-v2",
      "baseline" => Skill.hash(seed),
      "template" => Skill.hash(template),
      "inputs" => fingerprint(inputs),
      "profile" => profile,
      "cli" => String.trim(cli),
      "harness" => fingerprint(harness_files),
      "config_scope" =>
        "Normal Codex execution inherits host config. Refresh after changing that config."
    }

    key = identity |> :erlang.term_to_binary() |> Skill.hash() |> String.slice(0, 12)
    dir = opts[:dir] || Path.join(root, "results/setup")
    write(Path.join(dir, "context-#{key}.json"), identity)

    %{
      dir: dir,
      key: key,
      seed: seed,
      template: template,
      profile: profile,
      execute: &Harness.execute/3,
      fresh: opts[:fresh] || false,
      started_at: DateTime.to_iso8601(DateTime.utc_now()),
      deadline: System.monotonic_time(:millisecond) + (opts[:minutes] || 30) * 60_000
    }
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
    Map.merge(record, %{"checks" => checked.checks, "feedback" => checked.feedback})
  end

  def report(ctx, baseline, best, records) do
    text = text(ctx, best)

    passed =
      Enum.all?(records, fn r ->
        r["status"] == "completed" and Enum.all?(r["checks"], &elem(&1, 1))
      end)

    full_suite = length(records) == 3
    ready = full_suite and passed and Skill.validate(text) == :ok and Skill.words(text) <= 500

    baseline_record = read(case_path(ctx, baseline, hd(Fixture.cases().train).id)) |> recheck()
    comparison = [{"baseline", baseline_record}] ++ Enum.map(records, &{"selected", &1})

    lines =
      for {label, r} <- comparison do
        m = r["metrics"] || %{}

        "| #{label} | #{r["case_id"]} | #{Enum.count(r["checks"], &elem(&1, 1))}/#{map_size(r["checks"])} | #{get_in(m, ["usage", "total_tokens"]) || "unknown"} | #{m["tool_calls"] || "unknown"} | #{m["elapsed_ms"] || "unknown"} |"
      end

    report = """
    # Setup evaluation

    Baseline: #{baseline} (#{Skill.words(text(ctx, baseline))} words).
    Selected: [#{best}](skills/#{best}.md) (#{Skill.words(text)} words).
    Ready for review: #{ready}. Full suite checked: #{full_suite}. Original skill is unchanged.

    | Skill | Case | Checks | Total tokens | Tool calls | Milliseconds |
    | --- | --- | --- | --- | --- | --- |
    #{Enum.join(lines, "\n")}

    Measurements are from saved executions; reuse does not measure the model again.
    This is one small suite, not a general reliability claim. Token subsets and proposal
    costs are in the case JSON and search JSON. Context: context-#{ctx.key}.json.
    """

    File.write!(Path.join(ctx.dir, "report.md"), report)
    IO.puts(report)
    %{passed: passed, ready: ready, candidate: best, records: records}
  end

  def write(path, data) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path <> ".tmp", Jason.encode!(data, pretty: true) <> "\n")
    File.rename!(path <> ".tmp", path)
  end

  defp fingerprint(files),
    do: files |> Enum.sort() |> Enum.map_join(&File.read!/1) |> Skill.hash()
end
