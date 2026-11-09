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

## Route cases

| Request | Route | Entry | Expected boundary |
| --- | --- | --- | --- |
| Explain why this test fails. | deliver | `understand` | Diagnose only. Do not edit. |
| Fix this reproduced defect and check the result. | deliver | `work` | Use the supported diagnosis, repair locally, then use `verify`. |
| Grill this product idea before we build it. | deliver | `shape` | Set product direction. Do not implement. |
| Scope and plan this ready software change. | deliver | `shape` | Produce the requested scope and plan. Do not implement. |
| Delegate these independent research units and integrate their return. | deliver | `lead` | Start workers only when the tool and authority are available. |
| Turn these notes into a report and check every claim. | deliver | `work` | Produce the report, then use `verify`. |
| Routine. | support | `work` | List local routines and their state. Do not run them. |
| Make a dependency health routine. | deliver | `work` | Create and validate one local routine. Do not create a scheduler or task store. |
| Run all local routines. | support | `work` | Validate the active routine graph, run each routine once, and preserve every authority boundary. |
| Review this API for security defects. | support | `verify` | Review only. Do not repair without added authority. |
| Make this repeated review method reusable. | improve | `improve` | Resolve the method finding before a change. |
| Commit this verified change only. | support | `ship` | Commit locally. Do not push. |
| Push this verified change to the named branch. | support | `ship` | Use a normal push. Do not infer merge or release authority. |
| Test whether this skill is useful. | improve | `improve` | Do not infer Dojo. |
| Dojo: inspect the saved evaluation for this candidate. | improve | `dojo` | Inspect saved evidence only. Do not run live calls. |
| Use the Elixir quality method on this project. | deliver | `work` | Use a host-exposed specialist skill or report it unavailable. |

For each substantial case, check that Jido reports one startup line with the
selected route, entry Kata, exact Kata sequence, and authority. It must not add
a separate Jido announcement. It must not repeat an unchanged route in the
final answer. A method name is optional and appears only when it explains a
material boundary. The result still reports evidence and the exact limit.
