# Documentation

Use the [Docs Kata rules](AGENTS.md) to collect, review, and maintain documents.
The [inbox and intake log](inbox/README.md) list material that awaits review.
Setup has not checked the inbox documents against the implementation. The
current plans section lists reviewed active plans.

## Documents kept at fixed paths

- [Project README](../README.md): project entry point, skill list, and attribution.
- [Project instructions](../AGENTS.md): rules for the whole repository.
- [Dojo guide](../dojo/README.md): entry point for skill and agent-trace evaluation.
- [Dojo runner handoff](../dojo/RUNNER.md): path used by active task handoffs.

The intake log records retained files and exclusions. Retention does not mean
that a document has been reviewed or its claims have been verified.

## Current plans

- [Skill library architecture](plans/skill-library-architecture.md): keep fewer
  than 20 active skills through facets, work profiles, domain lenses, and a
  first-class verification step.
- [Complete skill template conversion](plans/2026-11-04-0604-refactor-complete-skill-template-conversion-plan.md):
  audit every active package and convert each proven nonconforming package
  through the maintenance and writing workflows.
- [Jido skills migration backlog](plans/jido-skills-migration-backlog.md):
  remaining verification and the archive gate for `agentjido/jido-skills`.
- [Skill import queue](plans/skill-import-queue.md): de-duplicated TODO list for
  possible imports from Compound Engineering, pstack, and Matt Pocock.
