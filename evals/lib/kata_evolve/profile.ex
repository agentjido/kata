defmodule KataEvolve.Profile do
  @moduledoc "Named execution settings, independent of the evaluated skill."
  def default, do: "codex-astra-xhigh"

  def fetch!(name) do
    {profiles, _} = Code.eval_file(Path.join(KataEvolve.root(), "config/profiles.exs"))

    case Map.fetch(profiles, name) do
      {:ok, profile} ->
        profile

      :error ->
        raise ArgumentError,
              "Unknown profile: #{name}. Choose #{Enum.join(Map.keys(profiles), ", ")}"
    end
  end
end
