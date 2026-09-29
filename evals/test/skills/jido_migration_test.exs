defmodule KataEvolve.JidoMigrationTest do
  use ExUnit.Case, async: true

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)
  @skills ~w(
    kata-ex-jido-action
    kata-ex-jido-agent
    kata-ex-jido-ai
    kata-ex-jido-testing
    kata-review-pr
    kata-sync-docs
  )

  test "migrated skills are valid, licensed, and discoverable from the shared skill root" do
    for name <- @skills do
      root = Path.join(@root, "skills/#{name}")
      text = File.read!(Path.join(root, "SKILL.md"))
      interface = File.read!(Path.join(root, "agents/openai.yaml"))
      license = File.read!(Path.join(root, "LICENSE"))

      assert Skill.validate(text, name) == :ok
      assert interface =~ "display_name:"
      assert interface =~ "short_description:"
      assert license =~ "Apache License"
      assert license =~ "Copyright 2026 Mike Hostetler"
      assert File.read!(Path.join(@root, "README.md")) =~ "`#{name}`"
    end
  end

  test "Jido skills use current API boundaries and no hub prerequisite" do
    action = skill("kata-ex-jido-action")
    agent = skill("kata-ex-jido-agent")
    ai = skill("kata-ex-jido-ai")
    testing = skill("kata-ex-jido-testing")

    assert action =~ "Jido.Exec.run/3"
    assert action =~ "An action can perform HTTP"
    assert agent =~ "Jido.Agent.Directive"
    assert agent =~ "Jido.Agent.StateOp"
    assert agent =~ "Jido.AgentServer.call"
    assert agent =~ "delay_ms"
    assert ai =~ "use Jido.AI.Agent"
    assert ai =~ "deterministic tests"
    assert testing =~ "Jido.AgentServer.call/2"

    refute Enum.any?([action, agent, ai, testing], &String.contains?(&1, "Invoke `jido-core`"))
    refute Enum.any?([action, agent, ai, testing], &String.contains?(&1, "%Jido.Directive"))
  end

  test "general migration skills preserve their write boundaries" do
    review = skill("kata-review-pr")
    docs = skill("kata-sync-docs")

    assert review =~ "does not change code, labels, branches, or the PR"
    assert review =~ "Do not edit code"
    assert docs =~ "Edit only the selected documentation"
    assert docs =~ "Use `kata-setup` only"
  end

  test "kata-work has a self-contained pull request hardening route" do
    work = skill("kata-work")

    reference =
      File.read!(Path.join(@root, "skills/kata-work/references/pull-request-hardening.md"))

    license = File.read!(Path.join(@root, "skills/kata-work/LICENSE-JIDO-SKILLS"))

    assert work =~ "references/pull-request-hardening.md"
    assert reference =~ "does not by itself authorize a push"
    assert reference =~ "Do not merge the pull request"
    assert work =~ "does not require another skill"
    assert license =~ "Apache License"
  end

  defp skill(name), do: File.read!(Path.join(@root, "skills/#{name}/SKILL.md"))
end
