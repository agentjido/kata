# Skill import queue

Purpose: Keep one de-duplicated queue of external skills that can improve Kata.

Status: Active TODO list
Last reviewed: 2026-11-04

## Scope

This queue uses only these local reference sources:

| Source | Snapshot | Skill entries reviewed | License |
| --- | --- | ---: | --- |
| [Compound Engineering](../../../references/compound-engineering-plugin/skills/) | `406b85c4562de3d415927fccc5e614c6554aab00` | 37 | MIT, Copyright Every |
| [Original pstack](../../../references/cursor-plugins/pstack/skills/) | Cursor plug-ins snapshot `6ea74587e384e1a8035c09ae33a46fe3f881eb9b` | 58 | MIT, Copyright Lauren Tan |
| [Portable pstack](../../../references/pstack/skills/) | `7f2d936bba86c2c512c4ad83e759752f4f065b7c` | 53 | MIT, Copyright Lauren Tan |
| [Matt Pocock skills](../../../references/mattpocock-skills/skills/) | `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` | 39 | MIT, Copyright Matt Pocock |
| [Addy Osmani agent skills](../../../references/addyosmani-agent-skills/skills/) | `301b02b12bff98e4688e6984af6556802322bbde` | 25 | MIT, Copyright Addy Osmani |
| [Superpowers](../../../references/superpowers/skills/) | `22f0b463e7a5e579904dd6211a520321035526f7` | 15 | MIT, Copyright Jesse Vincent |

The pstack counts include 24 small principle skills. The original collection
also has host-specific packages that the portable fork omits. The Matt Pocock count includes eight skills under
`in-progress/`. Those skills are evidence, but they are not primary import
candidates.

No other reference collection is in scope. Test fixtures are not skills and are
not in the counts.

## De-duplication rules

Use the job as the unit of comparison. Similar source names do not require
separate Kata skills.

1. Keep one Kata candidate for one user job.
2. Record each source procedure that has a useful, different idea.
3. Fold pstack principle skills into a task skill. Do not import each principle
   as a separate skill.
4. Do not queue a new skill when a current Kata skill already owns the job.
5. Keep host-specific commands, model names, issue trackers, and services out of
   the Kata version.
6. Import a candidate only after a real task shows the need.
7. Preserve the source license and add author credit to the root README.

## Portable pstack disposition

The 2026-11-03 import added skills from portable pstack commit
`7f2d936bba86c2c512c4ad83e759752f4f065b7c`. The 2026-11-04 curation kept
`kata-technical-writing` as an active adaptation.

It folded focused methods into current owners:

- repository-guard creation into `kata-work` and its independent proof into
  `kata-verify`;
- benchmark, blast-radius, adversarial-review, and comment-review methods into
  `kata-verify`;
- recent-work recall into `kata-understand`;
- test-first repair and decision logging into `kata-work`;
- project verification-skill creation into `kata-write-skill`; and
- AI-pattern cleanup into `kata-technical-writing`.

It retired `bro`, `in-your-own-words`, `ketchup`, `kata-principled`, and
`sharpen` as active packages.

## Priority queue

Each row is one possible Kata skill. The source entries in a row are a source
set, not separate import tasks. Priority shows the suggested intake order. It
does not authorize an import.

### Ready for a real task

These jobs have broad use, clear source agreement, and no focused Kata skill.

| ID | TODO | Candidate | De-duplicated source set | Main ideas to retain |
| --- | --- | --- | --- | --- |
| Q01 | [x] | `kata-debug` | CE `ce-debug`; Matt `diagnosing-bugs`; pstack bug-fix and performance playbooks, `principle-fix-root-causes` | Implemented as `kata-debug` with diagnosis-only and authorized-repair boundaries. |
| Q02 | [x] | Code review | CE `ce-code-review`; Matt `code-review`; pstack `interrogate`, `blast-radius` | Folded into the compound `kata-verify` router as a focused code-review method. |
| Q03 | [x] | Test-first defect repair | Matt `tdd`; pstack `tdd`; the fix loop in CE `ce-debug` | Folded the focused method into `kata-work`. Future evaluation can compare the other sources. |
| Q04 | [x] | `kata-idea` | CE `ce-brainstorm`; Matt `grilling` and `grill-with-docs`; pstack `interrogate` and architecture principles | Implemented with Explore, Grill, and Challenge methods and a requirements-only Product Contract handoff to `kata-roadmap` or `kata-plan`. |
| Q05 | [ ] | `kata-prototype` | CE `ce-prototype`; Matt `prototype`; pstack prototype playbook, `arena`, and `principle-exhaust-the-design-space` | State the question first, choose a prototype that can answer it, compare alternatives when useful, let the user judge the result, and keep the prototype separate from production code. |
| Q16 | [x] | `kata-roadmap` | Matt `wayfinder` | Implemented as a durable decision roadmap with Beadwork or single-writer CSV state. Removed required companion skills, automatic branches, pushes, and generic issue-tracker setup. |

### Next candidates

These jobs are useful. They need a scope decision or a real task before import.

| ID | TODO | Candidate | De-duplicated source set | Decision needed |
| --- | --- | --- | --- | --- |
| Q06 | [ ] | `kata-architecture` | Matt `codebase-design`, `domain-modeling`, `improve-codebase-architecture`; pstack `architect` and architecture principles | Decide whether domain language and module design belong in one skill or two focused skills. Keep repository audit separate from design advice. |
| Q07 | [ ] | `kata-app-verification` | pstack `create-verification-skill`, `maintain-verification-skill`, `principle-prove-it-works`; CE `ce-dogfood`, `ce-test-browser`, `ce-test-xcode` | Creation is now a `kata-write-skill` specialization. A real task must show that verification execution or maintenance needs a separate active skill. |
| Q08 | [ ] | `kata-review-feedback` | CE `ce-resolve-pr-feedback`; the review-response parts of CE `ce-babysit-pr`; pstack babysit playbook | Keep this separate from Q02. It must assess existing comments, apply only justified changes, and verify each resolution. Remove the GitHub-only assumption. |
| Q09 | [x] | `kata-shipit` | CE `ce-commit-push-pr`; Superpowers `finishing-a-development-branch`; Kata `kata-commit` | Replaced `kata-commit` with separate Commit, Ship, Watch, and Land authority routes. |
| Q10 | [x] | `kata-learn` | CE `ce-compound`, `ce-compound-refresh`; pstack `reflect`, `show-me-your-work`, `principle-encode-lessons-in-structure`; Matt `retro` as secondary evidence | Folded durable capture and maintenance into `kata-docs`. Prefer code, tests, lint, or a skill change over duplicate prose. |
| Q11 | [ ] | `kata-handoff` | CE `ce-handoff`; pstack `recall` and pause/session-pickup playbooks; Matt `handoff` | Define one portable handoff contract. Do not duplicate task-history features supplied by a host. |

### Parked until a specific need appears

| ID | TODO | Candidate job | Sources | Reason to wait |
| --- | --- | --- | --- | --- |
| Q12 | [ ] | Research and decision rationale | Matt `research`; pstack `why`; CE research support in planning | `kata-plan` and `kata-understand` already cover much of this work. A real task must show the missing boundary. |
| Q13 | [ ] | Metric-driven optimization | CE `ce-optimize`; pstack performance and hill-climb playbooks | The source procedures assume a repeatable metric and a long experiment loop. Test them on one measurable task first. |
| Q14 | [x] | Documentation review and maintenance | CE `ce-doc-review`; pstack `technical-writing`; Matt `writing-for-agents` | Implemented as the inbox and maintenance routes in `kata-docs`, including bounded code-to-document reconciliation. |
| Q15 | [ ] | Issue and feedback triage | Matt `triage` and `to-tickets`; CE `ce-sweep` and `ce-product-pulse`; pstack Benny procedures | Use the queued `docs/agents/issues.md` contract first. Support GitHub only through `gh` and Jira only through tested `twg` guidance. Keep messaging and schedules separate. |
| Q17 | [ ] | Merge-conflict resolution | Matt `resolving-merge-conflicts` | It has only one source and a narrow trigger. Import it when a real conflict needs the procedure. |
| Q18 | [ ] | Human-only runbook generator | Matt `wizard` | It is useful for credentials and external dashboards, but it is not a common Kata job yet. |

## Already covered by Kata

Do not create another skill for these source clusters. Use them only as evidence
when the current Kata skill is revised.

| Current Kata skill | Source entries that overlap it |
| --- | --- |
| `kata-roadmap` | Matt `wayfinder`; CE strategy and pstack orchestration remain unadopted reference evidence. |
| `kata-plan` | CE `ce-plan`; Matt `to-spec` and `to-tickets`; pstack multi-phase planning playbook. The current package uses these only as source evidence for one deep software-planning suite. |
| `kata-idea` | CE `ce-brainstorm`; Matt `grilling` and `grill-with-docs`; pstack `interrogate` |
| `kata-work` | CE `ce-work` and `lfg`; Matt `implement` and `implement-spec`; pstack `correct`, `figure-it-out`, autonomous-run, and feature playbooks |
| `kata-verify` | CE and Matt code review; Addy Osmani security review; pstack `correct`, `benchmark-checklist`, `blast-radius`, `interrogate`, and `no-comments` |
| `kata-shipit` | CE `ce-commit-push-pr`; Superpowers `finishing-a-development-branch`; the former `kata-commit` boundary |
| `kata-understand` | pstack `recall`, `how`, and parts of `why`; the context-reconstruction part of CE `ce-handoff`; the investigation parts of Matt architecture skills |
| `kata-showme` | CE `ce-explain`; pstack `teach`; visual report ideas from Matt `improve-codebase-architecture` |
| `kata-write-skill` | CE `ce-retune`; pstack `automate-me` and skill-authoring playbook; Matt `writing-for-agents` |
| `kata-docs` | Former `kata-setup`; CE `ce-setup`, `ce-compound`, and `ce-compound-refresh`; pstack `setup-pstack`; Matt `setup-matt-pocock-skills` |
| `kata-technical-writing` | pstack `technical-writing` and `unslop`; Matt `writing-for-agents` prose guidance |

The current skill can still need improvement. Overlap means revise or evaluate
the current skill instead of adding a second entry point for the same job.

## Sources that are not queued

- The 24 pstack `principle-*` packages are retired from the active catalog.
  Keep them only as source references unless repeated task evidence supports a
  focused method.
- Do not import the pstack router skill `poteto-mode`.
- Do not import pstack service or product helpers such as `make-bot-ui`,
  `setup-pstack`, and the dormant Benny automation pack.
- Do not import the Matt Pocock `in-progress/` writing experiments or
  product-specific `misc/` migrations and exercise scaffolds. `retro` can inform
  Q10, but it is not the primary source.
- Do not import CE service-specific procedures such as `ce-proof`,
  `ce-riffrec-feedback-analysis`, or `ce-test-xcode` as general skills. A useful
  host-neutral rule can still inform Q07 or Q15.
- Do not queue aliases or large orchestration wrappers. Kata should keep small,
  separate skills that a user can request by job.

## Import TODO template

Complete this list for one queue item at a time. Use `kata-write-skill` only when
the user requests the import.

- [ ] Confirm a real task needs the candidate and name the missing capability in
  current Kata.
- [ ] Re-read every source package named in the queue row, including its linked
  support files.
- [ ] Record the exact source commit, author, license, and files that will be
  adapted.
- [ ] Write one outcome contract and explicit non-goals before adapting text.
- [ ] Select the smallest compatible parts from the source set. Do not combine
  all source procedures by default.
- [ ] Remove host names, fixed model names, service assumptions, and calls to
  other skills.
- [ ] Create `skills/<kata-name>/SKILL.md` with matching standard frontmatter.
- [ ] Select a subject from the canonical vocabulary by the knowledge needed to
  judge the result, and write it to `metadata.subject`.
- [ ] Copy required license notices and add author attribution to `README.md`.
- [ ] Add focused fixtures and outcome checks for the real task.
- [ ] Run the skill on the task and record failures, cost, and useful behavior.
- [ ] Revise or reject the candidate from evidence. Do not keep two Kata skills
  for the same job.
- [ ] Update this queue, the root skill table, and the documentation index.

## Maintenance

When a source snapshot changes, compare new skill entry files and descriptions
against this queue. Add a new row only when the new job does not fit a current
Kata skill or an existing candidate. Update counts and commit hashes in the same
change.
