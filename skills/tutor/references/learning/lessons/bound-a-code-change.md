# Bound a code change

**Practice:** Write one assignment for a software change with an observable
check, a file boundary, and a delivery limit.

Concepts: [done](../concepts/done.md), [scope](../concepts/scope.md), and
[evidence](../concepts/evidence.md).

1. Ask for one real change and the behavior that must be different afterward.
2. Ask for the check that shows the behavior: a test, a command, or an
   observed output. Prefer a check that fails before the change.
3. Ask which files or modules the agent can change and which it must not.
4. Ask which delivery actions are allowed: local change only, commit, push, or
   pull request.
5. Ask which evidence the agent must return with the change.
6. Give feedback on the weakest of the check, the boundary, or the limit.

Worked example:

```text
Change: The export command writes dates as YYYY-MM-DD.
Check: `test/export_test` has a new case that fails now and passes after.
Boundary: Change `lib/export/` and its tests only. Do not change the import
code or add a dependency.
Delivery: Local change only. I review the diff before a commit.
Return: The diff, the full test output, and each assumption made.
```

Common mistake:

```text
Fix the date bug and clean up the export module while you are there.
```

The request has no check, so "fixed" has no evidence. "Clean up" adds
unbounded changes that hide the repair in the diff and make the review slow.

Complete when the learner writes an assignment with one observable check, a
file boundary, and a delivery limit. This lesson prepares the assignment. It
does not make the change, and it does not teach a programming language.
