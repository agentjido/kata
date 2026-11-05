defmodule KataEvolve.DocsSkillTest do
  use ExUnit.Case

  @moduletag :legacy_contract

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)
  @package Path.join(@root, "skills/kata-docs")

  test "kata-docs is the one active Docs Kata package" do
    text = File.read!(Path.join(@package, "SKILL.md"))

    assert :ok = Skill.validate(text, "kata-docs")
    refute File.exists?(Path.join(@root, "skills/kata-setup"))

    for field <- [
          "schema: kata.skill/v1",
          "subject: general",
          "practice: steward",
          "object: project-documentation",
          "profile: bounded-execution",
          "authority: local-write"
        ] do
      assert text =~ field
    end

    interface = File.read!(Path.join(@package, "agents/openai.yaml"))
    assert interface =~ ~s(display_name: "Docs")
  end

  test "natural-language routes keep their owning references and boundaries" do
    text = File.read!(Path.join(@package, "SKILL.md"))

    for reference <- [
          "document-contracts.md",
          "setup.md",
          "inbox.md",
          "record.md",
          "maintain.md"
        ] do
      assert text =~ "references/#{reference}"
      assert File.regular?(Path.join([@package, "references", reference]))
    end

    assert File.regular?(Path.join(@package, "templates/docs-agents.md"))
    assert text =~ "Infer the operation from ordinary language"
    assert Regex.match?(~r/process one\s+item by default/i, text)
    assert text =~ "project-knowledge-capture"
    assert text =~ "Respect a check-only request"
    assert text =~ "use the project's planning workflow"
    assert text =~ "use the project's documentation-sync workflow"

    jido = File.read!(Path.join(@root, "skills/jido/references/commands.md"))
    understand = File.read!(Path.join(@root, "skills/kata-understand/SKILL.md"))
    assert jido =~ "`../kata-docs/SKILL.md`"
    assert understand =~ "project-knowledge-capture"
  end

  test "recording and maintenance do not promote unsupported knowledge" do
    record = File.read!(Path.join(@package, "references/record.md"))
    maintain = File.read!(Path.join(@package, "references/maintain.md"))
    contracts = File.read!(Path.join(@package, "references/document-contracts.md"))

    assert record =~ "already communicate it well enough"
    assert record =~ "evidence is incomplete"
    assert Regex.match?(~r/do not treat\s+the caller's confidence label as proof/i, record)
    assert maintain =~ "Do not infer that a plan is complete"
    assert maintain =~ "does not perform an unbounded"
    assert contracts =~ "The `docs/` tree is the project wiki"
  end
end
