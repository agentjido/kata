defmodule KataEvolve.Skill do
  @moduledoc "Skill identity, word counts, and optimization metadata; no task-specific rules."
  @frontmatter ~r/\A---\r?\n(.*?)\r?\n---(?:\r?\n|\z)/s

  def words(text), do: text |> String.split() |> length()
  def hash(text), do: :crypto.hash(:sha256, text) |> Base.encode16(case: :lower)

  def validate(text, expected_name \\ nil)

  def validate(text, expected_name) when is_binary(text) do
    with true <- byte_size(text) <= 16_000,
         [_, fields] <- Regex.run(@frontmatter, text),
         [_, name] <- Regex.run(~r/^name:\s*([^\r\n]+)$/m, fields),
         name = String.trim(name) |> String.trim("\"") |> String.trim("'"),
         true <- Regex.match?(~r/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, name),
         true <- is_nil(expected_name) or name == expected_name,
         true <- Regex.match?(~r/^description:[ \t]*\S[^\r\n]*$/m, fields) do
      :ok
    else
      _ ->
        {:error,
         "Use name and description frontmatter matching the selected skill (maximum 16 KB)"}
    end
  end

  def validate(_, _), do: {:error, "Skill must be text"}

  def mark_optimized(text, profile) do
    target = "#{profile.provider}/#{profile.model}/#{profile.reasoning_effort}"
    field = "optimized_for: #{Jason.encode!(target)}"

    Regex.replace(
      @frontmatter,
      text,
      fn full, original_fields ->
        fields = String.replace(original_fields, "\r\n", "\n")

        updated =
          cond do
            Regex.match?(~r/^metadata: *\{[^\n]*\} *$/m, fields) ->
              Regex.replace(~r/^metadata: *\{([^\n]*)\} *$/m, fields, fn _, values ->
                kept =
                  Regex.replace(
                    ~r/(?:^|,)\s*optimized_for:\s*(?:"[^"]*"|'[^']*'|[^,}]+)/,
                    values,
                    ""
                  )

                kept = kept |> String.trim() |> String.trim(",") |> String.trim()
                "metadata: {" <> Enum.join(Enum.reject([kept, field], &(&1 == "")), ", ") <> "}"
              end)

            Regex.match?(~r/^metadata: *$/m, fields) ->
              cleaned = Regex.replace(~r/^  optimized_for:[^\n]*\n?/m, fields, "")
              Regex.replace(~r/^metadata: *$/m, cleaned, "metadata:\n  #{field}")

            Regex.match?(~r/^metadata:/m, fields) ->
              raise ArgumentError, "Optimization metadata must be an inline or block map"

            true ->
              fields <> "\nmetadata: {#{field}}"
          end

        newline = if String.contains?(full, "\r\n"), do: "\r\n", else: "\n"

        String.replace(full, original_fields, String.replace(updated, "\n", newline),
          global: false
        )
      end,
      global: false
    )
  end
end
