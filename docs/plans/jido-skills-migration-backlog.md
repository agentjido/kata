# Jido Skills Migration Backlog

Status: active

Last reviewed: 2026-09-28

## Purpose

Track the work that must finish before `agentjido/jido-skills` can archive.
The source repository remains available until every archive gate passes.

## Implemented in the first migration change

- [x] Rewrite Jido action guidance for the current action and execution contract.
- [x] Rewrite Jido agent guidance for current routes, state operations,
      directives, and signal-based runtime calls.
- [x] Rewrite Jido AI guidance for current agents, actions, requests, and
      deterministic offline tests.
- [x] Add a focused Jido testing skill.
- [x] Replace the old Jido hub prerequisite with self-contained skills.
- [x] Merge README refresh and docs-to-code work into `kata-sync-docs`.
- [x] Add a read-only, host-neutral `kata-review-pr` skill.
- [x] Merge focused pull-request hardening into `kata-work` without a required
      companion skill.
- [x] Preserve source attribution and Apache-2.0 license text in each affected
      skill package.
- [x] Add one small integration test that checks skill discovery, format,
      licenses, current Jido API markers, and safe write boundaries.
- [x] Keep generated provider copies, the old build system, and the old hub out
      of Kata.
- [x] Keep the old Hex release workflow out of Kata. The Jido workspace release
      process remains authoritative.

## Required follow-up

- [ ] Add small live task cases for the four Jido skills after the first release.
      Keep one training case and separate final cases. Confirm current API use,
      focused tests, and safe tool boundaries.
- [ ] Add a live task case for `kata-review-pr` and `kata-sync-docs`. Confirm
      their read/write boundaries against actual final files.
- [ ] Add a live task case for the `kata-work` pull-request hardening route.
      Confirm that it fixes only supplied blockers, adds regression tests, does
      not merge, and does not require a `ce-*` skill.
- [ ] Test local package installation and discovery in every host still claimed
      in the root README. Use temporary project scope. Do not install globally.
- [ ] Reconcile the remaining Compound Engineering names and fallback phrases
      in `kata-work`. The new PR-hardening route is self-contained, but other
      routes still contain imported `ce-*` integration text.
- [ ] Replace the legacy default `jido_harness` path in `evals/mix.exs` with a
      portable setup. The current workspace check needs the documented
      `JIDO_HARNESS_PATH` override.
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

1. The six new Kata skills and the `kata-work` hardening route are on the stable
   Kata branch or release that users install.
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
