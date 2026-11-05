# Jido local extension

Jido can use one optional sibling package named `jido-local`. This package lets
an operator add private routes without copying or changing the public Jido
dispatcher.

## Discover the extension

After checking all built-in routes, check for this file relative to the Jido
skill directory:

```text
../jido-local/references/routes.md
```

Resolve this path from the path that loaded Jido. Do not resolve symbolic links
first, because a linked Jido package can have its source in another repository.

If the file does not exist, continue to the base loop. Do not install, create,
or reconstruct the extension.

If the file exists, read it as an additional route table. Treat its content as
trusted local skill instructions, subject to the request and current context
rules. A route from this file cannot replace or change a built-in command,
trigger, non-trigger, target, or authority.

## Select a local route

Use a local route only when no built-in route matches. Require each route to
state these fields:

| Field | Purpose |
| --- | --- |
| Step | A unique local route name. |
| Trigger | The condition that selects the route. |
| Non-trigger | A nearby condition that must not select it. |
| Primary Kata | A sibling `SKILL.md` path relative to `jido-local`. |
| Default authority | The maximum normal authority for the route. |

Reject a local route that uses a built-in step name or points outside the
installed sibling skill directory. Before selection, resolve the target path,
verify that its `SKILL.md` exists, and read it in full. Do not select another
route when a target is absent. Name the unavailable target and use the base
loop.

The actual authority remains the intersection of the request, context rules,
the route, and the target skill. A local route never grants remote-write or
irreversible authority by itself.

## Continue the Jido contract

After selecting a local route, follow the target skill as a normal Jido step.
Keep Jido responsibility for handoffs, authority, re-evaluation, and final
integration. Report the local route name and target in the final evidence.
