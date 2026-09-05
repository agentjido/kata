defmodule KataEvolve.Metrics do
  @moduledoc "Compact counters over Harness events; no command output is retained."

  def new,
    do: %{tools: %{}, tool_errors: 0, file_change_events: 0, usage: %{}, calls: MapSet.new()}

  def add(event, acc) do
    case event.type do
      :tool_call ->
        key = {event.payload["name"], event.payload["call_id"] || event.sequence}

        if MapSet.member?(acc.calls, key) do
          acc
        else
          %{
            acc
            | tools: Map.update(acc.tools, elem(key, 0) || "unknown", 1, &(&1 + 1)),
              calls: MapSet.put(acc.calls, key)
          }
        end

      :tool_result ->
        %{acc | tool_errors: acc.tool_errors + if(event.payload["is_error"], do: 1, else: 0)}

      :file_change ->
        %{acc | file_change_events: acc.file_change_events + 1}

      :usage ->
        %{acc | usage: Map.merge(acc.usage, event.payload)}

      _ ->
        acc
    end
  end

  def finish(acc, elapsed_ms) do
    fields = ~w(input_tokens output_tokens cached_input_tokens reasoning_output_tokens)
    usage = Map.new(fields, &{&1, acc.usage[&1]})

    total =
      case {usage["input_tokens"], usage["output_tokens"]} do
        {input, output} when is_number(input) and is_number(output) -> input + output
        _ -> nil
      end

    %{
      usage: Map.put(usage, "total_tokens", total),
      tool_calls: Enum.sum(Map.values(acc.tools)),
      tools: acc.tools,
      tool_errors: acc.tool_errors,
      file_change_events: acc.file_change_events,
      elapsed_ms: elapsed_ms
    }
  end
end
