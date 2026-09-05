defmodule Mix.Tasks.Setup.Score do
  @shortdoc "Score saved setup evidence; no LLM calls or result changes"
  use Mix.Task

  def run(args) do
    {opts, args, invalid} = OptionParser.parse(args, strict: [repetitions: :integer])

    case {args, invalid, opts[:repetitions] || 1} do
      {[profile, context, candidate], [], repetitions} when repetitions in [1, 3] ->
        profile
        |> KataEvolve.Setup.Score.from_saved(context, candidate, repetitions)
        |> Jason.encode!(pretty: true)
        |> IO.puts()

      _ ->
        Mix.raise("Use mix setup.score PROFILE CONTEXT CANDIDATE [--repetitions 1|3]")
    end
  end
end
