# Skill provenance and retention index

Purpose: Show where each active skill came from and record the applied skill
retention decisions.

Status: Current

Last reviewed: 2026-11-04

## Summary

Direct inspection found 19 active skill packages.

| Primary origin | Count | Meaning |
| --- | ---: | --- |
| Kata-native | 12 | The package was first written as part of the Kata work system. Some packages now contain folded source methods. |
| In-house source | 2 | Mike Hostetler or Jason Allum wrote the earlier source. Kata adapted or migrated it. |
| Hybrid | 1 | Kata owns the workflow, but it adapts ideas and methods from named external sources. |
| External adaptation | 4 | Kata adapted the active package from an external project. |

The root [README attribution section](../../README.md#attribution), package
license files, and current package files support this index.

## Active skills

### Kata-native

| Skill | Current job | Folded source method |
| --- | --- | --- |
| `jido` | Select the smallest Kata route for an explicit request. | None. |
| `kata-commit` | Create one local commit from verified work. | None. |
| `kata-docs` | Set up and maintain Docs Kata, including bounded code-to-document reconciliation. | Earlier Jido docs-sync material. |
| `kata-dojo` | Run an explicitly requested skill evaluation. | None. |
| `kata-ex-design-review` | Review Elixir and OTP design. | None. |
| `kata-ex-quality` | Find, backlog, batch, and fix bounded Elixir quality findings. | Jason Allum's focused coverage and dead-code methods and analyzers. |
| `kata-maintain-skill` | Resolve one skill-library maintenance finding. | None. |
| `kata-orient` | Maintain scoped `AGENTS.md` and entry-point `README.md` files. | None. |
| `kata-status-report` | Report local and remote Git workbench state. | None. |
| `kata-understand` | Establish current condition or reconstruct recent work context. | pstack `recall`. |
| `kata-verify` | Judge one candidate and run selected focused verification methods. | pstack `benchmark-checklist`, `blast-radius`, `interrogate`, and `no-comments`. |
| `kata-work` | Produce one candidate result with optional test-first or decision-log methods. | pstack `tdd` and `show-me-your-work`. |

### In-house source

| Skill | Earlier source |
| --- | --- |
| `kata-build-jido` | Mike Hostetler's `agentjido/jido-skills` action, agent, runtime, AI, and test material. |
| `kata-neckbeard` | Jason Allum's private `neckbeard` skill. |

### Hybrid

| Skill | Source relationship |
| --- | --- |
| `kata-write-skill` | Kata owns the workflow. It adapts authoring ideas from Matt Pocock and Compound Engineering and the pstack project-verification-skill method. |

### External adaptations kept

| Skill | External source | Decision reason |
| --- | --- | --- |
| `kata-plan` | Compound Engineering `ce-plan` | Planning is a core Kata step with a distinct result. |
| `kata-showme` | HumanLayer `show-me` | Visual explanation is a distinct job that prose does not replace well. |
| `kata-correct` | pstack `correct` | It turns repeated mistakes into structural controls. |
| `kata-technical-writing` | pstack `technical-writing` and Mike Hostetler's Elixir documentation guidance | It owns one document-writing job and now contains the former `unslop` cleanup mode. |

## Applied folds

| Former skill | Current owner |
| --- | --- |
| `kata-benchmark-checklist` | `kata-verify` benchmark reference. |
| `kata-blast-radius` | `kata-verify` blast-radius reference. |
| `kata-create-verification-skill` | `kata-write-skill` Create specialization. |
| `kata-ex-coverage` | `kata-ex-quality` coverage rules and analyzer. |
| `kata-ex-hunt-dead-code` | `kata-ex-quality` dead-code rules, analyzer, roots template, and false-positive reference. |
| `kata-interrogate` | `kata-verify` adversarial-review reference. |
| `kata-no-comments` | `kata-verify` comment-review reference. |
| `kata-recall` | `kata-understand` recall mode. |
| `kata-show-your-work` | `kata-work` decision-log method. |
| `kata-tdd` | `kata-work` test-first method. |
| `unslop` | `kata-technical-writing` AI-pattern cleanup mode. |

## Retired external skills

| Skill | Reason |
| --- | --- |
| `bro` | Plain restatement is normal conversation behavior. |
| `in-your-own-words` | Goal restatement belongs in normal conversation or understanding work. |
| `ketchup` | Current-chat summary is normal host behavior. Its video mode added a large path for a small job. |
| `kata-principled` | The 24-command package added a large rule catalog without task-use evidence. |
| `sharpen` | Normal prompt editing can apply its small "deeper, not bigger" rule. |

## Other consolidation decisions

- `kata-jido-action`, `kata-jido-agent`, `kata-jido-ai`, and
  `kata-jido-testing` became `kata-build-jido`.
- `kata-review-pr` retired.
- `kata-sync-docs` retired. `kata-docs` maintenance now owns bounded
  code-to-document reconciliation.

## Admission rule

Add a separate active skill only when real tasks show all of these facts:

1. The job occurred at least twice.
2. Its result differs from a current core result.
3. Its method contains judgment that a normal request does not supply.
4. A command, mode, or reference cannot preserve the method well.
5. The job is worth one active catalog entry.
