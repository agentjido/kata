# Jido Skills Migration Backlog

Status: active

Last reviewed: 2026-11-04

## Purpose

Track the work that must finish before `agentjido/jido-skills` can archive.
The source repository remains available until every archive gate passes.

## Implemented migration and consolidation

- [x] Rewrite Jido action, agent, runtime, AI, and test guidance for current
      contracts.
- [x] Combine that guidance in the self-contained `kata-build-jido` skill.
- [x] Retire `kata-review-pr` and move bounded code-to-document reconciliation
      into `kata-docs` maintenance.
- [x] Merge focused pull-request hardening into `kata-work` without a required
      companion skill.
- [x] Preserve source attribution and Apache-2.0 license text in the consolidated
      skill package.
- [x] Add one small integration test that checks skill discovery, format,
      licenses, current Jido API markers, and safe write boundaries.
- [x] Keep generated provider copies, the old build system, and the old hub out
      of Kata.
- [x] Keep the old Hex release workflow out of Kata. The Jido workspace release
      process remains authoritative.

## Required follow-up

- [ ] Add small live task cases for the action, agent/runtime, AI, and test
      routes in `kata-build-jido` after the first release. Keep one training
      case and separate final cases. Confirm current API use, focused tests, and
      safe tool boundaries.
- [ ] Add a live task case for the `kata-work` pull-request hardening route.
      Confirm that it fixes only supplied blockers, adds regression tests, does
      not merge, and does not require a `ce-*` skill.
- [ ] Test local package installation and discovery in every host still claimed
      in the root README. Use temporary project scope. Do not install globally.
- [x] Reconcile the remaining Compound Engineering names and fallback phrases
      in `kata-work`. No `ce-*` integration references remain in that package.
- [x] Replace the legacy default `jido_harness` path in `dojo/mix.exs` with the
      pinned public GitHub dependency. Dojo no longer needs a workspace-specific
      dependency-path override.
- [ ] Review Jido skill examples again when `jido`, `jido_action`, or `jido_ai`
      changes a major or minor contract. Add a regression fixture for each API
      defect found after release.
- [ ] Merge and release a stable Kata version that contains the migrated skill
      files, licenses, evaluation suites, and documentation.
- [ ] Add a deprecation notice to the old repository only after the stable Kata
      install path exists.
- [ ] Record a disposition for each open issue and pull request in
      `agentjido/jido-skills`.

## Exact archive gate

Do not archive `agentjido/jido-skills` until all conditions are true:

1. `kata-build-jido` and the `kata-work` hardening route are on the stable Kata
   branch or release that users install.
2. The first-release integration test passes. The deeper live task cases in
   this backlog pass before the old repository archives. Saved evidence includes
   the exact source hash, outcome checks, and complete final files.
3. Current `jido`, `jido_action`, and `jido_ai` compile and test checks pass for
   the API baseline named by the release.
4. Every host claimed in Kata's installation section can discover the new
   skills from a temporary project-scope installation, or the unsupported host
   claim is removed.
5. Kata contains the Apache-2.0 text, copyright, source commit, and attribution
   for all migrated content.
6. The old repository README points to the stable Kata install path, and all
   open source work has a recorded destination or retirement decision.
7. `bin/jido admin worktrees check` passes, with branch divergence reported
   separately from working-tree changes.
8. The repository owner gives explicit approval for the archive action.

If one condition is false, keep the old repository available and mark it as
deprecated only when the stable Kata install path is ready.
