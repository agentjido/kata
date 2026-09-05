defmodule KataEvolve.LoopTest do
  use ExUnit.Case
  alias KataEvolve.{Fixture, Store}

  test "saved baseline is rechecked without a call, and pending proposals resume after an error" do
    dir = Path.join(System.tmp_dir!(), "kata-loop-#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(dir) end)

    ctx = %{
      dir: dir,
      key: "test",
      template: "rules",
      fresh: false,
      started_at: DateTime.to_iso8601(DateTime.utc_now()),
      profile: %{
        provider: :codex,
        model: "test-model",
        reasoning_effort: :medium,
        runtime_timeout_ms: 1000,
        idle_timeout_ms: 1000
      },
      deadline: System.monotonic_time(:millisecond) + 60_000,
      execute: fn _, _, root -> complete_fixture(root) end
    }

    seed = skill(900)
    baseline = Store.skill(ctx, seed)
    item = hd(Fixture.cases().train)
    record = KataEvolve.evaluate(ctx, baseline, item)
    assert Enum.all?(record["checks"], &elem(&1, 1))
    no_call = %{ctx | execute: fn _, _, _ -> flunk("Cache must prevent a live call") end}
    assert KataEvolve.evaluate(no_call, baseline, item) == record

    # A changed assertion result is derived from final files, not trusted from saved checks.
    path = Store.case_path(ctx, baseline, item.id)
    Store.write(path, Map.put(record, "checks", %{"incorrect_cached_check" => false}))
    assert KataEvolve.evaluate(no_call, baseline, item)["checks"] == record["checks"]

    owner = self()

    failing = %{
      ctx
      | execute: fn _, _, root ->
          if File.exists?(Path.join(root, "feedback.json")) do
            feedback = File.read!(Path.join(root, "feedback.json"))
            assert feedback =~ "checks"
            refute feedback =~ "validation-note"
            File.write!(Path.join(root, "SKILL.md"), skill(600))
            send(owner, :proposal_call)
            {:ok, %{metrics: %{}}}
          else
            {:error, :temporary_service_failure}
          end
        end
    }

    assert_raise RuntimeError, ~r/Codex execution failed/, fn ->
      KataEvolve.tune(failing, baseline, record, 1)
    end

    assert_received :proposal_call
    state = Store.read(Path.join(dir, "search-test.json"))
    assert state["pending"]
    assert length(state["proposals"]) == 1

    # The next invocation retries the same candidate; no new proposal is made.
    candidate = KataEvolve.tune(ctx, baseline, record, 1)
    assert candidate != baseline
    refute_received :proposal_call
    selected = KataEvolve.evaluate(no_call, candidate, item)
    assert selected["status"] == "completed"
    assert selected["skill_words"] > 500
  end

  test "five rounds survive a proposal failure and continue after rejected candidates" do
    dir = Path.join(System.tmp_dir!(), "kata-budget-#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(dir) end)
    counter = start_supervised!({Agent, fn -> 0 end})

    ctx = %{
      dir: dir,
      key: "budget",
      template: "rules",
      fresh: false,
      started_at: DateTime.to_iso8601(DateTime.utc_now()),
      profile: %{
        provider: :codex,
        model: "test-model",
        reasoning_effort: :medium,
        runtime_timeout_ms: 1000,
        idle_timeout_ms: 1000
      },
      deadline: System.monotonic_time(:millisecond) + 60_000,
      execute: fn _, _, root ->
        if File.exists?(Path.join(root, "feedback.json")) do
          n = Agent.get_and_update(counter, &{&1 + 1, &1 + 1})

          if n == 3 do
            {:error, :temporary_proposal_failure}
          else
            File.write!(Path.join(root, "SKILL.md"), skill(240 + n))
            {:ok, %{metrics: %{}}}
          end
        else
          complete_fixture(root)
        end
      end
    }

    baseline = Store.skill(ctx, skill(220))
    record = KataEvolve.evaluate(ctx, baseline, hd(Fixture.cases().train))

    assert_raise RuntimeError, ~r/Proposal call failed/, fn ->
      KataEvolve.tune(ctx, baseline, record, 5)
    end

    path = Path.join(dir, "search-budget.json")
    assert Store.read(path)["target_proposals"] == 5
    assert length(Store.read(path)["proposals"]) == 2

    assert KataEvolve.tune(ctx, baseline, record, 5) == baseline
    state = Store.read(path)
    assert length(state["proposals"]) == 5
    assert Enum.all?(state["proposals"], &(&1["decision"] == "rejected"))
    assert Agent.get(counter, & &1) == 6
  end

  test "profiles select explicit models and reject unknown names" do
    assert Store.profile("codex-astra-xhigh").model == "gpt-6-astra"
    assert Store.profile("codex-astra-xhigh").reasoning_effort == :xhigh
    assert Store.profile("codex-sol-medium").model == "gpt-5.6-sol"
    assert Store.profile("codex-sol-medium").reasoning_effort == :medium
    assert_raise ArgumentError, ~r/Unknown profile/, fn -> Store.profile("unknown") end
  end

  test "context identity reuses old records and changes when execution settings change" do
    dir = Path.join(System.tmp_dir!(), "kata-context-#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(dir) end)
    identity = %{"runner" => "test", "profile" => Store.profile("codex-sol-medium")}
    Store.write(Path.join(dir, "context-legacy.json"), identity)

    assert Store.save_context(dir, identity) == "legacy"
    assert Store.save_context(dir, Jason.decode!(Jason.encode!(identity))) == "legacy"

    changed = put_in(identity, ["profile", :reasoning_effort], :high)
    key = Store.save_context(dir, changed)
    refute key == "legacy"
    assert Store.save_context(dir, changed) == key
    assert length(Path.wildcard(Path.join(dir, "context-*.json"))) == 2
  end

  test "optimization metadata is valid, repeatable, and changes only frontmatter" do
    profile = Store.profile("codex-sol-medium")
    source = skill(220)
    marked = KataEvolve.Skill.mark_optimized(source, profile)
    assert marked =~ ~s(metadata: {optimized_for: "codex/gpt-5.6-sol/medium"})
    assert KataEvolve.Skill.validate(marked) == :ok
    assert KataEvolve.Skill.mark_optimized(marked, profile) == marked

    assert List.last(String.split(marked, "---\n", parts: 3)) ==
             List.last(String.split(source, "---\n", parts: 3))

    astra = KataEvolve.Skill.mark_optimized(marked, Store.profile("codex-astra-xhigh"))
    refute astra =~ "gpt-5.6-sol"
    assert KataEvolve.Skill.validate(astra) == :ok
  end

  defp skill(n),
    do:
      "---\nname: kata-setup\ndescription: Set up docs.\n---\nUse templates/docs-agents.md. " <>
        String.duplicate("Preserve. ", n)

  defp complete_fixture(root) do
    item = hd(Fixture.cases().train)

    for path <- [item.source, item.asset] do
      Fixture.write(root, "docs/inbox/" <> path, File.read!(Path.join(root, path)))
      File.rm!(Path.join(root, path))
    end

    Fixture.write(
      root,
      "README.md",
      "# Example\n[Note](docs/inbox/#{item.source})\n[Docs](docs/README.md)\n"
    )

    template = File.read!(Path.join(root, ".agents/skills/kata-setup/templates/docs-agents.md"))
    Fixture.write(root, "docs/AGENTS.md", template)
    Fixture.write(root, "docs/README.md", "[Rules](AGENTS.md)\n[Inbox](inbox/README.md)")

    Fixture.write(
      root,
      "docs/inbox/README.md",
      "#{item.source} | docs/inbox/#{item.source} | Awaiting review"
    )

    {:ok, %{metrics: %{}}}
  end
end
