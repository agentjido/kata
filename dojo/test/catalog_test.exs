defmodule KataEvolve.CatalogTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias KataEvolve.Catalog

  setup do
    root = Path.join(System.tmp_dir!(), "kata-catalog-#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(root, "skills"))
    on_exit(fn -> File.rm_rf!(root) end)
    %{root: root}
  end

  test "classifies conforming, legacy, and invalid packages", %{root: root} do
    write_skill(root, "producer", """
    metadata:
      schema: kata.skill/v1
      subject: agent-work
      practice: build
      object: skill-package
      profile: system-design
      authority: local-write
      consumes: [skill-request]
      produces: [conversion-brief]
    """)

    write_skill(root, "legacy", "metadata: {subject: agent-work}")

    write_skill(root, "invalid", """
    metadata:
      schema: kata.skill/v1
      subject: agent-work
      practice: inspect
      object: skill-package
      profile: unknown
      authority: read-only
      consumes: [skill-library]
      produces: [finding]
    """)

    catalog = Catalog.scan(root)

    assert Catalog.find(catalog.skills, "producer").status == :conforming
    assert Catalog.find(catalog.skills, "legacy").status == :legacy

    invalid = Catalog.find(catalog.skills, "invalid")
    assert invalid.status == :invalid
    assert "Invalid profile: \"unknown\"" in invalid.errors

    assert Catalog.summary(catalog) == %{
             total: 3,
             conforming: 1,
             legacy: 1,
             invalid: 1,
             workflow_edges: 0
           }
  end

  test "maps matching produced and consumed types", %{root: root} do
    write_skill(
      root,
      "maintain",
      metadata("govern", "skill-library", ["skill-library"], ["conversion-brief"])
    )

    write_skill(
      root,
      "write",
      metadata("build", "skill-package", ["conversion-brief"], ["skill-package"])
    )

    assert Catalog.scan(root).edges == [
             %{source: "maintain", type: "conversion-brief", target: "write"}
           ]
  end

  test "creates one evidence record for each legacy or invalid package", %{root: root} do
    write_skill(root, "legacy", "metadata: {subject: general}")
    write_skill(root, "broken", "metadata:\n  schema: kata.skill/v2")

    findings = Catalog.scan(root).findings

    assert Enum.map(findings, & &1.id) == [
             "invalid-metadata:broken",
             "legacy-metadata:legacy"
           ]
  end

  test "help is available without scanning the repository" do
    Mix.Task.reenable("kata.catalog")

    output =
      capture_io(fn ->
        Mix.Tasks.Kata.Catalog.run(["help", "list"])
      end)

    assert output =~ "mix kata.catalog list"
    assert output =~ "--subject"
  end

  defp write_skill(root, name, metadata) do
    directory = Path.join([root, "skills", name])
    File.mkdir_p!(directory)

    File.write!(
      Path.join(directory, "SKILL.md"),
      """
      ---
      name: #{name}
      description: Test skill #{name}.
      #{metadata}
      ---

      # #{name}
      """
    )
  end

  defp metadata(practice, object, consumes, produces) do
    """
    metadata:
      schema: kata.skill/v1
      subject: agent-work
      practice: #{practice}
      object: #{object}
      profile: system-design
      authority: local-write
      consumes: [#{Enum.join(consumes, ", ")}]
      produces: [#{Enum.join(produces, ", ")}]
    """
    |> String.trim_trailing()
  end
end
