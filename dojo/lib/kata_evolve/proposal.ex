defmodule KataEvolve.Proposal do
  @moduledoc "A readable proposal prompt and bounded, labeled training feedback."
  alias KataEvolve.{Evidence, Skill, Suite}
  @version "skill-proposal-v3"
  @approaches [
    %{
      id: "remove-procedure",
      instruction:
        "Remove redundant procedure and repeated checks. Retain the fixed outcomes. A complete rewrite is allowed."
    },
    %{
      id: "replace-workflow",
      instruction:
        "Design a different investigation or execution workflow. Change the order or decision rules instead of adding another checklist."
    },
    %{
      id: "refine-evidence",
      instruction:
        "Use the measured evidence to refine the most useful available approach. Reuse sound ideas from previous text; remove overhead and address proven faults."
    }
  ]

  def approach(round) when is_integer(round) and round > 0,
    do: Enum.at(@approaches, rem(round - 1, length(@approaches)))

  def prompt_path, do: Path.join(KataEvolve.root(), "prompts/propose_skill.md")

  def prompt(module) do
    extra =
      if function_exported?(module, :proposal_instructions, 0),
        do: String.trim(module.proposal_instructions()),
        else: ""

    File.read!(prompt_path()) <>
      if(extra == "", do: "", else: "\nAdditional skill requirements:\n#{extra}\n")
  end

  def policy(module) do
    %{
      version: @version,
      prompt: prompt(module),
      outcome_contract: Suite.outcome_contract(module),
      approaches: @approaches,
      builder_sha256: Evidence.hash(File.read!(__ENV__.file))
    }
  end

  def feedback(ctx, parent, reference, previous, history, round) do
    trials = [reference, parent] ++ if(previous, do: [previous], else: [])
    cases = ctx.module.spec().cases |> Enum.filter(&(&1.split == :train)) |> Map.new(&{&1.id, &1})

    observations =
      trials
      |> Enum.flat_map(fn trial ->
        Enum.map(trial.records, fn record ->
          item = Map.get(cases, record["case_id"])

          unless item && record["context"] == ctx.id && record["skill"] == Skill.hash(trial.text),
            do: raise("Proposal feedback requires matching training evidence only")

          observation(ctx.module, item, record)
        end)
      end)
      |> Enum.uniq_by(& &1.execution_id)

    %{
      version: @version,
      round: round,
      outcome_contract: Suite.outcome_contract(ctx.module),
      search_approach: approach(round),
      target: Map.take(ctx.profile, [:provider, :model, :reasoning_effort]),
      reference: identity(reference.text, "reference.md") |> Map.put(:cost_score, 50.0),
      parent: identity(parent.text, "SKILL.md") |> Map.put(:cost_score, parent.score / 1_000_000),
      previous_attempt: if(previous, do: identity(previous.text, "previous.md")),
      support_paths: ctx.module.spec().support,
      history:
        Enum.map(history, fn decision ->
          decision
          |> Map.take(~w(round candidate decision reason note))
          |> Map.put(
            "cost_score",
            if(decision["score_units"], do: decision["score_units"] / 1_000_000)
          )
        end),
      observations: observations
    }
  end

  defp identity(text, file), do: %{sha256: Skill.hash(text), words: Skill.words(text), file: file}

  defp observation(module, item, record) do
    changed = Evidence.changes(record["initial"], record["final"])

    %{
      execution_id: record["execution_id"],
      skill: record["skill"],
      case_id: item.id,
      task: module.prompt(item),
      checks: record["checks"],
      outcome: record["outcome_test"]["status"],
      review: record["outcome_test"]["review"] || %{},
      failure: excerpt(record["outcome_test"]["failure"] || "", 1_000),
      answer: excerpt(record["answer"] || "", 4_000),
      metrics:
        Map.take(record["metrics"] || %{}, ~w(usage tool_calls tools tool_errors elapsed_ms)),
      changed_files:
        Enum.take(changed, 6)
        |> Enum.map(fn path ->
          file = get_in(record, ["final", "files", path])

          %{
            path: path,
            type: if(file, do: file["type"], else: "deleted"),
            content: if(file && is_binary(file["text"]), do: excerpt(file["text"], 1_200))
          }
        end),
      omitted_changed_files: max(length(changed) - 6, 0)
    }
  end

  def excerpt(text, length),
    do: %{text: String.slice(text, 0, length), truncated: String.length(text) > length}
end
