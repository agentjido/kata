defmodule KataEvolve.Answer do
  @moduledoc "Retain only the last complete assistant answer, never tool output."
  def new, do: %{text: nil, sequence: nil, terminal: false, chunks: []}

  def add(event, state) do
    case event.type do
      :output_text_delta ->
        case event.payload["text"] do
          text when is_binary(text) ->
            %{state | chunks: [text | state.chunks], sequence: event.sequence}

          _ ->
            state
        end

      :tool_call ->
        %{state | chunks: []}

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
    # ACP reports message chunks. Keep only the message after the last tool
    # call. Older harness versions can still report an explicit final message.
    text = state.text || state.chunks |> Enum.reverse() |> Enum.join()

    complete =
      state.terminal and result.status == :completed and
        String.trim(text) != ""

    %{
      answer: text,
      answer_complete: complete,
      answer_capture: %{
        source: if(state.text, do: "last_output_text_final", else: "last_acp_message"),
        sequence: state.sequence,
        result_text_truncated: Map.get(result, :text_truncated?, false)
      }
    }
  end
end
