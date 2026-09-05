defmodule Mix.Tasks.Setup.Eval do
  @shortdoc "Check, record, or tune kata-setup on a named Codex profile"
  use Mix.Task

  def run(args) do
    {opts, rest, invalid} =
      OptionParser.parse(args,
        strict: [profile: :string, attempts: :integer, minutes: :integer, fresh: :boolean]
      )

    if invalid != [] or rest not in [["check"], ["baseline"], ["tune"]],
      do:
        Mix.raise(
          "Use mix setup.eval check | baseline | tune [--profile NAME] [--attempts 1..5] [--minutes N] [--fresh]"
        )

    if (opts[:attempts] || 1) not in 1..5 or (opts[:minutes] || 30) not in 1..120,
      do: Mix.raise("Use 1-5 attempts and 1-120 minutes")

    case rest do
      ["check"] ->
        IO.inspect(KataEvolve.check(opts))

      [command] ->
        Mix.Task.run("app.start")
        result = KataEvolve.run(command, opts)
        if not result.passed, do: Mix.raise("Setup checks failed. See the saved profile report.")
    end
  end
end
