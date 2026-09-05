# Kata

Personal engineering practices for coding agents.

Observe. Build. Verify. Improve.

Kata is a software engineering process by Mike Hostetler and Jason Allum, packaged as
skills for coding agents. The project is being prepared for public use at
[agentjido/kata](https://github.com/agentjido/kata). The skills are a starting
point and will change as actual work shows what helps.

## Process

Understand the current condition. Set a clear target. Make a small change. Check the result. Keep useful lessons.

Use the amount of planning that the work needs. A small fix can use a few lines in the conversation. A larger change can use a written plan. Specifications are one tool in the process.

Use `kata-ex-<task>` for skills that require Elixir. Language-agnostic skills use
`kata-<task>`. Keep both in the flat `skills/<name>/SKILL.md` layout.

### General engineering

| Skill | Job |
| --- | --- |
| `kata-neckbeard` | Explain the current system with evidence from code and documentation. |
| `kata-showme` | Explain the current topic with diagrams and focused visuals. |
| `kata-setup` | Set up Docs Kata and collect existing documents in `docs/inbox`. |

### Elixir engineering

| Skill | Job |
| --- | --- |
| `kata-ex-coverage` | Find and explain gaps in Elixir test coverage. |
| `kata-ex-hunt-dead-code` | Find unused Elixir modules and verify removal of confirmed unused groups. |

Elixir skills declare `metadata: {language: elixir}`. Without a language marker,
a skill is language-agnostic. `kata-neckbeard` is general system investigation;
it does not require Elixir. Language scope is separate from the model recorded
in `optimized_for`.

Use a skill by name when you need it. Each skill can run separately.

To adopt Docs Kata in a project, ask: "Use kata-setup in this repository."
It creates `docs/AGENTS.md`, a documentation index, and `docs/inbox/` with an
intake log. Existing documents move into the inbox with their original paths
recorded. Required entry points and documents with fixed consumers stay in
place. Links and supporting assets are preserved.

The docs rules define guides, reference, decisions, plans, and lessons as the
destinations for later review. Setup collects material; it does not treat old
documents as verified or create every category in advance.

## Skill evaluation

Our target is **Astra xhigh**: Codex, model `gpt-6-astra`, reasoning `xhigh`.
Skills in `skills/` target this profile. Keep one source version per skill and
aim for 200–500 words. Other models can be used for experiments; their candidates
and measurements stay in `evals/results/`. We do not maintain separate model
variants of the source skills.

The setup and neckbeard skills record their optimization target in one frontmatter line:

```yaml
metadata: {optimized_for: "codex/gpt-6-astra/xhigh"}
```

This is a provenance note, not a command that selects or requires a model.
The execution profile controls the harness, model, and reasoning level. Only add
an optimization claim when a skill has been tuned for that target; the other
skills share the intended target but do not yet have equivalent evaluation evidence.
Use [`evals/`](evals/README.md) to measure and improve skills. Plugin users do not
need Elixir.

### Tune, check, and adopt

1. **Define success.** Save a small test project and write checks for the skill's
   expected behavior. Use one case for tuning and separate cases for final checks.
2. **Record one training baseline.** Run the current source skill with an explicit
   harness, model, and reasoning level. Save final files, checks, and measurements.
   Fix checker faults offline before more model calls.
3. **Propose and compare.** Give the model the skill and training feedback. Test
   its revision on the same case. Keep it only if correctness passes and the fixed
   cost score improves. Keep the fixtures and checks fixed during the attempt.
4. **Verify an improved candidate.** Stop if training shows no improvement. Check
   the selected text on cases that were not used
   for feedback. Review its safeguards and supporting files. Use repeated fresh
   runs of the same candidate before making an efficiency or reliability claim.
5. **Adopt it.** Copy the reviewed candidate to `skills/<name>/SKILL.md`. Check
   that it matches the tested file. Commit the skill, fixtures, and result records
   together. This updates the source package; it does not install a plugin.

Use the same runner for each skill's dedicated suite. For example:

```sh
cd evals
mix check
mix skill.eval suites/neckbeard.exs train
mix skill.eval suites/neckbeard.exs tune --attempts 5 --max-calls 11
```

Use the printed candidate path with
`mix skill.eval suites/neckbeard.exs verify --candidate PATH`.
Tuning does not overwrite the source skill. Existing execution
slots and proposals are reused. Verification fixes one candidate and batch;
resume that batch to collect missing evidence.
After adoption, the new source becomes the next tuning baseline.

One training case and five proposal rounds need at most 11 model calls before a
verification decision. Full repeated verification starts only for a promising
candidate. Call/token limits and `status` reports include proposals and error
retries. See the [evaluator guide](evals/README.md) and [process review](evals/EVALUATOR_REVIEW.md).
The [proposal prompt](evals/prompts/propose_skill.md) permits full rewrites against
a fixed outcome contract. It tries removing procedure, replacing the workflow,
and refining the measured approach. Labeled training costs, actual outputs, and
prior rejection reasons guide each proposal. An unchanged proposal skips its
candidate call; the next approach can use the remaining budget. Change notes
stay outside the skill.

The shared loop selects by cost score after outcome checks pass. The old setup
command remains available for its historical experiment and selects by word count.
A shorter skill can use more total tokens:
the first setup trial reduced the skill from 939 to 499 words, but its training
run used more tokens. See the [recorded comparison](evals/results/setup/report.md).

### Skill quality score

The common rule is `skill-quality-v2`; historical setup evidence retains
`setup-quality-v1`. Both use the cost weights and correctness gates below.

Use a fixed rule to score saved evidence. **The same inputs and rule version must
produce the same score.** The calculator runs without a model. New live executions
can produce different evidence and thus different scores.

**Every case must pass its Elixir outcome test before efficiency earns a score.**
The test checks the actual final project state. For file creation, assert the
expected path, file type, required content, valid links, and preservation of
existing material. File existence or a model's success statement is insufficient.
Each suite returns its declared outcome checks. The runner asserts all of them
through ExUnit and records `outcome_test`; saved answers and final files can run
through those assertions again offline.

Correctness is a requirement. A candidate scores **0** if its format is invalid,
it exceeds 500 words, or its required Elixir outcome test proves an incorrect result.
Execution/capture errors, checker errors, pending review, missing cases, duplicate
executions, or mixed execution contexts are **unscored** (`null`).
Missing cost measurements for otherwise passing work are also unscored. The fixed reference
must have complete, passing results. Scores apply to the named suite and profile.

For each case, take the median of each metric across the required executions.
Compare the candidate with a **fixed source baseline**, not the latest parent:

```text
token_ratio = candidate_tokens / baseline_tokens
tool_ratio  = (candidate_tool_calls + 1) / (baseline_tool_calls + 1)
time_ratio  = candidate_elapsed_ms / baseline_elapsed_ms

case_cost = 0.70 × token_ratio + 0.20 × tool_ratio + 0.10 × time_ratio
cost      = mean(case_cost across all required cases)
score     = round(100 / (1 + cost), 6)
```

Each case has equal weight. Total tokens are input plus output, including cached
input once. The `+1` permits a reference case with zero tool calls. Positive token
and time measurements are required. Proposal costs are reported separately.
The weights are our v1 policy: token use matters most; variable elapsed time has
less weight. Word count is a limit, with no extra reward for shorter text.

A passing baseline scores **50**. Lower relative cost scores above 50; higher cost
scores below 50. Freeze the reference, fixtures, required checks, profile, execution
settings, repetitions, and rule version before search. Checker repairs create new
assessments of saved outputs without model calls or changes to old results. A
changed checker stops live search for offline diagnosis. Changes to actual task
inputs require new executions. Do not compare scores across profiles or different
case sets.

Use one execution per case for an **exploratory** score. Require three fresh
executions per case for both reference and candidate before promotion; every
execution must pass. A median cannot hide a failed execution. The evolver should
maximize the training score, keep the current parent on equal scores, and check
the selected candidate on cases excluded from proposal feedback. Promotion also
requires a repeated full-suite score above the fixed reference and review of
behavior the assertions do not cover.

The [generic calculator](evals/lib/kata_evolve/score.ex) implements this rule.
The [scoring guide](evals/README.md#calculate-a-quality-score) gives the command and
evidence contract. The common evolver uses this score and collects separate
training and repeated verification evidence.

Applied to the saved Sol trial, the source scores **50.000000** and the selected
445-word candidate scores **43.654704**. These are exploratory scores. This rule
would reject the candidate for promotion despite its shorter text.
The expanded setup outcome test passes 13 assertions per case on those saved
files, including generated content. The original live report retains its ten
checks per case; the new checker identity and results are recorded by the scorer.

### Models and current scope

| Harness | Model | Reasoning | Use and evidence |
| --- | --- | --- | --- |
| Codex through `jido_harness` | `gpt-6-astra` | `xhigh` | Primary tuning profile. Setup passed three live cases. Neckbeard Round 1 passed one training case; see the adoption note below. |
| Codex through `jido_harness` | `gpt-5.6-sol` | `medium` | Completed five tuning rounds. The source and selected candidate each passed all 30 fixture checks. |

The user requested adoption of neckbeard Round 1 from the
[three-round v3 trial](evals/results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/report.md).
The exact 290-word candidate is now in `skills/kata-neckbeard/SKILL.md`. It passed
all 12 checks on one training case and scored **57.809727**. This is exploratory
evidence. Repeated runs and separate final cases have not been checked. The
[adoption record](evals/results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/adoption.json)
records this exception to the normal verification requirement.

The task model and proposal model use the same profile. Astra xhigh is the default.
For the Sol medium experiment, from `evals`:

```sh
mix setup.eval tune --profile codex-sol-medium --attempts 5 --minutes 30
```

Five attempts means five proposal rounds, followed by final checks. It does not
mean five independent repetitions of an unchanged skill. Each round compares its
candidate against the best training result so far. Rejected proposals do not end
the requested round budget. Saved state preserves that budget after an interruption.

The [completed Sol trial](evals/results/setup/codex-sol-medium/report.md) reduced
the skill from 500 to 445 words. Total tokens across the three cases increased
from 698,373 to 857,248, about 23%. The loop improved word count; this trial did
not show token savings. The candidate stays in evaluation results. The source
skill and its Astra target are unchanged.

The shared runner takes a suite file and supports any skill with its own outcome
checks. Setup and neckbeard adapters are included; the other active suites remain
in their optimization worktrees until integration. See [the evaluation guide](evals/README.md)
for the interface and [legacy setup commands](evals/SETUP_LEGACY.md) for historical
results. Testing Sol does not change the Astra target or establish support for an
entire model family.

The [Astra optimization plan](evals/OPTIMIZATION_PLAN.md) defines the next round
for coverage, dead-code hunting, neckbeard, and showme. Setup is excluded.

## Attribution

Keep author credits here and in required license files, outside skill instructions.

Kata is authored by Mike Hostetler and [Jason Allum](https://github.com/jallum).

- `kata-showme` is adapted from `show-me`, written by Dex Horthy and published
  in [humanlayer/skills](https://github.com/humanlayer/skills). The original
  [MIT license notice](skills/kata-showme/LICENSE) is included with the skill.
- Jason Allum wrote the original `coverage`, `neckbeard`, and `hunt-dead-code`
  skills. These were not published in a public repository. Kata includes
  adaptations as `kata-ex-coverage`, `kata-neckbeard`, and `kata-ex-hunt-dead-code`.

## Installation

The GitHub commands below are for the public repository once it is available
and these files are pushed. Until then, use a local checkout or an account
with repository access. No public marketplace listing is required.

From the project where you want to use Kata:

```sh
npx skills add agentjido/kata --agent codex
```

Select another host with `--agent claude-code` or `--agent cursor`. To use a
local checkout, replace `/path/to/kata` with the plugin repository directory:

```sh
npx skills add /path/to/kata --agent codex
```

These commands install skills at project scope. Installation has not been tested.

Ask the host to use a skill by name. For example: "Use kata-ex-coverage to inspect test coverage." Skill invocation syntax depends on the host.

### Grok Build CLI

Start Grok from the target project with this local checkout:

```sh
grok --plugin-dir /path/to/kata
```

For a saved installation from the local checkout:

```sh
grok plugin install /path/to/kata --trust
grok plugin enable kata
```

To install from GitHub:

```sh
grok plugin install agentjido/kata --trust
grok plugin enable kata
```

Start a new session. Select a skill from the `/` menu, such as `/kata-showme`.
Use `grok plugin list` to inspect saved installs. For active development, use
`--plugin-dir` to load the current files directly.
See the [Grok plugin documentation](https://docs.x.ai/build/features/skills-plugins-marketplaces)
and [CLI install guide](https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-pager/docs/user-guide/09-plugins.md).

### Grok Bot

Grok Bot manages private skills in its own library. The Grok Build commands
above do not install skills into that library. For personal use, give the Bot
the skill files and ask it to save each one as a private skill:

1. Attach the selected `skills/kata-*/SKILL.md` file to a Bot conversation.
2. Include the skill's support files: `coverage_tool.exs` for `kata-ex-coverage`,
   `LICENSE` for `kata-showme`, `templates/docs-agents.md` for `kata-setup`, and
   `scripts/dead_code.exs`, `roots.exs`, and `reference.md` for `kata-ex-hunt-dead-code`.
3. Ask: "Save these files as a private skill. Keep the name from SKILL.md,
   the instructions and support files, including license notices. Resolve support file
   paths from the saved skill directory. Tell me if you cannot retain a file."
4. Open **Settings → Plugins → Yours** and enable the saved skill for the Bot.
   Select it from the `/` menu.

Repeat for each skill you want to use. These are saved
copies; repeat the import when the source changes. Coverage needs Elixir and
access to the target project's coverage files on the Bot computer. Do not treat
coverage as ready if the Bot cannot retain or run its support script.

This uses the documented [Grok Bot private skill workflow](https://docs.x.ai/grok-bot/skills-routines-and-automations).
Support file retention and execution have not been tested. A direct Git
repository install into Grok Bot has not been verified. Making Kata public
does not automatically add it to the Grok Bot plugin catalog.

### Pi

From the target project, register the local checkout at project scope:

```sh
pi install -l /path/to/kata
```

Pi reads the `pi.skills` entry in `package.json`. Local packages use the source
files without copying them. To install from GitHub:

```sh
pi install -l git:github.com/agentjido/kata
```

Omit `-l` for a user-wide install. Start a new Pi session after installation
and ask it to use a skill by name. Use `pi list` to inspect installed packages.
See the [Pi package documentation](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/packages.md).

The package files and skill paths have passed static checks. Host installation
and runtime behavior have not been tested.

## Package structure

```text
skills/<name>/SKILL.md          Shared skill content
plugin.json                    Root plugin metadata
.claude-plugin/plugin.json     Claude plugin metadata
.claude-plugin/marketplace.json Local-source marketplace entry
.codex-plugin/plugin.json      Codex plugin metadata
.cursor-plugin/plugin.json     Cursor plugin metadata
.grok-plugin/plugin.json       Grok Build plugin metadata
package.json                   Pi package with the shared skills path
```

The package follows the root skills layout used by [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/57e409e5c8c2c472106bd7d87ac72b724b70826b). The skill text is specific to Kata. Each skill is self-contained and uses the [Agent Skills format](https://agentskills.io/specification).

[`npx skills`](https://github.com/vercel-labs/skills) installs the skill files. The small host manifests provide a base for native plugin use later. Native host loading has not been tested.

There is no plugin build step, runtime service, or hook. The coverage skill
includes an Elixir script that reads coverage data from a target project.
The dead-code skill includes an Elixir analyzer for source references and declared
entry points. Its JSON output needs Elixir 1.18+. Keep project root declarations
in the target repository and pass their path with `--roots`.
The `private: true` field in `package.json` prevents accidental npm publication;
it does not control GitHub visibility or prevent Pi installs from Git.
No npm publication or public marketplace submission is configured.
