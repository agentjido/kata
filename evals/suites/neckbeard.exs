Code.require_file("support/neckbeard_project.exs", __DIR__)

defmodule KataEvolve.NeckbeardSuite do
  @behaviour KataEvolve.Suite
  @moduledoc "Read-only investigation outcomes; semantic review remains a separate gate."
  @id "kata-neckbeard"
  @fixture Path.expand("../test/fixtures/kata-neckbeard", __DIR__)
  @root Path.expand("../..", __DIR__)
  @checks ~w(answer_present required_claims supporting_citations documentation_conflict missing_reason evidence_limits no_false_runtime_claim no_contradiction no_invented_reason project_unchanged)

  def spec do
    %{
      id: @id,
      source: Path.join(@root, "skills/#{@id}/SKILL.md"),
      support: [],
      cases: [
        %{id: "train-retry", split: :train, writable: []},
        %{id: "final-cache", split: :final, writable: []},
        %{id: "final-export", split: :final, writable: []}
      ],
      inputs: [__ENV__.file, @fixture],
      execution_inputs: [
        Path.join(@fixture, "input"),
        Path.join(__DIR__, "support/neckbeard_project.exs")
      ],
      checks: Map.new(~w(train-retry final-cache final-export), &{&1, @checks})
    }
  end

  def validate(text) do
    valid =
      Regex.match?(~r/\A---\nname: kata-neckbeard\ndescription: [^\n]+\n/s, text) and
        not Regex.match?(~r/Original author:|Adapted for Kata by|language:\s*elixir/i, text)

    if valid,
      do: :ok,
      else:
        {:error, "Keep neckbeard name and description; no author credit or language restriction"}
  end

  def proposal_instructions do
    """
    Keep natural answers and language-independent scope. Reading order, headings,
    internal checklists, and investigation procedure can change. Do not add fixture-specific
    values, paths, response templates, or evaluator instructions.
    """
  end

  defdelegate prepare(root, item), to: KataEvolve.NeckbeardProject

  def outcome_contract do
    [
      "Answer the user's question about the correct current repository, with accurate material claims supported by relevant source files and lines.",
      "Distinguish implemented behavior from documented requirements or intent; identify relevant disagreements and cite both sources.",
      "Use relevant source, documentation, configuration, tests, and recorded history as evidence where the question requires them.",
      "Do not infer design history or rationale from implementation alone. State missing evidence and separate facts from deductions.",
      "State the limits of static inspection. Do not claim tests passed or deployed behavior was verified without evidence.",
      "Keep the work within investigation and reporting. Follow applicable project instructions and preserve project files and Git state."
    ]
  end

  def prompt(item) do
    "Use kata-neckbeard. Read .agents/skills/kata-neckbeard/SKILL.md. " <>
      expected(item.id)["question"]
  end

  def expected(id),
    do: Path.join([@fixture, "expected", "#{id}.json"]) |> File.read!() |> Jason.decode!()

  def check(record, item) do
    answer = record["answer"] || ""
    contract = expected(item.id)
    blocks = claim_blocks(answer)
    files = get_in(record, ["initial", "files"]) || %{}
    citations = citations(answer, files)

    claim_results =
      Map.new(contract["claims"], fn claim ->
        passed =
          Enum.any?(blocks, fn block ->
            relation?(block, claim) and
              Enum.any?(citations(block, files), &supports?(&1, claim["evidence"]))
          end)

        {claim["id"], passed}
      end)

    missing = for {id, false} <- claim_results, do: id

    results = %{
      "answer_present" => String.trim(answer) != "" and record["answer_complete"] == true,
      "required_claims" =>
        recognized(
          missing == [],
          "Unresolved claims or evidence: #{Enum.join(Enum.sort(missing), ", ")}"
        ),
      "supporting_citations" =>
        citations != [] and Enum.all?(citations, & &1.valid) and
          Enum.any?(citations, &(&1.path in contract["test_files"])),
      "documentation_conflict" =>
        recognized(
          missing == [] or
            Regex.match?(
              ~r/\b(?:conflict|contradict|differ|mismatch|outdated|incorrect|disagree|stale|does not match|doesn't match|inaccurate)/i,
              answer
            ),
          "Cannot establish the documentation comparison"
        ),
      "missing_reason" =>
        recognized(missing_reason?(answer), "Cannot establish the limits of rationale evidence"),
      "evidence_limits" =>
        recognized(
          Regex.match?(
            ~r/(?:static|inspect|source|not\s+(?:run|execut|verif)|did\s+not\s+(?:run|execut|verif))/i,
            answer
          ) and
            Regex.match?(
              ~r/(?:not|cannot|can't|unverified|unknown|unconfirmed)[^.!?\n]{0,100}(?:deploy|production|runtime|real network|live behavior)|(?:deploy|production|runtime|real network|live behavior)[^.!?\n]{0,100}(?:not|unverified|unknown|unconfirmed)/i,
              answer
            ),
          "Cannot establish the limits of static or deployed evidence"
        ),
      "no_false_runtime_claim" => no_runtime_claim?(answer),
      "no_contradiction" =>
        not explicit_retry_error?(item.id, blocks) and
          not Enum.any?(
            contract["forbidden"],
            &Regex.match?(Regex.compile!(&1, "i"), strip_links(answer))
          ),
      "no_invented_reason" =>
        not Regex.match?(
          ~r/(?:chosen|selected|designed|picked)[^.!?\n]{0,40}(?:because|for performance|to reduce|to improve)/i,
          answer
        ),
      "project_unchanged" => record["initial"] == record["final"]
    }

    # The shared runner records these assertions. No saved success flag is trusted.
    results
  end

  def assert_outcome!(record, item) do
    for {name, passed} <- check(record, item) do
      ExUnit.Assertions.assert(passed == true, "Neckbeard outcome failed: #{name}")
    end

    :ok
  end

  defp recognized(true, _), do: true
  defp recognized(false, reason), do: {:review, reason}

  # Recognized wrong numeric claims remain failures. An unfamiliar prose form
  # remains unresolved instead of becoming a fabricated behavior failure.
  defp explicit_retry_error?("train-retry", blocks) do
    blocks
    |> Enum.flat_map(fn block ->
      plain = strip_links(block) |> String.replace(~r/[*`_]/, "")
      inherited = implementation_subject?(plain)
      Enum.map(String.split(plain, ~r/(?<=[.!?])\s+|\n/, trim: true), &{&1, inherited})
    end)
    |> Enum.any?(fn {plain, inherited} ->
      implementation =
        implementation_subject?(plain) or (inherited and Regex.match?(~r/\A\s*It\b/i, plain))

      implementation and not Regex.match?(~r/\b(?:guide|docs|documentation|tests?)\b/i, plain) and
        (Enum.any?(
           Regex.scan(~r/\b(one|two|three|four|five|six|\d+)\s+(?:total\s+)?attempts\b/i, plain),
           fn [_, number] -> String.downcase(number) not in ["3", "three"] end
         ) or
           Enum.any?(
             Regex.scan(~r/\b(\d+(?:\.\d+)?)\s*(seconds|milliseconds|ms)\b/i, plain),
             fn [_, number, unit] ->
               {value, ""} = Float.parse(number)
               value != if(String.downcase(unit) == "seconds", do: 0.1, else: 100.0)
             end
           ))
    end)
  end

  defp explicit_retry_error?(_, _), do: false

  defp implementation_subject?(plain),
    do:
      Regex.match?(
        ~r/\A\s*(?:implementation|source|code|(?:the\s+)?client|fetch|by default)\b/i,
        plain
      )

  defp relation?(block, claim) do
    plain = strip_links(block) |> String.replace(~r/[*`_]/, "")

    plain =
      if claim["id"] == "delay",
        do: String.replace(plain, ~r/\b(?:time\.)?sleep\(0\.1\)/, "0.1 seconds"),
        else: plain

    Regex.match?(Regex.compile!(claim["relation"], "i"), plain) and
      (claim["intent"] != true or
         Regex.match?(~r/\b(?:guide|manual|readme|document|docs|claim|says|states)/i, plain))
  end

  defp missing_reason?(answer) do
    Regex.match?(
      ~r/(?:no|not|cannot|can't|unknown|unrecorded|missing|doesn't|does not)[^.!?\n]{0,160}(?:reason|rationale|why|decision|history|record|choice)|(?:reason|rationale|why|decision)[^.!?\n]{0,160}(?:not|unknown|missing|cannot|can't|no\s+(?:evidence|record))/i,
      answer
    )
  end

  defp no_runtime_claim?(answer) do
    answer
    |> String.split(~r/(?<=[.!?])\s+|[;\n]/, trim: true)
    |> Enum.all?(fn block ->
      positive =
        Regex.match?(
          ~r/(?:tests?\s+(?:all\s+)?(?:pass(?:ed)?|succeed(?:ed)?)|(?:ran|executed)\s+(?:the\s+)?tests|(?:verified|confirmed)\s+(?:the\s+)?(?:deployment|production)|(?:establish|verify|confirm)(?:es|ed)?\s+(?:the\s+)?(?:real network|runtime|deployed|production|actual elapsed|live behavior))/i,
          block
        )

      negative =
        Regex.match?(
          ~r/(?:not|never|didn't|did not|cannot|can't)[^.!?\n]{0,90}(?:run|execut|pass|verif|confirm|establish)|(?:have|has)\s+not/i,
          block
        )

      not positive or negative
    end)
  end

  # Table cells keep their own column subject. Shared links bind by the column
  # subject and link label, so guide and implementation evidence cannot mix.
  defp claim_blocks(answer) do
    parts = blocks(answer)

    Enum.with_index(parts)
    |> Enum.flat_map(fn {part, index} ->
      rows = String.split(part, "\n", trim: true)

      if length(rows) >= 3 and Enum.all?(rows, &String.starts_with?(String.trim(&1), "|")) do
        [header, separator | body] = Enum.map(rows, &cells/1)

        if Enum.all?(separator, &Regex.match?(~r/\A:?-+:?\z/, &1)) do
          adjacent = [
            if(index > 0, do: Enum.at(parts, index - 1), else: ""),
            Enum.at(parts, index + 1, "")
          ]

          Enum.flat_map(body, fn row ->
            label = hd(row)

            Enum.zip(tl(header), tl(row))
            |> Enum.map(fn {subject, cell} ->
              plain = strip_links(cell) |> String.replace(~r/[*`_]/, "")

              value =
                case Regex.run(
                       ~r/\A\s*(?:Says\s+)?(?:(?:up to|at most)\s+)?(\d+|one|two|three|four|five)\b/i,
                       plain
                     ) do
                  [_, number] -> "#{number} #{label}. "
                  _ -> ""
                end

              pointer = Enum.map_join(adjacent, " ", &shared_pointer(&1, subject))

              "#{subject}: #{value}#{label}: #{cell}\n#{pointer}"
            end)
          end)
        else
          [part]
        end
      else
        [part]
      end
    end)
  end

  defp shared_pointer(paragraph, subject) do
    family =
      cond do
        Regex.match?(~r/guide|docs?|document|manual|readme/i, subject) ->
          ~r/\b(?:guides?|docs?|documentation|manual|readme)\b/i

        Regex.match?(~r/implementation|source|code/i, subject) ->
          ~r/\b(?:implementation|source|code)\b/i

        true ->
          ~r/(?!)/
      end

    narrative = Regex.replace(~r/\[[^\]]*\]\([^)]*\)/, paragraph, "")

    if Regex.match?(family, narrative) or
         Regex.match?(
           ~r/\b(?:sources?|references?|compare|see)\b|\A\s*(?:and|[,;:.])*\s*\z/i,
           narrative
         ) do
      Regex.scan(~r/\[([^\]]*)\]\([^)]*\)/, paragraph)
      |> Enum.filter(fn [_, label] -> Regex.match?(family, label) end)
      |> Enum.map_join(" ", &hd/1)
    else
      ""
    end
  end

  defp cells(line),
    do: line |> String.trim() |> String.trim("|") |> String.split("|") |> Enum.map(&String.trim/1)

  # A link can point to the start of a Markdown paragraph or a contiguous block
  # of constant assignments. Do not expand across a blank line or other code.
  defp passage_end(path, text, first, last)
       when is_binary(path) and is_binary(text) and first == last do
    if String.ends_with?(path, ".py") and first > 0 do
      constants =
        text
        |> String.split("\n")
        |> Enum.drop(first - 1)
        |> Enum.take_while(&Regex.match?(~r/\A[A-Z][A-Z0-9_]*\s*=/, &1))

      max(last, first + length(constants) - 1)
    else
      paragraph_end(path, text, first, last)
    end
  end

  defp passage_end(_, _, _, last), do: last

  defp paragraph_end(path, text, first, last) do
    if String.ends_with?(path, ".md") and first > 0 do
      lines = String.split(text, "\n")
      previous = Enum.at(lines, first - 2, "")

      if first == 1 or String.trim(previous) == "" do
        rest =
          lines
          |> Enum.drop(first - 1)
          |> Enum.take_while(&(String.trim(&1) != "" and not String.starts_with?(&1, "#")))

        max(last, first + length(rest) - 1)
      else
        last
      end
    else
      last
    end
  end

  def blocks(answer), do: String.split(answer, ~r/\n\s*\n/, trim: true)
  defp strip_links(text), do: Regex.replace(~r/\[([^\]]+)\]\([^)]*\)/, text, "\\1")

  def citations(answer, files) do
    markdown = Regex.scan(~r/\[[^\]]*\]\(<?([^)>]+)>?\)/, answer) |> Enum.map(&Enum.at(&1, 1))
    # Support plain source references as well as Markdown links.
    bare =
      Regex.scan(
        ~r/(?<![\w\/])([\w.\/-]+\.(?:py|ts|sql|md):\d+(?:[-–]\d+)?)/,
        Regex.replace(~r/\[[^\]]*\]\([^)]*\)/, answer, "")
      )
      |> Enum.map(&Enum.at(&1, 1))

    Enum.map(Enum.uniq(markdown ++ bare), fn href ->
      case Regex.run(
             ~r/\A(.+?)(?::(\d+)(?:[-–](\d+))?|#L(\d+)(?:-L?(\d+))?)\z/,
             URI.decode(String.trim(href))
           ) do
        nil ->
          %{path: href, first: 0, last: 0, valid: false}

        parts ->
          [_, raw | nums] = parts
          nums = Enum.reject(nums, &(&1 == "")) |> Enum.map(&String.to_integer/1)
          first = hd(nums)
          last = List.last(nums)
          path = resolve_path(raw, files)
          text = get_in(files, [path, "text"])

          valid =
            is_binary(text) and first >= 1 and last >= first and
              last <= length(String.split(text, "\n"))

          %{path: path, first: first, last: passage_end(path, text, first, last), valid: valid}
      end
    end)
  end

  defp resolve_path(raw, files) do
    path = String.trim_leading(raw, "./")

    cond do
      ".." in Path.split(raw) ->
        nil

      Map.has_key?(files, path) ->
        path

      String.starts_with?(raw, "/") ->
        matches = Map.keys(files) |> Enum.filter(&String.ends_with?(raw, "/" <> &1))
        if length(matches) == 1, do: hd(matches), else: nil

      true ->
        nil
    end
  end

  defp supports?(citation, spans) do
    citation.valid and
      Enum.any?(spans, fn [path, first, last] ->
        citation.path == path and citation.first <= last and citation.last >= first
      end)
  end
end
