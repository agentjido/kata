defmodule KataEvolve.Evidence do
  @moduledoc "Complete small project snapshots and immutable JSON records."
  alias KataEvolve.Skill

  def take(root) do
    %{
      "files" => files(root),
      "index" => git(root, ["ls-files", "--stage"]),
      "head" => git(root, ["rev-parse", "HEAD"])
    }
  end

  def files(root), do: walk(root, "") |> Map.new()

  defp walk(root, relative) do
    File.ls!(Path.join(root, relative))
    |> Enum.sort()
    |> Enum.flat_map(fn name ->
      path = Path.join(relative, name)
      full = Path.join(root, path)
      stat = File.lstat!(full)
      mode = Bitwise.band(stat.mode, 0o7777)

      case stat.type do
        :directory ->
          [{path, %{"type" => "directory", "mode" => mode}} | walk(root, path)]

        :regular ->
          bytes = File.read!(full)

          content =
            if String.valid?(bytes),
              do: %{"text" => bytes},
              else: %{"base64" => Base.encode64(bytes)}

          [{path, Map.merge(content, %{"type" => "file", "mode" => mode})}]

        :symlink ->
          [{path, %{"type" => "symlink", "target" => File.read_link!(full), "mode" => mode}}]

        other ->
          [{path, %{"type" => to_string(other), "mode" => mode}}]
      end
    end)
  end

  def text(snapshot, path) do
    case snapshot["files"][path] do
      %{"text" => text} -> text
      %{"base64" => data} -> Base.decode64!(data)
      _ -> ""
    end
  end

  def allowed?(path, paths) do
    Enum.any?(paths, fn allowed ->
      path == String.trim_trailing(allowed, "/") or
        (String.ends_with?(allowed, "/") and String.starts_with?(path, allowed))
    end)
  end

  def changes(initial, final) do
    (Map.keys(initial["files"]) ++ Map.keys(final["files"]))
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.filter(&(initial["files"][&1] != final["files"][&1]))
  end

  def preserved?(initial, final, writable) do
    initial["head"] == final["head"] and initial["index"] == final["index"] and
      Enum.all?(changes(initial, final), fn path ->
        path not in [".git", ".agents"] and not String.starts_with?(path, ".git/") and
          not String.starts_with?(path, ".agents/") and allowed?(path, writable)
      end)
  end

  def write_new!(path, value) do
    File.mkdir_p!(Path.dirname(path))
    bytes = if is_binary(value), do: value, else: Jason.encode!(value, pretty: true) <> "\n"

    case File.open(path, [:write, :exclusive]) do
      {:ok, io} ->
        try do
          IO.binwrite(io, bytes)
        after
          File.close(io)
        end

      {:error, reason} ->
        raise "Refuse to replace evidence #{path}: #{inspect(reason)}"
    end

    path
  end

  def read(path), do: path |> File.read!() |> Jason.decode!()
  def hash(value), do: Skill.hash(value)
  def json(value), do: value |> Jason.encode!() |> Jason.decode!()
  def identity(value), do: value |> json() |> :erlang.term_to_binary([:deterministic]) |> hash()

  def fingerprint(paths) do
    paths
    |> Enum.sort()
    |> Map.new(fn path ->
      cond do
        File.dir?(path) -> {path, files(path)}
        true -> {path, %{"sha256" => hash(File.read!(path)), "type" => "file"}}
      end
    end)
    |> identity()
  end

  # Relative names make the same checkout portable between worktrees.
  def portable_fingerprint(paths, root) do
    paths
    |> Enum.uniq()
    |> Map.new(fn path ->
      name = Path.relative_to(Path.expand(path), Path.expand(root))
      value = if File.dir?(path), do: files(path), else: hash(File.read!(path))
      {name, value}
    end)
    |> identity()
  end

  def git(root, args) do
    case System.cmd("git", ["-c", "core.fsmonitor=false" | args],
           cd: root,
           env: [{"GIT_OPTIONAL_LOCKS", "0"}],
           stderr_to_stdout: true
         ) do
      {text, 0} -> text
      {error, code} -> raise "Git #{inspect(args)} failed (#{code}): #{error}"
    end
  end
end
