# Documentation

Use the [Docs Kata rules](AGENTS.md) to collect, review, and maintain documents.
The [inbox and intake log](inbox/README.md) record source material and its
disposition.

Last reviewed: 2026-11-04

## Current state

- Direct frontmatter inspection found 39 active skill packages. All 39 declare
  `kata.skill/v1` metadata. This is a point-in-time result from 2026-11-04.
- [`jido`](../skills/jido/SKILL.md) owns work routing.
  [`kata-orient`](../skills/kata-orient/SKILL.md) owns scoped project
  orientation through `AGENTS.md` and entry-point `README.md` files.
  [`kata-docs`](../skills/kata-docs/SKILL.md) owns Docs Kata setup, inbox
  processing, durable capture, and maintenance.
- Dojo has current suite adapters for
  [the `kata-docs` setup route](../dojo/suites/setup.exs) and
  [`kata-neckbeard`](../dojo/suites/neckbeard.exs). The other live-suite work
  remains pending. Dojo is opt-in and runs only after an explicit request.

## Documents kept at fixed paths

- [Project README](../README.md): project entry point, skill list, and attribution.
- [Project instructions](../AGENTS.md): rules for the whole repository.
- [Dojo guide](../dojo/README.md): preserved opt-in evaluation tooling and historical evidence.
- [Dojo runner handoff](../dojo/RUNNER.md): preserved interface for explicitly requested Dojo work.

The intake log records retained files and exclusions. Retention does not mean
that a document has been verified.

## Active work

- [Jido skills migration backlog](plans/jido-skills-migration-backlog.md):
  remaining verification and the archive gate for `agentjido/jido-skills`.
- [Skill import queue](plans/skill-import-queue.md): de-duplicated TODO list for
  possible imports from Compound Engineering, pstack, and Matt Pocock.

## Needs review

- [Skill library architecture](plans/skill-library-architecture.md): useful
  working model with a skill-budget target and support-route details that do not
  match the current library.

## Archived source material

- [Astra search notes](archive/evals/2026-09-05-astra-tuning-notes.md) and the
  [evaluator review](archive/evals/2026-09-05-evaluator-review.md): unverified
  research and historical measurements. Their claims were not rechecked in the
  2026-11-04 review and are not current project authority.

## Completed and superseded plans

- [Complete skill template conversion](plans/2026-11-04-0604-refactor-complete-skill-template-conversion-plan.md):
  completed in commit `86d79df`; the direct metadata check still passes.
- [Astra xhigh optimization plan](plans/2026-09-05-astra-optimization-plan.md):
  superseded by the current Dojo process and retained as historical intent.

## Evaluation reference

- [Setup evaluation results](reference/setup-evaluation-results.md): historical
  outcomes and the handoff to the common runner.
- [Legacy setup evaluation commands](reference/setup-evaluation-legacy-commands.md):
  offline commands for preserved `kata-setup` evidence after the source skill
  became `kata-docs`.
