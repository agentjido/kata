Code.require_file("release_changelog.exs", __DIR__)
ExUnit.start()

defmodule Kata.ReleaseChangelogTest do
  use ExUnit.Case, async: true

  alias Kata.ReleaseChangelog

  test "reads a manual release heading" do
    changelog = """
    # Changelog

    ## [1.2.3] - 2026-11-07

    ### Added

    - A manual release.

    ## [1.2.2] - 2026-11-01
    """

    assert ReleaseChangelog.release_dates(changelog, "1.2.3") == ["2026-11-07"]

    assert ReleaseChangelog.release_notes(changelog, "1.2.3") ==
             {:ok, "### Added\n\n- A manual release."}
  end

  test "reads a Release Please heading" do
    changelog = """
    # Changelog

    ## [1.3.0](https://github.com/agentjido/skills/compare/v1.2.3...v1.3.0) (2026-11-07)

    ### Features

    * add one method

    ## [1.2.3] - 2026-11-01
    """

    assert ReleaseChangelog.release_dates(changelog, "1.3.0") == ["2026-11-07"]

    assert ReleaseChangelog.release_notes(changelog, "1.3.0") ==
             {:ok, "### Features\n\n* add one method"}
  end

  test "rejects a missing release" do
    changelog = "# Changelog\n"

    assert ReleaseChangelog.release_dates(changelog, "1.2.3") == []
    assert ReleaseChangelog.release_notes(changelog, "1.2.3") == :error
  end
end
