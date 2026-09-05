defmodule KataEvolve.Score do
  @moduledoc "Fixed-reference costs for case-specific outcome checks."
  alias KataEvolve.{Evidence, Skill}
  @version "skill-quality-v2"
  def version, do: @version

  def calculate(candidate, reference, protocol, validate \\ &Skill.validate/1) do
    base = %{version: @version, protocol: protocol, score: nil, score_units: nil, eligible: false}

    cond do
      not valid_protocol?(protocol) ->
        Map.put(base, :reason, "Invalid case, check, or repetition specification")

      not complete?(candidate, protocol) or not complete?(reference, protocol) ->
        Map.put(base, :reason, "Missing, duplicate or mismatched evidence")

      Enum.any?(candidate.records ++ reference.records, &unresolved?/1) ->
        Map.put(base, :reason, "Execution, capture, checker error, or pending review")

      validate.(reference.text) != :ok or not passing?(reference.records, protocol) ->
        Map.put(base, :reason, "Reference outcome failed")

      validate.(candidate.text) != :ok or Skill.words(candidate.text) > 500 or
          not passing?(candidate.records, protocol) ->
        Map.merge(base, %{score: 0.0, score_units: 0, reason: "Candidate requirement failed"})

      not Enum.all?(candidate.records ++ reference.records, &metrics?/1) ->
        Map.put(base, :reason, "Missing or invalid metrics")

      true ->
        cases =
          Enum.map(protocol.case_ids, fn id ->
            c = medians(candidate.records, id)
            r = medians(reference.records, id)

            cost =
              0.70 * c.tokens / r.tokens + 0.20 * (c.tools + 1) / (r.tools + 1) +
                0.10 * c.time / r.time

            %{id: id, candidate: c, reference: r, cost: cost}
          end)

        cost = Enum.sum(Enum.map(cases, & &1.cost)) / length(cases)
        units = round(100_000_000 / (1 + cost))

        Map.merge(base, %{
          score: units / 1_000_000,
          score_units: units,
          eligible: true,
          cases: cases,
          relative_cost: cost
        })
    end
  end

  defp valid_protocol?(p) do
    is_map(p) and p[:repetitions] in [1, 3] and is_binary(p[:context]) and
      is_list(p[:case_ids]) and p.case_ids != [] and
      length(p.case_ids) == length(Enum.uniq(p.case_ids)) and is_map(p[:checks]) and
      Enum.sort(Map.keys(p.checks)) == Enum.sort(p.case_ids) and
      Enum.all?(p.checks, fn {_case, checks} ->
        is_list(checks) and checks != [] and Enum.all?(checks, &is_binary/1) and
          length(checks) == length(Enum.uniq(checks))
      end)
  end

  def complete?(data, p) do
    records = data.records
    ids = Enum.map(records, & &1["execution_id"])
    groups = Enum.group_by(records, & &1["case_id"])

    p.repetitions in [1, 3] and p.case_ids != [] and
      Enum.sort(Map.keys(groups)) == Enum.sort(p.case_ids) and
      length(ids) == length(Enum.uniq(ids)) and Enum.all?(ids, &(is_binary(&1) and &1 != "")) and
      Enum.all?(groups, fn {_id, rs} ->
        length(rs) == p.repetitions and
          Enum.sort(Enum.map(rs, & &1["repetition"])) == Enum.to_list(1..p.repetitions)
      end) and
      Enum.all?(records, fn r ->
        r["context"] == p.context and r["skill"] == Skill.hash(data.text) and
          (is_nil(p[:assessment]) or r["assessment"] == p.assessment)
      end)
  end

  def passing?(records, p) do
    Enum.all?(records, fn r ->
      checks = Map.fetch!(p.checks, r["case_id"])

      r["status"] == "completed" and r["answer_complete"] == true and
        get_in(r, ["outcome_test", "framework"]) == "ExUnit" and
        get_in(r, ["outcome_test", "status"]) == "passed" and
        get_in(r, ["outcome_test", "case_id"]) == r["case_id"] and
        is_map(r["checks"]) and Enum.sort(Map.keys(r["checks"])) == Enum.sort(checks) and
        Enum.all?(r["checks"], fn {_, value} -> value == true end)
    end)
  end

  defp unresolved?(r) do
    r["status"] != "completed" or r["answer_complete"] != true or
      get_in(r, ["outcome_test", "status"]) in [
        "execution_error",
        "capture_error",
        "checker_error",
        "review"
      ]
  end

  def metrics?(r) do
    m = r["metrics"] || %{}
    u = m["usage"] || %{}
    i = u["input_tokens"]
    o = u["output_tokens"]

    Enum.all?([i, o, m["tool_calls"]], &(is_integer(&1) and &1 >= 0)) and
      i + o > 0 and u["total_tokens"] == i + o and is_integer(m["elapsed_ms"]) and
      m["elapsed_ms"] > 0
  end

  def medians(records, id) do
    rs = Enum.filter(records, &(&1["case_id"] == id))
    median = fn xs -> xs |> Enum.sort() |> Enum.at(div(length(xs), 2)) end

    %{
      tokens: median.(Enum.map(rs, &get_in(&1, ["metrics", "usage", "total_tokens"]))),
      tools: median.(Enum.map(rs, &get_in(&1, ["metrics", "tool_calls"]))),
      time: median.(Enum.map(rs, &get_in(&1, ["metrics", "elapsed_ms"])))
    }
  end

  def input_hashes(records), do: Enum.map(records, &Evidence.identity/1)
end
