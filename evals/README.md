# Skill evaluation

Use one small suite per skill. Codex runs the skill through `jido_harness`, with
**gpt-6-astra / xhigh** as the default. Keep the official skill in `skills/`.
Keep fixtures, candidate text, final answers, final files, and costs in Git.
Do not save tool transcripts or intermediate output.

## Run an optimization

Run from `kata/evals`. Set `JIDO_HARNESS_PATH` if the local dependency is elsewhere.
Run `mix deps.get` once, then:

```sh
mix check
mix skill.eval suites/neckbeard.exs train
mix skill.eval suites/neckbeard.exs tune --attempts 5 --max-calls 11
mix skill.eval suites/neckbeard.exs status
```

`tune` creates the training reference if it is missing. The separate `train`
command lets you inspect the first answer before spending on proposals.
`baseline` is an alias for `train`; it no longer runs the full suite.

1. **Calibrate offline.** Test saved correct outputs and deliberate faults. Check
   actual content, links, values, relationships, and preserved files. An agent's
   claim of success is insufficient.
2. **Run one training reference.** It must pass its ExUnit outcome test and have
   valid measurements. Stop and diagnose a failure before more calls.
3. **Tune on training cases only.** Make up to five proposals. Test each distinct
   candidate once per training case. Keep a candidate only if every outcome passes
   and its cost score improves. Repeated candidate text reuses its saved execution.
4. **Stop if there is no improvement.** Keep the official skill. A shorter skill
   with higher execution cost is not an improvement.
5. **Verify one promising candidate.** Run three fresh executions per case for
   both source and candidate. The training screen must pass with a score above 50
   before these calls start. No proposals can follow verification in that context.
6. **Review and adopt.** Require every final outcome to pass, a full score above
   50, at most 500 words, and review of behavior the checks do not cover. Copy the
   exact tested candidate to `skills/<name>/SKILL.md`. Commit the suite and evidence
   with it. The runner does not replace official skills.

Use the candidate path printed by `tune`:

```sh
mix skill.eval suites/neckbeard.exs verify --candidate PATH --max-calls 30
```

With one training case and two final cases, five unsuccessful rounds need at most
**11 calls**, down from 20. The first proposal follows one source call, instead of
ten. A complete experiment that reaches verification still needs up to **29 calls**.
These are protocol counts, not measured token savings. Proposal calls count too.

The verification candidate and batch name are fixed at first use. A resumed command
fills missing slots. It cannot discard a failed completed answer by changing the
batch name. Final-case feedback must never enter proposals for the same benchmark,
including through a new context or worktree.

## Proposal prompt

Edit [prompts/propose_skill.md](prompts/propose_skill.md) to change the shared
revision prompt. The runner appends the suite's `proposal_instructions/0` and uses
the selected execution profile for proposals too. Astra xhigh remains the default.

The v3 prompt permits **full rewrites against a fixed outcome contract**. A
proposal can delete, replace, combine, or reorder instructions. It must preserve
required behavior, scope, safeguards, and support references. One testable
hypothesis can require many edits. The brief change, expected saving, and risk
note stays outside the skill. Measured cost after outcome passes decides selection.
A shorter skill is not enough.

The three search directions are `remove-procedure`, `replace-workflow`, and
`refine-evidence`. Longer searches cycle through them with updated feedback. The
best valid measured candidate remains the parent; previous candidate text is
also available for useful ideas. We have not added a population search.

Each suite can declare `outcome_contract/0`: a small list of required outcomes,
without fixture answers or instructions about the method. The contract and its
hash are in every proposal and the frozen search policy. Existing suites without
this callback conservatively preserve the source behavior. The assigned approach
can vary; the outcome contract and final acceptance rules cannot.

The proposer receives four small inputs:

| File | Purpose |
| --- | --- |
| `SKILL.md` | Current parent; the only file it can edit. |
| `reference.md` | Original source, to preserve scope and required behavior. |
| `previous.md` | Last attempted skill, when present, including a rejected revision. |
| `feedback.json` | Fixed outcome contract, search approach, target profile, labeled hashes and scores, prior decisions/reasons, and training observations. |

Feedback includes the actual training task, outcome checks, measured costs, and
bounded excerpts of the answer and changed files. It reuses duplicate observations
and excludes unchanged project files. It rejects final-case or mismatched records.
Answers are capped at 4,000 characters; file excerpts at six files of 1,200
characters each. Truncation is explicit. Tool counts are available; tool commands
and intermediate output are not. Costs support a hypothesis, not a proven cause.

The prompt keeps scope, safeguards, verification, and support references fixed.
It forbids fixture-specific answers and changes made only to satisfy a parser.
If an approach supports no useful change, the proposer leaves the file unchanged.
The runner skips that candidate call and continues with the next approach within
the same budget. Identical candidates reuse evidence. There is no metadata-only
edit or automatic budget increase.

Each proposal saves its compact feedback and prompt hash. The search policy saves
the full rendered prompt and feedback-builder hash. A prompt or builder change
stops resume of that search; old proposal decisions are not silently reused.
The [three-round Astra trial](results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v2-three-rounds-20260905/report.md)
completed seven live calls. Parser failures blocked its candidates. The source
was retained. Its saved answers now calibrate citation placement, table comparisons,
and delay expressions; unresolved claims require review instead of a false failure.
The original scores remain intact. The [Astra search notes](ASTRA_TUNING_NOTES.md)
explain why v3 allows broader rewrites.
The [three-round v3 trial](results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/report.md)
selected a passing 290-word candidate with an exploratory score of 57.809727.
One candidate remained unscored after an explicit review disposition; the final
proposal continued from the passing parent without changing the checker.
The user then requested adoption of that exact Round 1 candidate into
`skills/kata-neckbeard/SKILL.md`. The
[adoption record](results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/adoption.json)
records this decision separately from the trial. Repeated verification and final
cases have not run; the score remains exploratory.

## Repair a checker without model calls

Execution identity and checker identity are separate. A run fixes the source,
project inputs and preparation code, prompts, support files, model, tools, and
execution settings. A checker revision fixes the expected outcomes, checker code,
and score rule. Changes to checks create new assessments of the same saved output.
They do not create new executions or replace old results.

```sh
mix skill.eval suites/neckbeard.exs check --context CONTEXT_ID
mix skill.eval suites/neckbeard.exs score --context CONTEXT_ID --batch candidate-full-HASH_PREFIX
```

The runner prints the context ID when a live command starts. Both offline commands
use saved source text and require no Codex executable. A changed prompt, fixture,
preparation file, or support file cannot reuse an old execution contract. All
score inputs must use the same checker revision. A checker change during search
stops further proposals; first recheck and inspect the saved evidence. Do not
restart a paid series automatically to debug a parser.

Old v2 contexts did not separate execution inputs from checkers. Keep them as
historical evidence. You can diagnose an old record with the current checker:

```sh
mix skill.eval suites/neckbeard.exs check --record test/fixtures/kata-neckbeard/replay/train-retry-1.json
```

This saves a new assessment keyed by the raw record hash. It does not import that
run into a new baseline or certify that old contexts are comparable. The neckbeard
example includes the unchanged real answer that exposed the first checker defect.
Its table, shared paragraph citation, and uncertainty statement now pass offline.
This is a checker repair, not a skill promotion or a new live quality measurement.

## Stop rules and costs

The default limits are **30 started calls and 2,000,000 recorded tokens per
execution context**. Set `--max-calls N` and `--max-tokens N` to change them. Limits
apply across resumed commands, candidates, proposals, and retries. The token limit
is checked before dispatch; one call can exceed the remaining token allowance.
A call also has a ten-minute time limit. An unfinished dispatch blocks new calls.

`status` calculates calls, proposals, errors, missing measurements, tokens, tool
calls, and elapsed milliseconds from saved evidence. It does not use a manually
updated status file. `--context ID` limits the report to one context; `--results
PATH` reads an existing result directory, including an old worktree. Known tokens
exclude any call whose usage was not returned. Coordinating-agent costs are not
part of the harness totals. `--results PATH` can also select an isolated results
directory for other commands; local tests use temporary directories.

| Result | Action |
| --- | --- |
| Failed outcome | Keep the answer. Reject a candidate; stop a failed source or final batch. |
| Checker error or `review` | Stop. Repair or review offline. Do not assign a quality score. |
| Execution or capture error | Stop. Diagnose the cause. Keep the call and its cost. |
| Missing metrics | Stop. No cost score is possible. |
| Call or token limit | Keep completed slots. Resume with an explicit larger limit if needed. |

After you fix an execution problem, `--retry-errors` permits a new attempt for
only the incomplete/error slot. It saves a linked record and counts both calls.
It cannot retry a completed wrong answer. There are no automatic error retries.
A dispatch with no returned result needs diagnosis before it can be reconciled.

## Add a suite

A file under `suites/` implements `KataEvolve.Suite`:

| Callback | Contract |
| --- | --- |
| `spec/0` | Skill id, source, support paths, cases, checks, execution inputs, checker inputs. |
| `prepare(project, case)` | Create that case's input project and Git history. |
| `prompt(case)` | State the task without expected answers or evaluator details. |
| `check(record, case)` | Return each declared outcome as `true`, `false`, or `{:review, reason}`. |
| `validate(text)` | Optional skill format or support-reference rules. |
| `proposal_instructions/0` | Optional general revision rules. No final-case feedback. |
| `outcome_contract/0` | Optional fixed list of required behavior; no fixture values or prescribed procedure. |

Keep preparation code separate from the checker. List every preparation helper and
input fixture in `execution_inputs`. List every checker, expected answer, and
calibration dependency in `inputs`. Prompts, case specifications, and skill support
files are also part of the execution contract. Hashes use project-relative paths
where possible, so a worktree move does not by itself change fixture identity.

Each case has an `id`, `split: :train | :final`, and `writable` paths. Use `[]` for
read-only tasks, exact paths for files, and a trailing slash for directories.
Git state and packaged skill files are always protected. `check/2` receives the
actual final answer and complete initial/final snapshots. Read a saved file with
`KataEvolve.Evidence.text/2`. The runner asserts the exact check set through ExUnit
and adds answer-capture and file-preservation checks.

Use `false` for an established outcome failure. Use `{:review, reason}` when a
parser cannot decide. Both block adoption; review remains unscored. Review is not
a bypass for a failed file/content assertion. This runner has no automatic review
approval or paid model judge. Improve checks with positive examples and nearby
faults; preserve the failed execution and assess it again offline.

The examples are [neckbeard](suites/neckbeard.exs), for answers about Python and
TypeScript, and [setup](suites/setup.exs), for document creation and moves. Setup is
excluded from this live round. Its legacy preparation/check helper is still
conservatively included in execution inputs; changing that helper starts a new
context. The other skill suites remain in their worktrees pending integration.

## Calculate a quality score

The common calculator uses **`skill-quality-v2`**. It keeps the v1 cost formula but
makes execution, capture, and checker errors, plus pending review, **unscored**
(`null`). Invalid skill format, more than 500 words, or a proven failed candidate
outcome scores **0**. Missing, duplicate, mismatched, or incomplete evidence is
unscored. The reference must have complete passing outcomes and valid metrics.

For each case, use median total tokens, tool calls, and elapsed milliseconds:

```text
case_cost = 0.70 × candidate_tokens / reference_tokens
          + 0.20 × (candidate_tools + 1) / (reference_tools + 1)
          + 0.10 × candidate_time / reference_time
score = round(100 / (1 + mean(case_cost)), 6)
```

Each case has equal weight. Count cached input once within total input tokens.
Use a fixed source reference, not the latest parent. Passing reference cost is
50; lower cost scores above 50. An overlength source can supply reference costs
but cannot qualify for adoption. Ties keep the current parent. Word count earns
no separate reward. Proposal costs are reported but are not candidate run costs.

Training scores use one run per case. Promotion scores require three fresh runs
per case for both versions. Every counted execution must pass; medians cannot
hide failures. Save the score rule, execution context, checker revision, exact
skill hashes, and record hashes with each score. The same inputs yield the same
score. Do not compare scores across different models, protocols, or checker rules.
Historical v1 scores remain unchanged.

## Profiles and storage

Astra xhigh is the default for proposals and skill execution. `--profile NAME`
selects a profile from [config/profiles.exs](config/profiles.exs). For example,
`codex-sol-medium` selects the existing Sol medium profile. Metadata is stamped
before candidate evaluation and preserves language metadata. There is no fallback.

Live calls use the Codex CLI login and a temporary auth-only home. macOS process
rules isolate the project and control writes. This live access method requires
macOS; suite checks do not require the project to use Elixir.

Results live in `results/<skill-id>/<profile>/`:

- `skills/` and `contexts/`: exact candidate text and fixed execution inputs.
- `batches/`: immutable final answers/files, metrics, and linked error retries.
- `assessments/`: checker revision, raw record hash, and ExUnit outcomes.
- `search/`: proposals, costs, fixed search policy, and selection decisions.
- `calls/`: dispatch/result receipts, including calls interrupted before a result.
- `scores/`: versioned results and hashes of their inputs.

Keep author credits in README.md and required license files, never SKILL.md.
The [evaluator review](EVALUATOR_REVIEW.md) records the measured waste and this
repair. The previous [optimization plan](OPTIMIZATION_PLAN.md) is paused; do not
restart its worktree loops with the old evaluator.

The old `mix setup.eval` and `mix setup.score` commands remain isolated under
`lib/kata_evolve/setup/`. Historical setup results and `setup-quality-v1` are
unchanged. See [the legacy guide](SETUP_LEGACY.md).
