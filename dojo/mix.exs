defmodule KataEvolve.MixProject do
  use Mix.Project

  def project do
    [
      app: :kata_evolve,
      version: "0.1.0",
      elixir: "~> 1.19",
      deps: deps(),
      aliases: [
        check: ["format --check-formatted", "compile --warnings-as-errors", "test"],
        maintenance: [
          "format --check-formatted",
          "compile --warnings-as-errors",
          "test --exclude legacy_contract"
        ]
      ]
    ]
  end

  def application, do: [extra_applications: [:logger, :crypto, :ex_unit]]

  def cli, do: [preferred_envs: [check: :test, maintenance: :test]]

  defp deps do
    [
      {:jido_harness, github: "agentjido/jido_harness", tag: "v3.0.0-rc.1"}
    ]
  end
end
