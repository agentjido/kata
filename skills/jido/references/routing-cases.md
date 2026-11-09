# Routing acceptance cases

Use these cases to review a Jido revision. They define expected entry behavior;
they do not grant the actions named in a request.

## Activation cases

| Context | Expected behavior |
| --- | --- |
| The requester starts the goal with `$jido`. | Use Jido. |
| A standing user or workspace instruction prefers Jido and the work is substantial or ambiguous. | Use Jido. |
| The request is a simple question, direct command, or small self-contained task. | Skip Jido. |
| The requester selects another workflow or says not to use a skill. | Skip Jido. |
| The requester asks Jido to teach a concept or practise a skill. | Recommend one explicit `$tutor` request with relevant context. Do not start Tutor automatically. |

## Entry cases

| Request | Entry | Sequence | Expected boundary |
| --- | --- | --- | --- |
| Explain why this test fails. | `understand` | `understand` | Diagnose only. Do not edit. |
| Fix this reproduced defect and check the result. | `work` | `work -> verify` | Use the supported diagnosis, repair locally, then verify. |
| Grill this product idea before we build it. | `shape` | `shape` | Set product direction. Do not implement. |
| Scope and plan this ready software change. | `shape` | `shape` | Produce the requested scope and plan. Do not implement. |
| Delegate these independent research units and integrate their return. | `lead` | `lead -> verify` | Start workers only when the tool and authority are available. |
| Turn these notes into a report and check every claim. | `work` | `work -> verify` | Produce the report, then verify each claim. |
| Routine. | `work` | `work` | List local routines and their state. Do not run them. |
| Make a dependency health routine. | `work` | `work` | Create and validate one local routine. Do not create a scheduler or task store. |
| Run all local routines. | `work` | `work` | Validate the active routine graph, run each routine once, and preserve every authority boundary. |
| Review this API for security defects. | `verify` | `verify` | Review only. Do not repair without added authority. |
| Make this repeated review method reusable. | `improve` | `improve` | Resolve the method finding before a change. |
| Commit this verified change only. | `ship` | `ship` | Commit locally. Do not push. |
| Push this verified change to the named branch. | `ship` | `ship` | Use a normal push. Do not infer merge or release authority. |
| Test whether this skill is useful. | `improve` | `improve` | Do not infer Dojo. |
| Dojo: inspect the saved evaluation for this candidate. | `dojo` | `dojo` | Inspect saved evidence only. Do not run live calls. |
| Use the Elixir quality method on this project. | `work` | `work -> verify` | Use a host-exposed specialist skill or report it unavailable. |

For each substantial case, check that Jido gives one plain startup sentence
with the planned steps and the authority limit. The sentence must use the
plain verb from `commands.md` for each Kata in the Sequence column, in that
order, and no plain verb for a Kata outside it. For example, `work -> verify`
reads as "produce ..., then check ...". It must not add a separate Jido
announcement or a route label. It must not repeat an unchanged plan in the
final answer. A method name is optional and appears only when it explains a
material boundary. The result still reports evidence, the exact limit, and
whether the verdict is separate or self-checked.
