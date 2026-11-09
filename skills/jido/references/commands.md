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

The startup sentence uses the plain verb for each planned Kata, in sequence
order. Each verb maps to one Kata, so a reviewer can read the selected
sequence from the sentence. Do not use these verbs for other steps in the
sentence.

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

For help, explain the eight Katas with one natural-language `$jido` example for
each. Do not tell the user to invoke an internal Kata as a separate skill.
