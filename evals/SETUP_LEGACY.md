# Existing setup evaluations

These commands preserve the original setup experiment and its saved results.
Use [the common runner](README.md) for new skill suites. The legacy loop selects
by word count subject to correctness; it does not implement the new promotion rule.

From `kata/evals`:

```sh
mix setup.eval check
mix setup.score codex-sol-medium b76130fc2246 29c4ddc219b8
```

Both commands run offline. The check command rechecks saved final files through
ExUnit. The calculator uses `setup-quality-v1`: 70% tokens, 20% tools, 10% time,
correctness required, and a 500-word candidate limit. The rule version and saved
measurements are unchanged. Code now lives under `KataEvolve.Setup`; new score
output identifies the moved checker paths.

The [first Astra trial](results/setup/report.md) remains historical evidence.
The [Sol trial](results/setup/codex-sol-medium/report.md) ran five proposal rounds
on `gpt-5.6-sol / medium`. Its selected text fell from 500 to 445 words, but total
tokens rose from 698,373 to 857,248. Its exploratory cost score is **43.654704**,
compared with the source's **50.000000**. It would not qualify for promotion under
the cost rule. It remains an experiment, separate from the official Astra skill.

The old live commands are retained for compatibility:

```sh
mix setup.eval baseline
mix setup.eval tune --profile codex-sol-medium --attempts 5 --minutes 30
```

They reuse saved runs and resume proposals. `--fresh` replaces legacy case files;
it does not produce independent immutable repetitions. Use the generic setup
adapter for any future experiment that needs the new storage and scoring protocol.
Setup is excluded from the current live tuning round.

The previous `jido_evolve` spike and early saved outputs remain reference material.
This runner uses `jido_harness` for CLI execution and does not need a separate
`jido_evolve` API. Previously tracked upstream work remains linked here:

- [Harness #70](https://github.com/agentjido/jido_harness/issues/70): configuration isolation for normal Codex coding runs.
- [Evolve #33](https://github.com/agentjido/jido_evolve/issues/33): cleanup after evaluator or reflector timeouts.
- [Harness #71](https://github.com/agentjido/jido_harness/issues/71): intermittent fake-CLI failure before output.

These are historical issue references; their current status was not checked for
this refactor. Local runner and checker defects are recorded separately.
