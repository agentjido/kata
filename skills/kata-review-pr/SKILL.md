---
name: kata-review-pr
description: Review a pull request for correctness, regression risk, tests, security, CI, and merge readiness without changing it. Use for a PR review or readiness decision; use an implementation workflow when the request is to fix the change.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: review
  object: pull-request
  profile: bounded-execution
  authority: read-only
  consumes: [pull-request]
  produces: [pull-request-review]
---

# Review Pull Request

**Outcome:** An evidence-based review with ordered findings and a clear
readiness result. The review does not change code, labels, branches, or the PR.

**Done:** The complete diff and affected behavior have been inspected, each
finding has evidence, readiness and available CI state are reported, and every
unknown or untested area is explicit.

## Assignment

The required input is one pull request or a branch with one resolvable pull
request. Ask when the target or comparison base is ambiguous.

Direct user authority or inherited caller authority permits read-only local and
remote inspection and focused tests that repository rules allow. It does not
permit code edits, review submission, labels, merges, pushes, or other remote
changes. Report an unavailable check as unknown instead of expanding authority.

## Establish the review target

Read active project instructions. Resolve the PR URL, number, or current-branch
PR. Record the base and head revisions. Use the available code-host tool or
CLI to read metadata, checks, reviews, comments, merge state, and changed files.
If remote data is not available, mark each affected result as unknown.

Inspect the complete diff against the correct base. For a large change, review
it file by file and trace changed public behavior into callers and tests. Use a
detached or isolated checkout only when local inspection or tests need it.
Preserve the user's current checkout and files.

## Review by risk

Review in this order:

1. correctness and data-loss defects;
2. security, authorization, secrets, and unsafe input;
3. public contracts, migrations, concurrency, and error behavior;
4. missing or weak regression tests;
5. documentation and operational effects;
6. required CI, review state, and merge conflicts.

Check the repository's language and framework rules. Do not apply a generic
style preference when the project has a clear local pattern. Do not report a
possible issue as a defect without evidence from the diff or affected code.

Run focused tests only when review authority and the local checkout make that
safe. Record the exact command and result. Inspection of a test is not a test
run.

## Report

Lead with findings in severity order. Give each finding a short title, impact,
evidence, and the smallest safe correction. Use an exact file and line when
possible. Keep non-blocking notes separate.

End with:

```text
Verdict: ready | needs work | unknown
CI: passing | failing | pending | unavailable
Merge state: clean | conflicted | unknown
Tests run: <commands or none>
Residual risk: <short statement>
```

If there are no findings, say so and still state untested or unavailable
areas. Do not edit code, post comments, submit a review, change labels, merge,
or push unless the user gives that separate authority.
