# Kata

Personal knowledge-work practices for coding agents.

## Install Agent Jido Kata

Give this prompt to your coding agent:

```text
Install the Agent Jido Kata skills from https://github.com/agentjido/kata for
my user account. Use npx skills as the default installer. Select this coding
agent as the target. If this agent requires its native plugin installer, use
that method instead. Confirm that the jido skill is available. Tell me if I
must start a new session.
```

You need access to the repository while it is private. If your agent cannot
install the plugin, use the [manual installation](#manual-installation) commands.

[Manual installation](#manual-installation) · [Skill package guide](skills/README.md) ·
[Documentation index](docs/README.md) · [Intake log](docs/inbox/README.md)

Understand. Plan. Work. Verify. Improve.

Kata is a knowledge-work system by Mike Hostetler and Jason Allum, packaged as
skills for coding agents. Software engineering is one supported domain. The project is being prepared for public use at
[agentjido/kata](https://github.com/agentjido/kata). The skills are a starting
point and will change as actual work shows what helps.

## Process

Jido translates a requester's goal into one of two internal routes. Value delivery
uses `understand -> plan -> work -> verify`. Kaizen improves the reusable work
system through `maintain-skill -> write-skill`. Both end in consumer acceptance.
Dojo is a separate, opt-in evaluation tool. A route starts at the first unresolved
contract, so ready work can skip understanding and planning.

Use the amount of planning that the work needs. A small fix can use a few lines in the conversation. A larger change can use a written plan. Specifications are one tool in the process.

Use `kata-ex-<task>` for skills that require Elixir. Language-agnostic skills
use `kata-<task>`. Small conversation commands can keep a distinctive bare
name when the user approves the exception. Keep all packages in the flat
`skills/<name>/SKILL.md` layout.

### Primary entry point

| Skill | Job |
| --- | --- |
| `jido` | Translate an explicit `$jido` goal into the smallest valid value-delivery, Kaizen, or support sequence. |

`$jido` is the initial front door for Jido-Kata. The requester uses normal language.
Jido infers the internal route, enters at the first unresolved step, and reports
the selected sequence and authority. Direct leaf skills remain available.

### General work

| Skill | Job |
| --- | --- |
| `kata-understand` | Establish the current condition and bound an unclear problem with evidence. |
| `kata-verify` | Check one candidate result against its acceptance conditions without repairing it. |
| `kata-dojo` | On explicit request, inspect saved evidence or evaluate one exact skill candidate. |
| `kata-write-skill` | Write, import, or convert one package with the library contract and faceted metadata. |
| `kata-benchmark-checklist` | Check that a performance measurement is valid, repeatable, and relevant. |
| `kata-blast-radius` | Find and prove effects of a change outside its visible diff. |
| `kata-commit` | Create one local Git commit from an already verified, explicitly scoped change. |
| `kata-correct` | Turn repeated repository mistakes into structural checks. |
| `kata-create-verification-skill` | Create a project-local skill that drives and verifies the real application. |
| `kata-interrogate` | Run an adversarial review and keep only findings proven by execution. |
| `kata-maintain-skill` | Resolve one evidence-backed finding about skill-library ownership, overlap, classification, or contract conformance. |
| `kata-no-comments` | Remove weak comments and identify code that needs a structural fix. |
| `kata-orient` | Create, audit, or refresh scoped `AGENTS.md` and entry-point `README.md` files. |
| `kata-plan` | Turn a work request into a plan and create a Beadwork graph when the repository is configured for it. |
| `kata-principled` | Apply one of 24 focused engineering principles through a named command. |
| `kata-recall` | Rebuild recent work context from chats, repository state, and shared records. |
| `kata-review-pr` | Review a pull request without changing code or remote state. |
| `kata-show-your-work` | Keep a reviewable TSV decision trail for long-running work. |
| `kata-status-report` | Give a quick local and remote Git workbench status for one project or a folder of projects. |
| `kata-sync-docs` | Check current documentation against code and correct stale claims. |
| `kata-tdd` | Use a focused failing test or executable check before a bug fix. |
| `kata-technical-writing` | Write or review README files and other technical prose from verified source facts. |
| `kata-work` | Produce one candidate result from a ready request and hand it to independent verification. |
| `kata-neckbeard` | Explain the current system with evidence from code and documentation. |
| `kata-showme` | Explain the current topic with diagrams and focused visuals. |
| `kata-docs` | Set up and steward Docs Kata, process inbox material, record durable knowledge, and maintain document structure. |

### Conversation commands

These small commands keep their distinctive source names. Use them only by
explicit request.

| Skill | Job |
| --- | --- |
| `bro` | Restate the last response in short, plain language. |
| `in-your-own-words` | Restate the user's goal and problem before work starts. |
| `ketchup` | Summarize chat progress and waiting decisions in text or, by explicit request, a short subtitled video. |
| `sharpen` | Rewrite a task to make it deeper without making it larger. |
| `unslop` | Remove common AI writing patterns without changing meaning. |

### Elixir engineering

| Skill | Job |
| --- | --- |
| `kata-jido-action` | Build and test actions with the current `Jido.Action` contract. |
| `kata-jido-agent` | Build and test agents, routes, state operations, directives, and runtime signals. |
| `kata-jido-ai` | Add Jido AI agents, tools, generation, and structured output with offline tests. |
| `kata-jido-testing` | Add focused tests for Jido action, agent, runtime, and AI behavior. |
| `kata-ex-coverage` | Find and explain gaps in Elixir test coverage. |
| `kata-ex-design-review` | Review Elixir design, contracts, and OTP ownership with selectable Phoenix, Ash, and Jido package lenses. |
| `kata-ex-hunt-dead-code` | Find unused Elixir modules and verify removal of confirmed unused groups. |

Elixir skills include `language: elixir` in their metadata. Without a language
marker, a skill is language-agnostic. `kata-neckbeard` is general system investigation;
it does not require Elixir. Model evaluation evidence is separate from skill
classification metadata.

Use a skill by name when you need it. Each skill can run separately.

`kata.skill/v1` metadata adds practice, object, profile, authority, input, and
output facets beside each skill's subject. All 39 active packages use the
complete schema. Skill frontmatter is the canonical classification source.
Small tools can derive catalog, workflow, and overlap candidates from it.

`kata-principled` is one skill with 24 commands. Invoke a command as
`$kata-principled prove-it-works` or `$kata-principled fix-root-causes`. This
keeps the principle catalog out of the main skill list while preserving each
focused rule in the package references.

The four Jido skills are self-contained. They do not require a separate hub
skill. They were rewritten from `agentjido/jido-skills` against current local
`jido`, `jido_action`, and `jido_ai` APIs. They use `Jido.Agent.Directive`,
signal-based `AgentServer` calls, current state operations, and the current rule
that an action can perform immediate I/O when its result is needed by the
workflow.

`kata-plan` is adapted from Compound Engineering's `ce-plan`. It keeps the
required references, scripts, and source license. Its support scripts pass
local contract checks, but the adapted workflow has not been tested in live
model runs. `kata-work` is the general execution boundary. It produces one
candidate result and direct work evidence, but it does not certify its own
output. `kata-verify` owns the independent judgment boundary. Commit and remote
delivery remain separate actions.

For Durable repository plans, `kata-plan` checks for an installed `bw` command
and an already initialized Beadwork repository. When both checks pass, it creates
and verifies an epic and task graph from the plan units. Otherwise it writes only
the plan file. It never initializes Beadwork automatically.

Use `kata-docs` with ordinary requests such as "set up project docs," "process
this inbox note," "record this verified decision," or "tidy the docs." Setup
creates `docs/AGENTS.md`, a documentation index, and `docs/inbox/` with an
intake log. Existing documents move into the inbox with their original paths
recorded. Required entry points and documents with fixed consumers stay in
place. Links and supporting assets are preserved.

The docs rules define guides, reference, decisions, plans, and lessons as the
destinations for reviewed knowledge. Setup collects material without treating
it as verified. A targeted inbox request processes one item by default.
Maintenance drains the full inbox by placing current material, archiving
non-authoritative history, or reporting an explicit blocker. Other skills can
pass verified durable knowledge to `kata-docs`; the caller remains responsible
for its evidence and authority.

Use `kata-orient` to create, audit, or refresh the root and nested `AGENTS.md`
files and the entry-point `README.md` files that orient people and agents. It
can send a `readme-brief` to `kata-technical-writing` and can return general
project knowledge as a `project-knowledge-capture` for `kata-docs`. Each skill
keeps a self-contained fallback and does not require another skill at runtime.

## Dojo skill evaluation

> **Opt-in only.** Dojo is preserved experimental evaluation tooling. Do not run
> it for ordinary skill development, catalog work, formatting, tests, or package
> verification. Use it only when the current request explicitly names Dojo. A
> live model run also requires an explicit profile and token or call budget.

The implementation and saved evidence remain in `dojo/` for historical review
and possible future experiments. They are not part of the default Kata workflow.

`kata-dojo` is the formal evaluation entry point. It selects the first missing
evidence gate and uses the runner below when the current repository supplies it.
It does not author or adopt a skill. The current runner evaluates skills only;
generic play evaluation needs a later adapter.

The primary Dojo evaluation profile is **Astra xhigh**: Codex, model
`gpt-6-astra`, reasoning `xhigh`. Keep one focused source version per skill.
Other models can be used for experiments; their candidates and measurements
stay in `dojo/results/`. We do not maintain separate model variants of source
skills.

No active source package currently claims `optimized_for`. The saved setup and
neckbeard evidence applies to the exact historical text in its result record.
Both source skills changed after those trials, so that evidence does not prove
optimization of the current files. Add an optimization claim only when the
exact current file has sufficient saved evidence for that target. Use
[Dojo](dojo/README.md) to measure and improve skills. Plugin users do not need
Elixir.

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
cd dojo
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
retries. See the [Dojo guide](dojo/README.md) and the
[historical process review](docs/archive/evals/2026-09-05-evaluator-review.md).
The [proposal prompt](dojo/prompts/propose_skill.md) permits full rewrites against
a fixed outcome contract. It tries removing procedure, replacing the workflow,
and refining the measured approach. Labeled training costs, actual outputs, and
prior rejection reasons guide each proposal. An unchanged proposal skips its
candidate call; the next approach can use the remaining budget. Change notes
stay outside the skill.

The shared loop selects by cost score after outcome checks pass. The old setup
command remains available for its historical experiment and selects by word count.
A shorter skill can use more total tokens:
the first setup trial reduced the skill from 939 to 499 words, but its training
run used more tokens. See the [recorded comparison](dojo/results/setup/report.md).

### Skill quality score

The common rule is `skill-quality-v3`. Historical score files retain their
recorded rule versions. The current rule uses the cost weights and correctness
checks below.

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

Correctness is a requirement. A candidate scores **0** if its format is invalid
or its required Elixir outcome test proves an incorrect result.
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
less weight. Word count is reported but does not affect correctness or score.

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

The [generic calculator](dojo/lib/kata_evolve/score.ex) implements this rule.
The [scoring guide](dojo/README.md#calculate-a-quality-score) gives the command and
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
| Codex through `jido_harness` | `gpt-6-astra` | `xhigh` | Primary tuning profile. Historical setup text passed three live cases. Neckbeard Round 1 passed one training case; see the adoption note below. |
| Codex through `jido_harness` | `gpt-5.6-sol` | `medium` | Completed five tuning rounds. The source and selected candidate each passed all 30 fixture checks. |

The user requested adoption of neckbeard Round 1 from the
[three-round v3 trial](dojo/results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/report.md).
The exact 290-word candidate was adopted at that time. The current
`skills/kata-neckbeard/SKILL.md` has changed and no longer matches that
candidate. The historical candidate passed all 12 checks on one training case
and scored **57.809727**. This is exploratory evidence. Repeated runs and
separate final cases have not been checked. The
[adoption record](dojo/results/kata-neckbeard/codex-astra-xhigh/trials/proposal-v3-three-rounds-20260905/adoption.json)
records this exception to the normal verification requirement.

The task model and proposal model use the same profile. Astra xhigh is the default.
For the Sol medium experiment, from `dojo`:

```sh
mix setup.eval tune --profile codex-sol-medium --attempts 5 --minutes 30
```

Five attempts means five proposal rounds, followed by final checks. It does not
mean five independent repetitions of an unchanged skill. Each round compares its
candidate against the best training result so far. Rejected proposals do not end
the requested round budget. Saved state preserves that budget after an interruption.

The [completed Sol trial](dojo/results/setup/codex-sol-medium/report.md) reduced
the skill from 500 to 445 words. Total tokens across the three cases increased
from 698,373 to 857,248, about 23%. The loop improved word count; this trial did
not show token savings. The candidate stays in evaluation results. The source
skill and its Astra evaluation target were unchanged by that trial.

The shared runner takes a suite file and supports any skill with its own outcome
checks. Setup and neckbeard adapters are included; the other active suites remain
in their optimization worktrees until integration. See [the Dojo guide](dojo/README.md)
for the interface and
[legacy setup commands](docs/reference/setup-evaluation-legacy-commands.md) for historical
results. Testing Sol does not change the Astra target or establish support for an
entire model family.

The [superseded Astra optimization plan](docs/plans/2026-09-05-astra-optimization-plan.md)
records the earlier round for coverage, dead-code hunting, neckbeard, and
showme. Setup was excluded from that round.

## Attribution

Keep author credits here and in required license files, outside skill instructions.

Kata is authored by Mike Hostetler and [Jason Allum](https://github.com/jallum).

- `kata-orient` is an original Kata workflow informed by the
  [AGENTS.md open format](https://agents.md/),
  [OpenAI guidance for lean repository instructions](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra),
  and
  [OpenAI guidance for scoped repository rules](https://developers.openai.com/blog/custom-code-review-rules-for-codex).
- `kata-write-skill` adapts skill-authoring concepts from Matt Pocock's
  [writing-for-agents](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/productivity/writing-for-agents)
  and Every's
  [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00).
  The package includes the source MIT notices:
  [Matt Pocock license](skills/kata-write-skill/LICENSE-MATT-POCOCK) and
  [Compound Engineering license](skills/kata-write-skill/LICENSE-COMPOUND-ENGINEERING).
- `kata-plan` is adapted from `ce-plan` in
  [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/57e409e5c8c2c472106bd7d87ac72b724b70826b),
  maintained by Kieran Klaassen and Trevin Chow with community contributions.
  The source is commit `57e409e5c8c2c472106bd7d87ac72b724b70826b`.
  The imported skill includes Every's original
  [MIT license notice](skills/kata-plan/LICENSE).
- `kata-showme` is adapted from `show-me`, written by Dex Horthy and published
  in [humanlayer/skills](https://github.com/humanlayer/skills). The original
  [MIT license notice](skills/kata-showme/LICENSE) is included with the skill.
- `kata-benchmark-checklist`, `kata-blast-radius`, `bro`, `kata-correct`,
  `kata-create-verification-skill`, `in-your-own-words`, `kata-interrogate`,
  `ketchup`, `kata-no-comments`, `kata-principled`,
  `kata-recall`, `sharpen`, `kata-show-your-work`, `kata-tdd`,
  `kata-technical-writing`, and `unslop` are adapted from
  [painhardcore/pstack](https://github.com/painhardcore/pstack/tree/7f2d936bba86c2c512c4ad83e759752f4f065b7c),
  maintained by Andrei Iurchenkov from Lauren Tan's original pstack work. The
  source is commit `7f2d936bba86c2c512c4ad83e759752f4f065b7c`. Each imported skill
  contains the source MIT license and copyright notice.
- `kata-technical-writing` also adapts Elixir documentation guidance from Mike
  Hostetler's *The Elixir Library Documentation Manifesto v1* and its Jido
  style guides in `mikehostetler/jido_run`. The source files were reviewed at
  repository commit `ed57e19f78d6a8995323310ef7cbb43eecf838df`.
- Jason Allum wrote the original `coverage`, `neckbeard`, and `hunt-dead-code`
  skills. These were not published in a public repository. Kata includes
  adaptations as `kata-ex-coverage`, `kata-neckbeard`, and `kata-ex-hunt-dead-code`.
- Mike Hostetler wrote the source material migrated from
  [agentjido/jido-skills](https://github.com/agentjido/jido-skills), reviewed at
  commit `fb832fc5ccb84b45a101d49fbf78d94f89abb0a5`. Kata rewrites and merges that
  material as `kata-jido-action`, `kata-jido-agent`, `kata-jido-ai`,
  `kata-jido-testing`, `kata-review-pr`, and `kata-sync-docs`. Each affected
  skill directory contains the required Apache-2.0 license and copyright notice.

## Manual installation

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

These commands install skills at project scope. A local project-scope Codex
installation from this checkout passed on 2026-09-28. That check predates the
current skill set. Claude Code and Cursor installation still need direct checks.

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
   `LICENSE` for `kata-showme`, the complete `kata-docs` and
   `kata-technical-writing` directories, and
   `scripts/dead_code.exs`, `roots.exs`, and `reference.md` for `kata-ex-hunt-dead-code`.
   Include `LICENSE` with each `kata-jido-*`, `kata-review-pr`, and
   `kata-sync-docs` skill.
   For `kata-plan`, include the complete skill directory with `references/`,
   `scripts/`, and all license files.
   For every pstack-derived skill, include its `LICENSE`. Include the complete
   directory for `kata-create-verification-skill`, `kata-principled`, and
   `kata-show-your-work` because they have support files.
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

The package files and skill paths have passed static checks. The local Codex
project installation has passed. Pi runtime behavior has not been tested.

## Package structure

```text
skills/<name>/SKILL.md          Shared skill content
skills/README.md               Skill package and maintenance guide
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
