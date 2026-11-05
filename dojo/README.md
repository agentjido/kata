# Dojo

Dojo is preserved, opt-in tooling for controlled skill-evaluation experiments.
It is not part of the normal Kata development or verification workflow.

## Activation

Do not run a command in this directory unless the current user request
explicitly names Dojo. A request to write, improve, test, review, or verify a
skill does not activate Dojo.

Do not use this Mix project for routine skill contract checks, catalog queries,
formatting, or repository validation. Do not treat the presence of a suite or
saved result as permission to continue an experiment.

A live model run has a separate gate. It requires:

- an explicit request for a live Dojo evaluation;
- one exact candidate and one selected suite;
- an explicit execution profile;
- an explicit call or token budget; and
- authority for the model cost and local result files.

Inspection of saved evidence does not authorize a live call. Never infer a paid
budget.

## Preserved purpose

Use Dojo, when explicitly requested, to answer one bounded question:

> Does this exact skill candidate produce better measured outcomes than its
> fixed source under this fixed evaluation contract?

Dojo can:

- replay and inspect saved evaluation evidence;
- run controlled cases for one exact candidate;
- check outcomes independently of the agent's success claim;
- compare tokens, tool calls, and elapsed time after outcomes pass; and
- produce an adoption recommendation for the skill owner.

Dojo does not author, adopt, install, commit, publish, or continuously optimize
skills. It is not a required Kaizen stage. Ordinary skill acceptance does not
require a Dojo result.

## Automated maintenance

Dependabot checks the Mix dependencies in this directory each week. The
separate `Dojo Maintenance` workflow runs `mix maintenance` for Dojo dependency
changes, Dojo source changes, and a weekly schedule. This command checks
formatting, compilation, and the stable offline tests. It does not run a live
model evaluation. New tests join this gate by default.

The full `mix check` command remains the complete local gate. It also runs
legacy skill-contract and generic-loop tests. Those tests currently refer to
removed skill packages or an older suite contract, so they are not in the
automated maintenance gate. They use the `legacy_contract` test tag. Keep this
exclusion explicit until those contracts are updated or removed.

Dojo maintenance is separate from the Kata release process. A Kata release does
not run Dojo, package it as an artifact, use its version, or require its checks.

## Current status

The code, fixtures, suites, and historical results remain in this directory.
They are retained for reproducibility and possible future experiments.

The saved setup and neckbeard results apply only to their recorded source text,
cases, checks, model, and execution settings. They do not prove that the current
skill files are optimized. No active skill package claims `optimized_for` from
this evidence.

Important historical findings are:

- The Sol setup experiment produced a shorter candidate that used about 23%
  more task tokens across its three cases. Shorter text was not a measured
  improvement.
- The neckbeard experiment found a promising one-run candidate, but repeated
  verification did not run. Later source changes made that result historical.

See these retained reports:

- [Setup experiment](results/setup/report.md)
- [Sol setup experiment](results/setup/codex-sol-medium/report.md)
- [Neckbeard experiment](results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/report.md)
- [Evaluator review](../docs/archive/evals/2026-09-05-evaluator-review.md)

## Explicit Dojo work

After activation, read the selected suite and local Mix task help before a
command. Use saved evidence before new execution. Keep the candidate, task
inputs, checks, profile, and scoring rule fixed during a comparison.

Training evidence from one run is exploratory. A promotion recommendation needs
complete repeated source and candidate results, passing outcomes for every run,
an improved score, exact candidate identity, and review of behavior outside the
checks. Do not let a median hide a failed required run.

Keep live execution records immutable. A checker repair can create a new
assessment of saved output, but it is not a new model execution. Stop on a
checker error, review state, missing metric, or exhausted budget.

The preserved runner interface is in [RUNNER.md](RUNNER.md). Read it only after
the explicit Dojo activation gate passes.
