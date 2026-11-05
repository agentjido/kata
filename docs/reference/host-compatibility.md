# Host compatibility and package details

Status: Reference; host-specific checks remain limited

Last reviewed: 2026-11-05 (moved from the installation guide; runtime checks not repeated)

Use [the installation guide](../guides/installation.md) first. It uses
`npx skills`, the main install path. The sections below preserve alternative
host instructions and their known limits. They are not required for first use.

## Grok Build CLI

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

## Grok Bot

Grok Bot manages private skills in its own library. The Grok Build commands
above do not install skills into that library. For personal use, give the Bot
the skill files and ask it to save each one as a private skill:

1. Attach the selected `skills/kata-*/SKILL.md` file to a Bot conversation.
2. Include the skill's support files: `LICENSE` for `kata-showme`, the complete
   `kata-docs` and `kata-technical-writing` directories.
   Include `LICENSE` with `kata-build-jido`.
   Include both license files with `kata-debug`.
   Include all license files and references with `kata-idea`, `kata-roadmap`,
   `kata-verify`, and `kata-shipit`.
   For `kata-plan`, include the complete skill directory with `references/`
   and all license files.
   For `kata-ex-quality`, include the complete skill directory with its rule
   playbooks, CSV templates, backlog tool, coverage analyzer, dead-code analyzer,
   roots template, and analyzer reference.
   Include each pstack `LICENSE` or `LICENSE-PSTACK` file with its affected
   skill directory.
3. Ask: "Save these files as a private skill. Keep the name from SKILL.md,
   the instructions and support files, including license notices. Resolve support file
   paths from the saved skill directory. Tell me if you cannot retain a file."
4. Open **Settings → Plugins → Yours** and enable the saved skill for the Bot.
   Select it from the `/` menu.

Repeat for each skill you want to use. These are saved
copies; repeat the import when the source changes. The quality coverage route
needs Elixir and access to the target project's coverage files on the Bot
computer. Do not treat coverage as ready if the Bot cannot retain or run the
quality support scripts.

This uses the documented [Grok Bot private skill workflow](https://docs.x.ai/grok-bot/skills-routines-and-automations).
Support file retention and execution have not been tested. A direct Git
repository install into Grok Bot has not been verified. The public Kata
repository is not automatically added to the Grok Bot plugin catalog.

## Pi

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

The package files and skill paths have passed current static checks. Pi runtime
behavior has not been tested.

## Package structure

```text
skills/<name>/SKILL.md          Shared skill content
skills/README.md               Skill package and maintenance guide
skills/catalog.exs             Phoenix Playground live skill catalog
plugin.json                    Root plugin metadata
.claude-plugin/plugin.json     Claude plugin metadata
.claude-plugin/marketplace.json Local-source marketplace entry
.codex-plugin/plugin.json      Codex plugin metadata
.cursor-plugin/plugin.json     Cursor plugin metadata
.grok-plugin/plugin.json       Grok Build plugin metadata
package.json                   Pi package with the shared skills path
```

The package follows the root skills layout used by [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/57e409e5c8c2c472106bd7d87ac72b724b70826b). The skill text is specific to Kata. Each skill is self-contained and uses the [Agent Skills format](https://agentskills.io/specification).

[`npx skills`](https://github.com/vercel-labs/skills) is the main install path.
See the [installation guide](../guides/installation.md). It installs the skill files. The small host manifests provide a base for native plugin use later. Native host loading has not been tested.

The plugin has no build step, runtime service, or hook. `skills/catalog.exs` is
an optional local development app; it is not part of plugin execution.
`kata-ex-quality` includes Elixir scripts that read coverage data and analyze
source reachability in a target project. The dead-code JSON output needs Elixir
1.18 or later. Keep project root declarations in the target repository and pass
their path with `--roots`.
The `private: true` field in `package.json` prevents accidental npm publication;
it does not control GitHub visibility or prevent Pi installs from Git.
No npm publication or public marketplace submission is configured.

