# Documentation

## Start here

1. [Install Jido](guides/installation.md) with `npx skills`.
2. [Install and give Jido a task](../README.md#install).
3. [Inspect the Jido package](../skills/README.md).

See [host compatibility](reference/host-compatibility.md) for advanced install
options. The sections below contain project and maintenance records.

Use the [Docs Kata rules](AGENTS.md) for documentation changes. The
[inbox and intake log](inbox/README.md) record source material.

Last reviewed: 2026-11-09 (Jido and Tutor sibling skills; dated records retained)

## Current state

- [`jido`](../skills/jido/SKILL.md) owns work routing, authority, continuation,
  and final integration.
- [`tutor`](../skills/tutor/SKILL.md) is the explicit WorkTutor entry point for
  explanation, practice, feedback, and learning resources.
- Seven normal internal Katas own understanding, shaping, leadership, work,
  verification, improvement, and Git delivery. Dojo is an eighth,
  explicit-only internal Kata.
- Detailed methods and license notices are internal Jido support files. They
  are not separate commands.
- [Local routines](routines/README.md) define repository maintenance work that
  Jido can inspect, validate, or run. Routine files do not grant authority.
- Dojo has a current suite adapter for
  [the `kata-docs` setup route](../dojo/suites/setup.exs) and preserves a
  historical Neckbeard adapter. The other live-suite work remains pending. Dojo
  is opt-in and runs only after an explicit request.

## Documents kept at fixed paths

- [Project README](../README.md): public project entry point and first-use guide.
- [Project instructions](../AGENTS.md): rules for the whole repository.
- [Dojo guide](../dojo/README.md): preserved opt-in evaluation tooling and historical evidence.
- [Dojo runner handoff](../dojo/RUNNER.md): preserved interface for explicitly requested Dojo work.

The intake log records retained files and exclusions. Retention does not mean
that a document has been verified.

## Active work

- [Public 1.0 release plan](plans/2026-11-04-1504-idea-public-1-0-release-plan.md):
  product and implementation contract for legal, package, release, directory,
  README, and launch preparation.

- [Jido skills migration backlog](plans/jido-skills-migration-backlog.md):
  remaining verification and the archive gate for `agentjido/jido-skills`.
- [Skill import queue](plans/skill-import-queue.md): de-duplicated TODO list for
  possible imports from Compound Engineering, pstack, Matt Pocock, Addy Osmani,
  and Superpowers.
- [Repository issue backend support](plans/issue-backend-support.md): queued
  shared `docs/agents/issues.md` contract and Beadwork, CSV, GitHub `gh`, and
  Jira `twg` adapters.

The [single-command consolidation plan](plans/2026-11-09-jido-single-command-consolidation-plan.md)
records the internal Jido consolidation. Its one-public-skill surface is
superseded by the current Jido and Tutor sibling packages. The older
[skill library architecture](plans/skill-library-architecture.md) is retained
as the source for the work-system contracts that the internal Katas preserve.

## Archived source material

- [Astra search notes](archive/evals/2026-09-05-astra-tuning-notes.md) and the
  [evaluator review](archive/evals/2026-09-05-evaluator-review.md): unverified
  research and historical measurements. Their claims were not rechecked in the
  2026-11-04 review and are not current project authority.

## Completed and superseded plans

- [Leadership and productivity design brief](plans/2026-11-05-leadership-productivity-design-brief.md):
  implemented the initial `kata-tutor`, `kata-scope`, and `kata-delegate`
  packages and their Jido routes. External resources remain deferred.
- [Existing skill improvement backlog](plans/2026-11-04-existing-skill-improvement-backlog.md):
  completed seven bounded refinements in the existing skill owners; it did not
  add `kata-prototype`, and it sends visual-design work to Impeccable.
- [Complete skill template conversion](plans/2026-11-04-0604-refactor-complete-skill-template-conversion-plan.md):
  completed in commit `86d79df`; the direct metadata check still passes.
- [Astra xhigh optimization plan](plans/2026-09-05-astra-optimization-plan.md):
  superseded by the current Dojo process and retained as historical intent.

## Evaluation reference

- [Installation guide](guides/installation.md): first use through `npx skills`.
- [Host compatibility](reference/host-compatibility.md): advanced host instructions
  and package details.
- [Release guide](guides/releasing.md): version, validation, tag, GitHub Release,
  directory, and recovery process.
- [Attribution](reference/attribution.md): current sources, adaptations, and
  package-specific notices.

- [Skill provenance and retention index](reference/skill-provenance-and-retention.md):
  current origin groups and proposed keep, fold, or retire actions for imported
  skills.
- [Setup evaluation results](reference/setup-evaluation-results.md): historical
  outcomes and the handoff to the common runner.
- [Legacy setup evaluation commands](reference/setup-evaluation-legacy-commands.md):
  offline commands for preserved `kata-setup` evidence after the source skill
  became `kata-docs`.
