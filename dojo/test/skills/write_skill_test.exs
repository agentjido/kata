defmodule KataEvolve.WriteSkillTest do
  use ExUnit.Case

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)
  @package Path.join(@root, "skills/kata-write-skill")
  @maintenance Path.join(@root, "skills/kata-maintain-skill")
  @active_docs [
    "README.md",
    "docs/plans/skill-import-queue.md"
  ]

  test "the unified package has valid identity, interface, and references" do
    skill_path = Path.join(@package, "SKILL.md")
    text = File.read!(skill_path)

    assert :ok = Skill.validate(text, "kata-write-skill")

    for reference <- [
          "create.md",
          "import.md",
          "convert.md",
          "library-contract.md",
          "authoring-principles.md",
          "skill-template.md"
        ] do
      assert text =~ "references/#{reference}"
      assert File.regular?(Path.join([@package, "references", reference]))
    end

    assert text =~ "**Done:**"

    for field <- [
          "schema: kata.skill/v1",
          "subject: agent-work",
          "practice: build",
          "object: skill-package",
          "profile: system-design",
          "authority: local-write",
          "consumes: [skill-request, skill-source, conversion-brief]",
          "produces: [conforming-skill-package]"
        ] do
      assert text =~ field
    end

    for license <- ["LICENSE-MATT-POCOCK", "LICENSE-COMPOUND-ENGINEERING"] do
      assert File.regular?(Path.join(@package, license))
    end

    interface = File.read!(Path.join(@package, "agents/openai.yaml"))
    assert interface =~ ~s(display_name: "Write Skill")
    assert interface =~ "short_description:"
  end

  test "the route and work contracts keep required boundaries" do
    package_text =
      [
        "SKILL.md",
        "references/create.md",
        "references/import.md",
        "references/convert.md",
        "references/library-contract.md",
        "references/authoring-principles.md",
        "references/skill-template.md"
      ]
      |> Enum.map(&File.read!(Path.join(@package, &1)))
      |> Enum.join("\n")

    for term <- [
          "Create",
          "Import",
          "Convert",
          "Outcome contract",
          "Activation contract",
          "Work contract",
          "Authority contract",
          "Responsibility contract",
          "Assignment contract",
          "Faceted metadata contract",
          "Information contract",
          "Verification contract",
          "bounded-execution",
          "coordination",
          "system-design",
          "direction",
          "conditions instead of case lists",
          "risk and reach",
          "# Skill template"
        ] do
      assert package_text =~ term
    end

    refute Regex.match?(~r/jaques|stratif|time-span of discretion/i, package_text)

    refute Regex.match?(
             ~r/disable-model-invocation|sol-first|fable|claude\.md|slash command/i,
             package_text
           )
  end

  test "maintenance metadata routes conversion briefs to the writing package" do
    writer = File.read!(Path.join(@package, "SKILL.md"))
    maintainer = File.read!(Path.join(@maintenance, "SKILL.md"))

    assert :ok = Skill.validate(maintainer, "kata-maintain-skill")
    assert writer =~ "consumes: [skill-request, skill-source, conversion-brief]"
    assert maintainer =~ "produces: [resolved-library-finding, conversion-brief]"
    assert maintainer =~ "practice: govern"
    assert maintainer =~ "object: skill-library"
    assert maintainer =~ "`kata-write-skill`"

    interface = File.read!(Path.join(@maintenance, "agents/openai.yaml"))
    assert interface =~ ~s(display_name: "Maintain Skill")
  end

  test "jido routes writing and maintenance as the first library commands" do
    jido = File.read!(Path.join(@root, "skills/jido/SKILL.md"))
    commands = File.read!(Path.join(@root, "skills/jido/references/commands.md"))

    assert :ok = Skill.validate(jido, "jido")
    assert jido =~ "schema: kata.skill/v1"
    assert jido =~ "practice: route"
    assert jido =~ "profile: coordination"
    assert jido =~ "Only `write-skill` and `maintain-skill` can"
    assert commands =~ "| `write-skill` |"
    assert commands =~ "`../kata-write-skill/SKILL.md`"
    assert commands =~ "| `maintain-skill` |"
    assert commands =~ "`../kata-maintain-skill/SKILL.md`"
    assert :binary.match(commands, "| `write-skill` |") <
             :binary.match(commands, "| `maintain-skill` |")
  end

  test "source licenses and attribution stay with the adapted contract" do
    matt = File.read!(Path.join(@package, "LICENSE-MATT-POCOCK"))
    compound = File.read!(Path.join(@package, "LICENSE-COMPOUND-ENGINEERING"))
    readme = File.read!(Path.join(@root, "README.md"))

    assert matt =~ "Copyright (c) 2026 Matt Pocock"
    assert compound =~ "Copyright (c) 2025 Every"
    assert readme =~ "4ae2317ddb22b046e26455e4f9c9b3aaaf62212d"
    assert readme =~ "406b85c4562de3d415927fccc5e614c6554aab00"
    assert readme =~ "skills/kata-write-skill/LICENSE-MATT-POCOCK"
    assert readme =~ "skills/kata-write-skill/LICENSE-COMPOUND-ENGINEERING"
  end

  test "migrated Katas keep valid subject metadata" do
    skill_paths =
      Path.wildcard(Path.join(@root, "skills/*"))
      |> Enum.filter(&File.dir?/1)

    metadata_rows =
      skill_paths
      |> Enum.flat_map(fn path ->
        text = File.read!(Path.join(path, "SKILL.md"))

        case metadata_subject(text) do
          subject when is_binary(subject) -> [{Path.basename(path), subject}]
          nil -> []
        end
      end)

    migrated = [
      {"jido", "agent-work"},
      {"kata-write-skill", "agent-work"},
      {"kata-maintain-skill", "agent-work"},
      {"kata-status-report", "software-engineering"},
      {"kata-setup", "general"},
      {"kata-neckbeard", "software-engineering"},
      {"kata-ex-coverage", "software-engineering"},
      {"kata-ex-design-review", "software-engineering"},
      {"kata-ex-hunt-dead-code", "software-engineering"}
    ]

    for row <- migrated do
      assert row in metadata_rows
    end

    assert Enum.all?(metadata_rows, fn {_name, subject} ->
             Regex.match?(~r/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, subject)
           end)
  end

  test "active documentation uses only the unified authoring entry point" do
    for relative <- @active_docs do
      text = File.read!(Path.join(@root, relative))
      assert text =~ "kata-write-skill"
      refute text =~ "kata-build-skill"
      refute text =~ "kata-import-skill"
    end

    refute File.exists?(Path.join(@root, "skills/kata-build-skill"))
    refute File.exists?(Path.join(@root, "skills/kata-import-skill"))
  end

  defp metadata_subject(text) do
    [_, fields] = Regex.run(~r/\A---\r?\n(.*?)\r?\n---/s, text)

    case Regex.run(
           ~r/^metadata:\s*\{[^\n]*subject:\s*["']?([a-z0-9-]+)["']?[^\n]*\}\s*$/m,
           fields
         ) do
      [_, subject] ->
        subject

      nil ->
        case Regex.run(~r/^  subject:\s*["']?([a-z0-9-]+)["']?\s*$/m, fields) do
          [_, subject] -> subject
          nil -> nil
        end
    end
  end
end
