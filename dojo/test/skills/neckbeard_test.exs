Code.require_file("../../suites/neckbeard.exs", __DIR__)

defmodule KataEvolve.NeckbeardTest do
  use ExUnit.Case, async: true
  alias KataEvolve.NeckbeardSuite, as: Suite
  @fixtures Path.expand("../fixtures/kata-neckbeard", __DIR__)

  test "fixed good answers and bad answers calibrate outcome checks" do
    examples = File.read!(Path.join(@fixtures, "calibration/manifest.json")) |> Jason.decode!()

    for example <- examples do
      answer = File.read!(Path.join([@fixtures, "calibration", example["file"]]))
      record = record(example["case"], answer)
      checks = Suite.check(record, %{id: example["case"]})

      assert Enum.all?(checks, &(elem(&1, 1) == true)) == example["pass"],
             "#{example["file"]}: #{inspect(checks)}"

      if example["pass"], do: assert(Suite.assert_outcome!(record, %{id: example["case"]}) == :ok)
    end
  end

  test "a correct answer cannot hide edits, deletion, extra output, or incomplete capture" do
    answer = File.read!(Path.join(@fixtures, "calibration/train-retry-good.md"))
    original = record("train-retry", answer)

    for final <- [
          put_in(original["final"], ["files", "client.py", "text"], "changed"),
          update_in(original["final"], ["files"], &Map.delete(&1, "client.py")),
          put_in(original["final"], ["files", "answer.md"], %{"type" => "file", "text" => answer}),
          Map.put(original["final"], "head", "changed"),
          Map.put(original["final"], "index", "changed")
        ] do
      checks = Suite.check(Map.put(original, "final", final), %{id: "train-retry"})
      refute checks["project_unchanged"]
    end

    refute Suite.check(Map.put(original, "answer_complete", false), %{id: "train-retry"})[
             "answer_present"
           ]
  end

  test "citation parser validates current target paths and actual lines" do
    files = record("train-retry", "")["initial"]["files"]

    for href <- [
          "client.py:3",
          "/tmp/isolated/client.py:3",
          "client.py#L3-L5",
          " /tmp/isolated/client.py:3 "
        ] do
      assert [%{valid: true, path: "client.py"}] = Suite.citations("[source](#{href})", files)
    end

    for href <- [
          "../client.py:3",
          "client.py:999",
          "missing.py:3",
          "https://example.org/client.py:3"
        ] do
      assert [%{valid: false}] = Suite.citations("[source](#{href})", files)
    end
  end

  test "real saved table answer passes without changing the failed execution record" do
    path = Path.join(@fixtures, "replay/train-retry-1.json")
    bytes = File.read!(path)
    record = Jason.decode!(bytes)
    assert record["outcome_test"]["status"] == "failed"
    checked = KataEvolve.Suite.recheck(Suite, record)
    assert checked["outcome_test"]["status"] == "passed", inspect(checked["checks"])
    assert File.read!(path) == bytes

    # Column names and citation scope matter. These are not accepted just because
    # the same numbers occur somewhere in the answer.
    for answer <- [
          String.replace(
            record["answer"],
            "| Implementation | Guide |",
            "| Guide | Implementation |"
          ),
          String.replace(record["answer"], "Says **5**", "Says **8**"),
          String.replace(record["answer"], "guides/retries.md:3", "tests/test_client.py:7"),
          String.replace(record["answer"], "The guide’s three claims", "An unrelated test"),
          record["answer"] <> "\nThe status was chosen because it improves performance."
        ] do
      refute KataEvolve.Suite.recheck(Suite, Map.put(record, "answer", answer))["outcome_test"][
               "status"
             ] == "passed"
    end
  end

  test "prepare supplies a dirty export fixture but no expected answers or checker" do
    root = Path.join(System.tmp_dir!(), "neckbeard-local-#{System.unique_integer([:positive])}")
    File.mkdir_p!(root)
    on_exit(fn -> File.rm_rf!(root) end)
    Suite.prepare(root, %{id: "final-export"})
    assert File.read!(Path.join(root, "local.cache")) =~ "ignored cache"
    assert File.read!(Path.join(root, "operator-note.txt")) =~ "untracked"
    {status, 0} = System.cmd("git", ["status", "--short", "--ignored"], cd: root)
    assert status =~ "MM exporter/README.md"
    assert status =~ "?? operator-note.txt"
    assert status =~ "!! local.cache"
    refute File.exists?(Path.join(root, "expected"))
    refute File.exists?(Path.join(root, "calibration"))
  end

  test "shared table sources keep guide and implementation columns separate" do
    answer = File.read!(Path.join(@fixtures, "calibration/train-retry-shared-table.md"))
    assert Suite.assert_outcome!(record("train-retry", answer), %{id: "train-retry"}) == :ok

    for changed <- [
          String.replace(answer, "| Guide | Implementation |", "| Implementation | Guide |"),
          String.replace(answer, "Up to **5**", "Up to **8**"),
          String.replace(answer, "/client.py:3", "/client.py:1"),
          String.replace(answer, "[implementation]", "[unrelated]"),
          String.replace(answer, "/guides/retries.md:3", "/tests/test_client.py:7")
        ] do
      refute Enum.all?(
               Suite.check(record("train-retry", changed), %{id: "train-retry"}),
               &(elem(&1, 1) == true)
             )
    end

    files = record("train-retry", "")["initial"]["files"]
    assert [%{first: 3, last: 5}] = Suite.citations("[Source](client.py:3)", files)
    assert [%{first: 1, last: 1}] = Suite.citations("[Source](client.py:1)", files)
  end

  defp record(id, answer) do
    root = Path.join([@fixtures, "input", id])

    files =
      Path.wildcard(root <> "/**/*", match_dot: true)
      |> Enum.filter(&File.regular?/1)
      |> Map.new(
        &{Path.relative_to(&1, root),
         %{"type" => "file", "text" => File.read!(&1), "mode" => 0o644}}
      )

    snapshot = %{"files" => files, "head" => "fixture-head", "index" => "fixture-index"}

    %{
      "case_id" => id,
      "answer" => answer,
      "answer_complete" => true,
      "initial" => snapshot,
      "final" => snapshot
    }
  end

  test "all three live answers pass without prescribing table or citation placement" do
    for round <- 1..3 do
      answer = File.read!(Path.join(@fixtures, "calibration/train-retry-live-round-#{round}.md"))
      original = record("train-retry", answer)
      assert Suite.assert_outcome!(original, %{id: "train-retry"}) == :ok

      for changed <- [
            String.replace(answer, "| Guide | Implementation |", "| Implementation | Guide |") <>
              "\nThe client makes four total attempts. [Client](client.py:3-15)",
            String.replace(answer, "/client.py:3", "/client.py:1"),
            answer <> "\nThe client has a delay of 100 seconds. [Client](client.py:3-15)",
            answer <> "\nAll tests passed."
          ] do
        checked = KataEvolve.Suite.recheck(Suite, Map.put(original, "answer", changed))
        refute checked["outcome_test"]["status"] == "passed", "Round #{round}: #{changed}"
      end
    end
  end

  test "unresolved prose requires review while known wrong facts fail" do
    answer = File.read!(Path.join(@fixtures, "calibration/train-retry-good.md"))

    unresolved =
      String.replace(answer, "three total attempts", "a small number of total attempts")

    checked = KataEvolve.Suite.recheck(Suite, record("train-retry", unresolved))
    assert checked["outcome_test"]["status"] == "review"
    assert checked["outcome_test"]["review"]["required_claims"] =~ "attempts"

    for name <- ["wrong-count", "wrong-units", "negated-status", "false-test-pass"] do
      answer = File.read!(Path.join(@fixtures, "calibration/train-retry-#{name}.md"))
      checked = KataEvolve.Suite.recheck(Suite, record("train-retry", answer))
      assert checked["outcome_test"]["status"] == "failed", inspect(checked["checks"])
    end
  end

  test "real network behavior is a runtime evidence limit" do
    answer = File.read!(Path.join(@fixtures, "calibration/train-retry-live-v3-source.md"))
    assert Suite.assert_outcome!(record("train-retry", answer), %{id: "train-retry"}) == :ok

    changed =
      String.replace(
        answer,
        "they do not establish real network behavior or actual elapsed delay",
        "they establish real network behavior and actual elapsed delay"
      )

    checked = KataEvolve.Suite.recheck(Suite, record("train-retry", changed))
    refute checked["outcome_test"]["status"] == "passed"
  end
end
