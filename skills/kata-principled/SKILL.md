---
name: kata-principled
description: Apply one focused engineering principle by command. Use as `$kata-principled <command>` when design, debugging, testing, concurrency, migration, measurement, or delivery needs a clear decision rule.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: decide
  object: engineering-principle
  profile: bounded-execution
  authority: read-only
  consumes: [work-request, principle-command]
  produces: [principled-decision]
---

# Principled engineering

**Outcome:** The current executor receives one evidence-based decision rule for
the task in progress.

**Done:** The reply names one command, the task fact that selected it, the
decision that it changes, and the evidence that supports the result.

## Assignment

The required input is one current task. A command is optional. Use the named
command when the operator supplies it. Otherwise, select the narrowest command
that matches the task facts. The work profile is `bounded-execution`.

Direct user authority or inherited caller authority permits read-only use of
the current task evidence. This skill does not grant authority to edit files,
delegate work, change remote state, or perform a destructive action. Use only
the caller's existing scope and authority. Ask the operator when two commands
would change the same decision in materially different ways.

Apply one principle to the current task. The word after the skill name is the command. For example:

```text
$kata-principled attack-the-premise
$kata-principled fix-root-causes
$kata-principled prove-it-works
```

If the user names a command, read only its matching file in `references/` and apply it. If the user does not name a command, select the narrowest matching command from the table, state the selection, and read only that file. Do not combine commands unless the user asks or the task has two independent decision points.

The principle guides work inside the user's scope. It does not authorize edits, delegation, remote changes, or destructive actions that the user did not request.

## Commands

| Command | Use it when |
| --- | --- |
| `attack-the-premise` | Two fixes based on the same assumption failed. |
| `boundary-discipline` | Validation or external adapters are spreading into business logic. |
| `build-the-lever` | A repeatable tool can do or prove the work. |
| `encode-lessons-in-structure` | The same correction or instruction appears again. |
| `exhaust-the-design-space` | A new interface or architecture has no clear precedent. |
| `experience-first` | Product scope and implementation convenience conflict. |
| `explain-the-number` | A measured number will guide a decision. |
| `fix-root-causes` | Symptoms may hide an earlier failure. |
| `foundational-thinking` | Core types, data structures, or shared state need a decision. |
| `guard-the-context-window` | Large outputs or repeated reads hide the important state. |
| `laziness-protocol` | A change adds abstractions, layers, or excess diff. |
| `make-operations-idempotent` | Retries, restarts, or partial runs can repeat an operation. |
| `migrate-callers-then-delete-legacy-apis` | A new internal API replaces an old one. |
| `minimize-reader-load` | Code has too many layers or too much hidden state. |
| `model-the-domain` | Stateful code has many branches or repeated shape assumptions. |
| `never-block-on-the-human` | Reversible work can continue without a user decision. |
| `outcome-oriented-execution` | A planned rewrite has explicit phase boundaries. |
| `prove-it-works` | Work appears complete and needs real verification. |
| `redesign-from-first-principles` | A new requirement does not fit the existing design. |
| `separate-before-serializing-shared-state` | Concurrent workers can write the same state. |
| `sequence-verifiable-units` | Multi-step work needs safe, reviewable units. |
| `subtract-before-you-add` | A change can remove dead or redundant parts first. |
| `test-behavior-not-implementation` | A test risks coupling to internal structure. |
| `type-system-discipline` | Types can prevent invalid states or boundary mistakes. |

## Reply

Name the command, the task fact that triggered it, the decision it changes, and the evidence that shows the result. Keep the reply proportional to the task.

## Verify

Confirm that the selected command has one matching file in `references/`, that
the decision stays inside the current task, and that the reply does not claim
authority or evidence that the caller did not supply.
