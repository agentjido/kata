# Jido work routes

Jido has four routes. Select the route from the requested result, not from a
word that appears in the request.

## Deliver

```text
understand -> shape? -> lead? -> work -> verify -> ship?
```

Enter at the first unresolved contract:

| Kata | Enter when | Skip when |
| --- | --- | --- |
| `understand` | The current condition, cause, evidence, or workbench state is unclear. | Supported facts already bound the work. |
| `shape` | Direction, scope, decisions, or technical sequence are unresolved. | The target, boundary, acceptance, and route are ready. |
| `lead` | The request asks for teaching, delegation, worker coordination, or managed return. | One direct worker is sufficient and no teaching was requested. |
| `work` | The result, scope, acceptance, and authority are known. | A candidate already exists. |
| `verify` | A candidate needs independent acceptance evidence. | Current matching evidence already proves each material condition. |
| `ship` | The user asks for a commit, push, pull request, merge, tag, or release. | The requested result is local or delivery authority is absent. |

A failed verification returns to the repair owner, then to verification. Jido
keeps integration ownership through that return.

## Learn

```text
lead -> work? -> verify?
```

Use `lead` in teaching mode when the user asks to learn or practise agent
leadership. Teaching is not a required gate for ordinary delivery.
Reflection is a learning result, not an internal Kata or a sequence step.

## Improve

```text
improve
```

Use `improve` for reusable skills and work methods. It resolves the finding and
changes the method only when the request authorizes that change. Do not route a
skill-library request through ordinary software planning only because it uses
the words plan or work.

## Support

Use the same Katas for support work:

- repository state uses `understand` with the Git workbench method;
- documentation and visual artifacts use `work`;
- security review uses `verify`;
- Git delivery uses `ship`.

## Explicit Dojo route

```text
dojo
```

Use `dojo` only when the current request explicitly names Dojo. Do not infer
it. An evaluation result does not adopt or publish a candidate.

## Route output vocabulary

Use only `deliver`, `learn`, `improve`, `support`, or `dojo` as the route name.
Use only internal Kata names from `commands.md` in the entry and sequence.
Acceptance, reflection, and handoff are results or transitions, not Katas.
Do not use older output terms such as `deliver-value`, `accept`, `procedure`,
or a former `kata-*` package name.

## Altitude rule

Altitude is the first unresolved contract, not task size. Use the lowest Kata
that can act without guessing. Move earlier only when evidence shows that a
required contract is missing.
