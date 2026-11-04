---
name: kata-maintain-skill
description: Maintain a skill library by resolving one evidence-backed finding about ownership, overlap, classification, contract conformance, or retirement. Use when the required library change is not yet known; use a skill-writing workflow when the package change is already defined.
metadata:
  schema: kata.skill/v1
  subject: agent-work
  practice: govern
  object: skill-library
  profile: system-design
  authority: local-write
  consumes: [skill-library, skill-evaluation-evidence]
  produces: [resolved-library-finding, conversion-brief, work-request, verified-change]
---

# Maintain Skill

**Outcome:** One resolved library finding and the smallest safe change for the
target library.

**Done:** Exactly one finding has one disposition. The decision has specific
evidence. When the operator requests a fix, the permitted change is complete and
verified. When the operator also requests a commit, the commit workflow reports
its result. Unrelated library concerns remain unchanged.

## Assignment

The operator can supply a finding or Dojo evidence. If no finding is supplied,
inspect the library and select one. When supplied evidence already proves the
finding, owner, and remedy, do not repeat discovery or planning. Work in the
requested skill repository. Read its active
instructions, library rules, metadata conventions, current changes, and affected
packages before an edit.

Direct user authority or inherited caller authority permits local inspection
and the smallest local edit that resolves the finding. This can include skill
contracts, activation text, metadata, indexes, references, and documentation.
Do not install, publish, release, or change remote state. Get explicit approval
before a package deletion or rename, a license or provenance change, execution
of untrusted source, or a change that expands the assignment.

A request to complete the maintenance loop permits the in-scope local fix and
the required handoffs. This skill does not stage or commit changes. A commit
requires an explicit operator request and the canonical commit workflow. This
authority does not permit amend, rebase, push, merge, or other remote or
history-changing actions.

The work profile is `system-design` when the finding changes a reusable library
contract or ownership boundary. It is `bounded-execution` when the finding only
repairs an established classification or index rule. Ask the accountable owner
when the decision depends on intent, rights, or authority that repository
evidence cannot establish.

## Select one finding

If the operator supplied a finding, test it before you accept it. Reuse matching
Dojo evidence only for the exact candidate and evaluation contract. Otherwise,
compare the declared library contract with the packages, indexes, and their
current callers. Select one issue with:

- a concrete consequence for safe use, routing, ownership, discoverability,
  rights, or maintenance;
- evidence in specific files or observed behavior; and
- a remedy that fits the granted authority.

Prefer the finding with the highest likely harm and strongest evidence, then
prefer the smaller remedy. Do not select a style preference, a speculative gap,
or an issue that requires a broad audit to prove.

When a package can be out of date with the library contract, read the
repository's canonical skill-writing contract. In Kata, `kata-write-skill` owns
that contract. Report a conversion finding only when the gap can change the
outcome, activation, authority, classification, rights, verification, or next
consumer. A different heading or format is not sufficient evidence.

Write a short finding record before the change:

- **Observation:** What is inconsistent or ineffective.
- **Evidence:** What proves the condition.
- **Consequence:** Who or what receives the wrong result.
- **Canonical owner:** Which package or index must own the rule.
- **Disposition:** What this invocation will do.

Choose one disposition:

| Disposition | Condition |
| --- | --- |
| Refine | The canonical owner is correct, but its contract does not produce the required result. |
| Consolidate | Overlapping owners create an ambiguous route or duplicate rule. Keep one authoritative owner. |
| Reclassify | The package and the canonical index disagree about its work domain. |
| Retire | Evidence shows that the package is unsafe, obsolete, or has no distinct job. Approval is required. |
| Route | The finding proves a missing job or an existing package needs conversion to the library contract. Produce a bounded authoring brief for the maintainer. |
| Reject | The evidence does not prove a library defect. Make no change. |
| Defer | Required evidence, rights, or authority is unavailable. State the missing condition. |

## Resolve the finding

Apply only the selected disposition. Preserve unrelated edits, callers,
supported metadata, notices, licenses, and attribution. Keep each rule in one
canonical location. Use subject, practice, object, inputs, and outputs to find
overlap candidates. Then compare outcome, activation conditions, authority, and
next consumer. Do not consolidate packages only because their metadata, topics,
or tools are similar.

For a refinement, change the smallest contract text or support file that fixes
the proven consequence. For a consolidation, move the required behavior to the
canonical owner and update affected callers before an approved retirement. For
a reclassification, reuse the exact facet values used by equivalent work and
keep classification in the skill frontmatter. For a route, state the required
outcome, non-trigger, authority, taxonomy, acceptance evidence, and source
rights. If the operator requested a report only, stop with that brief. If the
operator requested a completed fix, use the canonical skill-writing workflow
for a skill-package change. Use the canonical work-execution workflow for
another clear local change, then use independent verification. Enter at work when
the finding already resolved the target, scope, acceptance conditions, and
authority; do not add understanding or planning steps. Return here with the
verification result.
For a conversion route, also name the behavior and resources to preserve and
the exact contract gaps to correct. Route Kata conversions to `kata-write-skill`
when it is available. Keep the brief complete when it is not available.

Do not fix a second finding. Mention another concern only when it blocks this
one.

## Complete the requested loop

When the operator requested a fix, do not report a Route disposition as complete
until the writing handoff is verified or has an explicit blocker.

When the operator also requested a commit, pass the verified change to the
canonical commit workflow. In Kata, use `kata-commit`. Do not stage or commit
inside this skill. Report the returned commit hash or blocker.

Produce `verified-change` only when this invocation leaves a verified local
library mutation. A report-only, rejected, deferred, or routed finding does not
produce it.

## Verify and report

Check every changed name, frontmatter field, link, reference, caller, notice,
and subject entry that applies. Test changed activation, execution, or authority
behavior when the finding affects it. Use static checks only for a static index
or metadata repair. State the exact reason for any check that did not run.

Report the finding, disposition, canonical owner, evidence, changed files,
checks, and any blocker. Do not claim that the library is healthy as a whole;
the result covers one finding only.
