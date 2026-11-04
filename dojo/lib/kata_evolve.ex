defmodule KataEvolve do
  @moduledoc "Dojo evaluates agent runs through independent skill outcome checks."

  def root, do: Path.expand("..", __DIR__)

  def run(suite_path, command, opts \\ []) do
    module = KataEvolve.Suite.load!(suite_path)
    KataEvolve.Experiment.run(module, suite_path, command, opts)
  end
end
