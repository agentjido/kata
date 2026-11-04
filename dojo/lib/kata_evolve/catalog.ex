defmodule KataEvolve.Catalog do
  @moduledoc """
  Builds an in-memory catalog from skill frontmatter.

  The scanner reads the flat `kata.skill/v1` metadata schema. It does not cache
  results or change skill files. Skills without that schema remain visible as
  legacy packages.
  """

  @schema "kata.skill/v1"
  @required ~w(schema subject practice object profile authority consumes produces)
  @identifier_fields ~w(subject practice object)
  @list_fields ~w(consumes produces)
  @profiles ~w(bounded-execution coordination system-design direction)
  @authorities ~w(read-only local-write external-write destructive)
  @facets ~w(subject practice object profile authority consumes produces)

  def default_root, do: KataEvolve.root() |> Path.dirname()

  def facets, do: @facets

  def scan(root \\ default_root()) do
    root = Path.expand(root)

    skills =
      root
      |> Path.join("skills/*/SKILL.md")
      |> Path.wildcard()
      |> Enum.sort()
      |> Enum.map(&read_skill(&1, root))

    %{
      root: root,
      skills: skills,
      edges: edges(skills),
      findings: findings(skills)
    }
  end

  def summary(%{skills: skills, edges: edges}) do
    counts = Enum.frequencies_by(skills, & &1.status)

    %{
      total: length(skills),
      conforming: Map.get(counts, :conforming, 0),
      legacy: Map.get(counts, :legacy, 0),
      invalid: Map.get(counts, :invalid, 0),
      workflow_edges: length(edges)
    }
  end

  def filter(skills, filters) do
    Enum.filter(skills, fn skill ->
      Enum.all?(filters, fn
        {:status, value} ->
          Atom.to_string(skill.status) == value

        {field, value} when field in [:subject, :practice, :object, :profile, :authority] ->
          skill.metadata[Atom.to_string(field)] == value
      end)
    end)
  end

  def facet_values(skills, facet) when facet in @facets do
    skills
    |> Enum.filter(&(&1.status == :conforming))
    |> Enum.flat_map(fn skill -> List.wrap(skill.metadata[facet]) end)
    |> Enum.frequencies()
    |> Enum.sort_by(fn {value, _count} -> value end)
  end

  def find(skills, name), do: Enum.find(skills, &(&1.name == name))

  def edges(skills) do
    conforming = Enum.filter(skills, &(&1.status == :conforming))

    for source <- conforming,
        output <- source.metadata["produces"],
        target <- conforming,
        output in target.metadata["consumes"] do
      %{source: source.name, type: output, target: target.name}
    end
    |> Enum.sort_by(&{&1.source, &1.type, &1.target})
  end

  def findings(skills) do
    skills
    |> Enum.flat_map(fn
      %{status: :invalid} = skill ->
        [
          %{
            id: "invalid-metadata:#{skill.name}",
            severity: "error",
            skill: skill.name,
            path: skill.path,
            observation: "The skill package does not satisfy its declared metadata contract.",
            evidence: skill.errors,
            consequence: "Catalog and workflow data for this package is not reliable.",
            suggested_route: "conversion",
            canonical_owner: "kata-write-skill"
          }
        ]

      %{status: :legacy} = skill ->
        missing = Enum.reject(@required, &present?(skill.metadata[&1]))

        [
          %{
            id: "legacy-metadata:#{skill.name}",
            severity: "info",
            skill: skill.name,
            path: skill.path,
            observation: "The skill does not declare #{@schema}.",
            evidence: Enum.map(missing, &"Missing metadata field: #{&1}"),
            consequence: "The skill cannot participate fully in facet and workflow maps.",
            suggested_route: "conversion",
            canonical_owner: "kata-write-skill"
          }
        ]

      _skill ->
        []
    end)
    |> Enum.sort_by(fn finding ->
      rank = if finding.severity == "error", do: 0, else: 1
      {rank, finding.skill}
    end)
  end

  defp read_skill(path, root) do
    directory_name = path |> Path.dirname() |> Path.basename()
    relative_path = Path.relative_to(path, root)

    case parse_frontmatter(File.read!(path)) do
      {:ok, fields, metadata} ->
        name = fields["name"] || directory_name
        errors = identity_errors(name, directory_name) ++ metadata_errors(metadata)

        status =
          cond do
            errors != [] -> :invalid
            metadata["schema"] == @schema -> :conforming
            true -> :legacy
          end

        %{
          name: name,
          directory_name: directory_name,
          description: fields["description"],
          path: relative_path,
          metadata: metadata,
          status: status,
          errors: errors
        }

      {:error, reason} ->
        %{
          name: directory_name,
          directory_name: directory_name,
          description: nil,
          path: relative_path,
          metadata: %{},
          status: :invalid,
          errors: [reason]
        }
    end
  end

  defp parse_frontmatter(text) do
    case String.split(text, ~r/\r?\n/) do
      ["---" | rest] ->
        {frontmatter, tail} = Enum.split_while(rest, &(&1 != "---"))

        if tail == [] do
          {:error, "Frontmatter has no closing delimiter"}
        else
          fields =
            ["name", "description"]
            |> Map.new(fn key -> {key, top_level_value(frontmatter, key)} end)

          {:ok, fields, metadata(frontmatter)}
        end

      _ ->
        {:error, "SKILL.md does not start with frontmatter"}
    end
  end

  defp top_level_value(lines, key) do
    prefix = key <> ":"

    Enum.find_value(lines, fn line ->
      if String.starts_with?(line, prefix) do
        line |> String.replace_prefix(prefix, "") |> String.trim() |> scalar()
      end
    end)
  end

  defp metadata(lines) do
    case Enum.find_index(lines, &String.starts_with?(&1, "metadata:")) do
      nil ->
        %{}

      index ->
        line = Enum.at(lines, index)
        value = line |> String.replace_prefix("metadata:", "") |> String.trim()

        if value == "" do
          lines
          |> Enum.drop(index + 1)
          |> Enum.take_while(&(String.trim(&1) == "" or Regex.match?(~r/^\s+/, &1)))
          |> parse_metadata_block()
        else
          parse_inline_metadata(value)
        end
    end
  end

  defp parse_metadata_block(lines) do
    Enum.reduce(lines, %{}, fn line, metadata ->
      case Regex.run(~r/^\s+([a-zA-Z0-9_-]+):\s*(.*?)\s*$/, line) do
        [_, key, value] -> Map.put(metadata, key, metadata_value(value))
        _ -> metadata
      end
    end)
  end

  defp parse_inline_metadata(value) do
    value
    |> String.trim()
    |> String.trim_leading("{")
    |> String.trim_trailing("}")
    |> then(&Regex.scan(~r/(?:^|,)\s*([a-zA-Z0-9_-]+):\s*("[^"]*"|'[^']*'|[^,}]+)/, &1))
    |> Map.new(fn [_, key, raw] -> {key, metadata_value(String.trim(raw))} end)
  end

  defp metadata_value("[" <> rest) do
    rest
    |> String.trim_trailing("]")
    |> String.split(",", trim: true)
    |> Enum.map(&(&1 |> String.trim() |> scalar()))
  end

  defp metadata_value(value), do: scalar(value)

  defp scalar(<<"\"", _::binary>> = value) do
    case JSON.decode(value) do
      {:ok, decoded} -> decoded
      _ -> String.trim(value, "\"")
    end
  end

  defp scalar("'" <> rest), do: rest |> String.trim_trailing("'") |> String.replace("''", "'")
  defp scalar(value), do: String.trim(value)

  defp identity_errors(nil, _directory), do: ["Frontmatter is missing name"]

  defp identity_errors(name, directory) when name != directory,
    do: ["Frontmatter name #{inspect(name)} does not match directory #{inspect(directory)}"]

  defp identity_errors(_name, _directory), do: []

  defp metadata_errors(%{"schema" => @schema} = metadata) do
    missing =
      @required
      |> Enum.reject(&present?(metadata[&1]))
      |> Enum.map(&"Missing required metadata field: #{&1}")

    profile =
      if metadata["profile"] in @profiles,
        do: [],
        else: ["Invalid profile: #{inspect(metadata["profile"])}"]

    authority =
      if metadata["authority"] in @authorities,
        do: [],
        else: ["Invalid authority: #{inspect(metadata["authority"])}"]

    identifiers =
      for field <- @identifier_fields,
          value = metadata[field],
          present?(value),
          not identifier?(value),
          do: "Invalid #{field} identifier: #{inspect(value)}"

    list_identifiers =
      for field <- @list_fields,
          value <- List.wrap(metadata[field]),
          not identifier?(value),
          do: "Invalid #{field} identifier: #{inspect(value)}"

    missing ++ profile ++ authority ++ identifiers ++ list_identifiers
  end

  defp metadata_errors(%{"schema" => schema}) when schema not in [nil, ""],
    do: ["Unsupported metadata schema: #{inspect(schema)}"]

  defp metadata_errors(_metadata), do: []

  defp present?(value), do: value not in [nil, "", []]

  defp identifier?(value) when is_binary(value),
    do: Regex.match?(~r/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, value)

  defp identifier?(_value), do: false
end
