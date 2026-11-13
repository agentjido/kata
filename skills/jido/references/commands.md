# Internal Kata registry and routing

These are internal routes of the single `jido` Agent Skill. They are not
public commands or separately installable skills. This file is the one fixed
registry and routing source.

## Registry

| Kata | Plain verb | Fixed path | Detailed methods |
| --- | --- | --- | --- |
| `understand` | investigate | `references/katas/understand.md` | understand, debug diagnosis, Git workbench |
| `shape` | plan | `references/katas/shape.md` | idea, roadmap, scope, software plan |
| `lead` | delegate | `references/katas/lead.md` | delegate |
| `work` | produce | `references/katas/work.md` | general work, debug repair, docs, routines, visual explanation, technical writing |
| `verify` | check | `references/katas/verify.md` | general verification, security review |
| `improve` | improve | `references/katas/improve.md` | maintain method, write method |
| `ship` | deliver | `references/katas/ship.md` | Git delivery |
| `dojo` | evaluate | `references/katas/dojo.md` | saved or live controlled evaluation |

The startup line uses the plain verb for each planned Kata, in sequence order.
Each verb maps to one Kata, so a reviewer can read the selected sequence from
the line. Do not use these verbs for other steps in the line.

## Help

`$jido help` returns this capability menu and stops. It does not select or run
a Kata. The eight routes group the 19 detailed methods. The methods are
capabilities, not separate public commands.

| Route | Capability | Example request |
| --- | --- | --- |
| Investigate | Understand a current condition. | `$jido explain how this system works` |
| Investigate or Produce | Diagnose a reproducible failure, or repair a supported cause when authorized. | `$jido diagnose this test failure, fix it locally, and check the result` |
| Investigate | Report Git workbench state. | `$jido report the local and remote repository state` |
| Plan | Explore or challenge a product idea. | `$jido grill this product idea before we build it` |
| Plan | Manage a decision roadmap. | `$jido map the decisions needed to reach this product goal` |
| Plan | Define scope and acceptance. | `$jido scope this request and name the exclusions` |
| Plan | Make a software implementation plan. | `$jido plan this ready software change` |
| Delegate | Assign bounded work and integrate returns. | `$jido delegate these research tasks and combine the results` |
| Produce | Complete ready general work. | `$jido implement this ready plan and check the local result` |
| Produce | Create or maintain project documentation. | `$jido update the project guide for the current behavior` |
| Produce | Create, inspect, validate, or run local routines. | `$jido list the routines available in this repository` |
| Produce | Make a focused visual explanation. | `$jido show how these components exchange data` |
| Produce | Write one technical artifact. | `$jido turn these notes into a decision brief` |
| Check | Verify a candidate against its conditions. | `$jido verify this result against the acceptance checks` |
| Check | Give security guidance or review source. | `$jido review this API for security defects` |
| Improve | Resolve a reusable-method finding. | `$jido assess this feedback about our review method` |
| Improve | Write or revise a reusable method. | `$jido make this repeated review method reusable` |
| Deliver | Commit, publish, watch, merge, tag, or release with exact authority. | `$jido commit this verified change only` |
| Evaluate | Inspect or run a controlled Dojo evaluation when explicitly requested. | `$jido Dojo: inspect the saved evaluation for this candidate` |

After the table, add: `Give Jido a goal in ordinary language. Jido selects the
smallest route that the goal needs. Use $tutor when you want guided practice.`
Do not present an internal route as a separate command.

## Sequence

```text
understand? -> shape? -> lead? -> work? -> verify? -> ship?
improve, for a reusable skill or work method
dojo, only when the user names Dojo
```

Each Kata is optional. A request can use one Kata or several. Enter at the
first unresolved contract and keep the order shown:

| Kata | Enter when | Skip when |
| --- | --- | --- |
| `understand` | The current condition, cause, evidence, or workbench state is unclear. | Supported facts already bound the work. |
| `shape` | Direction, scope, decisions, or technical sequence are unresolved. | The target, boundary, acceptance, and sequence are ready. |
| `lead` | The request asks for delegation, worker coordination, or managed return. | One direct worker is sufficient. |
| `work` | The result, scope, acceptance, and authority are known. | A candidate already exists, or the request asks only for a report, review, or delivery. |
| `verify` | A candidate needs acceptance evidence. | Current matching evidence already proves each material condition. |
| `ship` | The user asks for a commit, push, pull request, merge, tag, or release. | The requested result is local or delivery authority is absent. |

A failed verification returns to the repair owner, then to verification. Jido
keeps integration ownership through that return.

Common single-Kata requests:

- repository state uses `understand` with the Git workbench method;
- documentation, routines, and visual artifacts use `work`;
- a security review uses `verify`; and
- Git delivery of a verified change uses `ship`.

## Selection rules

1. Select from the requested result, not from a word in the request. The words
   status, plan, work, test, or review do not select a Kata by themselves.
2. A request about a reusable skill or work method enters at `improve`. It
   resolves the finding and changes the method only when the request
   authorizes that change. Do not send a skill-library request through
   software planning only because it uses the words plan or work.
3. Use `dojo` only when the current request explicitly names Dojo. Do not
   infer it. An evaluation result does not adopt or publish a candidate.
4. Send a learning request to Tutor.
5. For all other work, enter at the first unresolved Kata in the sequence.
   Do not enter earlier than the evidence requires. Task size does not select
   a Kata. Move back to an earlier Kata only when evidence shows that its
   contract is missing.
6. Read one detailed method only when its condition applies.
7. A method cannot change the sequence, the authority, or Jido's integration
   duty.
8. If no internal method fits, use `base-loop.md`. Name the missing specialist
   method. Do not install, search for, or invent one.

## Vocabulary

Use only the eight Kata names from the registry for a step. Acceptance,
reflection, and handoff are results or transitions, not Katas. Do not use
older output terms such as `deliver-value`, `accept`, `procedure`, a route
label, or a former `kata-*` package name.

For other help requests, use the same capability menu. Do not tell the user to
invoke an internal Kata or detailed method as a separate skill.
