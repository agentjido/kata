# Evaluator review — 2026-09-05

The process spent most model calls preparing or repairing the evaluator. It did
not establish an improved official skill. Only showme reached proposal rounds.
The four live loops remain paused while the evaluator is repaired offline.

These totals come from saved case/proposal records and the coverage abort record
in the four `astra-*-20260905` worktrees. `KataEvolve.Usage.summary/1` reproduces
them from each `evals/results/<skill>/codex-astra-xhigh` directory.

| Skill | Started calls | Proposals | Recorded tokens | Tool calls | Recorded seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
| Coverage | 22 | 0 | 1,998,717 | 178 | 1,242.248 |
| Hunt dead code | 3 | 0 | 543,658 | 53 | 506.720 |
| Neckbeard | 1 | 0 | 66,886 | 7 | 61.884 |
| Showme | 24 | 5 | 1,496,963 | 80 | 1,413.666 |
| Total | 50 | 5 | 4,106,224 | 318 | 3,224.518 |

One interrupted coverage call has no metrics. Token and time totals exclude that
unknown cost and all coordinating-agent use. Seconds are summed call time, not
wall-clock duration. No reset credit or live call was used for this repair.

## Causes

- Nine full source executions plus a separate training call were required before
  the first proposal. A failed source outcome stopped useful search early.
- One context hash mixed project preparation, expected outcomes, parser code, and
  the score rule. Small parser corrections restarted paid source baselines.
- Finite prose patterns rejected valid table layouts, date formats, module names,
  citation spacing, and statements of uncertainty. Local good examples were too
  close to the parser's own assumptions.
- Execution problems, parser problems, and actual wrong outcomes were not clearly
  separated. A partial baseline and an execution error could lock a batch.
- Handwritten status files became stale. There was no central dispatch budget.

The coverage source also had a real missing refresh recommendation. Showme's five
candidates did not beat the fixed training cost reference. Those results must not
be converted into successes to make the process look better.

## Changes

- Start with one passing training reference. Run at most five proposal rounds.
  Reuse training evidence for duplicate text. Skip full verification if no
  candidate beats the reference. For the current three-case layout, unsuccessful
  tuning drops from 20 to at most 11 calls. Full verification remains three fresh
  runs per case for both versions, up to 29 total calls with five rounds.
- Separate execution contracts from checker revisions. Save new assessments keyed
  by checker revision and raw record SHA256. Preserve the original execution,
  verdict, final files, and cost. New fixtures/prompts/models need new executions.
- Stop on checker error, capture error, missing metrics, or undecidable output.
  These are unscored under `skill-quality-v2`. Proven wrong candidate outputs still
  score zero. No model judge or automatic review approval was added.
- Record each dispatch before the call. Enforce cumulative call/token limits.
  Resume missing slots. An explicit error retry saves a linked attempt for only
  that slot; completed wrong outputs cannot be replaced. Count all attempts.
- Derive status from evidence. Stop proposals once final verification starts and
  fix its candidate/batch. Keep final feedback out of further proposals.
- Repair the neckbeard example using the unchanged real output. Support ordinary
  table columns, shared guide paragraph citations, trimmed link destinations,
  and the phrase “does not explain the choice.” Counterexamples still reject
  wrong counts, swapped subjects, unrelated evidence, and invented history.

The [saved neckbeard record](test/fixtures/kata-neckbeard/replay/train-retry-1.json)
still has its original failed result. The current checker passes it offline. This
is evidence of a repaired checker, not a new execution, a reliable skill score,
or human approval. Old combined contexts are available for diagnostic replay;
they are not automatically imported into a new baseline.

## Next live step

Run one skill at a time until its checker passes calibration and one live training
case. Integrate the remaining worktree suites with separate preparation inputs.
Use their saved answers to test repairs before any model call. Then run a bounded
training search. Parallel skill loops can resume after that path is stable.

These defects are in Kata's evaluator and suite checks. This review found no new
`jido_harness` or `jido_evolve` defect that requires an upstream issue. Official
skills and their previous setup evidence were not changed by this repair.
