---
name: kata-review-pr
description: Review a pull request for correctness, regression risk, tests, security, CI, and merge readiness without changing it. Use for a PR review or readiness decision.
---

# Review Pull Request

**Outcome:** An evidence-based review with ordered findings and a clear
readiness result. The review does not change code, labels, branches, or the PR.

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
