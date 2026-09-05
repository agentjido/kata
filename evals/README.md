# Setup skill evaluation

A small Elixir test project for `kata-setup`. One profile: **Codex / Astra / xhigh**.
LLM access uses `jido_harness` and the existing Codex CLI login.

## Use

Run these commands from `kata/evals`. Run `mix deps.get` once first.

```sh
mix check                     # Local tests; no LLM calls
mix setup.eval tune           # Reuse baseline, propose, test, and compare
```

Read [`results/setup/report.md`](results/setup/report.md). It links to the selected
skill. The source skill stays unchanged. Review the candidate before copying it
into `../skills/kata-setup/SKILL.md`.

Two other commands are available:

```sh
mix setup.eval baseline       # Record or reuse the original on the training case
mix setup.eval check          # Recheck saved final files; no LLM or CLI required
```

Run the same `tune` command after an interruption. It completes the saved proposal
and missing checks before making another proposal. Completed case runs are reused;
execution errors are retried. A later completed invocation starts another attempt.

## The loop

1. Run the original skill on one guide fixture, or reuse its saved result.
2. Give Codex the current skill and training feedback. It edits one Markdown file.
3. Test the proposal on the same guide. Keep it if all checks pass and it is shorter.
   A passing proposal can also replace a parent that failed its checks.
4. Check the selected version on the nested-note and manual fixtures. These results
   are not sent to the proposal call. A failed final check prevents acceptance.

This is a GEPA-style reflective improvement loop with one parent. It has no
population, Pareto selection, or weighted fitness score. It does not depend on the
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

The loop stops at the first proposal that does not improve the training result.
Harness owns call deadlines and cleanup; there is no outer task that kills cleanup.
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
- `results/setup/skills/`: baseline and proposed Markdown, named by content hash.
- `results/setup/cases/`: final files and case metrics, including failed outcomes.
- `results/setup/search-*.json`: parent/proposal links, proposal metrics, resume state.
- `results/setup/context-*.json`: execution inputs and configuration identity.
- `results/setup/report.md`: the latest comparison.

Text files stay readable in JSON. Binary data uses base64. There is no event log,
command transcript, database, service, automatic commit, or skill installation.
Temporary workspaces and Harness journals are removed after each call. Codex can
retain its own history outside this project until optional ephemeral runs exist.

Each case records input/output tokens, cached input and reasoning subsets, tool
calls, tool errors, file-change events, and elapsed milliseconds. Total tokens are
input plus output; subsets are not added twice. Missing measurements stay null.
Tool counts cover the normalized events Harness reports. Proposal costs are separate
from skill execution costs. These metrics are reported, not combined into a score.

The three cases test one document and image each. Collision handling, fixed build
consumers, and repeat-run behavior need further cases before broad acceptance.

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
| `kata-coverage` | Small Elixir project with known covered and uncovered lines and generated coverage data | Correct modules, line numbers, and coverage counts; source files preserved. |
| `kata-neckbeard` | Small project with a known feature, limits, and an unanswered question | Claims agree with the source; cited files and lines support them; missing evidence is stated; project files preserved. |
| `kata-showme` | Fixed explanation request with known concepts and relationships | Required content and relationships are present; output opens and local links resolve. Review visual clarity separately. |

Calibrate the checker against an example that should pass and one that should
fail before paying for model runs. File existence alone is not proof of skill
effectiveness. Keep each fixture small enough that its expected result is clear.

The next code change should add only these extension points:

1. A skill selection that supplies its source path, support files, task prompt,
   candidate format checks, fixtures, and assertions.
2. A named profile selection from `config/profiles.exs`, with the exact profile
   recorded in the result. Keep the Harness adapter and metric counters shared.
3. A **verify-only** operation that runs an existing candidate on all cases,
   optionally with fresh repetitions, without making a new proposal.

These extension points are planned, not current command options. A dedicated Mix
task per skill is sufficient while the suites are small. Extract common code when
the second suite shows what it needs. Do not add a test-definition language.

## Which models to tune

Use **`codex-astra-xhigh`** first: Codex through `jido_harness`, model `gpt-6-astra`,
reasoning `xhigh`. Both skill execution and proposal generation use this profile.
Only setup has live evidence from the current loop. The other skills are untested
by this runner. Earlier mini-model results are historical spike data.

For another model, add an explicit profile and wire profile selection into the
runner first. Adding a map entry alone does not select it: `Store.context/1`
currently reads `codex-astra-xhigh` directly. The task has no `--profile` flag.
Another host also needs a suitable Harness adapter; the current wrapper sets
Codex-specific options.

Record skill hash, fixture identity, harness/CLI version, exact model ID, and
reasoning level for each comparison. Keep task and proposal costs separate. If we
later use a different proposal model, record both profiles. Do not compare runs as
if model settings were equal when they differ.

Treat model-family names as grouping metadata. Tune one canonical skill, then
verify that exact text on each profile we choose to support. A failure can lead to
a correction in the shared skill or a narrower tested-support statement. Keep
experimental variants in results until there is evidence that separate versions
are needed. Do not infer support for an entire family from one model's result.

Use fresh repetitions of both parent and candidate under the same conditions to
assess token use, tool calls, and time. Cached replay checks old outputs; it cannot
measure current model behavior. The current `tune --fresh` command also makes a
proposal, so it is **not** a substitute for the planned verify-only operation.

## Save an accepted candidate back to skills

First check the report and read the complete candidate. `Ready for review: true`
means the current fixture checks and word target passed; it does not establish
all skill behavior. Check that shortening preserved scope, safeguards, attribution,
and references to supporting files. For showme, also inspect the rendered result.

For setup, from `kata/evals`, select the exact file linked by the report and copy
it. Replace `<selected-hash>` below with that file's hash:

```sh
candidate_path="results/setup/skills/<selected-hash>.md"
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
