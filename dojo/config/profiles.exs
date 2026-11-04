base = %{
  provider: :codex,
  provider_options: %{
    cli_path:
      System.get_env("KATA_CODEX_PATH") ||
        if(File.regular?("/Applications/ChatGPT.app/Contents/Resources/codex"),
          do: "/Applications/ChatGPT.app/Contents/Resources/codex",
          else: System.find_executable("codex")
        )
  },
  runtime_timeout_ms: 600_000,
  idle_timeout_ms: 600_000
}

%{
  "codex-astra-xhigh" => Map.merge(base, %{model: "gpt-6-astra", reasoning_effort: :xhigh}),
  "codex-sol-medium" => Map.merge(base, %{model: "gpt-5.6-sol", reasoning_effort: :medium})
}
