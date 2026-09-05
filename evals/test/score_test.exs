defmodule KataEvolve.Setup.ScoreTest do
  use ExUnit.Case
  alias KataEvolve.Setup.{Fixture, Score, Skill, Store}

  setup do
    protocol = %{context: "fixed", case_ids: ["a", "b"], checks: ["correct"], repetitions: 1}
    reference = evidence(300, protocol)
    %{protocol: protocol, reference: reference}
  end

  test "baseline is 50 and shorter text alone earns no reward", ctx do
    assert score(ctx.reference, ctx).score == 50.0
    assert score(evidence(200, ctx.protocol), ctx).score == 50.0
    assert score(evidence(501, ctx.protocol), ctx).score == 0.0
  end

  test "cost weights, equal case weight, and monotonicity", ctx do
    candidate = evidence(250, ctx.protocol, 2)
    # Doubling tokens/time gives ratios 2; tools change from 2 to 4,
    # so their smoothed ratio is 5/3. Relative cost is 29/15.
    assert_in_delta score(candidate, ctx).score, 34.090909, 0.000001
    assert score(candidate, ctx).score < score(ctx.reference, ctx).score
    assert score(evidence(250, ctx.protocol, 0.5), ctx).score > 50.0

    candidate = %{candidate | records: [hd(ctx.reference.records), List.last(candidate.records)]}
    # Restore the candidate identity on the baseline-cost first case.
    candidate = %{
      candidate
      | records: Enum.map(candidate.records, &Map.put(&1, "skill", id(candidate.text)))
    }

    assert_in_delta score(candidate, ctx).score, 40.540541, 0.000001
  end

  test "failed checks and execution failures earn zero regardless of low cost", ctx do
    candidate = evidence(250, ctx.protocol, 0.5)

    for change <- [
          &Map.put(&1, "checks", %{"correct" => false}),
          &Map.put(&1, "checks", %{}),
          &Map.delete(&1, "outcome_test"),
          &Map.put(&1, "status", "error")
        ] do
      failed = %{candidate | records: List.update_at(candidate.records, 0, change)}
      assert %{score_units: 0, eligible: false} = score(failed, ctx)
    end
  end

  test "missing costs, cases, and different contexts are unscored", ctx do
    candidate = evidence(250, ctx.protocol)

    variants = [
      %{candidate | records: tl(candidate.records)},
      %{candidate | records: candidate.records ++ [hd(candidate.records)]},
      %{
        candidate
        | records: List.update_at(candidate.records, 0, &Map.put(&1, "context", "other"))
      },
      %{
        candidate
        | records:
            List.update_at(candidate.records, 0, &put_in(&1, ["metrics", "tool_calls"], nil))
      }
    ]

    for invalid <- variants, do: assert(%{score: nil, eligible: false} = score(invalid, ctx))

    broken = %{
      ctx.reference
      | records: Enum.map(ctx.reference.records, &Map.put(&1, "status", "error"))
    }

    assert Score.calculate(candidate, broken, ctx.protocol).score == nil
  end

  test "repeated evidence uses medians, preserves failures, and ignores input order", ctx do
    protocol = %{ctx.protocol | repetitions: 3}
    reference = evidence(300, protocol)
    candidate = evidence(250, protocol)

    expensive = fn record ->
      record
      |> put_in(["metrics", "usage", "input_tokens"], 990)
      |> put_in(["metrics", "usage", "total_tokens"], 1000)
      |> put_in(["metrics", "elapsed_ms"], 10000)
    end

    candidate = %{candidate | records: List.update_at(candidate.records, 0, expensive)}
    result = Score.calculate(candidate, reference, protocol)
    assert result.score == 50.0
    assert result.evidence == "repeated"

    assert result ==
             Score.calculate(
               %{candidate | records: Enum.reverse(candidate.records)},
               reference,
               protocol
             )

    failed = %{
      candidate
      | records: List.update_at(candidate.records, 0, &Map.put(&1, "status", "error"))
    }

    assert Score.calculate(failed, reference, protocol).score == 0.0

    duplicates = %{
      candidate
      | records:
          candidate.records
          |> Enum.uniq_by(& &1["case_id"])
          |> Enum.flat_map(&List.duplicate(&1, 3))
    }

    assert Score.calculate(duplicates, reference, protocol).score == nil
    assert Score.calculate(candidate, reference, %{protocol | case_ids: []}).score == nil
  end

  test "zero tool calls are valid and do not cause division by zero", ctx do
    zero = fn data ->
      %{data | records: Enum.map(data.records, &put_in(&1, ["metrics", "tool_calls"], 0))}
    end

    reference = zero.(ctx.reference)
    assert Score.calculate(reference, reference, ctx.protocol).score == 50.0
  end

  test "saved Sol example is reproducible and remains exploratory" do
    result = Score.from_saved("codex-sol-medium", "b76130fc2246", "29c4ddc219b8")
    assert result.score == 43.654704
    assert result.evidence == "exploratory"
    assert length(result.cases) == 3
    assert result == Score.from_saved("codex-sol-medium", "b76130fc2246", "29c4ddc219b8")

    assert Score.from_saved("codex-sol-medium", "b76130fc2246", "29c4ddc219b8", 3).score == nil
  end

  test "generated files must pass Elixir outcome assertions before earning a quality score" do
    dir = Path.join(KataEvolve.root(), "results/setup/codex-sol-medium")
    id = "abf90ebc381b"

    records =
      Path.wildcard(Path.join(dir, "cases/b76130fc2246-#{id}-*.json"))
      |> Enum.map(&(Store.read(&1) |> Store.recheck()))

    reference = %{text: File.read!(Path.join(dir, "skills/#{id}.md")), records: records}

    protocol = %{
      context: "b76130fc2246",
      case_ids: Enum.map(records, & &1["case_id"]),
      checks: Fixture.check_names(),
      repetitions: 1
    }

    assert Score.calculate(reference, reference, protocol).score == 50.0

    for {path, replacement} <- [
          {"docs/README.md", nil},
          {"docs/AGENTS.md", "# Rules\n"},
          {"docs/README.md", "# Index\n[Rules](missing.md)\n"},
          {"docs/inbox/README.md", "# Inbox\nAll material is approved.\n"}
        ] do
      record = hd(records)
      files = record["final"]["files"]

      files =
        if replacement,
          do: Map.put(files, path, %{"type" => "file", "text" => replacement}),
          else: Map.delete(files, path)

      # Cached success cannot hide an incorrect output file.
      checked = record |> put_in(["final", "files"], files) |> Store.recheck()
      assert checked["outcome_test"]["status"] == "failed"
      candidate = %{reference | records: [checked | tl(records)]}
      assert %{score_units: 0, eligible: false} = Score.calculate(candidate, reference, protocol)
    end
  end

  defp score(candidate, ctx), do: Score.calculate(candidate, ctx.reference, ctx.protocol)
  defp id(text), do: Skill.hash(text) |> String.slice(0, 12)

  defp evidence(words, protocol, factor \\ 1) do
    prefix = "---\nname: kata-setup\ndescription: Setup.\n---\ntemplates/docs-agents.md "
    text = prefix <> String.duplicate("word ", words - Skill.words(prefix))

    records =
      for case_id <- protocol.case_ids, repetition <- 1..protocol.repetitions do
        tokens = round(100 * factor)

        %{
          "case_id" => case_id,
          "skill" => id(text),
          "context" => protocol.context,
          "recorded_at" => "2026-09-05T12:00:0#{repetition}Z",
          "status" => "completed",
          "checks" => Map.new(protocol.checks, &{&1, true}),
          "outcome_test" => %{"framework" => "ExUnit", "case_id" => case_id, "status" => "passed"},
          "metrics" => %{
            "usage" => %{
              "input_tokens" => tokens - 10,
              "output_tokens" => 10,
              "total_tokens" => tokens
            },
            "tool_calls" => round(2 * factor),
            "elapsed_ms" => round(1000 * factor)
          }
        }
      end

    %{text: text, records: records}
  end
end
