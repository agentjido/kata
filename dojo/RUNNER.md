# Shared runner interface

The commands, suite callbacks, scoring rule, and storage contract are now described
in the [evaluation guide](README.md). This link remains for the active worktree
handoffs that referenced `RUNNER.md`.

The common modules are `KataEvolve.Suite`, `Experiment`, `Profile`, `Skill`,
`Score`, `Evidence`, `Harness`, and `Answer`. Setup-specific code lives under
`KataEvolve.Setup`. Add a suite without changing the common modules.

Active optimization worktrees keep their frozen runner version. Do not apply a
new runner to a measured batch; changes start a new execution context.
