defmodule KataEvolve.Setup.Suite do
  @moduledoc "Docs setup outcomes through the common skill runner."
  @behaviour KataEvolve.Suite
  alias KataEvolve.{Evidence, Setup}
  alias KataEvolve.Setup.Fixture

  def spec do
    fixtures = Fixture.cases()

    cases =
      for {split, items} <- [train: fixtures.train, final: fixtures.validation ++ fixtures.test],
          item <- items do
        Map.merge(item, %{split: split, writable: ["README.md", "docs/", item.source, item.asset]})
      end

    %{
      id: "kata-setup",
      source: Path.expand("../skills/kata-setup/SKILL.md", KataEvolve.root()),
      support: ["templates/docs-agents.md"],
      cases: cases,
      execution_inputs: [
        __ENV__.file,
        Path.join(KataEvolve.root(), "test/fixtures/setup/input"),
        Path.join(KataEvolve.root(), "lib/kata_evolve/setup/fixture.ex"),
        Path.join(KataEvolve.root(), "lib/kata_evolve/setup/snapshot.ex")
      ],
      inputs: [
        __ENV__.file,
        Path.join(KataEvolve.root(), "test/fixtures/setup/input"),
        Path.join(KataEvolve.root(), "lib/kata_evolve/setup/fixture.ex"),
        Path.join(KataEvolve.root(), "lib/kata_evolve/setup/snapshot.ex"),
        Path.join(KataEvolve.root(), "lib/kata_evolve/setup/skill.ex")
      ],
      checks: Map.new(cases, &{&1.id, Fixture.check_names()})
    }
  end

  def prepare(root, item) do
    source = spec().source
    template = File.read!(Path.join(Path.dirname(source), "templates/docs-agents.md"))
    Fixture.prepare(root, item, File.read!(source), template)
  end

  def prompt(item), do: "#{item.input} Complete Docs Kata setup and check the result."
  defdelegate validate(text), to: Setup.Skill

  def proposal_instructions do
    "Keep inspection, local edits, fixed consumers, collision-safe moves, relative links, " <>
      "intake records, safe repeats, and the templates/docs-agents.md reference."
  end

  def check(record, item) do
    initial = record["initial"]
    final = record["final"]

    initial = %{
      files: Map.new(initial["files"], fn {path, _} -> {path, Evidence.text(initial, path)} end),
      index: initial["index"]
    }

    Fixture.check_snapshot(%{files: final["files"], index: final["index"]}, item, initial).checks
  end

  def outcome_contract do
    [
      "Complete Docs Kata setup with usable documentation rules, an index, and an inbox intake record.",
      "Preserve document content, supporting assets, fixed consumers, and required entry points.",
      "Use collision-safe moves, preserve working relative links, and record original paths.",
      "Make repeated setup safe and preserve existing user work.",
      "Retain and use the templates/docs-agents.md support reference."
    ]
  end
end
