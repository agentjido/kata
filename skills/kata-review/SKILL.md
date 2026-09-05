---
name: kata-review
description: Review a code change for defects, regressions, and unnecessary complexity. Use when the user requests a review of a diff, pull request, or completed implementation.
---

# Review

Find issues that affect the requested result or make the change harder to maintain.

## Method

1. Establish the review scope and comparison point. Read the request, applicable instructions, and the complete relevant diff.
2. Read surrounding code and affected callers. Trace important data, state changes, error paths, and resource lifetimes.
3. Check behavior against the intended result. Inspect tests for missing cases that could hide a defect.
4. Check whether the implementation adds unnecessary code, dependencies, or process steps. Keep suggestions proportional to the change.
5. Confirm each finding with a concrete path to failure or a clear maintenance cost. Use available checks when authorized.
6. Report findings in order of impact. Give a file location, the trigger, the consequence, and a useful correction.

## Result

Provide actionable findings and the limits of the review. If no issues are found, say so and state what was inspected. Separate optional improvements from defects.

## Constraints

- A review request alone does not authorize code edits.
- Do not invent findings to fill a quota.
- Prefer evidence over speculative concerns and personal style preferences.
- Do not claim that a change is safe in every case because the review found no defect.
