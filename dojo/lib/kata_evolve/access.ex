defmodule KataEvolve.Access do
  @moduledoc "macOS process access controls for fixture-only Codex calls."

  def prepare(runtime, project, writable, cli) do
    unless System.find_executable("sandbox-exec"),
      do: raise("This evaluation requires macOS sandbox-exec")

    for dir <- ["home", "tmp"], do: File.mkdir_p!(Path.join(runtime, dir))
    auth = Path.join(System.get_env("CODEX_HOME") || Path.expand("~/.codex"), "auth.json")
    File.cp!(auth, Path.join(runtime, "home/auth.json"))
    File.chmod!(Path.join(runtime, "home/auth.json"), 0o600)
    policy = policy(runtime, project, writable)
    policy_path = Path.join(runtime, "access.sb")
    File.write!(policy_path, policy)
    wrapper = Path.join(runtime, "codex")

    File.write!(wrapper, """
    #!/bin/sh
    command_name="$1"
    shift
    exec /usr/bin/sandbox-exec -f #{quote_shell(policy_path)} #{quote_shell(cli)} "$command_name" --ignore-user-config --ignore-rules --ephemeral -c 'features.multi_agent=false' -c 'features.web_search_request=false' -c 'shell_environment_policy.inherit="all"' "$@"
    """)

    File.chmod!(wrapper, 0o700)

    {wrapper,
     %{
       "CODEX_HOME" => Path.join(runtime, "home"),
       "TMPDIR" => Path.join(runtime, "tmp"),
       "GIT_OPTIONAL_LOCKS" => "0",
       "GIT_CONFIG_GLOBAL" => "/dev/null",
       "GIT_CONFIG_NOSYSTEM" => "1"
     }}
  end

  def policy(runtime, project, writable) do
    # Deny all home-directory reads except the copied project and runtime tools.
    # This includes every checkout, expected output, other case and saved result.
    runtime = physical(runtime)
    project = physical(project)
    home = Path.expand("~")

    reads = [
      runtime,
      project,
      Path.join(home, ".local/share/mise"),
      Path.join(home, ".local/bin"),
      Path.join(home, ".local/share/uv"),
      Path.join(home, ".cache/uv")
    ]

    read_rules = Enum.map_join(reads, "\n", &"(allow file-read* (subpath #{q(&1)}))")

    writes =
      Enum.map_join(writable, "\n", fn path ->
        full = Path.join(project, String.trim_trailing(path, "/"))
        filter = if String.ends_with?(path, "/"), do: "subpath", else: "literal"
        "(allow file-write* (#{filter} #{q(full)}))"
      end)

    """
    (version 1)
    (allow default)
    (deny file-read* (subpath "/Users") (subpath "/private/var/folders") (subpath "/private/tmp") (subpath "/private/var/tmp"))
    (allow file-read-metadata (subpath "/Users") (subpath "/private/var/folders") (subpath "/private/tmp") (subpath "/private/var/tmp"))
    #{read_rules}
    (deny file-write*)
    (allow file-write* (subpath #{q(runtime)}))
    (allow file-write* (literal "/dev/null") (literal "/dev/tty"))
    #{writes}
    (deny file-write* (subpath #{q(Path.join(project, ".git"))}) (subpath #{q(Path.join(project, ".agents"))}))
    """
  end

  defp physical(path) do
    {resolved, 0} = System.cmd("/bin/pwd", ["-P"], cd: path)
    String.trim(resolved)
  end

  defp q(path), do: Jason.encode!(path)
  defp quote_shell(path), do: "'" <> String.replace(path, "'", "'\\''") <> "'"
end
