defmodule KataEvolve.Fixture do
  @moduledoc "Small document and asset cases with an independent expected state."

  def check_names,
    do:
      ~w(setup_files rules_content docs_index_targets intake_status content_preserved asset_preserved sources_moved image_target readme_target index_link intake_record protected_files git_index)

  def assert_outcome!(checked) do
    for name <- check_names() do
      ExUnit.Assertions.assert(
        checked.checks[name] == true,
        "Setup output assertion failed: #{name}"
      )
    end

    :ok
  end

  def cases do
    %{
      train: [
        %{
          id: "train-guide",
          input: "Collect the guide.",
          source: "guides/start.md",
          asset: "guides/images/flow.svg"
        }
      ],
      validation: [
        %{
          id: "validation-note",
          input: "Collect the nested design note.",
          source: "docs/design/cache.md",
          asset: "docs/media/cache.svg"
        }
      ],
      test: [
        %{
          id: "test-manual",
          input: "Collect the manual.",
          source: "manual/operations/recovery.md",
          asset: "manual/diagrams/recovery.svg"
        }
      ]
    }
  end

  def prepare(root, item, skill, template) do
    input = Path.expand("../../test/fixtures/setup/input/#{item.id}", __DIR__)
    files = KataEvolve.Snapshot.take_input(input)

    files =
      Map.merge(files, %{
        ".agents/skills/kata-setup/SKILL.md" => skill,
        ".agents/skills/kata-setup/templates/docs-agents.md" => template
      })

    document = files[item.source]

    Enum.each(files, fn {path, text} -> write(root, path, text) end)
    git!(root, ["init", "-q"])
    git!(root, ["add", "."])

    git!(root, [
      "-c",
      "user.name=Fixture",
      "-c",
      "user.email=fixture@example.invalid",
      "commit",
      "-qm",
      "Initial fixture"
    ])

    write(root, item.source, document <> "\nUncommitted sentence.\n")

    %{
      files: Map.put(files, item.source, document <> "\nUncommitted sentence.\n"),
      index: git!(root, ["ls-files", "--stage"])
    }
  end

  def check(root, item, initial),
    do: check_snapshot(KataEvolve.Snapshot.take(root), item, initial)

  def check_snapshot(snapshot, item, initial) do
    destination = "docs/inbox/" <> item.source
    asset_destination = "docs/inbox/" <> item.asset
    doc = read(snapshot, destination)
    log = read(snapshot, "docs/inbox/README.md")
    template = initial.files[".agents/skills/kata-setup/templates/docs-agents.md"] || ""

    checks = %{
      "setup_files" =>
        Enum.all?(
          ["docs/AGENTS.md", "docs/README.md", "docs/inbox/README.md"],
          &KataEvolve.Snapshot.regular?(snapshot, &1)
        ),
      "rules_content" =>
        String.trim(template) != "" and
          String.contains?(read(snapshot, "docs/AGENTS.md"), String.trim(template)),
      "docs_index_targets" =>
        links_to?(snapshot, "docs/README.md", "docs/AGENTS.md") and
          (links_to?(snapshot, "docs/README.md", "docs/inbox/README.md") or
             links_to?(snapshot, "docs/README.md", "docs/inbox")),
      "intake_status" =>
        Regex.match?(~r/await(?:s|ing)?\s+review|pending|unprocessed|unverified/i, log),
      "content_preserved" => normalize(doc) == normalize(initial.files[item.source]),
      "asset_preserved" => read(snapshot, asset_destination) == initial.files[item.asset],
      "sources_moved" =>
        not Map.has_key?(snapshot.files, item.source) and
          not Map.has_key?(snapshot.files, item.asset),
      "image_target" => links_to?(snapshot, destination, asset_destination),
      "readme_target" => links_to?(snapshot, "README.md", destination),
      "index_link" => links_to?(snapshot, "README.md", "docs/README.md"),
      "intake_record" =>
        String.contains?(log, item.source) and
          (String.contains?(log, destination) or
             links_to?(snapshot, "docs/inbox/README.md", destination)),
      "protected_files" =>
        Enum.all?(
          [
            "AGENTS.md",
            "lib/example.ex",
            "mix.exs",
            "test/test_helper.exs",
            "test/example_test.exs",
            ".agents/skills/kata-setup/SKILL.md",
            ".agents/skills/kata-setup/templates/docs-agents.md"
          ],
          &(read(snapshot, &1) == initial.files[&1])
        ),
      "git_index" => snapshot.index == initial.index
    }

    failures = for {name, false} <- checks, do: name

    hard_pass =
      checks["content_preserved"] and checks["asset_preserved"] and checks["protected_files"] and
        checks["git_index"]

    %{
      score: if(hard_pass, do: Enum.count(checks, &elem(&1, 1)) / map_size(checks), else: 0.0),
      checks: checks,
      feedback:
        if(failures == [],
          do: "All fixture checks passed.",
          else:
            "Failed checks: #{Enum.join(failures, ", ")}. Expected document at #{destination}; asset at #{asset_destination}. Preserve local edits and link targets."
        )
    }
  end

  def write(root, path, text) do
    full = Path.join(root, path)
    File.mkdir_p!(Path.dirname(full))
    File.write!(full, text)
  end

  def git!(root, args) do
    case System.cmd("git", args, cd: root, stderr_to_stdout: true) do
      {text, 0} -> text
      {text, code} -> raise "Git failed (#{code}): #{text}"
    end
  end

  defp read(snapshot, path), do: KataEvolve.Snapshot.text(snapshot, path)

  defp normalize(text) do
    Regex.replace(~r/\]\([^)]*\)/, text, "](LINK)") |> String.trim_trailing("\n")
  end

  defp links_to?(snapshot, from, target) do
    Regex.scan(~r/\]\(([^)]+)\)/, read(snapshot, from))
    |> Enum.any?(fn [_, href] ->
      path = href |> String.split("#", parts: 2) |> hd()
      Path.expand(path, Path.dirname("/" <> from)) == "/" <> target
    end)
  end
end
