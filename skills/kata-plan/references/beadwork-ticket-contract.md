# Beadwork ticket contract

Write tickets for an implementation agent that does not have the planning conversation. The ticket must contain all information that the agent needs for its one outcome.

## Required body

```markdown
## Objective

<Start with an imperative verb. State one completed outcome.>

## Context

Plan: `<docs/plans/...>`
Unit: `U<n>`
Covers: `R<n>`, `KTD<n>`

<Explain why the task exists. Include only context that changes implementation.>

## Dependencies

- Blocked by: `<ticket ID and required output>`, or `None`.
- Unblocks: `<ticket ID and supplied output>`, or `None`.

## Branch and integration rule

- Base: `<exact prerequisite ticket, branch, or commit>`.
- Combine: `<how outputs from several blockers enter this branch>`, or `Not applicable`.

Do not base an independent sibling on another sibling only for convenience.

## Source inventory

- `<exact count and source path>` — `<ported | superseded | deferred | excluded>`.

List support files, corpus inputs, runners, and unused files separately when their dispositions differ.

## API and behavior map

- `<old module, function, contract ID, or behavior>` -> `<current public owner or expected behavior>`. Evidence: `<repository path or recorded probe>`.

## Files

- Read: `<repository-relative path>`
- Change: `<repository-relative path>`
- Add: `<repository-relative path>`, if required
- Do not change: `<path, API, namespace, or behavior boundary>`
- Expected shared changes: `<path outside the main target, or None>`

## Instructions

1. <Use a direct verb and name the exact target.>
2. <State the required data flow, API behavior, or boundary.>
3. <Add or update named tests and fixtures.>
4. <Update named documentation or generated output only when required.>

## Acceptance criteria

- [ ] <Observable behavior or artifact exists.>
- [ ] <Named boundary or compatibility condition holds.>
- [ ] <Named failure or edge case has coverage.>
- [ ] <No forbidden-scope file or behavior changed.>

## Verification

- `<exact command>` — <expected exit state or output>.
- `<exact command>` — <expected exit state or output>.

## Handoff

In the Beadwork completion comment, list changed files, source disposition records, verification results, deviations from the plan, deferred assets, linked follow-up tickets, and remaining blockers.

A deferred asset must include its owner, exact failing command, expected result, actual result, and follow-up ticket ID. Keep the import ticket open when no follow-up owner or ticket exists.
```

## Directive language

Use commands such as:

- `Add ...`
- `Move ...`
- `Replace ...`
- `Keep ...`
- `Remove ... only after ...`
- `Run ... and confirm ...`

Do not use vague instructions such as:

- `Consider ...`
- `Explore ...`
- `Improve ...`
- `Clean up ...`
- `Handle edge cases ...`
- `Add tests as needed ...`

Replace vague text with a named action, target, condition, and result.

## Size rules

A normal task has one primary outcome and one coherent verification surface. Split the task when any condition is true:

- two parts can be completed and verified independently;
- a decision must be made before implementation can start;
- the task crosses unrelated namespaces or runtime owners;
- one part can fail without invalidating the other part;
- the task description needs several unrelated groups of acceptance criteria.

Do not split work only to make very small line-count targets. Keep a schema change and its required migration together. Keep an API change and its direct contract tests together when neither is useful alone.

For a ticket intended for a lower-capability model, prefer all of these conditions:

- one source asset family;
- one current module or runtime owner family;
- one focused verification command family;
- no unresolved product or architecture choice;
- no hidden merge or branch-base decision;
- no shared report or harness change combined with an unrelated new suite.

Split the ticket when it has two or more complexity multipliers:

- several independent API-owner mappings;
- a shared harness change plus a new suite;
- a manual runner plus smoke-test import;
- cross-suite report integration;
- runtime lifecycle coordination;
- several source roots or independent command families.

A large mechanical file copy can remain one ticket only when every file uses the same adaptation rule and the same verification gate. State the exact file count.

## Acceptance criteria rules

Every criterion must be binary and observable. Name the expected behavior, artifact, boundary, or command result.

Good:

- `[ ] .reach.exs rejects a dependency from Jido.Signal into Jido.Agent.`
- `[ ] mix test test/jido/signal/router_test.exs exits with status 0.`
- `[ ] No file under lib/jido/agent/ changes in this task.`

Bad:

- `[ ] Architecture is clean.`
- `[ ] Tests look good.`
- `[ ] The code is production ready.`

## Research tickets

Use a research ticket only when current evidence cannot support a safe decision. Its objective must name the decision, its artifact must be exact, and its acceptance criteria must define how the decision is closed.

Example objective: `Select the ownership boundary for Jido.Signal dispatch.`

Required output:

- a short decision record at a named path or a plan update;
- the options inspected;
- evidence for the selected option;
- the tickets that can start after the decision.

Do not mix the research and the dependent implementation in one ticket.

## Final ticket check

Reject or rewrite a ticket when any answer is “no”:

- Can an agent execute it without the planning conversation?
- Does it state one outcome?
- Does it name exact files or path patterns?
- Does it give exact source asset counts and dispositions?
- Does it map old API owners and behavior to current owners?
- Does it remove implementation choices that research can settle now?
- Are acceptance criteria binary and observable?
- Are verification commands exact?
- Are dependencies real blockers?
- Is the branch base or multi-parent integration rule explicit?
- Is forbidden scope clear?
