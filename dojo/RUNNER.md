# Preserved Dojo runner interface

Read this file only when the current user request explicitly names Dojo. Do not
use this runner for normal skill development, catalog work, formatting, tests,
or repository verification.

The implementation remains available for saved-evidence inspection and bounded
future experiments. Read `README.md`, the selected suite, and the current Mix
task help before any command. Do not install dependencies or repair the runner
unless the request also includes that work.

Live `train`, `tune`, or `verify` work requires an explicit profile and token or
call budget. Offline inspection does not authorize a live call.

The preserved modules are `KataEvolve.Suite`, `Experiment`, `Profile`, `Skill`,
`Score`, `Evidence`, `Harness`, and `Answer`. Setup-specific code remains under
`KataEvolve.Setup`.

Do not apply a changed runner to an existing measured batch. A runner, prompt,
fixture, or execution-input change starts a new execution context. Keep old
records immutable.
