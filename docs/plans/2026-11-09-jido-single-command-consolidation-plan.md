---
artifact_contract: jido-consolidation/v1
artifact_readiness: implementation-complete-release-pending
title: Consolidate Kata Behind One Jido Command
type: scope-and-implementation-plan
date: 2026-11-09
last_reviewed: 2026-11-09
domain: skill-library
execution: repository-change
---

# Consolidate Kata Behind One Jido Command

## Goal capsule

- **Objective:** Make `$jido` the only public Agent Skill command in this
  repository.
- **Means:** Move the useful general methods into a smaller internal set of
  Jido Katas, remove the leaf Agent Skill packages, and move Elixir-specific
  methods to repositories that own those domains.
- **Release boundary:** Preserve the published `v0.5.0` release as the last
  multi-skill baseline. Deliver this hard change as a later breaking release.
- **Authority:** This plan permits local implementation after its two owner
  decisions are complete. A push, tag, GitHub release, repository creation,
  repository archive, or external index update needs explicit authority in the
  execution request.
- **Stop conditions:** Stop before loss of required general behavior, license
  text, attribution, or saved user work.

## Baseline

The repository is `agentjido/skills`. It currently contains 23 discoverable
Agent Skill packages under `skills/`. The root manifests expose that complete
directory. The README and installation guide also tell users that they can
install or invoke the leaf skills directly.

The annotated `v0.5.0` tag exists locally and on GitHub. It points to release
commit `0507c5e451de5c86f74993042107389c49aac152`. GitHub published the
`Agent Jido Kata 0.5.0` release from that tag on 2026-11-07. Do not move,
replace, or delete this tag.

A 2026-11-07 planning session proposed the same main direction, but it did not
save a plan in this repository. It proposed one discoverable `jido` package,
no compatibility aliases, external ownership for Elixir-specific methods, and
a breaking release. This document makes that direction reviewable in the
repository.

## Maintenance finding

- **Observation:** Jido is the declared front door, but the package still
  exposes 22 other Agent Skill commands.
- **Evidence:** `skills/README.md` lists 23 packages. `package.json` and the
  host manifests expose `./skills`. The README and installation guide tell
  users to select individual packages.
- **Consequence:** The user must understand package names, and Jido must route
  through a large host registry. The public contract and installed shape do
  not match the intended single-command experience.
- **Canonical owner:** `skills/jido/`.
- **Disposition:** Consolidate the general methods into Jido. Transfer the
  domain-specific Elixir methods before their current packages are removed.

## Target contract

### Public surface

The repository has one discoverable Agent Skill:

```text
skills/jido/SKILL.md
```

The user starts all work with `$jido` and a normal-language goal. Leaf package
names are not public commands. Do not provide aliases, wrappers, deprecation
commands, or compatibility packages.

Jido selects an internal Kata, loads only the references needed for that Kata,
and retains responsibility for the complete requested outcome. Each internal
Kata keeps an explicit result, authority boundary, done condition, failure
direction, and next consumer.

### Internal Kata set

Use seven normal Katas and one explicit maintainer Kata:

| Internal Kata | Owns | Current packages absorbed |
| --- | --- | --- |
| `understand` | Establish facts, diagnose causes, and report repository state. | `kata-understand`, diagnostic parts of `kata-debug`, `kata-sitrep` |
| `shape` | Set direction and make work ready for execution. | `kata-idea`, `kata-roadmap`, `kata-scope`, `kata-plan` |
| `lead` | Teach agent leadership and assign bounded work. | `kata-tutor`, `kata-delegate` |
| `work` | Produce a candidate result through a selected work profile. | `kata-work`, repair parts of `kata-debug`, `kata-docs`, `kata-showme`, `kata-technical-writing` |
| `verify` | Judge a candidate with evidence and apply security review methods. | `kata-verify`, review parts of `kata-security` |
| `improve` | Resolve a reusable-method finding and write a conforming method revision. | `kata-maintain-skill`, `kata-write-skill` |
| `ship` | Commit, push, open or merge a pull request, and perform an explicitly authorized release operation. | `kata-shipit` |
| `dojo` | Run or inspect controlled evaluation work only after the request explicitly names Dojo. | `kata-dojo` |

Keep `dojo` isolated from normal routing. A normal `$jido` request must not
read, run, or change Dojo material.

Store the internal contracts below `skills/jido/references/katas/`. Store
substantial result-type or domain guidance below
`skills/jido/references/profiles/` and `skills/jido/references/lenses/`. Jido
must select the internal Kata before it selects a profile or lens.

### External domain ownership

Do not copy Elixir-specific methods into the general Jido package. The owner
retains their complete pre-consolidation source in `kata_bkp` and Git history.
Transfer to a domain repository is separate future work.

| Current material | Proposed future owner | Current disposition |
| --- | --- | --- |
| `kata-build-jido` | `agentjido/jido` | Removed from the general package; retained in `kata_bkp` and Git history |
| `kata-ex-design-review` | `agentjido/elixir-skills` | Removed from the general package; retained in `kata_bkp` and Git history |
| `kata-ex-quality` | `agentjido/elixir-skills` | Removed from the general package; retained in `kata_bkp` and Git history |
| `kata-technical-writing/references/elixir-library-docs.md` | `agentjido/elixir-skills` | Removed from the general package; retained in `kata_bkp` and Git history |

Jido can use these methods only when the host exposes them as separately
installed local skills. Jido must not scan the file system or reconstruct a
missing external method.

## Scope

### Included

- One public `jido` Agent Skill package.
- Seven normal internal Katas and the explicit-only Dojo Kata.
- Current general behavior, authority limits, completion rules, and recovery
  rules that are still required.
- A routing table that selects one internal Kata before any profile or lens.
- General work profiles for software, documents, research, operations, and
  visual explanations.
- Security guidance as a verification lens, with authorized repair handed to
  `work`.
- Transfer records for the Elixir-specific material.
- License and attribution mapping for every absorbed or transferred source.
- Manifest, validator, catalog, documentation, installation, and release
  changes required by the one-skill package.
- Behavioral routing tests and temporary project-scope installation checks.
- A breaking release after separate review and release authority.

### Excluded

- Compatibility aliases for `kata-*` commands.
- Automatic installation of external Elixir skills.
- Private skills or marketing material.
- Live Dojo evaluations.
- Changes to the Jido Elixir SDK itself.
- Creation of `agentjido/elixir-skills` without owner approval.
- Moving or replacing `v0.5.0`.
- A remote push, tag, release, repository archive, or directory refresh in the
  implementation task unless that task grants the required authority.

## Resolved execution decisions

1. **Elixir source:** Remove it from the general package now. Use `kata_bkp` and
   Git history as the retained source. Select and populate an external domain
   repository in a separate task.
2. **Dojo ownership:** Keep `dojo/` as maintainer tooling in
   `agentjido/skills`, with an explicit `$jido dojo ...` route and no separate
   Agent Skill package. A later repository move can use its own plan.

## Implementation plan

### Unit 1: Freeze the migration inventory

Create a machine-readable migration table for all 23 current packages. Record
the destination internal Kata or external repository, behavior to preserve,
support files, scripts, assets, licenses, attribution, callers, and checks.

Completion evidence:

- Every current `skills/*/SKILL.md` has one destination.
- Every `LICENSE*`, script, asset, and linked reference has one preservation or
  retirement decision.
- The table identifies the exact current paths that Jido and the validators
  call.

### Unit 2: Remove Elixir methods from the general package

Remove the Elixir-only package entry points and the Elixir documentation method.
Keep source history and record the backup boundary. Do not claim that an
external destination exists.

Completion evidence:

- No Elixir-only method remains in the Jido package.
- The plan and provenance record name `kata_bkp` and Git history as the retained
  source.
- Public text does not claim that an external destination already exists.

### Unit 3: Build the internal Jido contracts

Create the eight internal Kata files and the required profile and lens files.
Move rules from the current packages into one canonical location. Preserve
authority changes between read-only, local-write, external-write, and
destructive operations. Keep remote writes dependent on explicit authority.

Update `skills/jido/SKILL.md` so that it:

1. accepts a direct `$jido` request or a standing user or workspace preference
   for substantial or ambiguous work, and skips simple or separately routed
   requests;
2. selects the first unresolved internal Kata;
3. verifies the selected internal path against a fixed registry;
4. loads only the selected contract and required profile or lens;
5. continues through repair and verification until the requested outcome is
   complete or a stated stop condition applies; and
6. treats Dojo as explicit-only.

Completion evidence:

- Each internal Kata satisfies the library outcome, activation, work,
  authority, assignment, information, and verification contracts.
- No rule has two active canonical owners.
- Jido does not depend on another installed `kata-*` package.

### Unit 4: Replace the public package surface

After Units 2 and 3 pass, remove the 22 leaf package directories. Keep required
third-party license text and attribution in stable locations below the Jido
package or a repository license register. Update the validator so that it
requires exactly one `SKILL.md` and checks the new license map.

Update the catalog or replace it with a one-package inspection view. Remove
catalog rules that imply that internal Katas are installable Agent Skills.

Completion evidence:

```sh
find skills -mindepth 2 -maxdepth 2 -name SKILL.md
```

prints only `skills/jido/SKILL.md`, and the release validator passes.

### Unit 5: Update packaging and public documentation

Keep the host manifests pointed at the public skills directory only if that
directory contains only Jido. Otherwise, point each supported manifest at the
exact Jido package path. Confirm the behavior for each supported host instead
of assuming that all hosts interpret a single-file path in the same way.

Update these public facts in current documentation:

- repository: `agentjido/skills`;
- install source: `agentjido/skills`;
- public command: `$jido` only;
- package count: one;
- leaf Kata names: internal implementation terms, not install choices;
- breaking-change notice: no `kata-*` compatibility commands.

Update the README, installation guide, skills guide, host compatibility guide,
release guide, badges, and repository URLs. Keep versioned manifests and the
changelog under the repository's Release Please ownership guard; update them in
Unit 7.

Completion evidence:

- No current document tells a user to install or invoke a leaf Kata.
- No current public badge or installation instruction uses `agentjido/kata`.
- Historical documents remain dated records and do not claim to be current.

### Unit 6: Verify routing and restraint

Add deterministic routing cases for at least these requests:

- establish current facts;
- decide product direction;
- scope and plan ready work;
- delegate and integrate work;
- produce and verify a document;
- diagnose and repair a software fault;
- perform a security review without an unauthorized repair;
- improve a reusable method;
- commit or push only with the required authority;
- reject an inferred Dojo run;
- accept an explicit Dojo request without running a live evaluation in the
  test; and
- report a missing external Elixir method without inventing or installing it.

Also run the static release validator, link checks, host manifest checks, and
temporary project-scope installation checks for every host that the README
claims.

Completion evidence:

- All routing cases select the expected internal Kata and authority boundary.
- The installed package exposes `jido` and no `kata-*` commands.
- No normal case reads or runs Dojo material.
- A clean checkout passes the same checks as CI.

### Unit 7: Prepare the breaking release

Use `1.0.0` as the proposed release version because the public command surface
removes all leaf commands without compatibility. Update all versioned
manifests, their descriptions and repository URLs, release configuration,
changelog, and migration notes in one Release Please-owned change.

The release notes must state:

- `$jido` is the only public command;
- leaf `kata-*` commands were removed;
- the Elixir methods have their approved new install locations;
- `v0.5.0` remains available as the last multi-skill release; and
- normal Jido work does not run Dojo.

After local and CI verification, use a separate authorized release task to
merge, tag `v1.0.0`, and confirm the GitHub release. Do not retag `v0.5.0`.

## Acceptance contract

The consolidation is complete only when all conditions are true:

1. `skills/jido/SKILL.md` is the only discoverable Agent Skill in this
   repository.
2. `$jido` can route the defined cases without another public Kata package.
3. The seven normal Katas and explicit-only Dojo Kata have distinct results,
   authority, completion, and failure contracts.
4. Required general behavior from the removed packages has a tested owner.
5. Elixir-specific material is absent from the general package, and its source
   is retained in `kata_bkp` and Git history for a separate migration.
6. All required third-party notices and attribution remain present and mapped.
7. Current installation and public documentation name `agentjido/skills` and
   only `$jido`.
8. Release validation, links, routing cases, and claimed host installation
   checks pass from a clean checkout.
9. The annotated `v0.5.0` tag still resolves to release commit `0507c5e`.
10. A separate release task has the authority and evidence needed to publish
    the breaking release.

## Recommended execution boundary

Units 1 through 6 are implemented in the working tree. Keep Unit 7 as a
separate release change and release task.
This boundary keeps package migration evidence separate from version and tag
effects.

## Sources

- `skills/jido/SKILL.md` and its routing references.
- `skills/README.md` for the current 23-package public inventory.
- `docs/plans/skill-library-architecture.md` for the current work-system
  facets, skill budget, and package ownership rules.
- `skills/kata-write-skill/references/library-contract.md` for package and
  verification contracts.
- `package.json`, `plugin.json`, and host plugin manifests for the current
  package surface and repository identity.
- `scripts/validate_release.exs` for release, package, license, and link gates.
- `README.md` and `docs/guides/installation.md` for the current user contract.
- `docs/plans/jido-skills-migration-backlog.md` for earlier Jido ecosystem
  migration constraints.
- The published `v0.5.0` Git tag and GitHub release, verified on 2026-11-09.
