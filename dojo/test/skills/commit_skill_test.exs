defmodule KataEvolve.CommitSkillTest do
  use ExUnit.Case, async: true

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)
  @package Path.join(@root, "skills/kata-commit")

  test "commit package has a bounded local Git contract" do
    text = File.read!(Path.join(@package, "SKILL.md"))

    assert :ok = Skill.validate(text, "kata-commit")
    assert text =~ "schema: kata.skill/v1"
    assert text =~ "consumes: [verified-change]"
    assert text =~ "produces: [git-commit]"
    assert text =~ "Do not change file contents"
    assert text =~ "Do not use a broad add command"
    assert text =~ "git diff --cached --check"
    assert text =~ "Do not amend, rebase, push, or merge"

    interface = File.read!(Path.join(@package, "agents/openai.yaml"))
    assert interface =~ ~s(display_name: "Commit")
  end
end
