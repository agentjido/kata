# Host compatibility and package details

Status: Reference; host-specific runtime checks remain limited

Last reviewed: 2026-11-09

Use [the installation guide](../guides/installation.md) first. It uses
`npx skills`, the main install path.

## Public package shape

The repository contains two public Agent Skills:

```text
skills/jido/SKILL.md
skills/tutor/SKILL.md
```

Internal Kata contracts and detailed methods are support files below that
package. Internal Tutor commands and learning content are support files below
the Tutor package. A host must not expose these internal files as separate
commands.

## Grok Build CLI

Start Grok from a local checkout:

```sh
grok --plugin-dir /path/to/kata
```

For a saved installation:

```sh
grok plugin install /path/to/kata --trust
grok plugin enable kata
```

To install from GitHub:

```sh
grok plugin install agentjido/skills --trust
grok plugin enable kata
```

Start a new session and select `jido`. Native loading has not been checked for
this revision.

## Pi

From the target project, register the local checkout at project scope:

```sh
pi install -l /path/to/kata
```

To install from GitHub:

```sh
pi install -l git:github.com/agentjido/skills
```

Omit `-l` for a user-wide install. Start a new Pi session and ask it to use
`jido`. Pi runtime behavior has not been checked for this revision.

## Package structure

```text
skills/jido/SKILL.md             Public Agent Skill
skills/jido/references/katas/    Internal work contracts
skills/jido/references/methods/  Detailed methods and license notices
skills/tutor/SKILL.md            Public WorkTutor learning skill
skills/tutor/references/         Internal learning commands and content
skills/README.md                 Package and maintenance guide
skills/catalog.exs               Optional local package view
plugin.json                      Portable plugin metadata
.claude-plugin/plugin.json       Claude plugin metadata
.codex-plugin/plugin.json        Codex plugin metadata
.cursor-plugin/plugin.json       Cursor plugin metadata
.grok-plugin/plugin.json         Grok Build plugin metadata
package.json                     Pi package metadata
```

The package uses the [Agent Skills format](https://agentskills.io/specification).
It has no build step, runtime service, required MCP server, or hook.
`skills/catalog.exs` is an optional development app.

The `private: true` field in `package.json` prevents accidental npm
publication. It does not control GitHub visibility or prevent Pi installation
from Git.
