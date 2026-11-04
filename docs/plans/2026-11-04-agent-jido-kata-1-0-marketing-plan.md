# Agent Jido Kata 1.0 Marketing Plan

Status: Ready for maintainer review

Last reviewed: 2026-11-04

## Objective

Introduce Agent Jido Kata to software engineers who use coding agents for real
repository work. The launch must produce qualified trial and useful feedback,
not only page views or stars.

## Positioning

**Agent Jido Kata gives coding agents a repeatable way to understand, decide,
plan, work, verify, ship, and improve. Start with one `$jido` request.**

Kata is not a prompt collection and does not require users to select a long
workflow before work starts. Jido enters at the first unresolved contract and
keeps action inside the user's authority.

## Audiences

1. **Primary:** Engineers who already use Codex, Claude Code, Cursor, or another
   Agent Skills-compatible coding agent on multi-step repository work.
2. **Secondary:** Engineering leads who want a clearer boundary between
   investigation, implementation, verification, and delivery.
3. **Specialist:** Elixir and Jido developers who can also use the Elixir design,
   quality, and Jido-building skills.

## Message pillars

- **One front door:** Use `$jido` with a normal-language goal.
- **Start at the right point:** Ready work can skip exploration and planning.
- **Evidence before confidence:** Understanding and verification are explicit
  result boundaries.
- **Bounded authority:** A route does not grant permission to publish, delete,
  spend money, or change a live system.
- **Reusable improvement:** Kata can improve the work system without mixing
  that work into product delivery.

Do not claim that Kata is autonomous, universally optimized, safe without user
review, or verified on every coding host. Do not use saved Dojo experiments as
proof for the complete 1.0 library.

## Launch demonstration

Use the 1.0 preparation itself as the main case study:

```text
$jido help me prepare this repository for a public 1.0 release. Review the
README, directories, marketing plan, and GitHub release process.
```

Show these observable moments:

1. Jido selects `understand` because the current release state is unknown.
2. The review finds the missing root license, stale README statements, version
   drift, no release gate, and a stale skills.sh cache.
3. One accountable license decision moves the work into planning.
4. Implementation separates package conformance, public documentation, and
   release automation.
5. Independent verification checks the final candidate before any remote
   release action.

Create one short written walkthrough with a route diagram and selected diff
screens. A two-to-four-minute screen recording is optional. Do not show private
files, credentials, internal model output, or unreviewed attribution material.

## Launch assets

- Canonical source: `https://github.com/agentjido/kata`
- Release page: `https://github.com/agentjido/kata/releases/tag/v1.0.0`
- Directory page after refresh: `https://www.skills.sh/agentjido/kata`
- One installation command: `npx skills add agentjido/kata`
- One case study based on the launch demonstration.
- One compact workflow diagram from README content.
- One feedback issue with prompts for host, task, selected route, useful result,
  and failure or confusion.

All announcements must link to the canonical release or README. Do not create
separate descriptions that can drift.

## Distribution plan

### Release day

1. Publish the GitHub Release.
2. Confirm installation from the public tagged source.
3. Confirm or request refresh of the existing skills.sh page.
4. Publish the canonical announcement from the Agent Jido account or maintainer
   account.
5. Publish the case study and link it from the announcement.
6. Adapt the same message for the maintainers' established social channels and
   the Elixir community when the Jido and Elixir angle is relevant.

### Directory strategy

- **Now — [skills.sh](https://www.skills.sh/agentjido/kata):** Already indexed.
  Make its package list accurate before broad promotion. Its public submission
  process was still unclear on 2026-11-04, as shown by the open
  [publishing-process issue](https://github.com/vercel-labs/skills/issues/880).
  Use an evidence-based refresh issue only if normal indexing does not update it.
- **Later — [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills):**
  Consider after external usage exists. Its
  [contribution rules](https://github.com/VoltAgent/awesome-agent-skills/blob/main/CONTRIBUTING.md),
  reviewed on 2026-11-04, reject new projects without community adoption.
- **Reference only — [agentskills.io](https://agentskills.io/specification):**
  This is the format specification, not a general skill-submission directory.
- **Host marketplaces:** Evaluate only after native installation is tested for
  that host. The included manifests do not prove marketplace acceptance.

Do not submit the same launch to low-use lists. Each additional directory adds
cache, correction, and maintenance cost.

## Announcement draft

> Agent Jido Kata 1.0 is a knowledge-work system for coding agents. Give `$jido`
> a goal and it selects the smallest useful route through understanding,
> product decisions, planning, work, verification, shipping, or improvement.
> The project includes 20 portable Agent Skills and installs with
> `npx skills add agentjido/kata`. Version 1.0 adds Apache-2.0 licensing,
> shared-format validation, and a repeatable GitHub release process.

Follow this with the launch case-study link and one specific question: “What
repository task should Jido route next?”

## Schedule

- **Before launch:** Complete local verification, merge the release change,
  enable required CI, and prepare the case study.
- **Release day:** Tag, confirm the GitHub Release, test public installation,
  check skills.sh, then announce.
- **Days 1-3:** Answer installation and routing questions. Record repeated
  confusion without changing the process from one report.
- **Day 7:** Publish one real follow-up example from a different task shape.
- **Day 14:** Review qualified trials, failures, issue themes, and directory
  accuracy. Select only evidence-backed 1.0.1 work.
- **Day 30:** Decide whether usage supports a curated-list submission and which
  host needs a native-install verification pass.

## Measures

Record a launch baseline and review it at days 7, 14, and 30:

- successful public installs or discovery checks;
- unique cloners and referring sites from GitHub traffic;
- skills.sh installs after its catalog is current;
- users who report a real `$jido` task and selected route;
- installation, activation, and authority-boundary failures;
- issues or pull requests from external users; and
- repeat use by the same external user.

Stars and impressions are context, not success. The main success signal is an
external user who completes a real repository task and can explain where Jido
helped or failed.

## Approval boundaries

This plan does not authorize a push, tag, release, repository-setting change,
directory request, social post, email, forum post, or paid promotion. Each
remote action needs explicit maintainer authority and a final content review.
