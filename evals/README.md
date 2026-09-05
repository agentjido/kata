# Setup skill evaluation

A small Elixir test project for `kata-setup`. The source skills in `skills/` target
**Codex / gpt-6-astra / xhigh**. This is the default evaluation profile.
LLM access uses `jido_harness` and the existing Codex CLI login. Sol medium is an
experimental profile; its candidates remain in results, with no source variants.

## Use

Run these commands from `kata/evals`. Run `mix deps.get` once first.

```sh
mix check                     # Local tests; no LLM calls
mix setup.eval tune           # Reuse baseline, propose, test, and compare
```

Read the report path printed by the command. New runs save it under
`results/setup/<profile>/report.md`; it links to the selected candidate. Review an
Astra candidate before copying it into `../skills/kata-setup/SKILL.md`.
The [first Astra comparison](results/setup/report.md) remains as historical evidence.

Two other commands are available:

```sh
mix setup.eval baseline       # Record or reuse the original on the training case
mix setup.eval check          # Recheck saved final files; no LLM or CLI required
```

Run the same command after an interruption. It completes saved proposals and the
remaining round budget, then fills in missing final checks. Completed case runs
are reused; execution errors are retried. A later invocation after completion
adds a new round budget. Results are separated by profile and execution identity.

## The loop

1. Run the original skill on one guide fixture, or reuse its saved result.
2. Give Codex the current skill and training feedback. It edits one Markdown file.
3. Test the proposal on the same guide. Keep it if all checks pass and it is shorter.
   A passing proposal can also replace a parent that failed its checks.
4. Check the selected version and baseline on all three fixtures. The nested-note
   and manual results are not sent to the proposal call. A failed selected-candidate
   check prevents acceptance. Baseline results show whether the source skill works
   on the experimental profile before any revision.

This is a GEPA-style reflective improvement loop with one parent. It has no
population or Pareto selection. It does not yet use the quality score below for
selection. It does not depend on the
private `jido_evolve` example API. Future shared search behavior can move there.

The final target is 200–500 words. A shorter intermediate skill above 500 words is
allowed. Format and template-reference checks still apply. Short valid skills are
not padded. A passing result is evidence for these cases, not the whole skill scope.

## Limits and reruns

The default is one proposal and a 30-minute budget. Each CLI call has a ten-minute
limit, reduced to the remaining experiment time. Allow more proposals when needed:

```sh
mix setup.eval tune --attempts 3 --minutes 30
```

The task accepts one to five rounds. It completes the requested round budget even
when a proposal is rejected or unchanged. A saved target count prevents a resumed
experiment from adding extra rounds. CLI failures stop the command with evidence
saved; run it again to retry. Harness owns call deadlines and cleanup.
The budget covers CLI work. Startup and bounded cleanup can take extra time.

Use `--fresh` to measure again instead of reusing saved executions. It refreshes each
needed case once per invocation. Git can preserve earlier measurements before a
fresh run replaces them. Reuse is a cost-saving development step, not a new model
measurement. Changing the skill, inputs, template, profile, CLI, or Harness source
selects different saved evidence. Checker changes regrade final files locally.

Normal Codex runs currently inherit host configuration. Use `--fresh` after changing
that configuration. The runner version in `Store.context/1` must change if task
prompts or fixture preparation semantics change. No model fallback occurs.

## Files and measurements

- `test/fixtures/setup/input/`: fixed Elixir projects, documents, images, and links.
- `lib/kata_evolve/fixture.ex`: hard-coded checks for moves, local edits, links,
  protected files, the intake record, and an unchanged Git index.
- `results/setup/<profile>/skills/`: baseline and experimental Markdown by content hash.
- `results/setup/<profile>/cases/`: final files and case metrics, including failures.
- `results/setup/<profile>/search-*.json`: parent links, round decisions, proposal metrics,
  target round count, and resume state.
- `results/setup/<profile>/context-*.json`: execution inputs and configuration identity.
- `results/setup/<profile>/report.md`: the latest comparison for that profile.

Earlier Astra results remain directly under `results/setup/`. Offline checking
includes both layouts. The runner stamps each proposed skill with its actual
optimization profile before testing it. The source skill keeps its Astra metadata.

Text files stay readable in JSON. Binary data uses base64. There is no event log,
command transcript, database, service, automatic commit, or skill installation.
Temporary workspaces and Harness journals are removed after each call. Codex can
retain its own history outside this project until optional ephemeral runs exist.

Each case records input/output tokens, cached input and reasoning subsets, tool
calls, tool errors, file-change events, and elapsed milliseconds. Total tokens are
input plus output; subsets are not added twice. Missing measurements stay null.
Tool counts cover the normalized events Harness reports. Proposal costs are separate
from skill execution costs. The offline quality calculator combines execution costs;
the current tuning loop still selects by word count.

The three cases test one document and image each. Collision handling, fixed build
consumers, and repeat-run behavior need further cases before broad acceptance.

## Calculate a quality score

[`setup-quality-v1`](../README.md#skill-quality-score-setup-quality-v1) is the fitness
contract. Its implementation is [`KataEvolve.Score`](lib/kata_evolve/score.ex).
It has a correctness gate, then a bounded cost score. All required checks must pass;
passing more assertions does not compensate for one failed assertion.

### Elixir outcome tests are required

Each skill needs a hard-coded Elixir test for the result of its work. Test the
actual final files and behavior. A statement from the agent that it finished is
not evidence. For setup, the output contract includes:

| Output | Required assertion |
| --- | --- |
| `docs/AGENTS.md` | A regular file that contains the supplied rules template. |
| `docs/README.md` | A regular file with links to the rules and inbox. |
| `docs/inbox/README.md` | A regular file with source/destination records and an unprocessed or pending-review status. |
| Moved documents and assets | Content is preserved and links reach the intended files. |
| Existing project files and Git index | Protected files, local edits, and index entries are preserved. |

`Fixture.check_snapshot/3` derives the thirteen conditions from the initial and
final snapshots. `Fixture.assert_outcome!/1` executes their `ExUnit.Assertions`.
`Store.recheck/1` records the case ID, framework, and passed/failed result in
`outcome_test`. It always recomputes the result from final files. The score requires
both the passed test result and every required check; a failed output test scores
zero regardless of token savings. A missing test result cannot qualify.

These assertions execute after each skill run and during offline scoring. The
ExUnit suite also tests the checker with deliberately missing files, empty rules,
broken index links, and an incorrect intake status. A cached success flag cannot
make those outputs pass. Passing tests of the calculator alone does not qualify
a candidate; its own saved output must pass the outcome test.

Keep assertions outside the agent's editable project. Define the contract before
search and keep it fixed during tuning. Use exact text only where the contract
requires it, such as a supplied template. For free-form output, assert observable
properties and identify anything that still needs human review. Changes to the
checker start a new score series; they can regrade saved files without model calls.

### Run the calculator

Run this from `evals` to score the saved Sol candidate:

```sh
mix setup.score codex-sol-medium b76130fc2246 29c4ddc219b8
```

The arguments are profile, exact context ID, and candidate ID. The context selects
the fixed source baseline. The command rechecks saved final files and prints JSON.
It makes no model calls and changes no result files. The JSON includes component
ratios, medians, rule version, full skill hashes, and hashes of the input records,
context, checker, and scoring code. Save that output with the evidence in Git.
An example is [the saved Sol score](results/setup/codex-sol-medium/score-v1-29c4ddc219b8.json).

The calculation is:

```text
For each case i:
  T[i] = median(input_tokens + output_tokens)
  C[i] = median(tool_calls)
  D[i] = median(elapsed_ms)

  E[i] = 0.70 × T_candidate[i] / T_reference[i]
       + 0.20 × (C_candidate[i] + 1) / (C_reference[i] + 1)
       + 0.10 × D_candidate[i] / D_reference[i]

E = sum(E[i]) / number_of_cases
score_units = round(100000000 / (1 + E))
score = score_units / 1000000
```

Use `score_units` for comparison; display `score` to six decimal places. Each case
has equal weight, irrespective of its duration or number of assertions. Cached
input is included in input tokens; cached and reasoning subsets are not added
again. A reference with no tool calls is valid because both tool counts receive
`+1`. Tokens and time must be positive integers, tools a nonnegative integer, and
the saved total must equal input plus output. Missing metrics stay unscored.

The fixed baseline scores 50 when it meets the candidate requirements. The range
is 0–100, with higher scores preferred. The weights are a chosen policy, not a
statistical estimate. Do not change them to favor a candidate after seeing its
results. A shorter skill receives no direct bonus; valid skills at or below 500
words share the same length gate. There is no 200-word minimum and no padding.

### Evidence contract

Before search, fix the source reference, model and reasoning profile, harness and
host settings, case IDs, expected check names, checker version, repetition count,
and scoring version. Use a separate reference for each profile. Keep the same
reference for every candidate in one search; changing parents does not change
the reference. Also fix the training and final case sets before search.

`Score.calculate(candidate, reference, protocol)` is the pure calculation. Each
candidate/reference contains `text` and `records`. The protocol contains `context`,
`case_ids`, `checks`, and `repetitions`. The saved-file command uses all three setup
cases and the thirteen names in `Fixture.check_names/0`.

- Require exactly the declared cases and executions for both versions. A record
  must match its context and skill hash. Each execution must have a distinct
  `recorded_at` within that case; replaying a cached record is not another execution.
- Require the full, nonempty check set. An omitted check is a failure. Recompute
  checks from final files; do not trust a model's success statement.
- A complete reference must pass every check. Otherwise the score is `null` with
  a reason, since it cannot be used as a correct cost reference.
- An invalid candidate format, more than 500 words, failed check, timeout, or
  execution error gives an ineligible score of 0. No partial credit is awarded.
- Incomplete, duplicate, or mismatched evidence is unscored, as are missing or
  invalid costs for otherwise passing work. Unscored work cannot win selection.
- Check every execution before taking medians. Retain failed attempts in their
  declared slots. Do not replace them with successful retries in the same batch.
  A harness failure invalidates that comparison; a rerun is a new recorded batch.

One execution per case is exploratory. Three fresh executions per case for both
versions are required for promotion. Pass `--repetitions 3` to require that evidence;
it does not create executions. The current saved Sol trial is incomplete at that
level. The existing runner replaces case files on `--fresh`; it still needs
immutable repetition slots and a verify-only operation to collect such a batch.
Three successful repetitions are a small acceptance check, not a general reliability
estimate. Setup's own repeat-run behavior also needs a dedicated fixture.

### Selection and the saved example

The evolver's target is the highest eligible **training** `score_units`, always
against the fixed reference. A strict improvement replaces the current parent;
an equal score keeps the parent. Failed or unscored candidates cannot replace it.
Training may use one execution per case for inexpensive exploration. Never send
final-case results to the proposer. Check the selected text in a separate repeated
full-suite batch and require a score above its reference before promotion. Do not
compare the numeric scores of different case sets or repetition protocols.

The previous five-round Sol search selected for word count. Regrading its final
candidate with v1 gives:

| Version | Words | Checks | Quality score | Evidence |
| --- | --- | --- | --- | --- |
| Fixed source reference | 500 | 39/39 | 50.000000 | One execution per case |
| Selected Sol candidate | 445 | 39/39 | 43.654704 | One execution per case |

The shorter candidate costs more under this policy. It would not pass the score
requirement for promotion. This is an offline calculation, not a new model run or
a rerun of the five-round search. The score and its input hashes are saved beside
the original report; earlier search decisions remain unchanged.
The current checker adds three output assertions per case to the original ten.
Both versions pass them on their saved files. The historical live report retains
its original counts; the score JSON records the expanded contract and checker hash.

The calculator is implemented and tested. The evolver still uses `better?/2` and
word count. Connect the new calculation, freeze its reference and protocol in
search state, and add immutable repeated verification before using v1 for adoption.

## Adding another skill

The process can apply to each Kata skill, but the executable runner currently
selects setup paths, prompts, template checks, and cases directly. Changing only
the input skill file is not sufficient. Do not run the setup suite as evidence
that another skill works.

Start with one dedicated suite for the next skill. Keep its expected behavior in
Elixir assertions and its input project in Git. Use one training case and two
different final cases. Suitable first cases are:

| Skill | Saved input | Checks to write |
| --- | --- | --- |
| `kata-ex-coverage` | Small Elixir project with known covered and uncovered lines and generated coverage data | Correct modules, line numbers, and coverage counts; source files preserved. |
| `kata-ex-hunt-dead-code` | Elixir project with an unused module cycle, public entry points, and dynamic references | Finds the unused group; retains live modules; audit leaves files unchanged. Test requested removals separately with compilation and runtime checks. |
| `kata-neckbeard` | Small project with a known feature, limits, and an unanswered question | Claims agree with the source; cited files and lines support them; missing evidence is stated; project files preserved. |
| `kata-showme` | Fixed explanation request with known concepts and relationships | Required content and relationships are present; output opens and local links resolve. Review visual clarity separately. |

Calibrate the checker against an example that should pass and one that should
fail before paying for model runs. File existence alone is not proof of skill
effectiveness. Keep each fixture small enough that its expected result is clear.

First connect the fitness rule and repeated verification described above. When a
second skill needs a suite, keep these extension points small:

1. A skill selection that supplies its source path, support files, task prompt,
   candidate format checks, fixtures, and assertions.
2. A **verify-only** operation that runs an existing candidate on all cases,
   optionally with fresh repetitions, without making a new proposal.

These two extension points are planned, not current command options. Named profile
selection already works. A dedicated Mix task per skill is sufficient while the
suites are small. Extract common code when the second suite shows what it needs.
Do not add a test-definition language.

## Which models to tune

| Profile | CLI model ID | Reasoning | Role |
| --- | --- | --- | --- |
| `codex-astra-xhigh` | `gpt-6-astra` | `xhigh` | Default; the target for source skills in `skills/`. |
| `codex-sol-medium` | `gpt-5.6-sol` | `medium` | Experiment to test the setup skill and the tuning loop. |

Both skill execution and proposal generation use the selected profile. Run the
Sol experiment from this directory:

```sh
mix setup.eval tune --profile codex-sol-medium --attempts 5 --minutes 30
```

This means five proposal rounds, not five identical skill executions. With distinct
valid proposals, the experiment uses one training baseline, five proposal calls,
five candidate training calls, and final checks of the baseline and selected skill.
Cached or duplicate cases can reduce the number of executions. The report lists
round decisions and separates proposal costs from skill execution costs.

The intended source target remains Astra xhigh. Sol candidates are saved only as
experiment evidence. There are no shipped Sol variants or automatic model routes.
Only setup has a live suite; the other skills still need their own checks.

The [completed five-round Sol trial](results/setup/codex-sol-medium/report.md)
produced this comparison across the three cases:

| Version | Words | Checks | Total tokens | Tool calls | Seconds |
| --- | --- | --- | --- | --- | --- |
| Source skill | 500 | 30/30 | 698,373 | 36 | 567.4 |
| Selected Sol candidate | 445 | 30/30 | 857,248 | 37 | 446.8 |

These totals include skill execution only; proposal costs are listed separately
in the report. All five proposals passed the training checks and were shorter
than their parent. The selected text is 11% shorter, but used about 23% more
tokens across the suite. Time varied between calls. One execution per case does
not establish a speed or reliability improvement. The loop selects for word
count and correctness; it does not yet select for token use or time.

Keep exact model IDs and reasoning settings in `config/profiles.exs`. Unknown
profiles are rejected. Another coding host also needs suitable Harness options;
the current wrapper sets Codex-specific options. No fallback model is selected.

The setup skill uses one terse frontmatter line:

```yaml
metadata: {optimized_for: "codex/gpt-6-astra/xhigh"}
```

It records the optimization target; it does not select the model or claim that
all possible tasks pass. The word count includes this line. Experiments stamp
candidate metadata with the active profile and retain the source metadata intact.

Use fresh repetitions of both parent and candidate under the same conditions to
assess efficiency or reliability. Cached replay checks old outputs. Five evolution
rounds are not five independent measurements of one candidate. `tune --fresh` also
makes proposals, so it is not a substitute for the planned verify-only operation.
Do not infer family-wide support from one model or this small suite.

## Save an accepted candidate back to skills

Adopt an Astra-tested candidate into the source skills. Sol results are experimental.
First read the report and candidate. `Ready for review: true` means the current
fixture checks and word target passed; it does not establish
all skill behavior. Check that shortening preserved scope, safeguards, attribution,
and references to supporting files. For showme, also inspect the rendered result.

For setup, from `kata/evals`, select the exact file linked by the report and copy
it. Replace `<selected-hash>` below with that file's hash:

```sh
candidate_path="results/setup/codex-astra-xhigh/skills/<selected-hash>.md"
cp "$candidate_path" ../skills/kata-setup/SKILL.md
cmp "$candidate_path" ../skills/kata-setup/SKILL.md
git diff --check -- ../skills/kata-setup/SKILL.md
git diff -- ../skills/kata-setup/SKILL.md
```

Commit the changed source, relevant input fixtures, candidate, context, case
results, and search record together. Note the adoption in the result report.
Preserve earlier evidence in Git before a fresh run replaces any measurements.
No automatic promotion, commit, push, or plugin installation is performed.

After adoption, the source hash changes and the next tune starts from that text
as its baseline. Prior results remain evidence for their recorded hashes. If you
edit the candidate during review, test the edited text before adopting it; the
old result does not cover those edits.

## Dependencies and tracked gaps

Elixir 1.19+, Git, Codex, and a native build toolchain are required. The local Harness
path is `../../../Jido/proj_jido_harness/jido_harness`; override it with
`JIDO_HARNESS_PATH`. The profile is in `config/profiles.exs`. It prefers the desktop
CLI; `KATA_CODEX_PATH` can select another executable. CLI 0.149.0 rejected Astra;
the live checks use 0.153.1.

- [Harness #70](https://github.com/agentjido/jido_harness/issues/70): optional
  configuration isolation for normal Codex coding runs.
- [Evolve #33](https://github.com/agentjido/jido_evolve/issues/33): cleanup of detached
  work when an evaluator or reflector times out.
- [Harness #71](https://github.com/agentjido/jido_harness/issues/71): one intermittent
  fake-CLI failure before output. The same test seed and 60 follow-up probes passed;
  the cause is not yet known. Live setup evaluations passed.

The earlier CLI rejection, short reflection timeout, and intake-link checker error
were local integration problems. They are not evidence of a skill defect. The
previous final observations remain in `test/fixtures/setup/recorded/` as reference.
