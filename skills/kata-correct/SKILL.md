---
name: kata-correct
description: "Make one repeated repository mistake impossible through architecture or an executable guard. Use when evidence shows the same mistake at least twice; use a normal fix workflow for a one-time defect."
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: enforce
  object: repository-constraint
  profile: system-design
  authority: local-write
  consumes: [repeated-correction, repository-history]
  produces: [verified-repository-guard, verified-change]
---

# Correct

**Outcome:** One repeated mistake class has a structural owner or executable
guard that prevents the next occurrence.

**Done:** The class has evidence from at least two occurrences, the selected
guard fails on a real past mistake and passes on the corrected state, and the
local change is ready for a separate commit decision.

## Assignment

The required inputs are one target repository and evidence of repeated mistakes.
Direct user authority or inherited caller authority permits the smallest local
architecture, type, lint, test, or instruction change that blocks one class.
Preserve unrelated work. Do not stage, commit, push, change CI state, or fix a
second class without separate authority.

The operator keeps correcting agents in this repo for the same mistakes. Change the repo so the next agent can't make them.

Assume every contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Design the repo so a change that looks right from one file is right for the whole repo.

## Find one mistake class

Read recent commits, reverts, review comments, agent instruction files, and
comments that explain workarounds. Select one class only after evidence shows
that it happened at least twice.

## Fix the class at the highest level that works

1. **Eliminate it with architecture.** Give each piece of state one owner and each task one supported way. Hide internals so the wrong import fails. Replace hand-synced lists with one source of truth. Delete old ways and dead code an agent would copy.
2. **Enforce it with types so the bad state can't be written.** If bad code still compiles, add a lint or CI check whose error names the file, type, or function to use instead. If the pattern is already common, fail only when a change adds more.
3. **Test the behavior.** Fix or delete any test that still passes when the behavior it checks breaks, or that fails when only the internals change.
4. **Write docs or agent rules last, only for judgment calls.** Nothing fails when an agent skips them.

## Fix and prove

Select the highest-frequency class with the strongest evidence and fix that one
class. Prove the new check fails on a real past mistake. Run the same command
that CI uses when it is available locally. Leave the verified change uncommitted
for the commit workflow. Exceptions go on the offending line with a reason, an
expiry date, and the accountable owner's approval.

## Keep an existing rule table current

When the repository already has a rule table, update the one row for this class.
Pair the rule with its enforcement. Drop the row when the mistake cannot happen.
Do not create a documentation table when architecture, types, lint, or tests
already make the rule clear.

**Reply:** report the class, its evidence, the level you selected, and why a
higher level did not work.
