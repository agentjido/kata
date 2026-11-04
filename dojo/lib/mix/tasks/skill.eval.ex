defmodule Mix.Tasks.Skill.Eval do
  use Mix.Task
  @shortdoc "Evaluate a skill suite: baseline, tune, verify, check, or score"
  def run(args) do
    Mix.Task.run("app.start")

    {opts, positional, invalid} =
      OptionParser.parse(args,
        strict: [
          candidate: :string,
          batch: :string,
          reference: :string,
          attempts: :integer,
          profile: :string,
          context: :string,
          record: :string,
          retry_errors: :boolean,
          results: :string,
          max_calls: :integer,
          max_tokens: :integer
        ]
      )

    unless invalid == [], do: Mix.raise("Invalid options: #{inspect(invalid)}")

    case positional do
      [path, command] ->
        result = KataEvolve.run(path, command, opts)
        # Case records contain final source files; do not print those to the console.
        if is_list(result),
          do: IO.puts("Saved #{length(result)} records."),
          else: IO.puts(Jason.encode!(result, pretty: true))

        if command == "check" and
             (result == [] or Enum.any?(result, &(&1.outcome["status"] != "passed"))),
           do: Mix.raise("Saved outcome checks failed or no records were found")

        if command == "verify" and not result.eligible,
          do: Mix.raise("Candidate verification failed or its evidence is incomplete")

      _ ->
        Mix.raise("mix skill.eval SUITE_FILE train|tune|verify|score|check|status [options]")
    end
  end
end
