defmodule KataEvolve.Answer do
  @moduledoc "Retain only the last complete assistant answer, never tool output."
  def new, do: %{text: nil, sequence: nil, terminal: false}

  def add(event, state) do
    case event.type do
      :output_text_final ->
        case event.payload["text"] do
          text when is_binary(text) -> %{state | text: text, sequence: event.sequence}
          _ -> state
        end

      :run_completed ->
        %{state | terminal: true}

      _ ->
        state
    end
  end

  def finish(state, result) do
    # Codex emits full item.completed text. This is independent of RunResult's
    # bounded tail and avoids concatenating commentary or duplicated deltas.
    complete =
      state.terminal and result.status == :completed and
        is_binary(state.text) and String.trim(state.text) != ""

    %{
      answer: state.text || "",
      answer_complete: complete,
      answer_capture: %{
        source: "last_output_text_final",
        sequence: state.sequence,
        result_text_truncated: Map.get(result, :text_truncated?, false)
      }
    }
  end
end
