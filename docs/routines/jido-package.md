---
id: jido-package
status: active
authority: read-only
---

# Jido package

## Outcome

The repository has Jido and Tutor as its two public skills, and every internal
Jido Kata and detailed method has one valid registered owner.

## Trigger

Run after a Jido routing or method change and before a commit that changes the
Jido package.

## Scope

Include `skills/jido/`, the public `skills/` surface, the Jido package
validator, and routing acceptance cases. Exclude Dojo execution and all remote
state.

## Inputs

- `skills/jido/SKILL.md`
- `skills/jido/references/commands.md`
- `skills/jido/references/katas/`
- `skills/jido/references/methods/`
- `skills/jido/references/routing-cases.md`
- `scripts/validate_jido_package.exs`

## Steps

1. Run `elixir scripts/validate_jido_package.exs` from the repository root.
2. Use `rg --files -g 'SKILL.md' skills` and confirm that it returns only
   `skills/jido/SKILL.md` and `skills/tutor/SKILL.md`.
3. Confirm that new routine behavior remains an internal method and does not
   become a public skill or ninth routing Kata.

## Findings

Create a finding when a command fails, an unexpected public skill is added, a
registry path is missing, a method has no Kata owner, or a routing case loses
an authority boundary. Include the exact file and command evidence.

## Done

The commands pass and the observed public surface, registry, method ownership,
and routine boundary agree.

## Handoff

Send a reusable Jido contract finding to `improve`. Send a validator or normal
repository repair to the delivery loop. Do not commit or publish without a new
authorized request.
