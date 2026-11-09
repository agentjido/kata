# Learning map

Use this map for first placement and later coaching. Review supplied work, find
one gap that can improve the real result, and offer one lesson or concept. Do
not run a separate test or score the learner.

All nodes were reviewed in 2026-11. The review month records package review. It
does not prove that current models, hosts, or tools still behave the same way.

## Topic web

The approved topics are
[`define-work`](../topics/define-work.md),
[`direct-agents`](../topics/direct-agents.md),
[`use-jido`](../topics/use-jido.md),
[`verify-work`](../topics/verify-work.md),
[`improve-work`](../topics/improve-work.md), and
[`agentic-engineering`](../topics/agentic-engineering.md). Each topic file
declares related topics. Follow those relations when they help the learner;
do not treat them as a linear course or prerequisites.

## Lessons

| ID | Use when | Human practice | Concepts | Completion evidence |
| --- | --- | --- | --- | --- |
| `first-win` | The outcome or definition of done is unclear. | State one useful result and define done. | `outcome`, `done` | A request with an observable completion check. |
| `bound-the-work` | Nearby work, constraints, or exclusions can change the assignment. | Choose what is included and excluded. | `scope`, `constraints` | Clear boundaries and one resolved ambiguity. |
| `delegate-clearly` | A worker could guess about output, authority, or ownership. | Assign an output with context and authority. | `authority`, `ownership` | An assignment the learner can explain. |
| `check-the-return` | A returned result needs an acceptance or repair decision. | Compare the result with sources and agreed conditions. | `evidence`, `uncertainty` | A supported acceptance decision or specific repair request. |
| `improve-the-next-run` | The learner wants to apply a result or failure to later work. | Change one part of the next assignment. | `reflection`, `feedback` | One justified change without a mastery claim. |
| `choose-the-entry` | The learner does not know when to use `$jido`, `$tutor`, or a direct request. | Select the entry for one real request and write it. | `authority`, `ownership` | A written request with a stated reason and allowed actions. |
| `bound-a-code-change` | The real task is a software change for an agent. | Write the check, file boundary, and delivery limit. | `done`, `scope`, `evidence` | An assignment with one observable check and clear limits. |

Lesson files:

- [first-win](lessons/first-win.md)
- [bound-the-work](lessons/bound-the-work.md)
- [delegate-clearly](lessons/delegate-clearly.md)
- [check-the-return](lessons/check-the-return.md)
- [improve-the-next-run](lessons/improve-the-next-run.md)
- [choose-the-entry](lessons/choose-the-entry.md)
- [bound-a-code-change](lessons/bound-a-code-change.md)

Each lesson file has a worked example and a common mistake. Use them after the
learner's attempt, or earlier when the learner asks for an example.

## Concepts

| ID | Question |
| --- | --- |
| [`outcome`](concepts/outcome.md) | What useful result should exist? |
| [`done`](concepts/done.md) | What evidence will show completion? |
| [`scope`](concepts/scope.md) | What work belongs in this assignment? |
| [`constraints`](concepts/constraints.md) | Which limits shape an acceptable result? |
| [`authority`](concepts/authority.md) | Which actions and decisions can the worker take? |
| [`ownership`](concepts/ownership.md) | Who does, repairs, checks, and integrates the work? |
| [`evidence`](concepts/evidence.md) | What supports the acceptance decision? |
| [`uncertainty`](concepts/uncertainty.md) | What remains unknown or unsupported? |
| [`reflection`](concepts/reflection.md) | What should change after this result? |
| [`feedback`](concepts/feedback.md) | Which observed behavior should continue or change? |

## Router

1. Honor a named node or mode.
2. Otherwise inspect the real task or sample for the earliest material gap:
   outcome, boundary, assignment, return check, or next-run improvement.
   Use `choose-the-entry` for a question about when to use Jido or Tutor. Use
   `bound-a-code-change` when the real task is a software change.
3. Offer one node and state why it helps the current result.
4. If no real sample exists, use a small neutral task and the same router.
5. If the learner already demonstrates the action, reduce support or select a
   later relevant node. Do not require earlier lessons.
6. Treat a missing tool, file, permission, or current fact as a practical
   blocker, not a learning gap.

Successful completion of one node does not establish mastery. Use a nearby
variation only when the learner wants more practice.
