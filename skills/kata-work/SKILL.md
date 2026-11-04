---
name: kata-work
description: Implement and locally verify one clear work request. Use when the requested change and acceptance conditions are known; use an investigation or planning workflow when the problem or intended result is still unclear, and use a commit workflow after verification.
argument-hint: "[work request or plan path]"
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: implement
  object: project-change
  profile: bounded-execution
  authority: local-write
  consumes: [work-request, implementation-plan]
  produces: [verified-change]
---

# Work

**Outcome:** The requested change exists in the local worktree with current
verification evidence for the next consumer.

**Done:** The accepted scope is complete, the relevant checks pass or have an
explicit limit, the diff contains no unrelated work, and the result is ready
for review or commit.

## Assignment

The required input is a clear work request or an executable plan. Resolve its
scope, acceptance conditions, target repository, and repository instructions
before a write. Ask only when a missing decision can materially change the
result.

Direct user authority or inherited caller authority permits the smallest local
change that completes the request. Preserve existing user changes. Do not
stage, commit, amend, push, open a pull request, change remote state, or include
unrelated improvements. Do not add a dependency or perform a destructive
operation unless the request or plan requires it and repository rules permit it.

This skill owns implementation and local verification. The caller owns scope
decisions. A commit or review workflow owns the next boundary.

## Execute the work

1. Inspect the current state, the relevant code or content, and nearby tests or
   checks. For a plan, read the sections needed for the current work; do not
   rewrite the plan as progress tracking.
2. State the bounded change and its acceptance conditions. If the request still
   needs investigation or design, stop with the missing decision instead of
   inventing the target.
3. Implement the smallest coherent change. Follow local patterns and preserve
   behavior outside the accepted scope.
4. Verify in proportion to risk. Run focused checks first. Add broader compile,
   format, lint, test, or real-boundary checks only when the change can affect
   them. Record an unavailable or intentionally skipped check and its reason.
5. Inspect the final diff and worktree. Confirm that required files are present,
   no unrelated change was absorbed, and no credential or sensitive value was
   added.

Stop and report a blocker when the work conflicts with repository rules, needs
new authority, has a failed check that cannot be fixed within scope, or depends
on an unresolved product or safety decision. Keep completed local work intact.

## Report

Report the outcome, changed paths, verification commands and results, skipped or
failed checks, remaining risks, blockers, and unrelated worktree changes. State
that the change is ready for its next consumer. Do not claim a commit or remote
result.
