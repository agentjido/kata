defmodule KataEvolve.SuiteRunnerTest do
  use ExUnit.Case
  alias KataEvolve.{Access, Answer, Evidence, Suite, Score}

  test "final capture uses complete last event despite a truncated result tail" do
    state =
      Answer.new()
      |> then(
        &Answer.add(
          %{type: :output_text_final, payload: %{"text" => "commentary"}, sequence: 1},
          &1
        )
      )
      |> then(
        &Answer.add(
          %{
            type: :output_text_final,
            payload: %{"text" => String.duplicate("answer", 5000)},
            sequence: 2
          },
          &1
        )
      )
      |> then(&Answer.add(%{type: :run_completed}, &1))

    answer = Answer.finish(state, %{status: :completed, text: "tail", text_truncated?: true})
    assert answer.answer == String.duplicate("answer", 5000)
    assert answer.answer_complete
    refute Answer.finish(Answer.new(), %{status: :completed}).answer_complete
  end

  test "stamp keeps language and exact target; source validation is suite-specific" do
    source =
      "---\nname: kata-ex-sample\ndescription: Analyze.\nmetadata: {language: elixir}\n---\nRead source.\n"

    stamped = Suite.stamp(source)
    assert stamped =~ ~s(metadata: {language: elixir, optimized_for: "codex/gpt-6-astra/xhigh"})
    assert Suite.stamp(stamped) == stamped
  end

  test "context fingerprints encode paths, file types and contents" do
    root = temporary()
    File.write!(Path.join(root, "a"), "same")
    first = Evidence.fingerprint([root])
    assert byte_size(first) == 64
    assert Evidence.fingerprint([root]) == first
    File.rename!(Path.join(root, "a"), Path.join(root, "b"))
    refute Evidence.fingerprint([root]) == first
    assert byte_size(Evidence.fingerprint([Path.join(root, "b")])) == 64
  end

  test "immutable files cannot replace a failed attempt" do
    root = temporary()
    path = Path.join(root, "record.json")
    Evidence.write_new!(path, %{status: "failed"})
    assert_raise RuntimeError, fn -> Evidence.write_new!(path, %{status: "passed"}) end
    assert Evidence.read(path)["status"] == "failed"
  end

  test "snapshot retains build files, modes, symlinks and the Git state" do
    root = temporary()
    init_git(root)
    File.mkdir_p!(Path.join(root, "_build"))
    File.write!(Path.join(root, "_build/cache"), "old")
    File.ln_s!("_build/cache", Path.join(root, "link"))
    initial = Evidence.take(root)
    File.chmod!(Path.join(root, "_build/cache"), 0o700)
    final = Evidence.take(root)
    refute Evidence.preserved?(initial, final, [])
    assert Evidence.preserved?(initial, final, ["_build/"])
    assert initial["files"]["link"]["target"] == "_build/cache"
    refute Evidence.preserved?(initial, Map.put(final, "head", "changed"), ["_build/"])
  end

  test "OS access rules deny other checkouts and source writes, allow declared output" do
    root = temporary()
    project = Path.join(root, "project")
    runtime = Path.join(root, "runtime")
    File.mkdir_p!(project)
    File.mkdir_p!(runtime)
    neighbor = Path.join(root, "other-fixture-secret")
    File.write!(neighbor, "another case")
    source = Path.join(project, "source")
    output = Path.join(project, "answer.html")
    File.write!(source, "source")
    policy = Access.policy(runtime, project, ["answer.html"])

    {_out, neighbor_code} =
      System.cmd("sandbox-exec", ["-p", policy, "/bin/cat", neighbor],
        cd: project,
        stderr_to_stdout: true
      )

    assert neighbor_code != 0
    assert {"source", 0} = System.cmd("sandbox-exec", ["-p", policy, "/bin/cat", source])

    {_out, code} =
      System.cmd("sandbox-exec", ["-p", policy, "/bin/cat", Path.expand("../README.md")],
        stderr_to_stdout: true
      )

    assert code != 0

    {_out, code} =
      System.cmd(
        "sandbox-exec",
        ["-p", policy, "/bin/sh", "-c", "echo changed > \"$1\"", "sh", source],
        stderr_to_stdout: true
      )

    assert code != 0

    assert {"", 0} =
             System.cmd("sandbox-exec", [
               "-p",
               policy,
               "/bin/sh",
               "-c",
               "echo result > \"$1\"",
               "sh",
               output
             ])

    assert File.read!(source) == "source"
  end

  test "score uses neutral cost reference even when source is overlength" do
    text = "valid " <> String.duplicate("word ", 600)
    p = %{context: "fixed", case_ids: ["a"], repetitions: 3, checks: %{"a" => ["correct"]}}
    reference = data(text, 100, p)
    candidate = data("valid short", 50, p)
    result = Score.calculate(candidate, reference, p, fn _ -> :ok end)
    assert result.score_units > 50_000_000
    assert Score.calculate(reference, reference, p, fn _ -> :ok end).score_units == 0
    [first | rest] = candidate.records
    failed = %{candidate | records: [put_in(first, ["checks", "correct"], false) | rest]}
    assert Score.calculate(failed, reference, p, fn _ -> :ok end).score_units == 0
    duplicated = %{candidate | records: [first, first, first]}
    assert Score.calculate(duplicated, reference, p, fn _ -> :ok end).score == nil
    wrong_context = %{candidate | records: [Map.put(first, "context", "different") | rest]}
    assert Score.calculate(wrong_context, reference, p, fn _ -> :ok end).score == nil
  end

  defp data(text, tokens, p) do
    %{
      text: text,
      records:
        for rep <- 1..3 do
          %{
            "case_id" => "a",
            "context" => p.context,
            "skill" => Evidence.hash(text),
            "execution_id" => "#{text}-#{rep}",
            "repetition" => rep,
            "status" => "completed",
            "answer_complete" => true,
            "checks" => %{"correct" => true},
            "outcome_test" => %{"framework" => "ExUnit", "case_id" => "a", "status" => "passed"},
            "metrics" => %{
              "usage" => %{
                "input_tokens" => tokens,
                "output_tokens" => 0,
                "total_tokens" => tokens
              },
              "tool_calls" => 1,
              "elapsed_ms" => 10
            }
          }
        end
    }
  end

  defp init_git(root) do
    Evidence.git(root, ["init", "-q"])

    Evidence.git(root, [
      "-c",
      "user.name=Fixture",
      "-c",
      "user.email=fixture@example.invalid",
      "commit",
      "--allow-empty",
      "-qm",
      "Initial"
    ])
  end

  defp temporary do
    root = Path.join(System.tmp_dir!(), "suite-test-#{System.unique_integer([:positive])}")
    File.mkdir_p!(root)
    on_exit(fn -> File.rm_rf!(root) end)
    root
  end
end
