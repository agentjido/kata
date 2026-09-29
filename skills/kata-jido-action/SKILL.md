---
name: kata-jido-action
description: Build or change Jido actions with current schemas, execution contracts, state effects, and focused tests. Use for `Jido.Action` modules or action-based tools.
metadata: {language: elixir}
---

# Jido Action

**Outcome:** A small Jido action that follows the target repository's current
API, validates its public contract, and has tests for success and failure.

## Inspect the target

Read the active instructions, `mix.exs`, nearby actions, and their tests. Check
the installed `jido_action` version before you use an example. Preserve the
repository's schema style unless the task requests a migration.

Record the action name, parameters, output, error cases, context keys, and side
effects before you edit code. Keep one action focused on one operation.

## Implement the contract

Define the module with `use Jido.Action`. Use a Zoi object schema when the
repository uses Zoi. A NimbleOptions keyword schema is also supported. Add an
`output_schema` when callers or tools need a checked output shape.

Implement `run/2` with one of the supported results:

```elixir
{:ok, result}
{:ok, result, effects}
{:error, reason}
```

Use the context as a map. In an agent command, current state is available at
`context[:state]`. Do not assume other keys exist unless the caller sets them.

An action can perform HTTP, database, or file work when the result is required
immediately. Use a runtime boundary or a directive for an outbound effect that
does not need an immediate result. Use `Jido.Agent.StateOp` values for internal
agent state changes. Do not describe a directive as a state update.

Use `Jido.Exec.run/3` when the test or caller must include schema validation,
lifecycle hooks, timeout behavior, or execution options. A direct `run/2` call
tests only the callback.

For an AI tool, keep the action name and description clear, give parameters
useful descriptions, and use data that can become JSON. Verify the tool schema
through the adapter that the installed `jido_ai` version provides. Do not copy
an old `to_tool/0` example without checking that API.

## Verify

Test valid input, invalid input through the execution boundary, domain errors,
output shape, and each meaningful effect. Add a tool-schema test when the
action is model-callable.

Run the focused test first. Then run the repository's documented checks. When
no stronger command is documented, run:

```sh
mix test path/to/action_test.exs
mix compile --warnings-as-errors
mix test
```

Report the contract, side-effect choice, tests, and any API assumption that you
could not verify.
