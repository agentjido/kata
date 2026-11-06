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

    pattern =
      Regex.compile!(
        "^## \\[#{Regex.escape(version)}\\] - \\d{4}-\\d{2}-\\d{2}$\\n(?<notes>.*?)(?=^## \\[|\\z)",
        "ms"
      )

    case Regex.named_captures(pattern, changelog) do
      %{"notes" => notes} ->
        notes = String.trim(notes)

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
