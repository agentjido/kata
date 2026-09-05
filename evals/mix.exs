defmodule KataEvolve.MixProject do
  use Mix.Project

  def project do
    [
      app: :kata_evolve,
      version: "0.1.0",
      elixir: "~> 1.19",
      deps: deps(),
      aliases: [
        check: ["format --check-formatted", "compile --warnings-as-errors", "test"]
      ]
    ]
  end

  def application, do: [extra_applications: [:logger, :crypto, :ex_unit]]

  def cli, do: [preferred_envs: [check: :test]]

  defp deps do
    harness =
      System.get_env("JIDO_HARNESS_PATH") || "../../../Jido/proj_jido_harness/jido_harness"

    [{:jido_harness, path: harness}, {:jason, "~> 1.4"}]
  end
end
