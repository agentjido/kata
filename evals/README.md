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
