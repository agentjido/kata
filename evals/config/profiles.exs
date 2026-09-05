%{
  "codex-astra-xhigh" => %{
    provider: :codex,
    model: "gpt-6-astra",
    provider_options: %{
      cli_path:
        System.get_env("KATA_CODEX_PATH") ||
          if(File.regular?("/Applications/ChatGPT.app/Contents/Resources/codex"),
            do: "/Applications/ChatGPT.app/Contents/Resources/codex",
            else: System.find_executable("codex")
          )
    },
    reasoning_effort: :xhigh,
    runtime_timeout_ms: 600_000,
    idle_timeout_ms: 600_000
  }
}
