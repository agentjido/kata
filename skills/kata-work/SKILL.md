---
name: kata-work
description: Produce one candidate result from a clear work request or plan. Use when the target, scope, acceptance conditions, and authority are known; skip understanding and planning when those contracts are already resolved, and use a separate verification step for final judgment.
argument-hint: "[work request or plan path]"
metadata:
  schema: kata.skill/v1
  subject: general
  practice: execute
  object: work-result
  profile: bounded-execution
  authority: local-write
  consumes: [work-request, work-brief, work-plan, implementation-plan]
  produces: [candidate-result, work-evidence]
---

# Work

**Outcome:** The requested result exists in the target context with direct work
evidence for an independent verifier.

**Done:** The accepted scope is complete, obvious local checks pass or have an
explicit limit, unrelated state remains unchanged, and the candidate is ready
for verification.

## Assignment

The required input is a clear work request, work brief, or executable plan.
Before action, confirm the target result, scope, acceptance conditions, context,
authority, and next verifier. Start here when these contracts are already
resolved. Do not repeat an understanding or planning step for ceremony. Ask
only when a missing decision can materially change value, result, scope, cost,
or authority.

Direct user authority or inherited caller authority permits the smallest action
that completes the request inside its target context. Preserve existing user
state. Local writes are the normal authority. An external write, publication,
message, purchase, destructive action, or live-system change requires explicit
authority for that action. Do not stage, commit, amend, push, open a pull
request, or include unrelated improvements. Do not add a dependency unless the
request or plan requires it and the context rules permit it.

This skill uses delegated judgment to execute the resolved assignment and run
direct local checks. It does not certify its own result. The verification skill
owns the next evidence boundary, and the next consumer owns acceptance. A
domain-specific workflow can replace this skill when the result needs
specialist methods or authority.

Load a focused method only when its trigger applies:

- For an explicitly requested failing test, regression test, or a defect with
  an obvious cheap local test, read
  [references/tdd.md](references/tdd.md).
- For explicitly requested long-running or unattended decision logging, read
  [references/decision-log.md](references/decision-log.md).

These methods do not change the assignment authority or let this skill verify
its own result.

## Execute the work

1. Read the active context instructions and inspect only the state needed to
   execute the ready request. For a plan, read the relevant unit and its
   acceptance conditions; do not turn the plan into progress storage.
2. State the candidate result and the conditions that make it ready for
   verification. If the current condition is not supported, return to
   understanding. If the route still has a material decision, return to
   planning. Do not invent the missing contract.
3. Produce the smallest coherent result. This can be an artifact, analysis,
   recommendation, data change, software change, or authorized operation.
   Follow context rules and preserve state outside the accepted scope.
4. Run fast local checks that prevent an obviously incomplete handoff. Examples
   include opening an artifact, recalculating data, checking a diff, compiling
   changed code, or observing an operation response. These checks are work
   evidence, not the final verification verdict.
5. Inspect the final target state. Confirm that the candidate is identifiable,
   required parts exist, unrelated state was not absorbed, and no sensitive
   value was exposed.

Stop and report a blocker when the work conflicts with context rules, needs new
authority, has a failed local check that cannot be fixed within scope, or
depends on an unresolved value, product, or safety decision. Keep completed
in-scope work intact.

## Report

Report the candidate identity, changed state, direct checks and results,
skipped or failed checks, remaining risks, blockers, and preserved unrelated
state. State that the candidate is ready for independent verification. Do not
claim that it is verified, accepted, committed, published, or delivered unless
another owner supplied that evidence.
