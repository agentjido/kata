defmodule KataEvolve.Snapshot do
  @moduledoc "Small final file states that can be checked again without a model."
  alias KataEvolve.Fixture

  def take_input(root) do
    Map.new(walk(root, ""), fn {path, file} ->
      {String.trim_trailing(path, ".fixture"), text(%{files: %{path => file}}, path)}
    end)
  end

  def take(root) do
    files = walk(root, "") |> Map.new()

    %{
      files: files,
      index: Fixture.git!(root, ["ls-files", "--stage"]),
      head: Fixture.git!(root, ["rev-parse", "HEAD"])
    }
  end

  def text(snapshot, path) do
    case snapshot.files[path] do
      %{"type" => "file", "text" => content} -> content
      %{"type" => "file", "base64" => content} -> Base.decode64!(content)
      _ -> ""
    end
  end

  def regular?(snapshot, path), do: match?(%{"type" => "file"}, snapshot.files[path])

  defp walk(root, relative) do
    path = Path.join(root, relative)

    Enum.flat_map(Enum.sort(File.ls!(path)), fn name ->
      child = Path.join(relative, name)
      full = Path.join(root, child)

      cond do
        name in [".git", "_build", "deps"] ->
          []

        true ->
          case File.lstat!(full) do
            %{type: :directory} ->
              walk(root, child)

            %{type: :regular, size: size} when size <= 1_048_576 ->
              content = File.read!(full)

              field =
                if String.valid?(content),
                  do: %{"text" => content},
                  else: %{"base64" => Base.encode64(content)}

              [{child, Map.put(field, "type", "file")}]

            %{type: :symlink} ->
              [{child, %{"type" => "symlink", "target" => File.read_link!(full)}}]

            _ ->
              [{child, %{"type" => "unsupported"}}]
          end
      end
    end)
  end
end
