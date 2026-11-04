defmodule KataEvolve.NeckbeardProject do
  @moduledoc "Prepare fixed project inputs, separate from answer checks."
  @fixture Path.expand("../../test/fixtures/kata-neckbeard", __DIR__)

  def prepare(root, item) do
    File.cp_r!(Path.join([@fixture, "input", item.id]), root)

    if item.id == "final-export" do
      File.rename!(Path.join(root, "local.cache.fixture"), Path.join(root, "local.cache"))
    end

    git!(root, ["init", "-q"])
    git!(root, ["add", "."])
    if item.id == "final-export", do: git!(root, ["rm", "--cached", "operator-note.txt"])

    git!(root, [
      "-c",
      "user.name=Fixture",
      "-c",
      "user.email=fixture@example.invalid",
      "commit",
      "-qm",
      "Initial source import"
    ])

    if item.id == "final-export" do
      File.write!(
        Path.join(root, "exporter/README.md"),
        "\nOperator note: staging only; retain this text.\n",
        [:append]
      )

      git!(root, ["add", "exporter/README.md"])

      File.write!(
        Path.join(root, "exporter/README.md"),
        "\nLocal draft: deployment has not been checked.\n",
        [:append]
      )
    end

    :ok
  end

  defp git!(root, args) do
    {out, code} =
      System.cmd("git", args,
        cd: root,
        stderr_to_stdout: true,
        env: [
          {"GIT_CONFIG_GLOBAL", "/dev/null"},
          {"GIT_CONFIG_NOSYSTEM", "1"},
          {"GIT_AUTHOR_DATE", "2026-01-01T00:00:00Z"},
          {"GIT_COMMITTER_DATE", "2026-01-01T00:00:00Z"}
        ]
      )

    if code != 0, do: raise("Git fixture failed: #{out}")
    out
  end
end
