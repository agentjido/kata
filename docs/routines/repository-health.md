---
id: repository-health
status: active
authority: read-only
---

# Repository health

## Outcome

The Jido package, current documentation, and local release gates have one
integrated maintenance result.

## Trigger

Run for a general Jido repository maintenance review or before a delivery
decision that needs all local evidence.

## Scope

Include only the routines listed below. Their narrower scopes and exclusions
remain in force.

## Inputs

- The included routine definitions
- The evidence sources declared by each included routine

## Includes

- `jido-package`
- `documentation`
- `release-gates`

## Findings

Keep each included routine result separate. Do not merge unrelated failures
into one finding. A blocked included routine blocks only conclusions that need
its missing evidence.

## Done

Each included routine has one terminal result, and the integrated report states
which repository conditions are clear, have findings, need decisions, or are
blocked.

## Handoff

Route each supported finding through its named handoff. Do not infer authority
to repair, commit, push, merge, tag, or release from this composite routine.
