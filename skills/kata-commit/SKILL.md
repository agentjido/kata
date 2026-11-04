---
name: kata-commit
description: Create one local Git commit from an already verified, explicitly scoped change. Use when the operator asks to commit completed work; do not use to decide or implement the change, fix failed checks, amend history, or push.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: commit
  object: git-change
  profile: bounded-execution
  authority: local-write
  consumes: [verified-change]
  produces: [git-commit]
---

# Commit

**Outcome:** One local Git commit that contains only the accepted change for the
operator and the next delivery step.

**Done:** The staged diff matches the granted scope, required verification is
current for that source state, the commit exists with its hash and message, and
all unrelated changes remain uncommitted. A blocker is the result when these
conditions cannot be met safely.

## Assignment

The required inputs are one repository, an explicit commit request, the change
scope, and its verification evidence. Resolve scope from the request and the
completed work record. Ask when staged or unstaged changes make the intended
commit ambiguous.

Direct user authority or inherited caller authority permits Git inspection,
staging the accepted paths, and one new local commit. Do not change file
contents, fix failed work, amend, rebase, reset, checkout, merge, tag, push, or
change remote state. Do not bypass hooks unless the operator gives explicit
authority for that exact bypass. The work profile is `bounded-execution`.

The implementation owner fixes work. This skill owns only the commit boundary.
If the change is incomplete or verification fails, return it to that owner with
the blocker and do not commit.

## Build the commit

1. Read the repository instructions. Resolve the Git root and record the current
   branch, `HEAD`, status, staged diff, unstaged diff, and relevant untracked
   files. Do not include ignored files.
2. Confirm that verification applies to the current source state. Reuse current
   evidence when it names the same state. Run only a required missing check that
   does not change the requested scope. Stop on a failed or unavailable required
   check unless the operator explicitly accepts that known limit.
3. Inspect the candidate diff for unrelated content, generated noise,
   credentials, private keys, tokens, and other sensitive values. Report a
   suspected secret without reproducing it. Stop before staging it.
4. Stage explicit paths for this change. Do not use a broad add command unless
   the operator explicitly selected the complete worktree and every change was
   reviewed. Do not remove or rewrite an existing staged change. Stop when the
   index cannot be separated safely.
5. Inspect the complete staged name list, diff, and diff stat. Run
   `git diff --cached --check`. Confirm that the staged diff is non-empty and
   contains all required parts of the change and no unrelated parts.
6. Write a concise imperative message that describes the completed outcome.
   Create one commit with the repository's normal hooks. If a hook fails or
   changes files, stop and re-inspect the state. Do not retry automatically.
7. Verify the new commit hash, subject, changed paths, and worktree status.
   Preserve and report every remaining uncommitted change.

## Report

Report the commit hash and subject, committed paths, verification evidence,
hook result, and remaining worktree state. State clearly that no push occurred.
