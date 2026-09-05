# Kata

Personal engineering practices for coding agents.

Observe. Build. Verify. Improve.

Kata is Mike Hostetler's personal software engineering process, packaged as
skills for coding agents. The project is being prepared for public use at
[agentjido/kata](https://github.com/agentjido/kata). The skills are a starting
point and will change as actual work shows what helps.

## Process

Understand the current condition. Set a clear target. Make a small change. Check the result. Keep useful lessons.

Use the amount of planning that the work needs. A small fix can use a few lines in the conversation. A larger change can use a written plan. Specifications are one tool in the process.

| Skill | Job |
| --- | --- |
| `kata-coverage` | Find and explain gaps in Elixir test coverage. |
| `kata-neckbeard` | Explain the current system with evidence from code and documentation. |
| `kata-showme` | Explain the current topic with diagrams and focused visuals. |
| `kata-setup` | Set up Docs Kata and collect existing documents in `docs/inbox`. |

Use a skill by name when you need it. Each skill can run separately.

To adopt Docs Kata in a project, ask: "Use kata-setup in this repository."
It creates `docs/AGENTS.md`, a documentation index, and `docs/inbox/` with an
intake log. Existing documents move into the inbox with their original paths
recorded. Required entry points and documents with fixed consumers stay in
place. Links and supporting assets are preserved.

The docs rules define guides, reference, decisions, plans, and lessons as the
destinations for later review. Setup collects material; it does not treat old
documents as verified or create every category in advance.

## Attribution

Mike Hostetler develops Kata. [Jason Allum](https://github.com/jallum) will
contribute to this repository.

- `kata-showme` is adapted from `show-me`, written by Dex Horthy and published
  in [humanlayer/skills](https://github.com/humanlayer/skills). The original
  [MIT license notice](skills/kata-showme/LICENSE) is included with the skill.
- Jason Allum wrote the original `coverage`, `neckbeard`, and `hunt-dead-code`
  skills. These were not published in a public repository. Kata includes
  adaptations as `kata-coverage` and `kata-neckbeard`. The dead code skill is
  stored in the workspace references and is not yet part of the plugin.

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

Ask the host to use a skill by name. For example: "Use kata-coverage to inspect test coverage." Skill invocation syntax depends on the host.

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
2. Include the skill's support files: `coverage_tool.exs` for `kata-coverage`,
   `LICENSE` for `kata-showme`, and `templates/docs-agents.md` for `kata-setup`.
3. Ask: "Save these files as a private skill. Keep the name from SKILL.md,
   the instructions, author credits, and support files. Resolve support file
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
The `private: true` field in `package.json` prevents accidental npm publication;
it does not control GitHub visibility or prevent Pi installs from Git.
No npm publication or public marketplace submission is configured.
