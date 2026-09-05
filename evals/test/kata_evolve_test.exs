defmodule KataEvolveTest do
  use ExUnit.Case
  alias KataEvolve.Fixture

  test "checker accepts preserved moves and rejects lost local edits and broken links" do
    root = Path.join(System.tmp_dir!(), "kata-check-#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(root) end)
    item = hd(Fixture.cases().train)
    initial = Fixture.prepare(root, item, "skill", "template")
    refute Fixture.check(root, item, initial).checks["setup_files"]

    for path <- [item.source, item.asset] do
      Fixture.write(root, "docs/inbox/" <> path, initial.files[path])
      File.rm!(Path.join(root, path))
    end

    Fixture.write(
      root,
      "README.md",
      "# Example\n[Note](docs/inbox/#{item.source})\n[Docs](docs/README.md)\n"
    )

    Fixture.write(root, "docs/AGENTS.md", "Rules")
    Fixture.write(root, "docs/README.md", "Index")
    Fixture.write(root, "docs/inbox/README.md", "#{item.source} | docs/inbox/#{item.source}")
    assert Fixture.check(root, item, initial).score == 1.0

    assert Enum.sort(Map.keys(Fixture.check(root, item, initial).checks)) ==
             Enum.sort(Fixture.check_names())

    Fixture.write(root, "docs/inbox/README.md", "#{item.source} | [inbox file](#{item.source})")
    assert Fixture.check(root, item, initial).checks["intake_record"]

    Fixture.write(root, "docs/inbox/README.md", "#{item.source} | [inbox file](missing.md)")
    refute Fixture.check(root, item, initial).checks["intake_record"]
    Fixture.write(root, "docs/inbox/README.md", "#{item.source} | docs/inbox/#{item.source}")

    Fixture.write(root, "docs/inbox/" <> item.source, initial.files[item.source] <> "\n")
    assert Fixture.check(root, item, initial).score == 1.0

    Fixture.write(
      root,
      "docs/inbox/" <> item.source,
      String.replace(initial.files[item.source], "Uncommitted sentence.", "")
    )

    assert Fixture.check(root, item, initial).score == 0.0

    Fixture.write(
      root,
      "docs/inbox/" <> item.source,
      String.replace(initial.files[item.source], "images/flow.svg", "missing.svg")
    )

    result = Fixture.check(root, item, initial)
    assert result.checks["content_preserved"]
    refute result.checks["image_target"]
    assert result.score < 1.0
  end
end
