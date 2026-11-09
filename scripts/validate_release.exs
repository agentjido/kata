Code.require_file("release_changelog.exs", __DIR__)

defmodule Kata.ReleaseValidator do
  @root Path.expand("..", __DIR__)
  @description "A flexible workflow for agentic productivity: lead, delegate, and verify with Jido."
  @plugin_schema "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"
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
  @release_please_extra_files ~w(
    plugin.json
    .claude-plugin/plugin.json
    .cursor-plugin/plugin.json
    .codex-plugin/plugin.json
    .grok-plugin/plugin.json
  )
  @release_please_exclude_paths ~w(.github/ docs/ dojo/ scripts/)
  @required_licenses ~w(
    skills/jido/references/methods/kata-debug/LICENSE-COMPOUND-ENGINEERING
    skills/jido/references/methods/kata-debug/LICENSE-EVERYTHING-CLAUDE-CODE
    skills/jido/references/methods/kata-debug/LICENSE-MATT-POCOCK
    skills/jido/references/methods/kata-idea/LICENSE-COMPOUND-ENGINEERING
    skills/jido/references/methods/kata-idea/LICENSE-MATT-POCOCK
    skills/jido/references/methods/kata-idea/LICENSE-PSTACK
    skills/jido/references/methods/kata-maintain-skill/LICENSE-CURSOR
    skills/jido/references/methods/kata-plan/LICENSE
    skills/jido/references/methods/kata-roadmap/LICENSE-MATT-POCOCK
    skills/jido/references/methods/kata-security/LICENSE-CLOUDFLARE
    skills/jido/references/methods/kata-shipit/LICENSE-COMPOUND-ENGINEERING
    skills/jido/references/methods/kata-shipit/LICENSE-SUPERPOWERS
    skills/jido/references/methods/kata-showme/LICENSE
    skills/jido/references/methods/kata-technical-writing/LICENSE
    skills/jido/references/methods/kata-understand/LICENSE-K-DENSE
    skills/jido/references/methods/kata-understand/LICENSE-PSTACK
    skills/jido/references/methods/kata-verify/LICENSE-ADDY-OSMANI
    skills/jido/references/methods/kata-verify/LICENSE-COMPOUND-ENGINEERING
    skills/jido/references/methods/kata-verify/LICENSE-CURSOR
    skills/jido/references/methods/kata-verify/LICENSE-EVERYTHING-CLAUDE-CODE
    skills/jido/references/methods/kata-verify/LICENSE-K-DENSE
    skills/jido/references/methods/kata-verify/LICENSE-MATT-POCOCK
    skills/jido/references/methods/kata-verify/LICENSE-PSTACK
    skills/jido/references/methods/kata-work/LICENSE-CURSOR
    skills/jido/references/methods/kata-work/LICENSE-PSTACK
    skills/jido/references/methods/kata-write-skill/LICENSE-COMPOUND-ENGINEERING
    skills/jido/references/methods/kata-write-skill/LICENSE-MATT-POCOCK
    skills/jido/references/methods/kata-write-skill/LICENSE-PSTACK
  )

  def run(args) do
    {options, rest, invalid} = OptionParser.parse(args, strict: [tag: :string])

    errors =
      []
      |> add_cli_errors(rest, invalid)
      |> validate_repository(options[:tag])

    case errors do
      [] ->
        version = version!()
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
    version = version!()

    errors
    |> require(
      Regex.match?(@semver, version),
      "package.json: invalid semantic version #{inspect(version)}"
    )
    |> require(
      is_nil(tag) or tag == "v#{version}",
      "tag #{inspect(tag)} does not match package.json version #{inspect(version)}"
    )
    |> validate_manifests(version)
    |> validate_release_please(version)
    |> validate_changelog(version)
    |> validate_required_files()
    |> validate_skills()
    |> validate_public_boundary()
    |> validate_markdown_links()
  end

  defp validate_changelog(errors, version) do
    changelog = read!("CHANGELOG.md")
    release_dates = Kata.ReleaseChangelog.release_dates(changelog, version)

    valid_date =
      case release_dates do
        [date] -> match?({:ok, _date}, Date.from_iso8601(date))
        _other -> false
      end

    release_notes =
      case Kata.ReleaseChangelog.release_notes(changelog, version) do
        {:ok, notes} -> notes
        _other -> ""
      end

    errors
    |> require(
      length(release_dates) == 1,
      "CHANGELOG.md: must contain one release heading for #{version}"
    )
    |> require(valid_date, "CHANGELOG.md: release #{version} must have a valid ISO date")
    |> require(release_notes != "", "CHANGELOG.md: release #{version} has no notes")
  end

  defp validate_release_please(errors, version) do
    with {:ok, manifest} <- decode_json(".release-please-manifest.json"),
         {:ok, config} <- decode_json("release-please-config.json") do
      package = get_in(config, ["packages", "."]) || %{}

      extra_files =
        package
        |> Map.get("extra-files", [])
        |> Enum.filter(fn file ->
          is_map(file) and file["type"] == "json" and file["jsonpath"] == "$.version"
        end)
        |> Enum.map(& &1["path"])
        |> Enum.sort()

      exclude_paths = package |> Map.get("exclude-paths", []) |> Enum.sort()

      errors
      |> require(
        manifest["."] == version,
        ".release-please-manifest.json: root version must be #{version}"
      )
      |> require(package["release-type"] == "node", "release-please: release type must be node")
      |> require(
        package["skip-github-release"] == false,
        "release-please: GitHub release creation must remain enabled"
      )
      |> require(
        package["include-component-in-tag"] == false,
        "release-please: component must not be included in release tags"
      )
      |> require(
        package["include-v-in-tag"] == true,
        "release-please: release tags must use the v prefix"
      )
      |> require(
        extra_files == Enum.sort(@release_please_extra_files),
        "release-please: extra version files are incomplete"
      )
      |> require(
        exclude_paths == Enum.sort(@release_please_exclude_paths),
        "release-please: non-product path exclusions are incomplete"
      )
    else
      {:error, reason} -> ["release-please: invalid JSON: #{reason}" | errors]
    end
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
    plugin = json!("plugin.json")
    marketplace = json!(".claude-plugin/marketplace.json")
    plugins = marketplace["plugins"] || []

    errors
    |> require(package["private"] == true, "package.json: private must remain true")
    |> require(plugin["$schema"] == @plugin_schema, "plugin.json: portable schema is missing")
    |> require(plugin["license"] == "Apache-2.0", "plugin.json: license must be Apache-2.0")
    |> require(
      length(plugins) == 1 and hd(plugins)["description"] == @description,
      ".claude-plugin/marketplace.json: description is inconsistent"
    )
  end

  defp validate_required_files(errors) do
    required = ["LICENSE" | @required_licenses]

    Enum.reduce(required, errors, fn path, acc ->
      require(acc, File.regular?(Path.join(@root, path)), "missing required file: #{path}")
    end)
  end

  defp validate_skills(errors) do
    skill_files = @root |> Path.join("skills/*/SKILL.md") |> Path.wildcard() |> Enum.sort()
    expected = [Path.join(@root, "skills/jido/SKILL.md")]

    errors =
      require(errors, skill_files == expected, "jido must be the only active skill package")

    Enum.reduce(skill_files, errors, fn path, acc ->
      case validate_skill(path) do
        [] -> acc
        skill_errors -> Enum.reduce(skill_errors, acc, &[&1 | &2])
      end
    end)
  end

  defp validate_public_boundary(errors) do
    paths = @root |> Path.join("skills/*") |> Path.wildcard()

    errors =
      require(
        errors,
        Enum.map(paths, &Path.basename/1) |> Enum.sort() == ["README.md", "catalog.exs", "jido"],
        "skills/: public package surface must contain only jido and its package guides"
      )

    Enum.reduce(paths, errors, fn path, acc ->
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
      ~w(README.md CHANGELOG.md CONTRIBUTING.md CODE_OF_CONDUCT.md)
      |> Enum.map(&Path.join(@root, &1))
      |> Enum.filter(&File.regular?/1)

    patterns =
      ~w(docs/*.md docs/guides/**/*.md docs/reference/**/*.md skills/*/SKILL.md skills/*/README.md skills/jido/**/*.md)

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
  defp version!, do: json!("package.json") |> Map.fetch!("version")
  defp read!(path), do: File.read!(Path.join(@root, path))
  defp relative(path), do: Path.relative_to(path, @root)
  defp require(errors, true, _message), do: errors
  defp require(errors, false, message), do: [message | errors]
end

Kata.ReleaseValidator.run(System.argv())
