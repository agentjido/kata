---
name: kata-routine
description: "Create, inspect, validate, or run repository-local routines from docs/routines. Use when the request names a routine operation or asks Jido to find work from local routine files; do not use for reusable Jido methods or task-system configuration."
metadata:
  kata-argument-hint: "[list|show|make|update|validate|run] [routine or all]"
  schema: kata.skill/v1
  subject: general
  practice: operate
  object: local-routine
  profile: coordination
  authority: local-write
  consumes: "routine-request, local-routine, project-context"
  produces: "routine-definition, routine-status, routine-run-result, work-request, verified-change"
---

# Routine

**Outcome:** The requested local routine operation is complete, and each run
returns supported findings or bounded work requests for Jido to route.

**Done:** The selected operation has its required result. A created or updated
routine conforms to the local contract. A run validates its selected routines,
executes each one at most once within current authority, and returns evidence,
findings, decisions, and limits.

## Assignment and authority

The required input is a routine request and a project context. Local routines
are Markdown files under `docs/routines/` in that project. Read active project
instructions before the routine files. A routine can narrow an assignment, but
it cannot override an instruction or grant authority.

Direct user authority or inherited caller authority permits read-only routine
inspection. A make or update request permits the smallest local write under
`docs/routines/`. A run permits only the actions granted by its active
assignment. A routine's `authority` value is a ceiling, not permission. An
external write, message, purchase, live-system change, destructive action,
commit, push, merge, publication, tag, or release still requires authority for
that exact action.

Do not create a task store, local CSV file, schedule, hook, or background job
unless the assignment requests it. A task system, scheduler, and notification
service are extension points. Their configuration selects a resource; it does
not grant access or authority.

## Select one operation

| Request | Operation | Result |
| --- | --- | --- |
| `routine` or `list routines` | List | Available, active, paused, invalid, and blocked routines. Do not run them. |
| `show <name> routine` | Show | One routine definition and its resolved references. |
| `make a routine ...` | Make | One conforming local routine file and index entry. |
| `update <name> routine ...` | Update | One bounded routine revision. |
| `validate routines` | Validate | Format, reference, selection, and cycle findings without execution. |
| `run <name> routine` | Run named | One selected routine and its included routines. |
| `run all routines` | Run all | Every active routine, with each routine executed once. |

Do not treat a bare `routine` request as execution. Resolve a routine by its
exact `id` or file name. If a partial name has more than one match, return the
matches and do not run one by guess.

For make, update, validate, or run, read
[references/format.md](references/format.md). List and show can inspect the
directory without loading the full format when no validation judgment is
requested.

## Make or update a routine

Create the smallest routine that represents the requested local work. Keep
project-specific facts and commands in the routine. Keep reusable routing,
authority, failure, and verification rules in Jido.

Use a lowercase hyphenated `id` and the matching `<id>.md` file name. Add the
routine to `docs/routines/README.md` when that index exists. Preserve unrelated
routines and project documentation. Validate the new file before returning it.

An update changes only the named routine unless its reference graph requires a
matching repair. A change to the reusable routine contract belongs to Jido's
`improve` Kata, not to a local routine update.

## Validate and run routines

Before execution:

1. Resolve the project root and `docs/routines/` without scanning outside the
   active project.
2. Select the exact named routine or all files with `status: active`. Exclude
   `README.md` and paused routines from `run all`.
3. Validate every selected file and recursively resolve its ordered `Includes`
   list.
4. Reject a missing reference, duplicate `id`, file-name mismatch, invalid
   authority value, or reference cycle before any selected routine runs.
5. Build one ordered run set. Run an included or independently selected routine
   only once.

For each routine, turn its outcome, scope, inputs, steps, finding rule, done
condition, and handoff into a bounded work request. Return that request to Jido,
which selects the first unresolved internal Kata. A routine does not select its
own Kata and does not perform work outside Jido's active route.

When a routine delegates work, supply its run, parent, routine, and sequence as
correlation data. Preserve this data through the worker return. The delegation
return contract remains the canonical owner of the other worker-return fields.

Collect one terminal result for each routine:

- `clear`: the desired condition has current supporting evidence;
- `finding`: a specific difference has evidence, consequence, owner or owner
  gap, bounded remedy, and acceptance condition;
- `decision-required`: a value, scope, owner, or authority decision is needed;
- `blocked`: required evidence, capability, dependency, or authority is not
  available.

If a routine names a configured work-item role, use that extension only when
the active assignment authorizes the write. Otherwise, return the result
inline. Do not silently substitute a CSV file or another provider.

If one routine fails, keep completed read-only results. Do not start later
mutable routines when the failure can make their work unsafe or invalid.
Repair an invalid local definition only when the assignment includes that
write; otherwise, return the exact format finding. Do not retry an unchanged
failure or lower the routine's done condition.

## Report

Report the operation, selected routine ids, resolved execution order, result
and evidence for each routine, changed files, work-item extension effects,
skipped or paused routines, and any decision or authority gap. A run result is
not accepted work until the receiving Jido Kata meets its own completion and
verification contract.
