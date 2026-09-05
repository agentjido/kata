defmodule KataEvolve.Setup.Score do
  @moduledoc "Deterministic setup quality from fixed evidence; no model calls."
  alias KataEvolve.Setup.{Fixture, Skill, Store}

  @version "setup-quality-v1"

  def rules do
    %{
      version: @version,
      max_words: 500,
      weights: %{tokens: 70, tool_calls: 20, elapsed_ms: 10},
      score_decimal_places: 6
    }
  end

  def calculate(candidate, reference, protocol) do
    result = Map.merge(rules(), %{protocol: protocol, score: nil, eligible: false})

    cond do
      not valid_protocol?(protocol) ->
        Map.put(result, :reason, "Invalid case, check, or repetition specification")

      not complete?(candidate, protocol) or not complete?(reference, protocol) ->
        Map.put(result, :reason, "Missing, duplicate, or mismatched execution evidence")

      Skill.validate(reference.text) != :ok or not passing?(reference.records, protocol.checks) ->
        Map.put(result, :reason, "The fixed reference must pass every required check")

      Skill.validate(candidate.text) != :ok or Skill.words(candidate.text) > result.max_words or
          not passing?(candidate.records, protocol.checks) ->
        Map.merge(result, %{score: 0.0, score_units: 0, reason: "Candidate failed a requirement"})

      not Enum.all?(candidate.records ++ reference.records, &metrics?/1) ->
        Map.put(result, :reason, "Missing or invalid cost measurements")

      true ->
        cases =
          for id <- Enum.sort(protocol.case_ids) do
            c = medians(candidate.records, id)
            b = medians(reference.records, id)

            ratios = %{
              tokens: c.tokens / b.tokens,
              tool_calls: (c.tool_calls + 1) / (b.tool_calls + 1),
              elapsed_ms: c.elapsed_ms / b.elapsed_ms
            }

            weights = result.weights

            cost =
              (weights.tokens * ratios.tokens + weights.tool_calls * ratios.tool_calls +
                 weights.elapsed_ms * ratios.elapsed_ms) / 100

            %{case_id: id, candidate: c, reference: b, ratios: ratios, relative_cost: cost}
          end

        cost = Enum.sum(Enum.map(cases, & &1.relative_cost)) / length(cases)
        units = round(100_000_000 / (1 + cost))

        Map.merge(result, %{
          score: units / 1_000_000,
          score_units: units,
          eligible: true,
          evidence: if(protocol.repetitions == 3, do: "repeated", else: "exploratory"),
          relative_cost: cost,
          cases: cases
        })
    end
  end

  def from_saved(profile, context, candidate_id, repetitions \\ 1) do
    Store.profile(profile)

    unless Enum.all?([context, candidate_id], &Regex.match?(~r/\A[0-9a-f]{12}\z/, &1)),
      do: raise(ArgumentError, "Use the exact 12-character context and skill IDs")

    dir = Path.join(KataEvolve.root(), "results/setup/#{profile}")
    context_path = Path.join(dir, "context-#{context}.json")
    identity = Store.read(context_path)
    reference_id = String.slice(identity["baseline"], 0, 12)
    cases = Fixture.cases()
    case_ids = Enum.map(cases.train ++ cases.validation ++ cases.test, & &1.id)

    load = fn id ->
      skill_path = Path.join(dir, "skills/#{id}.md")
      paths = Path.wildcard(Path.join(dir, "cases/#{context}-#{id}-*.json"))

      data = %{
        text: File.read!(skill_path),
        records: Enum.map(paths, &(Store.read(&1) |> Store.recheck()))
      }

      {data, [skill_path | paths]}
    end

    {candidate, candidate_paths} = load.(candidate_id)
    {reference, reference_paths} = load.(reference_id)

    unless identity["profile_name"] == profile and
             Skill.hash(reference.text) == identity["baseline"] and
             String.starts_with?(Skill.hash(candidate.text), candidate_id),
           do:
             raise(ArgumentError, "Saved context does not match the requested skills or profile")

    protocol = %{
      context: context,
      case_ids: case_ids,
      checks: Fixture.check_names(),
      repetitions: repetitions
    }

    checker_paths =
      for name <- ~w(fixture snapshot skill store score),
          do: Path.join(KataEvolve.root(), "lib/kata_evolve/setup/#{name}.ex")

    paths = [context_path | candidate_paths ++ reference_paths ++ checker_paths]

    inputs =
      paths
      |> Enum.uniq()
      |> Enum.sort()
      |> Map.new(&{Path.relative_to(&1, KataEvolve.root()), Skill.hash(File.read!(&1))})

    calculate(candidate, reference, protocol)
    |> Map.merge(%{
      profile: profile,
      candidate: Skill.hash(candidate.text),
      reference: Skill.hash(reference.text),
      outcome_tests: %{
        candidate: Enum.map(candidate.records, & &1["outcome_test"]),
        reference: Enum.map(reference.records, & &1["outcome_test"])
      },
      inputs: inputs
    })
  end

  defp valid_protocol?(p) do
    p.repetitions in [1, 3] and p.case_ids != [] and p.checks != [] and
      Enum.uniq(p.case_ids) == p.case_ids and Enum.uniq(p.checks) == p.checks
  end

  defp complete?(data, p) do
    id = Skill.hash(data.text) |> String.slice(0, 12)
    groups = Enum.group_by(data.records, & &1["case_id"])

    Enum.sort(Map.keys(groups)) == Enum.sort(p.case_ids) and
      Enum.all?(groups, fn {_case, records} ->
        times = Enum.map(records, & &1["recorded_at"])

        length(records) == p.repetitions and length(Enum.uniq(times)) == p.repetitions and
          Enum.all?(records, fn r ->
            r["context"] == p.context and r["skill"] == id and
              is_binary(r["recorded_at"]) and r["recorded_at"] != ""
          end)
      end)
  end

  defp passing?(records, checks) do
    Enum.all?(records, fn r ->
      r["status"] == "completed" and is_map(r["checks"]) and
        get_in(r, ["outcome_test", "framework"]) == "ExUnit" and
        get_in(r, ["outcome_test", "case_id"]) == r["case_id"] and
        get_in(r, ["outcome_test", "status"]) == "passed" and
        Enum.sort(Map.keys(r["checks"])) == Enum.sort(checks) and
        Enum.all?(r["checks"], fn {_, value} -> value == true end)
    end)
  end

  defp metrics?(r) do
    input = get_in(r, ["metrics", "usage", "input_tokens"])
    output = get_in(r, ["metrics", "usage", "output_tokens"])
    tools = get_in(r, ["metrics", "tool_calls"])
    time = get_in(r, ["metrics", "elapsed_ms"])

    Enum.all?([input, output, tools], &(is_integer(&1) and &1 >= 0)) and
      input + output > 0 and is_integer(time) and time > 0 and
      get_in(r, ["metrics", "usage", "total_tokens"]) == input + output
  end

  defp medians(records, id) do
    records = Enum.filter(records, &(&1["case_id"] == id))
    median = fn values -> values |> Enum.sort() |> Enum.at(div(length(values), 2)) end

    %{
      tokens: median.(Enum.map(records, &get_in(&1, ["metrics", "usage", "total_tokens"]))),
      tool_calls: median.(Enum.map(records, &get_in(&1, ["metrics", "tool_calls"]))),
      elapsed_ms: median.(Enum.map(records, &get_in(&1, ["metrics", "elapsed_ms"])))
    }
  end
end
