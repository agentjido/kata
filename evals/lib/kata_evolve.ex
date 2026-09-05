defmodule KataEvolve do
  @moduledoc "Evaluate any skill through a suite of independent outcome checks."

  def root, do: Path.expand("..", __DIR__)

  def run(suite_path, command, opts \\ []) do
    module = KataEvolve.Suite.load!(suite_path)
    KataEvolve.Experiment.run(module, suite_path, command, opts)
  end
end
