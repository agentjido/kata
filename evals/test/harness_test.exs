defmodule KataEvolve.HarnessTest do
  use ExUnit.Case
  alias KataEvolve.{Harness, Metrics, Skill}

  test "usage subsets are not counted twice and tool IDs are deduplicated" do
    call = %{
      type: :tool_call,
      payload: %{"name" => "exec_command", "call_id" => "a"},
      sequence: 1
    }

    counters = Metrics.add(call, Metrics.new()) |> then(&Metrics.add(call, &1))

    counters =
      Metrics.add(
        %{
          type: :usage,
          payload: %{
            "input_tokens" => 100,
            "cached_input_tokens" => 90,
            "output_tokens" => 20,
            "reasoning_output_tokens" => 10
          }
        },
        counters
      )

    result = Metrics.finish(counters, 5)
    assert result.usage["total_tokens"] == 120
    assert result.tool_calls == 1
    assert Metrics.finish(Metrics.new(), 1).usage["total_tokens"] == nil
  end

  test "a shorter skill above 500 words can improve without weakening correctness" do
    text =
      "---\nname: kata-setup\ndescription: Set up docs.\n---\nUse templates/docs-agents.md. " <>
        String.duplicate("Preserve. ", 600)

    assert :ok = Skill.validate(text)
    parent = %{"status" => "completed", "checks" => %{"links" => true}, "skill_words" => 939}
    candidate = Map.put(parent, "skill_words", Skill.words(text))
    assert KataEvolve.Setup.better?(candidate, parent)
    refute KataEvolve.Setup.better?(Map.put(candidate, "checks", %{"links" => false}), parent)
    refute KataEvolve.Setup.better?(Map.put(candidate, "status", "error"), parent)
    assert {:error, _} = Skill.validate("missing frontmatter")
  end

  test "Harness executes a fake CLI, measures events, and prunes resources" do
    root = sandbox()
    script = Path.join(root, "fake-codex")

    File.write!(script, """
    #!/bin/sh
    cat <<'EVENTS'
    {"type":"thread.started","thread_id":"fake"}
    {"type":"item.completed","item":{"type":"command_execution","id":"one","command":"true","exit_code":0}}
    {"type":"item.completed","item":{"type":"agent_message","id":"answer","text":"Final answer"}}
    {"type":"turn.completed","usage":{"input_tokens":10,"output_tokens":2}}
    EVENTS
    """)

    File.chmod!(script, 0o755)

    profile = %{
      provider: :codex,
      provider_options: %{cli_path: script},
      runtime_timeout_ms: 5000,
      idle_timeout_ms: 5000
    }

    assert {:ok, result} = Harness.execute(profile, "Test", root)
    assert result.answer == "Final answer"
    assert result.answer_complete
    assert result.metrics.tool_calls == 1
    assert result.metrics.usage["total_tokens"] == 12
    assert Jido.Harness.Run.list() == []
    assert Jido.Harness.Process.list() == []
  end

  test "runtime timeout is an execution error and cancels the child" do
    root = sandbox()
    script = Path.join(root, "slow-codex")
    File.write!(script, "#!/bin/sh\nsleep 20\n")
    File.chmod!(script, 0o755)

    profile = %{
      provider: :codex,
      provider_options: %{cli_path: script},
      runtime_timeout_ms: 100,
      idle_timeout_ms: 100
    }

    assert {:error, _} = Harness.execute(profile, "Test", root)
    assert Jido.Harness.Run.list() == []
    assert Jido.Harness.Process.list() == []
  end

  defp sandbox do
    root = Path.join(System.tmp_dir!(), "kata-harness-test-#{System.unique_integer([:positive])}")
    File.mkdir_p!(root)
    on_exit(fn -> File.rm_rf!(root) end)
    root
  end
end
