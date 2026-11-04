defmodule KataEvolve.FlowKaizenTest do
  use ExUnit.Case, async: true

  alias KataEvolve.Skill

  @root Path.expand("../../..", __DIR__)

  test "value delivery has one valid skill for each transition" do
    for name <- ~w(kata-understand kata-plan kata-work kata-verify) do
      assert :ok = Skill.validate(skill(name), name)
      assert File.regular?(Path.join([@root, "skills", name, "agents", "openai.yaml"]))
    end

    assert skill("kata-understand") =~
             "produces: [understood-context, work-brief]"

    assert skill("kata-plan") =~
             "consumes: [planning-request, source-material, understood-context]"

    assert skill("kata-work") =~
             "consumes: [work-request, work-brief, work-plan, implementation-plan]"

    assert skill("kata-work") =~ "produces: [candidate-result, work-evidence]"
    refute skill("kata-work") =~ "produces: [verified-change]"

    assert skill("kata-verify") =~
             "consumes: [candidate-result, work-evidence, acceptance-contract, verification-request]"

    assert skill("kata-verify") =~
             "produces: [verified-result, verified-change, verification-finding]"
  end

  test "Kaizen keeps Dojo as an explicit optional route" do
    maintain = skill("kata-maintain-skill")
    writer = skill("kata-write-skill")
    dojo = skill("kata-dojo")

    assert :ok = Skill.validate(dojo, "kata-dojo")
    assert maintain =~ "consumes: [skill-library, skill-evaluation-evidence]"
    assert writer =~ "produces: [conforming-skill-package]"

    assert dojo =~
             "consumes: [conforming-skill-package, skill-evaluation-suite, skill-evaluation-request]"

    assert dojo =~
             "produces: [skill-evaluation-evidence, adoption-recommendation, verified-change]"

    assert dojo =~ "Do not edit the official source skill"
    assert dojo =~ "It is not adoption."
    assert dojo =~ "explicitly name Dojo"
    assert File.regular?(Path.join([@root, "skills/kata-dojo/references/kata-runner.md"]))
  end

  test "Jido infers both routes and enters at the first unresolved contract" do
    jido = skill("jido")
    loops = File.read!(Path.join(@root, "skills/jido/references/loops.md"))
    routes = File.read!(Path.join(@root, "skills/jido/references/commands.md"))

    assert :ok = Skill.validate(jido, "jido")

    assert jido =~
             "Do not ask the requester to label the request as Flow or\nKaizen."

    assert jido =~ "Select the first unresolved contract"
    assert jido =~ "Do not run a step for\nceremony."

    assert loops =~ "understand -> plan -> work -> verify -> consumer acceptance"
    assert loops =~ "maintain-skill -> write-skill -> consumer acceptance"
    assert loops =~ "dojo -> consumer acceptance"
    assert loops =~ "Dojo is an optional side route"
    assert loops =~ "A clear bounded change can use\n`work -> verify`."
    assert loops =~ "Do not add `understand` or `plan`"

    for route <-
          ~w(kata-understand kata-plan kata-work kata-verify kata-maintain-skill kata-write-skill kata-dojo) do
      assert routes =~ "../#{route}/SKILL.md"
    end

    assert routes =~ "$jido update this report"
    refute routes =~ "$jido flow"
    refute routes =~ "$jido kaizen"
  end

  test "Dojo requires authority and budget for live evaluation" do
    dojo = skill("kata-dojo")
    runner = File.read!(Path.join(@root, "skills/kata-dojo/references/kata-runner.md"))

    assert dojo =~ "Live model calls require an\nexplicit request"
    assert dojo =~ "Do not infer a paid budget."
    assert dojo =~ "This spike evaluates skills only."
    assert runner =~ "mix skill.eval SUITE verify --candidate PATH"
    assert runner =~ "Do not install dependencies"
  end

  defp skill(name), do: File.read!(Path.join(@root, "skills/#{name}/SKILL.md"))
end
