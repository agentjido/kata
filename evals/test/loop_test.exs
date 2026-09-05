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
      profile: %{runtime_timeout_ms: 1000, idle_timeout_ms: 1000},
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

    Fixture.write(root, "docs/AGENTS.md", "Rules")
    Fixture.write(root, "docs/README.md", "Index")
    Fixture.write(root, "docs/inbox/README.md", "#{item.source} | docs/inbox/#{item.source}")
    {:ok, %{metrics: %{}}}
  end
end
