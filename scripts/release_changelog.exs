defmodule Kata.ReleaseChangelog do
  @date_source "\\d{4}-\\d{2}-\\d{2}"

  def release_dates(changelog, version) do
    version = Regex.escape(version)

    [
      Regex.compile!("^## \\[#{version}\\] - (?<date>#{@date_source})$", "m"),
      Regex.compile!(
        "^## \\[#{version}\\]\\([^\\n]+\\) \\((?<date>#{@date_source})\\)$",
        "m"
      )
    ]
    |> Enum.flat_map(fn pattern -> Regex.scan(pattern, changelog, capture: :all_names) end)
    |> List.flatten()
  end

  def release_notes(changelog, version) do
    version = Regex.escape(version)

    heading_source =
      "(?:^## \\[#{version}\\] - #{@date_source}$|" <>
        "^## \\[#{version}\\]\\([^\\n]+\\) \\(#{@date_source}\\)$)"

    section_pattern =
      Regex.compile!("#{heading_source}\\n(?<notes>.*?)(?=^## \\[|\\z)", "ms")

    case Regex.named_captures(section_pattern, changelog) do
      %{"notes" => notes} -> {:ok, String.trim(notes)}
      _other -> :error
    end
  end
end
