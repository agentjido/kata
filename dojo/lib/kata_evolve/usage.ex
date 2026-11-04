defmodule KataEvolve.Usage do
  @moduledoc "Count calls before dispatch; derive costs from saved evidence."
  alias KataEvolve.Evidence

  def start!(ctx, id, kind) do
    totals = summary(ctx.dir, ctx.id)
    limits = Map.get(ctx, :limits, %{calls: 30, tokens: 2_000_000})

    cond do
      totals.pending > 0 ->
        raise("An earlier call has no result. Diagnose it before another call.")

      totals.calls >= limits.calls ->
        raise("Call budget reached (#{limits.calls})")

      totals.total_tokens >= limits.tokens ->
        raise("Token budget reached (#{limits.tokens})")

      true ->
        :ok
    end

    path = Path.join(ctx.dir, "calls/#{ctx.id}/#{id}/started.json")
    Evidence.write_new!(path, %{execution_id: id, kind: kind, started_at: DateTime.utc_now()})
  end

  def finish!(ctx, id, result) do
    {status, output} =
      case result do
        {:ok, out} -> {"completed", out}
        {:error, out} -> {"error", if(is_map(out), do: out, else: %{})}
      end

    Evidence.write_new!(Path.join(ctx.dir, "calls/#{ctx.id}/#{id}/result.json"), %{
      execution_id: id,
      status: status,
      metrics: output[:metrics]
    })
  end

  def summary(dir, context \\ "*") do
    starts = Path.wildcard(Path.join(dir, "calls/#{context}/*/started.json"))

    receipts =
      for path <- starts do
        start = Evidence.read(path)
        result = Path.join(Path.dirname(path), "result.json")

        if File.exists?(result),
          do: Evidence.read(result),
          else: Map.put(start, "status", "pending")
      end

    # Older experiments have no dispatch receipts. Include their saved calls and aborts.
    records =
      Path.wildcard(Path.join(dir, "batches/#{context}/*/cases/*.json")) ++
        Path.wildcard(Path.join(dir, "batches/#{context}/*/retries/*/*.json")) ++
        Path.wildcard(Path.join(dir, "search/#{context}/proposal-*.json")) ++
        Path.wildcard(Path.join(dir, "batches/#{context}/*/aborted.json"))

    legacy = for path <- records, do: Map.put(Evidence.read(path), "_path", path)
    all = Enum.uniq_by(receipts ++ legacy, &(&1["execution_id"] || &1["_path"]))
    add = fn path -> Enum.sum(Enum.map(all, &(get_in(&1, path) || 0))) end

    %{
      calls: length(all),
      proposals:
        Enum.count(starts, &(Evidence.read(&1)["kind"] == "proposal")) +
          Enum.count(
            legacy,
            &(String.contains?(&1["_path"], "/proposal-") and
                not Enum.any?(receipts, fn r -> r["execution_id"] == &1["execution_id"] end))
          ),
      pending: Enum.count(all, &(&1["status"] == "pending")),
      errors: Enum.count(all, &(&1["status"] == "error")),
      unknown_metrics: Enum.count(all, &(not is_map(&1["metrics"]))),
      total_tokens: add.(["metrics", "usage", "total_tokens"]),
      tool_calls: add.(["metrics", "tool_calls"]),
      elapsed_ms: add.(["metrics", "elapsed_ms"])
    }
  end
end
