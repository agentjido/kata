---
name: kata-jido-testing
description: Add focused tests for Jido actions, agents, signals, directives, plugins, runtimes, and AI integrations. Use when Jido behavior needs test coverage or a regression test.
metadata: {language: elixir}
---

# Jido Testing

**Outcome:** Tests prove the requested Jido behavior at the lowest reliable
layer and use a runtime only when the behavior depends on a process.

## Select the test boundary

Read active instructions, `mix.exs`, test helpers, nearby tests, and the current
Jido dependency versions. Reuse the repository's async, process, fixture, and
provider conventions.

Use these layers in order:

1. Test an action callback directly when only its domain behavior matters.
2. Use `Jido.Exec` when input or output validation, hooks, retries, timeouts, or
   execution options matter.
3. Call the agent module's `new/1` and `cmd/2` for state, state operations, and
   directives.
4. Start `Jido.AgentServer` only for signals, directive execution, timers,
   children, supervision, registration, or process lifecycle.
5. Use provider adapters or local stubs for AI behavior. Keep live providers
   out of the default suite.

## Write behavior evidence

Test public results and effects. For an action, cover valid input, validation
failure through the correct boundary, domain error, and output shape. For an
agent, cover initial state, the command result, and relevant
`Jido.Agent.StateOp` or `Jido.Agent.Directive` structs.

For runtime signal tests, create a `Jido.Signal` and use the current
`Jido.AgentServer.call/2` or `cast/2` API. Do not send action tuples to runtime
functions. Do not use the old `Jido.Directive` namespace.

Use monitors, messages, or repository polling helpers for asynchronous work.
Do not add fixed sleeps when a deterministic synchronization point exists.
Clean up started processes and temporary resources.

For AI code, test tool schemas, request shaping, structured-output validation,
and error mapping with deterministic inputs. State clearly when a behavior is
not covered because it requires a live service.

## Verify

Run the new test file first. Run it more than once when it covers concurrency.
Then run the documented project checks. Do not weaken an existing assertion or
skip a failure to make the suite pass.

Report the behavior proved, the selected test layer, commands, and remaining
runtime or provider risk.
