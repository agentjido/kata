defmodule Kata.ReleaseValidator do
  @root Path.expand("..", __DIR__)
  @description "A flexible workflow for agentic productivity: lead, delegate, and verify with Jido."
  @semver ~r/^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$/
  @identifier ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/
  @allowed_frontmatter ~w(name description license compatibility metadata allowed-tools)
  @required_metadata ~w(schema subject practice object profile authority consumes produces)
  @versioned_manifests ~w(
    package.json
    plugin.json
    .claude-plugin/plugin.json
    .cursor-plugin/plugin.json
    .codex-plugin/plugin.json
    .grok-plugin/plugin.json
  )
  @required_licenses ~w(
    skills/kata-build-jido/LICENSE
    skills/kata-debug/LICENSE-COMPOUND-ENGINEERING
    skills/kata-debug/LICENSE-EVERYTHING-CLAUDE-CODE
    skills/kata-debug/LICENSE-MATT-POCOCK
    skills/kata-ex-quality/LICENSE-EVERYTHING-CLAUDE-CODE
    skills/kata-ex-quality/LICENSE-GSTACK
    skills/kata-idea/LICENSE-COMPOUND-ENGINEERING
    skills/kata-idea/LICENSE-MATT-POCOCK
    skills/kata-idea/LICENSE-PSTACK
    skills/kata-maintain-skill/LICENSE-CURSOR
    skills/kata-plan/LICENSE
    skills/kata-roadmap/LICENSE-MATT-POCOCK
    skills/kata-shipit/LICENSE-COMPOUND-ENGINEERING
    skills/kata-shipit/LICENSE-SUPERPOWERS
    skills/kata-showme/LICENSE
    skills/kata-technical-writing/LICENSE
    skills/kata-understand/LICENSE-K-DENSE
    skills/kata-understand/LICENSE-PSTACK
    skills/kata-verify/LICENSE-ADDY-OSMANI
    skills/kata-verify/LICENSE-COMPOUND-ENGINEERING
    skills/kata-verify/LICENSE-CURSOR
    skills/kata-verify/LICENSE-EVERYTHING-CLAUDE-CODE
    skills/kata-verify/LICENSE-K-DENSE
    skills/kata-verify/LICENSE-MATT-POCOCK
    skills/kata-verify/LICENSE-PSTACK
    skills/kata-work/LICENSE-CURSOR
    skills/kata-work/LICENSE-PSTACK
    skills/kata-write-skill/LICENSE-COMPOUND-ENGINEERING
    skills/kata-write-skill/LICENSE-MATT-POCOCK
    skills/kata-write-skill/LICENSE-PSTACK
  )

  def run(args) do
    {options, rest, invalid} = OptionParser.parse(args, strict: [tag: :string])

    errors =
      []
      |> add_cli_errors(rest, invalid)
      |> validate_repository(options[:tag])

    case errors do
      [] ->
        version = read!("VERSION") |> String.trim()
        skill_count = @root |> Path.join("skills/*/SKILL.md") |> Path.wildcard() |> length()
        IO.puts("Validated Agent Jido Kata #{version}: #{skill_count} skills")
        if options[:tag], do: IO.puts("Validated release tag: #{options[:tag]}")
        :ok

      errors ->
        Enum.each(Enum.reverse(errors), &IO.puts(:stderr, "ERROR: #{&1}"))
        System.halt(1)
    end
  end

  defp add_cli_errors(errors, [], []), do: errors

  defp add_cli_errors(errors, rest, invalid) do
    ["invalid arguments: #{inspect(rest ++ invalid)}" | errors]
  end

  defp validate_repository(errors, tag) do
    version = read!("VERSION") |> String.trim()

    errors
    |> require(
      Regex.match?(@semver, version),
      "VERSION: invalid semantic version #{inspect(version)}"
    )
    |> require(
      is_nil(tag) or tag == "v#{version}",
      "tag #{inspect(tag)} does not match VERSION #{inspect(version)}"
    )
    |> validate_manifests(version)
    |> validate_required_files()
    |> validate_skills()
    |> validate_public_boundary()
    |> validate_markdown_links()
  end

  defp validate_manifests(errors, version) do
    errors =
      Enum.reduce(@versioned_manifests, errors, fn path, acc ->
        case decode_json(path) do
          {:ok, manifest} ->
            acc
            |> require(manifest["name"] == "kata", "#{path}: name must be kata")
            |> require(manifest["version"] == version, "#{path}: version must be #{version}")
            |> require(
              manifest["description"] == @description,
              "#{path}: description is inconsistent"
            )

          {:error, reason} ->
            ["#{path}: invalid JSON: #{reason}" | acc]
        end
      end)

    package = json!("package.json")
    marketplace = json!(".claude-plugin/marketplace.json")
    plugins = marketplace["plugins"] || []

    errors
    |> require(package["private"] == true, "package.json: private must remain true")
    |> require(
      length(plugins) == 1 and hd(plugins)["description"] == @description,
      ".claude-plugin/marketplace.json: description is inconsistent"
    )
  end

  defp validate_required_files(errors) do
    required = ["LICENSE", "NOTICE", "VERSION" | @required_licenses]

    Enum.reduce(required, errors, fn path, acc ->
      require(acc, File.regular?(Path.join(@root, path)), "missing required file: #{path}")
    end)
  end

  defp validate_skills(errors) do
    skill_files = @root |> Path.join("skills/*/SKILL.md") |> Path.wildcard() |> Enum.sort()
    errors = require(errors, skill_files != [], "no active skill packages found")

    Enum.reduce(skill_files, errors, fn path, acc ->
      case validate_skill(path) do
        [] -> acc
        skill_errors -> Enum.reduce(skill_errors, acc, &[&1 | &2])
      end
    end)
  end

  defp validate_public_boundary(errors) do
    @root
    |> Path.join("skills/*")
    |> Path.wildcard()
    |> Enum.reduce(errors, fn path, acc ->
      name = Path.basename(path)

      require(
        acc,
        match?({:ok, %File.Stat{type: type}} when type != :symlink, File.lstat(path)),
        "skills/#{name}: symbolic link in public repository"
      )
    end)
  end

  defp validate_skill(path) do
    relative = Path.relative_to(path, @root)
    text = File.read!(path)

    with [_, frontmatter] <- Regex.run(~r/\A---\n(.*?)\n---\n/s, text),
         {:ok, fields, metadata} <- parse_frontmatter(frontmatter) do
      name = fields["name"] |> scalar()
      description = fields["description"] |> scalar()
      directory = path |> Path.dirname() |> Path.basename()
      unknown = Map.keys(fields) -- @allowed_frontmatter
      missing_metadata = @required_metadata -- Map.keys(metadata)

      []
      |> require(name == directory, "#{relative}: name does not match its directory")
      |> require(
        String.length(name) <= 64 and Regex.match?(@identifier, name),
        "#{relative}: invalid name"
      )
      |> require(
        description != "" and String.length(description) <= 1024,
        "#{relative}: invalid description"
      )
      |> require(
        unknown == [],
        "#{relative}: unsupported frontmatter fields: #{Enum.join(unknown, ", ")}"
      )
      |> require(
        missing_metadata == [],
        "#{relative}: missing metadata: #{Enum.join(missing_metadata, ", ")}"
      )
      |> require(
        metadata["schema"] == "kata.skill/v1",
        "#{relative}: metadata.schema must be kata.skill/v1"
      )
      |> validate_facet(metadata, "consumes", relative)
      |> validate_facet(metadata, "produces", relative)
    else
      nil -> ["#{relative}: invalid frontmatter boundary"]
      {:error, reason} -> ["#{relative}: #{reason}"]
    end
  end

  defp parse_frontmatter(frontmatter) do
    lines = String.split(frontmatter, "\n")

    with index when is_integer(index) <- Enum.find_index(lines, &(&1 == "metadata:")) do
      {top, metadata_lines} = Enum.split(lines, index)
      metadata_lines = metadata_lines |> tl() |> Enum.take_while(&String.starts_with?(&1, "  "))

      with {:ok, fields} <- parse_fields(top, 0),
           {:ok, metadata} <- parse_fields(metadata_lines, 2),
           true <- Enum.all?(metadata, fn {_key, value} -> scalar_metadata?(value) end) do
        {:ok, Map.put(fields, "metadata", ""),
         Map.new(metadata, fn {key, value} -> {key, scalar(value)} end)}
      else
        false -> {:error, "metadata values must be strings"}
        {:error, reason} -> {:error, reason}
      end
    else
      nil -> {:error, "missing metadata block"}
    end
  end

  defp parse_fields(lines, indent) do
    prefix = String.duplicate(" ", indent)

    Enum.reduce_while(lines, {:ok, %{}}, fn line, {:ok, fields} ->
      case Regex.run(~r/^([a-z][a-z0-9-]*):\s*(.*)$/, String.replace_prefix(line, prefix, "")) do
        [_, key, value] when value != "" -> {:cont, {:ok, Map.put(fields, key, value)}}
        _ -> {:halt, {:error, "invalid frontmatter line #{inspect(line)}"}}
      end
    end)
  end

  defp scalar_metadata?(value) do
    value = String.trim(value)
    value != "" and not String.starts_with?(value, ["[", "{"])
  end

  defp validate_facet(errors, metadata, key, relative) do
    values = metadata |> Map.get(key, "") |> String.split(",") |> Enum.map(&String.trim/1)

    require(
      errors,
      values != [] and Enum.all?(values, &Regex.match?(@identifier, &1)),
      "#{relative}: metadata.#{key} must be comma-separated identifiers"
    )
  end

  defp validate_markdown_links(errors) do
    markdown_files()
    |> Enum.reduce(errors, fn path, acc ->
      Regex.scan(~r/(?<!!)\[[^\]]+\]\(([^)]+)\)/, File.read!(path), capture: :all_but_first)
      |> List.flatten()
      |> Enum.reduce(acc, &validate_link(path, &1, &2))
    end)
  end

  defp validate_link(path, raw_target, errors) do
    target = raw_target |> String.trim() |> String.trim("<>")

    if target == "" or String.starts_with?(target, ["#", "mailto:"]) or
         String.contains?(target, "://") do
      errors
    else
      target = target |> String.split("#", parts: 2) |> hd() |> URI.decode()
      target_path = Path.expand(target, Path.dirname(path))

      errors
      |> require(
        String.starts_with?(target_path, @root <> "/"),
        "#{relative(path)}: link leaves repository: #{target}"
      )
      |> require(File.exists?(target_path), "#{relative(path)}: missing link target: #{target}")
    end
  end

  defp markdown_files do
    root_files =
      ~w(README.md CHANGELOG.md CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md)
      |> Enum.map(&Path.join(@root, &1))
      |> Enum.filter(&File.regular?/1)

    patterns =
      ~w(docs/*.md docs/guides/**/*.md docs/reference/**/*.md skills/*/SKILL.md skills/*/README.md)

    (root_files ++ Enum.flat_map(patterns, &Path.wildcard(Path.join(@root, &1))))
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp scalar(nil), do: ""

  defp scalar(value) do
    value = String.trim(value)

    if String.length(value) >= 2 and String.first(value) == String.last(value) and
         String.first(value) in ["\"", "'"] do
      String.slice(value, 1, String.length(value) - 2)
    else
      value
    end
  end

  defp decode_json(path) do
    case JSON.decode(read!(path)) do
      {:ok, value} -> {:ok, value}
      {:error, reason} -> {:error, Exception.message(reason)}
    end
  end

  defp json!(path), do: path |> read!() |> JSON.decode!()
  defp read!(path), do: File.read!(Path.join(@root, path))
  defp relative(path), do: Path.relative_to(path, @root)
  defp require(errors, true, _message), do: errors
  defp require(errors, false, message), do: [message | errors]
end

Kata.ReleaseValidator.run(System.argv())
