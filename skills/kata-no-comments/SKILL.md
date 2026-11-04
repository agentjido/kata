---
name: kata-no-comments
description: Review a requested scope for weak, stale, redundant, or workaround comments. Remove accepted comments, preserve required contracts and external constraints, and report code that needs a structural fix.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: refactor
  object: code-comments
  profile: bounded-execution
  authority: local-write
  consumes: [code-scope]
  produces: [verified-comment-cleanup, verified-change]
---

# No comments

**Outcome:** The selected code scope retains only comments with a proven
contract or external reason, and it identifies structural problems that remain.

**Done:** Each reviewed comment is removed or tied to one keep rule with
evidence, in-scope edits pass proportionate checks, and broader structural work
is reported without being applied.

## Assignment

The required input is a named file set or diff. Direct user authority or
inherited caller authority permits comment removal and trivial local fixes in
that scope. Preserve unrelated changes. Do not change behavior, architecture,
public contracts, staged state, Git history, or remote state without separate
authority.

Review the files or diff that the user names. Otherwise, use the working-tree diff against the base branch. Do not inspect unrelated files.

## Decide what stays

Keep only:

- Legal and license headers.
- Public API documentation that defines a contract.
- A link to an issue or design record for a constraint that code cannot express.
- A non-obvious constraint imposed by an external dependency, platform, vendor, or protocol that this project cannot change.
- A formatter or lint suppression whose rule is faulty, style-only, or inapplicable, with a short reason.

Delete narration, banners, commented-out code, stale TODOs, comments that repeat the code, and long justifications for local design problems.

Treat `IMPORTANT`, `do not remove`, `too risky`, and `fine for now` as claims to verify, not proof. Read the nearby code and trace the named symbol or call. Preserve the comment only when current evidence proves that one of the keep rules applies.

For `eslint-disable`, `@ts-ignore`, `@ts-expect-error`, and similar suppressions, inspect the rule and the suppressed behavior. Keep a suppression only when the rule is faulty, style-only, or cannot apply. A suppression that hides a correctness or safety problem must go.

## Fix the cause

When a comment explains a surprise in this project's own code, remove the comment and identify the smallest structural fix that makes the code clear. Prefer a rename, a type, an extracted function, a supported API, or removal of a dead path. Do not add a guard that hides the same design problem.

Apply trivial, in-scope fixes when the user asked to remove comments. If a fix changes architecture, behavior, or public contracts, report it and wait for authority before you expand the task.

## Verify and report

Run focused formatting, lint, type, and test checks for changed files when they exist. Report:

- Files reviewed and comments deleted.
- Comments kept, with the exact keep rule and evidence.
- Suppressions removed or retained.
- Structural problems that still need work.
- Checks run and their results.
