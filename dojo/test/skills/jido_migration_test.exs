defmodule KataEvolve.JidoMigrationTest do
  use ExUnit.Case, async: true

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)
  @skills ~w(
    kata-jido-action
    kata-jido-agent
    kata-jido-ai
    kata-jido-testing
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
    action = skill("kata-jido-action")
    agent = skill("kata-jido-agent")
    ai = skill("kata-jido-ai")
    testing = skill("kata-jido-testing")

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
    assert docs =~ "Use `kata-docs` to establish"
  end

  test "kata-work stops at a candidate for independent verification" do
    work = skill("kata-work")
    interface = File.read!(Path.join(@root, "skills/kata-work/agents/openai.yaml"))

    assert Skill.validate(work, "kata-work") == :ok

    assert work =~
             "consumes: [work-request, work-brief, work-plan, implementation-plan]"

    assert work =~ "produces: [candidate-result, work-evidence]"
    assert work =~ "Do not stage, commit"
    assert work =~ "It does not certify its own result."
    assert work =~ "ready for independent verification"
    refute work =~ "pull request hardening"
    assert interface =~ "display_name:"
    assert interface =~ "short_description:"
  end

  defp skill(name), do: File.read!(Path.join(@root, "skills/#{name}/SKILL.md"))
end
