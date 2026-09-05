defmodule Mix.Tasks.Setup.Eval do
  @shortdoc "Check, record, or tune kata-setup with Codex Astra xhigh"
  use Mix.Task

  def run(args) do
    {opts, rest, invalid} =
      OptionParser.parse(args, strict: [attempts: :integer, minutes: :integer, fresh: :boolean])

    if invalid != [] or rest not in [["check"], ["baseline"], ["tune"]],
      do:
        Mix.raise(
          "Use mix setup.eval check | baseline | tune [--attempts 1..3] [--minutes N] [--fresh]"
        )

    if (opts[:attempts] || 1) not in 1..3 or (opts[:minutes] || 30) not in 1..120,
      do: Mix.raise("Use 1-3 attempts and 1-120 minutes")

    case rest do
      ["check"] ->
        IO.inspect(KataEvolve.check())

      [command] ->
        Mix.Task.run("app.start")
        result = KataEvolve.run(command, opts)
        if not result.passed, do: Mix.raise("Setup checks failed. See results/setup/report.md")
    end
  end
end
