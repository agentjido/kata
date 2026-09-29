---
name: kata-ex-jido-agent
description: Build or change Jido agents with current state, action, route, directive, plugin, and AgentServer contracts. Use for `Jido.Agent` modules and runtime wiring.
metadata: {language: elixir}
---

# Jido Agent

**Outcome:** A Jido agent whose pure command behavior and runtime signal
behavior use the target repository's installed APIs and have focused tests.

## Inspect the target

Read the active instructions, `mix.exs`, nearby agents, actions, plugins,
supervision code, and tests. Check the installed `jido` version. Do not apply a
remembered API when the local source differs.

Define the state the agent owns, the actions it runs, the signals it accepts,
and the effects that the runtime owns. Keep pure command behavior separate from
process and delivery behavior.

## Build the agent

Define the module with `use Jido.Agent`. For static routes, use the macro option:

```elixir
signal_routes: [
  {"order.created", MyApp.Actions.ProcessOrder}
]
```

Use `signal_routes/1` only when routes must depend on runtime context. Follow
the local schema style. A macro-generated agent module creates an agent value:

```elixir
agent = MyAgent.new()
{agent, directives} = MyAgent.cmd(agent, {MyAction, %{value: 1}})
```

The returned agent already contains the completed state. Directives do not
update that state. Use `Jido.Agent.StateOp` structs for strategy-owned state
operations. Use `Jido.Agent.Directive` structs for runtime-owned external
effects. Current examples include:

```elixir
%Jido.Agent.StateOp.SetState{attrs: %{status: :ready}}
%Jido.Agent.Directive.Emit{signal: signal}
%Jido.Agent.Directive.Schedule{message: :check, delay_ms: 1_000}
```

Check struct fields in the installed version before you add a directive. Do
not use the old `Jido.Directive` namespace or a `Jido.Directive.execute/2`
protocol.

For runtime behavior, start the agent through the repository's configured Jido
instance or `Jido.AgentServer`. Send a `Jido.Signal` to `call/2` or `cast/2`:

```elixir
{:ok, agent} = Jido.AgentServer.call(pid, signal)
:ok = Jido.AgentServer.cast(pid, signal)
```

Do not send an action tuple to these runtime functions. Use `cmd/2` for direct
action execution.

Add plugins only for a reusable capability that owns its state, actions, and
routes. Check plugin state keys for collisions. Add sensors, schedules, child
agents, pods, partitions, or persistence only when the task needs that runtime
feature.

## Verify

Test construction, state defaults, `cmd/2`, state operations, and returned
directives without a process. Add `AgentServer` tests only for signal routing,
directive execution, timers, supervision, or other process behavior.

Run focused tests, then the repository's documented checks. Report the command
contract, runtime boundary, and tests.
