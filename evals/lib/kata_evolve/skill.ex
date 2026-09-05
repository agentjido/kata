defmodule KataEvolve.Skill do
  @moduledoc "Minimal format checks; 500 words is a final target, not a tuning gate."

  @frontmatter ~r/\A(---\nname: kata-setup\ndescription: [^\n]+\n)(?:metadata: \{optimized_for: "[^"\n]+"\}\n)?---\n/

  def words(text), do: text |> String.split() |> length()
  def hash(text), do: :crypto.hash(:sha256, text) |> Base.encode16(case: :lower)

  def validate(text) do
    cond do
      not is_binary(text) ->
        {:error, "Skill must be text"}

      byte_size(text) > 16_000 ->
        {:error, "Skill exceeds 16 KB"}

      not Regex.match?(@frontmatter, text) ->
        {:error, "Keep the name and description frontmatter"}

      not String.contains?(text, "templates/docs-agents.md") ->
        {:error, "Keep the bundled template reference"}

      true ->
        :ok
    end
  end

  def mark_optimized(text, profile) do
    metadata =
      "metadata: {optimized_for: \"#{profile.provider}/#{profile.model}/#{profile.reasoning_effort}\"}"

    Regex.replace(@frontmatter, text, fn _, fields -> fields <> metadata <> "\n---\n" end,
      global: false
    )
  end
end
