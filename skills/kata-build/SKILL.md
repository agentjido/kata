---
name: kata-build
description: Implement a scoped change in small steps and use evidence to guide corrections. Use when the user requests implementation or asks to execute an existing plan.
---

# Build

Make the requested change while preserving the project's working conventions.

## Method

1. Read the request, applicable instructions, current work state, and any existing plan. Confirm the target from this context.
2. Inspect the code and checks for the first step. Preserve unrelated user changes.
3. Make a small, complete change. Reuse project patterns and dependencies where they fit.
4. Run the relevant checks when the user has authorized them. For a defect, use a reproduction or regression test when it provides useful evidence.
5. If a check fails, inspect the failure and form a specific explanation. Change one relevant cause or gather more evidence before another attempt.
6. Continue through the authorized work. Update the plan when evidence changes the approach. Ask only when a material decision is outside the existing scope.
7. Inspect the final diff. Remove accidental edits and report the result with the checks performed.

## Result

Deliver the change with a short report of behavior, validation, and remaining limits.

## Constraints

- Do not weaken acceptance conditions or checks to hide a failure.
- Do not repeat an unsuccessful action without a changed input or a reason to expect a different result.
- Treat commit, push, merge, and deployment as actions governed by the user's request and project rules.
- Do not claim completion while required work remains.
