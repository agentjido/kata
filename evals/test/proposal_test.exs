defmodule KataEvolve.ProposalFixture do
  def spec,
    do: %{
      cases: [%{id: "train", split: :train}, %{id: "withheld", split: :final}],
      support: ["helper.exs"]
    }

  def prompt(%{id: "train"}), do: "Read the training project."
  def proposal_instructions, do: "Preserve the public behavior."
  def outcome_contract, do: ["Explain the current behavior with supporting evidence."]
end

defmodule KataEvolve.ProposalTest do
  use ExUnit.Case, async: true
  alias KataEvolve.{Evidence, Proposal, Skill}

  test "feedback distinguishes the fixed source, parent, and rejected candidate" do
    ctx = context()
    reference = trial("original", "source-run", "answer")
    parent = Map.put(reference, :score, 50_000_000)
    previous = trial("rejected text", "previous-run", "different answer")

    history = [
      %{
        "round" => 1,
        "candidate" => Skill.hash(previous.text),
        "decision" => "rejected",
        "reason" => "More tool calls",
        "score_units" => 45_000_000,
        "note" => "Combined reads."
      }
    ]

    feedback = Proposal.feedback(ctx, parent, reference, previous, history, 2)
    assert feedback.reference.file == "reference.md"
    assert feedback.parent.file == "SKILL.md"
    assert feedback.previous_attempt.sha256 == Skill.hash(previous.text)
    assert feedback.target.model == "gpt-6-astra"
    assert feedback.target.reasoning_effort == :xhigh

    assert feedback.outcome_contract.requirements ==
             KataEvolve.ProposalFixture.outcome_contract()

    assert feedback.search_approach.id == "replace-workflow"

    assert Proposal.policy(KataEvolve.ProposalFixture).outcome_contract ==
             feedback.outcome_contract

    assert length(Enum.uniq(Enum.map(1..3, &Proposal.approach/1))) == 3

    assert [%{"decision" => "rejected", "reason" => "More tool calls", "cost_score" => 45.0}] =
             feedback.history

    assert length(feedback.observations) == 2

    assert Enum.map(feedback.observations, & &1.skill) == [
             Skill.hash(reference.text),
             Skill.hash(previous.text)
           ]

    assert Enum.all?(feedback.observations, &(&1.task == "Read the training project."))
    assert Proposal.feedback(ctx, parent, reference, previous, history, 2) == feedback
  end

  test "withheld cases and mismatched executions cannot enter proposal feedback" do
    reference = trial("original", "source-run", "answer")
    [record] = reference.records

    for bad <- [
          Map.put(record, "case_id", "withheld"),
          Map.put(record, "context", "other"),
          Map.put(record, "skill", "other")
        ] do
      trial = %{reference | records: [bad]}

      assert_raise RuntimeError, ~r/matching training evidence only/, fn ->
        Proposal.feedback(context(), Map.put(trial, :score, 50_000_000), trial, nil, [], 1)
      end
    end
  end

  test "feedback bounds answer and file excerpts without copying unchanged project files" do
    trial = trial("original", "source-run", String.duplicate("x", 4_100))
    [record] = trial.records

    files =
      for n <- 1..7,
          into: %{},
          do: {"changed-#{n}.md", %{"type" => "file", "text" => String.duplicate("y", 1_300)}}

    files = Map.put(files, "private.txt", %{"type" => "file", "text" => "UNCHANGED_PROJECT_DATA"})
    record = put_in(record, ["initial", "files", "private.txt"], files["private.txt"])
    record = put_in(record, ["final", "files"], files)
    trial = %{trial | records: [record]}
    feedback = Proposal.feedback(context(), Map.put(trial, :score, 50_000_000), trial, nil, [], 1)
    [observation] = feedback.observations
    assert observation.answer.truncated
    assert String.length(observation.answer.text) == 4_000
    assert length(observation.changed_files) == 6
    assert observation.omitted_changed_files == 1

    assert Enum.all?(
             observation.changed_files,
             &(String.length(&1.content.text) == 1_200 and &1.content.truncated)
           )

    refute Jason.encode!(feedback) =~ "UNCHANGED_PROJECT_DATA"
    refute Jason.encode!(feedback) =~ "withheld"
  end

  defp context,
    do: %{
      id: "fixed",
      module: KataEvolve.ProposalFixture,
      profile: %{provider: :codex, model: "gpt-6-astra", reasoning_effort: :xhigh}
    }

  defp trial(text, execution, answer) do
    snapshot = %{"files" => %{}, "head" => "head", "index" => "index"}

    %{
      text: text,
      records: [
        %{
          "execution_id" => execution,
          "skill" => Skill.hash(text),
          "case_id" => "train",
          "context" => "fixed",
          "answer" => answer,
          "checks" => %{"correct" => true},
          "outcome_test" => %{"status" => "passed"},
          "initial" => snapshot,
          "final" => snapshot,
          "metrics" =>
            Evidence.json(%{
              usage: %{total_tokens: 100},
              tool_calls: 1,
              tools: %{read: 1},
              elapsed_ms: 10
            })
        }
      ]
    }
  end
end
