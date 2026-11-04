defmodule Mix.Tasks.Kata.Catalog do
  use Mix.Task

  @shortdoc "Inspect the Kata skill catalog"

  @moduledoc """
  Reads skill metadata and writes catalog data to standard output.

      mix kata.catalog COMMAND [ARGUMENT] [options]

  Commands:

      summary             Count conforming, legacy, and invalid skills
      list                List skills and their primary facets
      show NAME           Show one skill record
      map                 Show workflow edges from produces to consumes
      facets FACET        Count values for one metadata facet
      findings            Show metadata findings for library maintenance
      check               Fail only when a skill is invalid
      help [COMMAND]      Show general or command-specific help

  Common options:

      --format text|json  Select output format; default is text
      --root PATH         Select the repository root; default is the Kata root
      --help, -h          Show help

  List filters:

      --status STATUS
      --subject VALUE
      --practice VALUE
      --object VALUE
      --profile VALUE
      --authority VALUE

  Findings options:

      --limit N           Return at most N findings

  The task scans `skills/*/SKILL.md` on every run. It does not cache data or
  change skill files. Use `--format json` for agent or script consumption.
  """

  alias KataEvolve.Catalog

  @switches [
    format: :string,
    root: :string,
    limit: :integer,
    status: :string,
    subject: :string,
    practice: :string,
    object: :string,
    profile: :string,
    authority: :string,
    help: :boolean
  ]

  @filters ~w(status subject practice object profile authority)a

  @impl Mix.Task
  def run(args) do
    {opts, positional, invalid} =
      OptionParser.parse(args, strict: @switches, aliases: [h: :help])

    if invalid != [], do: fail("Invalid options: #{inspect(invalid)}")

    cond do
      opts[:help] -> print_help(List.first(positional))
      positional == [] -> print_help(nil)
      hd(positional) == "help" -> print_help(Enum.at(positional, 1))
      true -> run_command(positional, opts)
    end
  end

  defp run_command([command | arguments], opts) do
    format = validate_format(opts[:format] || "text")
    catalog = Catalog.scan(opts[:root] || Catalog.default_root())

    case {command, arguments} do
      {"summary", []} -> output(Catalog.summary(catalog), format, &summary_text/1)
      {"list", []} -> list(catalog, opts, format)
      {"show", [name]} -> show(catalog, name, format)
      {"map", []} -> output(catalog.edges, format, &map_text/1)
      {"facets", [facet]} -> facets(catalog, facet, format)
      {"findings", []} -> findings(catalog, opts, format)
      {"check", []} -> check(catalog, format)
      _ -> fail("Invalid command or arguments. Run `mix kata.catalog help #{command}`.")
    end
  end

  defp list(catalog, opts, format) do
    filters =
      @filters
      |> Enum.flat_map(fn key -> if opts[key], do: [{key, opts[key]}], else: [] end)

    skills = Catalog.filter(catalog.skills, filters)
    output(skills, format, &list_text/1)
  end

  defp show(catalog, name, format) do
    case Catalog.find(catalog.skills, name) do
      nil -> fail("Unknown skill: #{name}")
      skill -> output(skill, format, &show_text/1)
    end
  end

  defp facets(catalog, facet, format) do
    if facet in Catalog.facets() do
      values = Catalog.facet_values(catalog.skills, facet)
      data = Enum.map(values, fn {value, count} -> %{value: value, count: count} end)
      output(data, format, fn _ -> facet_text(facet, values) end)
    else
      fail("Unknown facet: #{facet}. Use one of: #{Enum.join(Catalog.facets(), ", ")}")
    end
  end

  defp findings(catalog, opts, format) do
    findings =
      case opts[:limit] do
        nil -> catalog.findings
        limit when limit >= 0 -> Enum.take(catalog.findings, limit)
        _ -> fail("--limit must be zero or greater")
      end

    output(findings, format, &findings_text/1)
  end

  defp check(catalog, format) do
    invalid = Enum.filter(catalog.skills, &(&1.status == :invalid))

    if invalid == [] do
      data = Catalog.summary(catalog)

      output(data, format, fn summary ->
        "Catalog is valid. #{summary.legacy} legacy skills remain."
      end)
    else
      output(invalid, format, &list_text/1)
      Mix.raise("Catalog contains #{length(invalid)} invalid skill packages")
    end
  end

  defp output(data, "json", _text_renderer), do: IO.puts(JSON.encode!(data))
  defp output(data, "text", text_renderer), do: IO.puts(text_renderer.(data))

  defp summary_text(summary) do
    """
    Skills:         #{summary.total}
    Conforming:     #{summary.conforming}
    Legacy:         #{summary.legacy}
    Invalid:        #{summary.invalid}
    Workflow edges: #{summary.workflow_edges}
    """
    |> String.trim_trailing()
  end

  defp list_text([]), do: "No skills matched."

  defp list_text(skills) do
    headers = ["NAME", "STATUS", "SUBJECT", "PRACTICE", "OBJECT", "PROFILE", "AUTHORITY"]

    rows =
      Enum.map(skills, fn skill ->
        [
          skill.name,
          Atom.to_string(skill.status),
          skill.metadata["subject"] || "-",
          skill.metadata["practice"] || "-",
          skill.metadata["object"] || "-",
          skill.metadata["profile"] || "-",
          skill.metadata["authority"] || "-"
        ]
      end)

    table([headers | rows])
  end

  defp show_text(skill) do
    metadata =
      skill.metadata
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map_join("\n", fn {key, value} -> "  #{key}: #{format_value(value)}" end)

    errors =
      case skill.errors do
        [] -> "  -"
        values -> Enum.map_join(values, "\n", &"  - #{&1}")
      end

    """
    Name: #{skill.name}
    Status: #{skill.status}
    Path: #{skill.path}
    Description: #{skill.description || "-"}
    Metadata:
    #{metadata}
    Errors:
    #{errors}
    """
    |> String.trim_trailing()
  end

  defp map_text([]), do: "No workflow edges found."

  defp map_text(edges) do
    Enum.map_join(edges, "\n", fn edge ->
      "#{edge.source} --#{edge.type}--> #{edge.target}"
    end)
  end

  defp facet_text(facet, []), do: "No conforming skills define #{facet}."

  defp facet_text(facet, values) do
    rows = [
      [String.upcase(facet), "COUNT"] | Enum.map(values, fn {value, count} -> [value, count] end)
    ]

    table(rows)
  end

  defp findings_text([]), do: "No catalog findings."

  defp findings_text(findings) do
    Enum.map_join(findings, "\n\n", fn finding ->
      evidence = Enum.map_join(finding.evidence, "\n", &"  - #{&1}")

      """
      [#{String.upcase(finding.severity)}] #{finding.id}
      Path: #{finding.path}
      Observation: #{finding.observation}
      Evidence:
      #{evidence}
      Consequence: #{finding.consequence}
      Suggested route: #{finding.suggested_route} via #{finding.canonical_owner}
      """
      |> String.trim_trailing()
    end)
  end

  defp table(rows) do
    widths =
      rows
      |> Enum.zip()
      |> Enum.map(fn column ->
        column
        |> Tuple.to_list()
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.length/1)
        |> Enum.max()
      end)

    rows
    |> Enum.map(fn row ->
      row
      |> Enum.map(&to_string/1)
      |> Enum.zip(widths)
      |> Enum.map_join("  ", fn {value, width} -> String.pad_trailing(value, width) end)
      |> String.trim_trailing()
    end)
    |> Enum.join("\n")
  end

  defp format_value(value) when is_list(value), do: "[#{Enum.join(value, ", ")}]"
  defp format_value(value), do: to_string(value)

  defp validate_format(format) when format in ["text", "json"], do: format
  defp validate_format(format), do: fail("Unknown format: #{format}. Use text or json.")

  defp print_help(nil), do: IO.puts(@moduledoc)

  defp print_help(command) do
    text =
      case command do
        "summary" ->
          "mix kata.catalog summary [--format text|json] [--root PATH]\n\nCount catalog states and workflow edges."

        "list" ->
          "mix kata.catalog list [filters] [--format text|json] [--root PATH]\n\nList all skills. Filters: --status, --subject, --practice, --object, --profile, --authority."

        "show" ->
          "mix kata.catalog show NAME [--format text|json] [--root PATH]\n\nShow one parsed skill record, including errors."

        "map" ->
          "mix kata.catalog map [--format text|json] [--root PATH]\n\nConnect conforming skills when one produces a type that another consumes."

        "facets" ->
          "mix kata.catalog facets FACET [--format text|json] [--root PATH]\n\nCount values from conforming skills. Facets: #{Enum.join(Catalog.facets(), ", ")}."

        "findings" ->
          "mix kata.catalog findings [--limit N] [--format text|json] [--root PATH]\n\nReport invalid packages first, then legacy metadata candidates."

        "check" ->
          "mix kata.catalog check [--format text|json] [--root PATH]\n\nExit with failure only when a package is invalid. Legacy packages are allowed."

        "help" ->
          @moduledoc

        other ->
          fail("Unknown help topic: #{other}")
      end

    IO.puts(text)
  end

  defp fail(message), do: Mix.raise(message)
end
