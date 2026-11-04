defmodule KataEvolve.Setup.Skill do
  @moduledoc "Docs skill identity, format checks, and word counts."

  def words(text), do: text |> String.split() |> length()
  def hash(text), do: :crypto.hash(:sha256, text) |> Base.encode16(case: :lower)

  def validate(text) do
    cond do
      not is_binary(text) ->
        {:error, "Skill must be text"}

      byte_size(text) > 16_000 ->
        {:error, "Skill exceeds 16 KB"}

      KataEvolve.Skill.validate(text, "kata-docs") != :ok ->
        {:error, "Keep kata-docs name and description frontmatter"}

      not Enum.all?(
        [
          "references/document-contracts.md",
          "references/setup.md"
        ],
        &String.contains?(text, &1)
      ) ->
        {:error, "Keep the setup route references"}

      true ->
        :ok
    end
  end

  defdelegate mark_optimized(text, profile), to: KataEvolve.Skill
end
