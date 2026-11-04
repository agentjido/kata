# Skill import queue

Purpose: Keep one de-duplicated queue of external skills that can improve Kata.

Status: Active TODO list
Last reviewed: 2026-11-04

## Scope

This queue uses only these local reference sources:

| Source | Snapshot | Skill entries reviewed | License |
| --- | --- | ---: | --- |
| [Compound Engineering](../../../references/compound-engineering-plugin/skills/) | `57e409e5c8c2c472106bd7d87ac72b724b70826b` | 33 | MIT, Copyright Every |
| [Original pstack](../../../references/cursor-plugins/pstack/skills/) | Cursor plug-ins snapshot `6ea74587e384e1a8035c09ae33a46fe3f881eb9b` | 58 | MIT, Copyright Lauren Tan |
| [Portable pstack](../../../references/pstack/skills/) | `7f2d936bba86c2c512c4ad83e759752f4f065b7c` | 53 | MIT, Copyright Lauren Tan |
| [Matt Pocock skills](../../../references/mattpocock-skills/skills/) | `3cca18b368ae95cdbdebbff572ccafa662551015` | 37 | MIT, Copyright Matt Pocock |

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

## Imported from portable pstack

The 2026-11-03 import added these active skills from portable pstack commit
`7f2d936bba86c2c512c4ad83e759752f4f065b7c`:

- `kata-benchmark-checklist`, `kata-blast-radius`, `bro`, `kata-correct`
- `kata-create-verification-skill`, `in-your-own-words`, `kata-interrogate`
- `ketchup` with text and video modes, `kata-no-comments`, `kata-recall`
- `sharpen`, `kata-show-your-work`, `kata-tdd`, `kata-technical-writing`
- `unslop`

The import also combined all 24 `principle-*` packages into one active
`kata-principled` skill with named commands and bundled reference files.

## Priority queue

Each row is one possible Kata skill. The source entries in a row are a source
set, not separate import tasks. Priority shows the suggested intake order. It
does not authorize an import.

### Ready for a real task

These jobs have broad use, clear source agreement, and no focused Kata skill.

| ID | TODO | Candidate | De-duplicated source set | Main ideas to retain |
| --- | --- | --- | --- | --- |
| Q01 | [ ] | `kata-debug` | CE `ce-debug`; Matt `diagnosing-bugs`; pstack bug-fix and performance playbooks, `principle-fix-root-causes` | Build a tight reproduction loop, trace a complete causal chain, test one hypothesis at a time, redact evidence, and separate diagnosis from an authorized fix. |
| Q02 | [ ] | `kata-code-review` | CE `ce-code-review`; Matt `code-review`; pstack `interrogate`, `blast-radius` | Review intent, requirements, repository rules, correctness, security, maintainability, and effects outside the diff. De-duplicate findings and require evidence for important safety claims. |
| Q03 | [x] | `kata-tdd` | Matt `tdd`; pstack `tdd`; the fix loop in CE `ce-debug` | Imported from portable pstack. Future evaluation can compare the other sources. |
| Q04 | [ ] | `kata-brainstorm` | CE `ce-brainstorm`; Matt `grilling` and `grill-with-docs`; pstack `architect` and `principle-exhaust-the-design-space` | Settle product behavior before implementation planning. Find facts in the environment, ask only decision questions, compare real alternatives, and leave a small requirements handoff for `kata-plan`. |
| Q05 | [ ] | `kata-prototype` | CE `ce-prototype`; Matt `prototype`; pstack prototype playbook, `arena`, and `principle-exhaust-the-design-space` | State the question first, choose a prototype that can answer it, compare alternatives when useful, let the user judge the result, and keep the prototype separate from production code. |

### Next candidates

These jobs are useful. They need a scope decision or a real task before import.

| ID | TODO | Candidate | De-duplicated source set | Decision needed |
| --- | --- | --- | --- | --- |
| Q06 | [ ] | `kata-architecture` | Matt `codebase-design`, `domain-modeling`, `improve-codebase-architecture`; pstack `architect` and architecture principles | Decide whether domain language and module design belong in one skill or two focused skills. Keep repository audit separate from design advice. |
| Q07 | [ ] | `kata-app-verification` | pstack `create-verification-skill`, `maintain-verification-skill`, `principle-prove-it-works`; CE `ce-dogfood`, `ce-test-browser`, `ce-test-xcode` | Define a host-neutral core for UI, CLI, service, and native-app verification. Decide whether creation and maintenance need separate skills. |
| Q08 | [ ] | `kata-review-feedback` | CE `ce-resolve-pr-feedback`; the review-response parts of CE `ce-babysit-pr`; pstack babysit playbook | Keep this separate from Q02. It must assess existing comments, apply only justified changes, and verify each resolution. Remove the GitHub-only assumption. |
| Q09 | [ ] | `kata-ship` | CE `ce-commit`, `ce-commit-push-pr`, `ce-babysit-pr`, `ce-worktree`; pstack babysit and shipping playbooks; Matt `implement` close-out | Set a safe boundary between local completion, commit, push, pull request, CI repair, and merge. Remote writes must remain explicit and host-neutral. |
| Q10 | [x] | `kata-learn` | CE `ce-compound`, `ce-compound-refresh`; pstack `reflect`, `show-me-your-work`, `principle-encode-lessons-in-structure`; Matt `retro` as secondary evidence | Folded durable capture and maintenance into `kata-docs`. Prefer code, tests, lint, or a skill change over duplicate prose. |
| Q11 | [ ] | `kata-handoff` | CE `ce-handoff`; pstack `recall` and pause/session-pickup playbooks; Matt `handoff` | Define one portable handoff contract. Do not duplicate task-history features supplied by a host. |

### Parked until a specific need appears

| ID | TODO | Candidate job | Sources | Reason to wait |
| --- | --- | --- | --- | --- |
| Q12 | [ ] | Research and decision rationale | Matt `research`; pstack `why`; CE research support in planning | `kata-plan` and `kata-neckbeard` already cover much of this work. A real task must show the missing boundary. |
| Q13 | [ ] | Metric-driven optimization | CE `ce-optimize`; pstack performance and hill-climb playbooks | The source procedures assume a repeatable metric and a long experiment loop. Test them on one measurable task first. |
| Q14 | [x] | Documentation review and maintenance | CE `ce-doc-review`; pstack `technical-writing`; Matt `writing-for-agents` | Implemented as the inbox and maintenance routes in `kata-docs`; `kata-sync-docs` keeps code-to-document reconciliation. |
| Q15 | [ ] | Issue and feedback triage | Matt `triage` and `to-tickets`; CE `ce-sweep` and `ce-product-pulse`; pstack Benny procedures | These sources depend on trackers, messaging services, or scheduled automation. Define a local, host-neutral core before import. |
| Q16 | [ ] | Strategy and long-range work | CE `ce-strategy`; Matt `wayfinder`; pstack multi-phase and orchestration playbooks | The job can become a large process framework. Confirm that it can remain one small personal skill. |
| Q17 | [ ] | Merge-conflict resolution | Matt `resolving-merge-conflicts` | It has only one source and a narrow trigger. Import it when a real conflict needs the procedure. |
| Q18 | [ ] | Human-only runbook generator | Matt `wizard` | It is useful for credentials and external dashboards, but it is not a common Kata job yet. |

## Already covered by Kata

Do not create another skill for these source clusters. Use them only as evidence
when the current Kata skill is revised.

| Current Kata skill | Source entries that overlap it |
| --- | --- |
| `kata-plan` | CE `ce-plan`; Matt `to-spec`, `to-tickets`, `wayfinder`; pstack multi-phase planning playbook |
| `kata-work` | CE `ce-work` and `lfg`; Matt `implement` and `implement-spec`; pstack `figure-it-out`, autonomous-run, and feature playbooks |
| `kata-neckbeard` | pstack `how` and parts of `why`; the investigation parts of Matt architecture skills |
| `kata-showme` | CE `ce-explain`; pstack `teach`; visual report ideas from Matt `improve-codebase-architecture` |
| `kata-write-skill` | CE `ce-retune`; pstack `automate-me` and skill-authoring playbook; Matt `writing-for-agents` |
| `kata-docs` | Former `kata-setup`; CE `ce-setup`, `ce-compound`, and `ce-compound-refresh`; pstack `setup-pstack`; Matt `setup-matt-pocock-skills` |

The current skill can still need improvement. Overlap means revise or evaluate
the current skill instead of adding a second entry point for the same job.

## Sources that are not queued

- The 24 pstack `principle-*` packages now live under one `kata-principled`
  entry point. Do not add them as separate catalog skills.
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
