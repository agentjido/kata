> **Paused.** The evaluator review found expensive baseline restarts and false
> checker failures. Use [the revised process](README.md) for future runs. Keep the
> old worktree evidence unchanged. Do not resume these live loops before their
> suites are calibrated and moved to the revised evaluator.

# Astra xhigh optimization plan

Plan the next evaluation round for `kata-ex-coverage`, `kata-ex-hunt-dead-code`,
`kata-neckbeard`, and `kata-showme`. `kata-setup` is complete and excluded from this
round. Keep its source and saved evidence intact.

Use `codex-astra-xhigh`: Codex through `jido_harness`, model `gpt-6-astra`, reasoning
`xhigh`, for both skill execution and proposals. Keep one source skill per name.
Keep attribution in README.md and required license files, never in SKILL.md.

Implementation update: the main checkout now has the shared suite runner and
setup/neckbeard adapters. See the [evaluation guide](README.md). The active live
worktrees keep their frozen runner version; this refactor does not change their
measurements. The remaining sections retain the original round's design.

## Current state

| Skill | Current words | Main evaluation need |
| --- | ---: | --- |
| `kata-ex-coverage` | 705 | Correct figures, locations, and priorities in find and analyze modes. |
| `kata-ex-hunt-dead-code` | 436 | Correct audit findings and safe, explicitly requested removals. |
| `kata-neckbeard` | 370 | Correct claims and citations, clear uncertainty, no project edits. |
| `kata-showme` | 472 | Correct visual relationships and usable artifacts; human review of clarity. |

These counts include frontmatter. Coverage needs a candidate within 500 words.
The other skills need measured execution improvements, not forced shortening.

The original runner selected by word count. Its prompts, validator, paths, and
checks selected setup directly, its Harness wrapper dropped the final answer,
and `--fresh` replaced case files. That implementation is now isolated under
`KataEvolve.Setup` for historical commands. New suites use the shared runner.

## 1. Complete the shared runner once

The coverage task owns this shared work for the first round. It publishes a
separate runner commit for the other tasks. Skill tasks must not each build a runner.

1. Add a small suite adapter for source/support files, validation, case preparation,
   prompt, allowed changes, and independent ExUnit outcome assertions. Dedicated
   Mix tasks are sufficient. Avoid a test-definition language.
2. Retain the final answer outside the target project. Read-only skills must not
   write an output file just to satisfy the evaluator. Save one final answer or
   artifact, final files, and compact measurements; discard intermediate output.
   Handle Harness's bounded `text` and `text_truncated?` fields. Recover the complete
   final response from retained events when needed; incomplete capture cannot pass.
3. Select by the documented quality formula against a fixed passing reference.
   Make format and output validation specific to the selected skill. Freeze the
   source, support files, fixtures, checker, profile, host settings, and scoring
   version. Include paths and file types in context hashes. Use required checks
   per case, not setup's common check list. Keep final-case feedback out of proposal input.
4. Add a verify-only operation and immutable batch/case/repetition records. A
   failed attempt remains in its batch. A retry starts new evidence; it must not
   replace a failure or count cached results as fresh executions.
5. Enforce the declared file-change policy. The current snapshot omits some paths
   and file properties. Read-only cases must detect source edits, index/HEAD changes,
   deleted files, and unexpected output; allow only declared build artifacts when
   a case needs compilation. Keep the evaluator outside the editable project.

Use equal, fixed per-call limits. Stop between calls when the remaining budget
cannot cover another call; do not shorten later calls to fit the deadline.
Confine each execution to its fixture and skill package. A prompt alone cannot
protect the evaluator or prevent access to final cases. For read-only cases,
enforce read-only access as well as checking final state.

Generalize the existing calculation with an explicit suite/checker identity.
Preserve setup's old commands and saved scores with local regression checks.
No new live setup run is needed for this work.

## 2. Define and calibrate each suite

Start with one training case and two distinct final cases. Each skill task must
specify the exact contract before implementation. Cover different modes through
these cases without sending final-case answers to the proposer.

| Skill | Training | Final cases | Required outcome |
| --- | --- | --- | --- |
| `kata-ex-coverage` | Find weak modules using fixed coverage, Git history, and a progress tracker. | Analyze an umbrella module with stale coverage; handle missing coverage. | Exact module figures, source paths, uncovered line blocks, and freshness; no unsolicited file changes. |
| `kata-ex-hunt-dead-code` | Audit an unused cycle while retaining public, quoted, and runtime references. | Audit an umbrella project with explicit roots; remove only an authorized group with dedicated and mixed tests. | Exact candidate groups; audit preserves files; removal preserves live tests and passes clean compilation and independent runtime checks. |
| `kata-neckbeard` | Explain a Python retry policy where the guide conflicts with code. | Explain TypeScript cache boundaries; inspect a Python/SQL export beside a decoy project. | Exact behavior and limits, supporting citations, explicit missing design evidence, and no file changes. |
| `kata-showme` | Show a JavaScript call tree with exact ownership and order. | Draw a Python job sequence in Mermaid; create an HTML view of three job states. | Exact tree and message relationships; rendered visible data, working links, desktop/mobile checks, and only the permitted HTML file. |

Use deliberately correct and incorrect outputs to test each checker locally.
Include missing outputs, wrong values, reversed relationships, misleading citations,
and forbidden edits as applicable. A model's success statement cannot pass a case.
Keyword presence alone is not proof of a correct explanation. Fix the answer
contract and define unsupported cases that still need human review.

Keep answer checks small and case-specific. Parse ordinary tables, citations,
trees, or diagrams where they give a clear contract. Accept valid paraphrases;
unrecognized prose needs review and must not receive an automatic passing score.
Do not build a general natural-language grader for this first round.

Check the existing helper tools before freezing them. The coverage review found
possible differences between the skill and helper in report selection, freshness,
and path matching. The dead-code roots template can suggest editing its shared
copy. Confirm these points with small local checks and fix actual defects before
text tuning. Keep helper files fixed during the experiment. Prepare coverage
timestamps explicitly because Git does not preserve them.

For showme, preserve format choice in ordinary use. A fixture may explicitly ask
for Mermaid or HTML to exercise that mode. Test rendering where possible and use
human review for visual clarity; do not claim that DOM checks prove design quality.

## 3. Tune and verify

1. Run the source three times on every case: nine fresh executions. All outcome
   tests must pass. Freeze these costs as the full-suite reference before search.
   If a test fails, diagnose the fixture, tool, or skill before starting a new series.
2. Record one separate source training execution as the exploratory reference,
   then run up to five proposal rounds. Require all
   output assertions, valid format, and at most 500 words for an eligible candidate.
   Compare integer score units; keep the parent on a tie. Store proposal costs
   separately from skill execution costs. Include the intended Astra metadata in
   the text before evaluation so promotion can copy the exact tested file.
3. Keep the highest eligible training candidate. If there is no promising candidate,
   record that result and stop rather than running unnecessary final measurements.
4. Verify the unchanged selected text in a fresh full-suite batch: three independent
   executions per case. Every execution must pass. Compare with the frozen repeated
   source reference using per-case medians and the fixed 70% token, 20% tool-call,
   and 10% elapsed-time weights. Keep the same execution settings and case order.
5. Promote only a candidate within the word limit whose full-suite cost score is
   above the fixed reference and whose manual review passes. Review scope, safeguards,
   references, and visual quality where applicable. A failed final case rejects the
   candidate; do not use it as feedback for another proposal on the same benchmark.
6. Copy the exact reviewed artifact to its canonical `skills/<name>/SKILL.md`.
   Preserve the tested Astra metadata and `language: elixir` on the
   two Elixir skills. Commit the skill, fixtures, report, and compact evidence together.

Coverage's source exceeds the word limit. Its own eligibility score is 0, but
passing source executions can supply the fixed cost denominator. A valid candidate
must beat the neutral cost reference of 50; it cannot win merely by beating 0.
The source's long form is evidence, not an exception to the candidate word limit.

For this three-case design, a full five-round experiment uses up to 29 live
calls: nine source verification calls, one training reference, five proposals,
five candidate training calls, and nine selected-candidate verification calls.
Four complete experiments total up to 116 calls,
before retries or any added cases. These are call counts, not token or time estimates.
Use per-call and per-skill budgets; retain progress when a budget is reached.

## 4. Coordinate the four tasks

The user has authorized implementation and live optimization in four separate
Git worktrees. This document combines the task plans and sets one shared protocol.
Each task owns its suite, fixtures, result paths, and skill. Coverage also owns the
shared runner and publishes that work as a separate commit. The other tasks prepare
and calibrate their suites in parallel, then cherry-pick the shared runner commit.
Start the first live batch on coverage. Run the remaining live batches in order:
dead-code hunting, neckbeard, then showme. This keeps live measurement load stable.
Each task returns its best verified result and commits for integration; it must not
edit the main checkout or push. A no-improvement result is a valid outcome.

| Skill | Planning task ID |
| --- | --- |
| `kata-ex-coverage` | `01a07318-9f84-7b32-9083-a34466304d3f` |
| `kata-ex-hunt-dead-code` | `01a07318-c06e-7492-81fd-77577893f8de` |
| `kata-neckbeard` | `01a07318-c290-7052-b0bd-3691b70e737f` |
| `kata-showme` | `01a07318-c595-7751-9118-c05d7ff8ec34` |

Ownership paths are `test/fixtures/<skill-id>/`, skill-specific files under
`test/skills/`, and `results/<skill-id>/codex-astra-xhigh/`, relative to `evals/`.
Shared changes to Harness, storage, score calculation, or command dispatch belong
to the coverage task. Use the complete skill name as its suite ID, including showme.

Done means each skill has either a verified candidate adopted from its exact saved
file or a recorded no-improvement result. Setup remains outside this round.
