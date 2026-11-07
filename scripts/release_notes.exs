Code.require_file("release_changelog.exs", __DIR__)

defmodule Kata.ReleaseNotes do
  @semver ~r/^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$/

  def run([version]) do
    if Regex.match?(@semver, version) do
      print_notes(version)
    else
      fail("invalid semantic version #{inspect(version)}")
    end
  end

  def run(_args), do: fail("usage: elixir scripts/release_notes.exs <version>")

  defp print_notes(version) do
    changelog = File.read!(Path.expand("../CHANGELOG.md", __DIR__))

    case Kata.ReleaseChangelog.release_notes(changelog, version) do
      {:ok, notes} ->
        if notes == "" do
          fail("CHANGELOG.md: release #{version} has no notes")
        else
          IO.puts(notes)
        end

      _other ->
        fail("CHANGELOG.md: release #{version} was not found")
    end
  end

  defp fail(message) do
    IO.puts(:stderr, "ERROR: #{message}")
    System.halt(1)
  end
end

Kata.ReleaseNotes.run(System.argv())
