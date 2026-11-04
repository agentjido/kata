---
artifact_contract: kata-plan/v1
artifact_readiness: implementation-ready
product_contract_source: kata-idea
title: Release Agent Jido Kata 1.0
type: implementation-plan
date: 2026-11-04
last_reviewed: 2026-11-04
domain: software
execution: code
---

# Release Agent Jido Kata 1.0

## Goal Capsule

- Objective: Make Agent Jido Kata ready for a credible public 1.0 release.
- Means: Establish a clear public promise, a short entry-point README, an
  Apache-2.0 project license, one repository version, a repeatable GitHub release
  process, accurate directory listings, and a focused launch campaign.
- Authority: Local repository writes. Remote tags, releases, settings, directory
  requests, and announcements require later explicit authority.
- Stop conditions: Stop before a remote write, an unreviewed legal claim, loss
  of existing user changes, or a release that does not pass its required checks.
- Next executor: A repository implementer with local-write authority. Skill
  package metadata changes must use the approved `kata-write-skill` route.

## Product Contract

### Summary

Agent Jido Kata is an open knowledge-work system for coding agents. A user gives
`$jido` a normal-language goal. Jido selects the smallest useful sequence from
understanding through delivery and improvement. Advanced users can invoke the
leaf skills directly.

Version 1.0 must make this promise easy to understand, install, verify, and
share. It must not present experimental evaluation work as a requirement for
normal use.

### Problem Frame

The repository has useful skills and a defined process, but its public surface
still reads as an internal workbench. The README mixes the product pitch,
complete operating reference, installation details, attribution register, and
Dojo history. It also says that the public repository is private or not yet
public. Six manifests report version `0.3.0`. The repository has no root
license, tag, release, changelog, release workflow, or protected release gate.
The existing skills.sh page lists retired packages and does not show the current
20-package library.

### Actors

- A software engineer wants a coding agent to use a repeatable process without
  learning every skill first.
- An advanced user wants to select and install individual Kata skills.
- A contributor needs clear legal, contribution, security, and release rules.
- A maintainer needs one safe and repeatable way to publish a version.
- A directory operator or coding-agent host needs a valid package that follows
  the Agent Skills format.

### Requirements

- R1. The public product name is **Agent Jido Kata**. The repository remains
  `agentjido/kata`.
- R2. The primary public promise is: give `$jido` a goal and receive the
  smallest evidence-based work sequence that fits the goal and authority.
- R3. The README must let a new user understand the promise, install the
  package, run one example, see the main workflow, and find deeper references
  without reading internal history.
- R4. Detailed host instructions, package maintenance, provenance, and Dojo
  material must remain available, but they must not dominate the entry point.
- R5. Kata's original work must use Apache-2.0. All required third-party
  notices and package licenses must remain intact.
- R6. The repository must use one semantic version across a canonical version
  source and all host manifests. The first formal release is `1.0.0` and its Git
  tag is `v1.0.0`.
- R7. Pull requests and release tags must run deterministic checks for the
  package structure, skill frontmatter, links or referenced files, JSON
  manifests, version agreement, and release-tag agreement.
- R8. A release tag must create one GitHub release only after all release checks
  pass. The workflow must not publish an npm package or another registry
  package.
- R9. The release must include release notes and a changelog that explain the
  public contract, installation, compatibility limits, and important known
  constraints.
- R10. The skills.sh listing must show the current packages before the main
  launch announcement. A refresh request is a remote action and needs explicit
  authority.
- R11. Directory work must start with skills.sh because Kata already has a
  listing and uses its installer. Other directories must be evaluated for
  fit, maintenance cost, submission rules, and package compatibility before a
  submission.
- R12. Marketing must demonstrate one real workflow instead of advertising a
  large skill count. The primary launch example must start with `$jido` and show
  route selection, bounded authority, work, and verification.
- R13. Launch communication must separate stable 1.0 behavior from experimental
  Dojo work and unverified host support.
- R14. Existing uncommitted work and attribution changes must be preserved.

### Key Flows

1. A new user reads the README, installs from `agentjido/kata`, starts a new
   agent session if required, and asks `$jido` to perform one goal.
2. An advanced user opens the catalog, selects one leaf skill, and installs or
   invokes it directly.
3. A maintainer updates the canonical version and manifests in a reviewed
   change, updates the changelog, merges the change, and pushes a matching tag.
4. GitHub Actions validates the tagged source and creates the GitHub release.
5. A maintainer confirms or refreshes the skills.sh listing, then publishes the
   launch material.

### Acceptance Examples

- A first-time visitor can explain what Agent Jido Kata does after the first
  README screen and can copy one supported installation command.
- `VERSION`, every plugin manifest, and `package.json` report `1.0.0`.
- A `v1.0.0` tag on a source tree with version `1.0.0` can create a GitHub
  release. A mismatched tag fails before release creation.
- A pull request with invalid skill frontmatter or inconsistent manifest
  versions fails a required check.
- The 1.0 release does not start Dojo, publish npm content, change visibility,
  or submit to an external directory.
- The skills.sh page no longer presents the retired 17-skill catalog as the
  current release.

### Success Criteria

- A clean checkout passes the same validation used by GitHub Actions.
- The root repository contains an Apache-2.0 license and current third-party
  notices remain present.
- The README has one clear promise, one primary installation route, one first
  example, and links to detailed material.
- The GitHub release process can produce `v1.0.0` without manual release-note
  copying or package publication.
- The launch campaign produces one canonical announcement, one demonstration,
  and a small set of audience-specific posts that link back to the same release.
- The current skills.sh listing is accurate when the public launch begins.

### Scope Boundaries

- In: public positioning, README restructuring, license, community files,
  semantic version agreement, changelog, validation and release workflows,
  release documentation, skills.sh refresh plan, directory evaluation, and
  launch plan.
- Out: repository rename, npm publication, paid promotion, a website, live Dojo
  evaluation, new skills, skill redesign, automatic marketplace submission,
  remote repository settings, tags, releases, or announcements without explicit
  authority.

### Key Decisions

- Keep `agentjido/kata` and use **Agent Jido Kata** as the full public name.
- Use Apache-2.0 for Kata's original work.
- Use `jido` as the front door and leaf skills as the advanced interface.
- Start with one repository-wide semantic version at `1.0.0`.
- Use a reviewed version change plus a matching Git tag. Do not publish from an
  arbitrary branch or an npm release command.
- Treat skills.sh as the first directory because a stale listing already exists.
- Market the work system and its observable behavior, not the package count.

### Rejected Alternatives

- Rename the repository to `agentjido/skills`: too broad and less distinct.
- Present all skills equally on the README: this makes the first-use path hard
  to find.
- Use Dojo results as the main launch claim: current saved evidence does not
  establish the complete 1.0 library.
- Publish automatically from every merge to `main`: this removes the explicit
  version and tag boundary.
- Submit to every directory before the package is stable: stale copies increase
  correction and maintenance work.

### Dependencies

- GitHub Actions and GitHub Releases.
- The Agent Skills format at `agentskills.io`.
- The `npx skills` installer and skills.sh directory.
- Maintainer review of the final README, legal files, and release notes.
- Explicit remote-write authority for tags, releases, settings, directory
  requests, and announcements.

### Outstanding Questions

- Which external channels will the maintainers use for launch announcements?
  This choice changes distribution, but it does not block local release work.
- Which branch protection rules will the maintainers enable after the new checks
  exist? This is a later remote repository-setting decision.

### Sources

- `README.md:1-40` — current name, promise, installation prompt, and stale
  private/public language.
- `README.md:353-502` — current attribution register that must be preserved.
- `README.md:504-640` — host installation instructions and package structure.
- `package.json:1-15` — current `0.3.0` version and private npm guard.
- `AGENTS.md:18-27` — manifest consistency, requested release automation, Dojo,
  and preservation rules.
- `skills/jido/SKILL.md` — current routing promise and authority boundary.
- `skills/README.md` — current skill catalog and package guide.
- GitHub repository metadata inspected on 2026-11-04 — public visibility, no
  release, no tag, and no protected `main` branch.
- `https://www.skills.sh/agentjido/kata` inspected on 2026-11-04 — stale
  17-package listing with retired package names.
- `https://agentskills.io/specification` inspected on 2026-11-04 — current Agent
  Skills package and validation requirements.

## Planning Contract

### Product Contract Preservation

Product Contract unchanged. The technical plan adds no remote release,
directory submission, visibility change, or announcement authority.

### Current System

The repository distributes one flat `skills/<name>/SKILL.md` library through
six JSON manifests and `package.json`. The manifests all report `0.3.0`. There
is no canonical version file, repository validation command, CI workflow, or
release workflow.

The current README is the product entry point and the long-form reference. Its
first section has a usable installer prompt, but it also says that the public
repository is private and not ready. Later sections contain the complete Dojo
method, source attribution, host-specific installation details, and package
maintenance information.

All 20 active `SKILL.md` files are shorter than the Agent Skills recommendation
of 500 lines. Their `name` and `description` fields follow the expected shape.
However, every package represents `metadata.consumes` and `metadata.produces`
as YAML sequences. Ten packages also use the host-specific top-level
`argument-hint` field. The current Agent Skills specification permits only
string values inside `metadata` and rejects unknown top-level fields. The local
catalog expects sequences, so conformance requires an atomic metadata and
catalog-parser change.

The skills.sh source page already exists, but its cached 17-package catalog is
from an earlier repository state. Its listed names include retired packages.
The skills.sh project does not document a reliable author submission process;
its public issue tracker contains open indexing requests. The largest current
curated list, `VoltAgent/awesome-agent-skills`, requires established community
use, so it is not an appropriate day-one submission.

### Target System

The release path is:

```text
reviewed source change
  -> repository validation
  -> merge to main
  -> matching v1.0.0 tag
  -> tag validation
  -> GitHub Release with generated notes
  -> skills.sh accuracy check
  -> launch communication
```

`VERSION` owns the repository version. Every host manifest copies that exact
value. A local Elixir validator checks repository structure, relevant Agent
Skills format rules, retained notices, links, and version agreement. CI runs
the same command. The release workflow grants write access only to GitHub
contents and creates no package-registry artifact.

The README becomes a short product landing page. Stable reference material
moves to focused documents. The existing text and all uncommitted attribution
additions remain present in the new locations.

### Key Technical Decisions

#### KTD1 — Use one explicit repository version

- **Decision:** Add `VERSION` with `1.0.0`. Require every JSON manifest and
  `package.json` to match it. Use Git tag `v<version>`.
- **Reason:** R6 needs one inspectable release identity across hosts.
- **Rejected alternative:** Treat `package.json` as canonical. Kata is not an
  npm package, and `private: true` must remain.
- **Consequences:** Version changes touch several files, but validation detects
  drift before merge or release.
- **Governs:** R6-R9; U2, U3, U5.

#### KTD2 — Use tag-driven GitHub Releases

- **Decision:** Validate pull requests and `main` pushes. On a `v*` tag, rerun
  validation, require the tag to equal `v$(cat VERSION)`, then use the GitHub
  CLI to create a release with generated notes.
- **Reason:** R7-R9 require a deliberate release boundary without npm
  publication or a long-lived release bot.
- **Rejected alternative:** Publish after every merge to `main`. A merge is not
  an explicit version decision.
- **Consequences:** A maintainer must merge the release preparation and push the
  matching tag. A mismatched tag remains visible in Git but creates no release.
- **Governs:** R7-R9; U3, U5.

#### KTD3 — Keep release validation in Elixir

- **Decision:** Keep the repository validator as a dependency-free Elixir
  script. Pin the checkout and Elixir setup actions to immutable commit SHAs.
  Call the same script from local work and both workflows.
- **Reason:** The release gate must be reproducible and must not silently change
  when an action tag moves. Elixir is the established implementation language
  for Kata's local tools.
- **Rejected alternative:** Install a separate external validator toolchain in CI.
- **Consequences:** Kata owns its release checks and must update them when the
  Agent Skills specification changes. Action updates remain explicit changes.
- **Governs:** R7-R8; U2, U3.

#### KTD4 — Make Kata metadata valid Agent Skills metadata

- **Decision:** Encode the `consumes` and `produces` facets as comma-separated
  strings in YAML. Move each `argument-hint` value into the custom string
  `metadata.kata-argument-hint` field.
  Update the Kata library contract and catalog parser to expose facet values as
  lists inside Kata.
- **Reason:** The Agent Skills specification requires metadata values to be
  strings. Kata still needs multi-value workflow facets.
- **Rejected alternative:** Keep YAML sequences and omit official validation.
  That would preserve a known public-format violation.
- **Consequences:** All 20 packages receive a mechanical frontmatter change;
  ten also lose a host-only top-level extension. Skill behavior and routing text
  do not change. The change must run through `kata-write-skill` because it edits
  the skill library.
- **Governs:** R7, R11; U1, U2.

#### KTD5 — Separate the landing page from reference material

- **Decision:** Keep the README focused on promise, install, first use,
  workflow, package groups, compatibility, and next links. Move host-specific
  installation, full attribution, release operation, and launch execution to
  dedicated documents. Keep Dojo details in its existing guide.
- **Reason:** R3-R4 and R12-R13 require a fast first-use path without loss of
  provenance or advanced detail.
- **Rejected alternative:** Keep all current content and add a table of
  contents. The first-use burden and stale public claims would remain.
- **Consequences:** Existing deep README anchors can change at 1.0. The new
  README supplies replacement links.
- **Governs:** R1-R4, R9, R12-R14; U4, U5.

#### KTD6 — Delay curated-list submission until use exists

- **Decision:** Repair the existing skills.sh listing for 1.0. Record later
  directory candidates, but do not submit to curated lists until Kata has real
  external usage and meets their published criteria.
- **Reason:** R10-R11 require accurate distribution without low-value or
  premature submissions.
- **Rejected alternative:** Submit to every visible directory during launch.
- **Consequences:** The first launch depends on GitHub, skills.sh, direct
  demonstrations, and maintainer channels.
- **Governs:** R10-R13; U5.

### System Boundaries and Change Surface

| Surface | Current contract | Planned change | Compatibility or risk |
| --- | --- | --- | --- |
| Skill frontmatter | Kata facets use YAML lists | Use scalar strings; parse to lists for the catalog | Host metadata becomes spec-valid; Kata catalog output stays list-based |
| Host manifests | Six copies of `0.3.0` | Six copies of `1.0.0` checked against `VERSION` | All host identities remain `kata` |
| npm boundary | `private: true` | Preserve it | No npm publication |
| README | Landing page plus full reference | Short landing page with replacement links | Preserve attribution and user edits during the move |
| Legal surface | Package notices only | Root Apache-2.0 license, notice, and third-party attribution | Do not remove any package license |
| Validation | Manual and package-specific | One Elixir command shared by local work and CI | No Dojo run or live model call |
| Release | No tag or workflow | Matching tag creates one GitHub release | Remote action remains manual and separately authorized |
| Directory | Stale skills.sh cache | Verify or request refresh after 1.0 source is remote | Directory refresh is not part of local implementation |

### Implementation Units

#### U1 — Conform the active skill library

- **Outcome:** All active packages satisfy current Agent Skills metadata rules,
  while the Kata catalog still exposes multi-value consumes and produces
  facets.
- **Requirements:** R7, R11, R14.
- **Dependencies:** None.
- **Affected surfaces:** The 20 `skills/*/SKILL.md` frontmatter blocks;
  `skills/kata-write-skill/references/library-contract.md` for the serialization
  rule; `skills/catalog.exs` for scalar parsing; `skills/README.md` for the
  public package contract.
- **Implementation direction:** Through `kata-write-skill`, convert only the two
  sequence facets to comma-separated strings and move top-level
  `argument-hint` values to `metadata.kata-argument-hint`. Add one parsing helper that trims
  values, rejects empty members, and returns lists. Do not change the stable
  facet identifiers or any skill instruction body.
- **Test scenarios:** Official validation accepts each package; the catalog sees
  the same ordered facet values; missing or empty facets fail; every package
  name still matches its directory.
- **Verification:** Run the Elixir release validator and the catalog check.
  Inspect the scoped diff for instruction-body changes.
- **Completion signal:** Both Elixir checks report 20 packages.

#### U2 — Add the legal and version foundation

- **Outcome:** The repository has an Apache-2.0 public license and one `1.0.0`
  version across all distribution manifests.
- **Requirements:** R5-R6, R14.
- **Dependencies:** None.
- **Affected surfaces:** New `LICENSE`, `NOTICE`, and `VERSION`; `package.json`,
  `plugin.json`, `.claude-plugin/plugin.json`, `.cursor-plugin/plugin.json`,
  `.codex-plugin/plugin.json`, and `.grok-plugin/plugin.json`; existing package
  license files.
- **Implementation direction:** Use the unmodified Apache License 2.0 text.
  Attribute Agent Jido Kata in `NOTICE`. Keep `private: true`. Change only
  version and the agreed public description in the manifests. Do not remove or
  consolidate package notices.
- **Test scenarios:** All JSON parses; every version equals `VERSION`; root
  license and notice exist; all pre-existing package license paths still exist.
- **Verification:** Run the repository validator and compare a before/after
  inventory of `skills/**/LICENSE*`.
- **Completion signal:** One semantic version and complete legal files exist
  without lost notices.

#### U3 — Add repeatable validation and release automation

- **Outcome:** Local work, pull requests, `main`, and release tags use the same
  deterministic repository checks; matching tags create GitHub releases.
- **Requirements:** R7-R9.
- **Dependencies:** U1, U2.
- **Affected surfaces:** New Elixir repository validation script; new
  `.github/workflows/ci.yml` and `.github/workflows/release.yml`; optional
  `.github/release.yml` categories.
- **Implementation direction:** The dependency-free Elixir validator checks semantic version syntax,
  JSON parse and identity agreement, package discovery, required frontmatter,
  referenced local files, retained license inventory, and an optional tag
  argument. CI establishes Elixir and runs the local command. Release grants
  only `contents: write`, checks the tag, and calls
  `gh release create --verify-tag --generate-notes`. It creates no archive,
  package, or registry publication.
- **Test scenarios:** Valid source passes; one mismatched manifest fails; an
  invalid metadata value fails; a missing local reference fails; `v1.0.0`
  matches; `v1.0.1` fails against `VERSION=1.0.0`.
- **Verification:** Run the validator locally, exercise its negative fixtures
  in a temporary copy, and parse both workflows as YAML. Review permissions and
  confirm no package-publish command exists.
- **Completion signal:** CI and release workflows call the same passing command,
  and each negative case fails for the expected reason.

#### U4 — Build the public documentation surface

- **Outcome:** A first-time user can understand, install, and try Agent Jido
  Kata from the first README screen, while advanced and legal details remain
  available.
- **Requirements:** R1-R5, R9, R13-R14.
- **Dependencies:** U1, U2.
- **Affected surfaces:** `README.md`; new `docs/guides/installation.md`;
  `docs/reference/attribution.md`; `CONTRIBUTING.md`, `SECURITY.md`, and
  `CODE_OF_CONDUCT.md`; `docs/README.md` and related links.
- **Implementation direction:** Preserve the current uncommitted attribution
  additions when moving attribution. Keep one primary `npx skills` install
  command and one `$jido` example in the README. State tested and untested host
  support precisely. Link to the skill catalog, installation guide, Dojo,
  contribution, security, license, and attribution documents. Do not claim
  directory freshness until it is observed after release.
- **Test scenarios:** A reader can reach each promised document; no private or
  pre-public language remains; attribution text and package-license links are
  preserved; no broken relative links exist.
- **Verification:** Run the link and reference checks, compare the moved
  attribution text with the current README diff, and inspect the rendered
  Markdown structure.
- **Completion signal:** The README meets the first-use contract and all moved
  information has an indexed destination.

#### U5 — Add release operation and launch material

- **Outcome:** A maintainer has a complete 1.0 release checklist, changelog,
  directory decision, and demonstration-led marketing plan.
- **Requirements:** R8-R13.
- **Dependencies:** U2, U3, U4.
- **Affected surfaces:** New `CHANGELOG.md`, `docs/guides/releasing.md`, and
  `docs/plans/2026-11-04-agent-jido-kata-1-0-marketing-plan.md`; README and docs
  index links.
- **Implementation direction:** Document preflight, release change, tag, action,
  skills.sh verification or refresh request, rollback, and post-release checks.
  The marketing plan defines audience, message, one recorded or written demo,
  canonical GitHub announcement, channel adaptations, schedule, owner slots,
  success measures, and a two-week feedback loop. Record skills.sh as the first
  directory. Record `VoltAgent/awesome-agent-skills` as a later candidate after
  community-use evidence exists.
- **Test scenarios:** A maintainer can follow the release guide without an
  unstated command; every marketing claim is supported by 1.0 behavior; each
  remote action has a named approval boundary.
- **Verification:** Dry-run the local preflight through the tag check without
  creating a tag. Review the plan against the Product Contract and current
  directory rules.
- **Completion signal:** The local repository is ready for an explicit commit,
  push, tag, directory refresh, and launch decision.

#### U6 — Verify the integrated 1.0 candidate

- **Outcome:** One evidence set establishes whether the local 1.0 candidate is
  ready for remote release work.
- **Requirements:** R1-R14.
- **Dependencies:** U1-U5.
- **Affected surfaces:** All files changed by U1-U5 and a temporary installation
  target outside the repository.
- **Implementation direction:** Run fast static checks first, then the official
  package validator, catalog check, workflow and link checks, and one clean
  temporary `npx skills` discovery or installation check. Do not enter Dojo.
- **Test scenarios:** All 20 current packages are discovered; `jido` is present;
  the stale 17-package set is not produced from current source; no unrelated
  dirty file is overwritten.
- **Verification:** Use the commands in the Verification Contract. Inspect the
  final scoped diff and current Git status.
- **Completion signal:** All local gates pass, or the candidate returns a
  specific verification finding without remote release.

### Work Graph

- Initial frontier: U1 and U2.
- Parallel work: U1 and U2 can run independently. U4 can start after the public
  metadata and version wording from those units is stable.
- Critical path: U1 + U2 -> U3 -> U5 -> U6.
- Documentation path: U1 + U2 -> U4 -> U5 -> U6.
- Final integration unit: U6.

### Verification Contract

| Gate | Applies to | Evidence | Done signal |
| --- | --- | --- | --- |
| JSON and version | U2-U3 | Local validator | Six manifests parse and equal `VERSION` |
| Agent Skills format | U1, U3, U6 | Elixir frontmatter and metadata checks | 20 packages pass |
| Kata catalog | U1, U6 | `elixir skills/catalog.exs --check` | Reports 20 valid packages |
| Links and resources | U3-U6 | Local validator | No missing repository-relative target |
| Workflow safety | U3, U6 | YAML parse and manual permission review | Only release job has `contents: write`; no registry publish |
| Tag agreement | U3, U5 | Local validator with `v1.0.0` and mismatch case | Match passes and mismatch fails |
| Install discovery | U4, U6 | Temporary `npx skills` check from current source | 20 packages, including `jido`, are found |
| Preservation | all | Scoped diff and license inventory | No unrelated edit or required notice is lost |

Supported commands will be finalized with the implementation script. The
expected repository-root sequence is:

```sh
elixir scripts/validate_release.exs
elixir skills/catalog.exs --check
elixir scripts/validate_release.exs --tag v1.0.0
```

The temporary install check may need network access for the installer. Run it
outside the repository and do not retain installed files.

Requirement traceability:

| Requirements | Units | Main evidence |
| --- | --- | --- |
| R1-R4 | U4, U6 | README and link review |
| R5 | U2, U4, U6 | License and notice inventory |
| R6 | U2, U3, U6 | Version and tag checks |
| R7-R9 | U2, U3, U5, U6 | CI, release workflow, changelog, dry run |
| R10-R11 | U5 | Directory assessment and later live verification |
| R12-R13 | U4-U6 | Launch-plan claim review |
| R14 | U1-U6 | Scoped diff and preservation review |

### Rollout and Recovery

Local implementation is reversible through normal Git review. The first remote
point is the push of the release-preparation change. The second is the
`v1.0.0` tag. Before the tag, require passing CI and inspect the published
source at `main`. After the tag, confirm the GitHub release, install from the
tagged repository, and inspect skills.sh.

If release creation fails, keep the tag, repair the workflow through a reviewed
change, and rerun the failed workflow only when the tag still points to the
intended source. If the tag points to incorrect source, do not move or delete it
without explicit destructive authority; publish a corrective version instead.
If skills.sh stays stale, file a focused refresh request with the old and new
catalog evidence. Delay the main announcement until the directory is accurate.

### Risks and Assumptions

- **Risk:** The repository is already public without a root license. U2 is the
  first legal correction and must retain all third-party notices.
- **Risk:** skills.sh caches removed packages. The release cannot directly
  control its refresh schedule.
- **Risk:** README restructuring overlaps current uncommitted attribution work.
  U4 must move that exact content, not reconstruct it from `HEAD`.
- **Risk:** Kata's local validator can drift from the Agent Skills
  specification. Keep its checked fields linked to the reviewed specification
  and update tests when that specification changes.
- **Assumption:** GitHub-hosted runners can use Elixir 1.20.4 and OTP 28.1 after
  the pinned setup action. The workflow establishes these versions explicitly.
- **Assumption:** `gh` is available in GitHub-hosted runners. The release job
  verifies this before release creation.

### Open Planning Decisions

None block local implementation. Maintainers must later select announcement
channels and branch-protection settings. Those decisions do not change the
first executable unit.

### Definition of Done

- All 20 active skills pass the Elixir release validator.
- Kata's facet semantics and catalog behavior remain unchanged after scalar
  serialization.
- Apache-2.0, NOTICE, VERSION, and all third-party notices are present.
- All manifests report `1.0.0` and `private: true` remains in `package.json`.
- Local validation, CI, and release workflows implement the same gates.
- A matching tag dry run passes and a mismatch dry run fails.
- The README, installation guide, community files, attribution, changelog,
  release guide, and marketing plan satisfy R1-R14 with valid links.
- A temporary source install or discovery check finds the current 20 packages
  and `jido`.
- No Dojo run, remote change, tag, release, directory submission, or
  announcement occurs.
- The final diff preserves all unrelated work and is ready for consumer review.

### Planning Sources

- [Agent Skills specification](https://agentskills.io/specification), reviewed
  2026-11-04: metadata scalar rule, name and description limits, and 500-line
  recommendation.
- [Vercel skills creation guide](https://github.com/vercel-labs/skills/blob/main/docs/creating-skills.md),
  reviewed 2026-11-04: flat `skills/` discovery and plugin manifest discovery.
- [Current skills.sh source page](https://www.skills.sh/agentjido/kata), reviewed
  2026-11-04: stale 17-package catalog.
- [VoltAgent contribution rules](https://github.com/VoltAgent/awesome-agent-skills/blob/main/CONTRIBUTING.md),
  reviewed 2026-11-04: public documentation and established-use requirement.
- `skills/catalog.exs`: current list-based catalog parser and check command.
- `skills/kata-write-skill/references/library-contract.md`: current facet
  semantics.
- Current repository and GitHub metadata recorded in the Product Contract.

## Adapter Results

- Markdown: canonical at
  `docs/plans/2026-11-04-1504-idea-public-1-0-release-plan.md`
- HTML: not requested
- Beadwork: not requested
