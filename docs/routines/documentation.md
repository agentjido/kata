---
id: documentation
status: active
authority: read-only
---

# Documentation

## Outcome

Current project documents point to the current Jido package, active work, and
local routines without treating plans or intake material as completed work.

## Trigger

Run after a public contract, package layout, active plan, or documentation
structure changes.

## Scope

Include current Markdown files under the repository root and `docs/`. Exclude
archived claims except for their status and links. Do not edit documentation in
this routine.

## Inputs

- `README.md`
- `skills/README.md`
- `docs/README.md`
- `docs/AGENTS.md`
- `docs/inbox/README.md`
- `docs/routines/`
- Current source, configuration, and accepted decisions needed to test a claim

## Steps

1. Confirm that `docs/README.md` links to each current documentation category
   that contains active material.
2. Confirm that `docs/inbox/` contains only `README.md`, or report every
   unprocessed item with its owner and next action.
3. Compare current-state and completed-plan claims with direct repository
   evidence. Treat a plan as intent, not proof.
4. Confirm that root and package guides describe one public `$jido` command and
   keep internal methods private to the package.
5. Confirm that `docs/routines/README.md` indexes every routine file and does
   not treat results or extension providers as routine definitions.

## Findings

Create a finding for a broken or missing current link, unprocessed intake item,
unsupported completion claim, stale public contract, or missing routine index
entry. Cite the document and the conflicting evidence.

## Done

Every scoped check has current evidence or one bounded finding. No document was
changed during the run.

## Handoff

Send a ready documentation correction to the delivery loop. Return a product
or ownership decision to the user. Do not create a task-system record unless a
configured extension and the active request authorize it.
