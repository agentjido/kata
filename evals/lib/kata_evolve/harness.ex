defmodule KataEvolve.Harness do
  @moduledoc "Finite Codex runs with normalized measurements and explicit cleanup."
  alias Jido.Harness.Run
  alias KataEvolve.{Answer, Metrics}

  def execute(profile, prompt, workspace) do
    request =
      profile
      |> Map.drop([:provider])
      |> Map.merge(%{prompt: prompt, cwd: workspace, approval_mode: :auto_approve})

    request =
      request
      |> Map.put_new(:sandbox_mode, :workspace_write)
      |> Map.update(
        :provider_options,
        %{skip_git_repo_check: true},
        &Map.put(&1, :skip_git_repo_check, true)
      )

    started = System.monotonic_time(:millisecond)

    with {:ok, id} <- Run.start(profile.provider, request) do
      try do
        with {:ok, stream} <- Run.stream(id),
             {counters, answer} <-
               Enum.reduce(stream, {Metrics.new(), Answer.new()}, fn event, {m, a} ->
                 {Metrics.add(event, m), Answer.add(event, a)}
               end),
             {:ok, result} <- Run.await(id, 5_000) do
          metrics = Metrics.finish(counters, System.monotonic_time(:millisecond) - started)

          case result.status do
            :completed ->
              {:ok, Map.merge(%{metrics: metrics, run_id: id}, Answer.finish(answer, result))}

            status ->
              {:error, %{status: status, error: inspect(result.error), metrics: metrics}}
          end
        end
      after
        Run.cancel(id)
        Run.await(id, 5_000)

        for process <- Jido.Harness.Process.list(), process.metadata[:run_id] == id do
          Jido.Harness.Process.cancel(process.process_id)
          Jido.Harness.Process.await(process.process_id, 5_000)
          Jido.Harness.Process.prune(process.process_id)
        end

        Run.prune(id)
      end
    end
  end
end
