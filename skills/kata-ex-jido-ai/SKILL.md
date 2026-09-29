---
name: kata-ex-jido-ai
description: Add Jido AI generation, tool use, structured output, streaming, or AI agents with current `jido_ai` and `req_llm` contracts. Use for Jido LLM integration work.
metadata: {language: elixir}
---

# Jido AI

**Outcome:** A narrow Jido AI integration that uses current local APIs, keeps
provider settings safe, and has deterministic tests that do not need a live
provider.

## Inspect the target

Read active instructions, dependency versions, configuration, existing AI
modules, tools, tests, and provider test support. Search local source and docs
for the exact functions that the change needs. Do not fix a model name or
provider policy in the skill.

Select the smallest current surface:

- `Jido.AI.ask/2` or generation helpers for one direct request;
- `Jido.AI.Actions.*` inside an existing workflow;
- `Jido.AI.Agent` for a tool-using ReAct loop;
- a specific reasoning agent only when its strategy is required;
- the standalone ReAct runtime for streaming, checkpoints, or resume.

## Implement safely

Keep API keys and provider secrets in runtime configuration. Use a repository
model alias when one exists. Do not add a universal model default.

For a tool-using agent, use current `Jido.Action` modules as tools:

```elixir
defmodule MyApp.Agent do
  use Jido.AI.Agent,
    name: "my_agent",
    model: :fast,
    tools: [MyApp.Actions.Lookup]
end

{:ok, pid} = Jido.AgentServer.start(agent: MyApp.Agent)
{:ok, result} = MyApp.Agent.ask_sync(pid, "Find the order")
```

Use `ask/3` and `await/2` when the caller needs an explicit request handle.
Use request options such as `allowed_tools`, `tool_context`, `llm_opts`,
`request_transformer`, or structured output only after you confirm them in the
installed version.

Give each tool a narrow schema and stable name. Restrict tool exposure to the
request that needs it. Treat filesystem, shell, network, and data-changing
tools as high-risk. Validate their input at the action boundary.

Handle authentication errors, rate limits, timeouts, invalid output, partial
streams, and tool errors in the repository's normal error form. Never write
prompts, responses, tokens, or request logs that contain secrets to Git.

## Verify

Use fixtures, provider adapters, local HTTP stubs, tool-schema checks, and
prompt or request-shaping tests. Test structured-output validation and tool
failure paths. Do not add live network calls to the default suite.

Run a live provider check only when the user requests it and supplies an
approved credential path. Report which tests were offline and which, if any,
used a live provider.
