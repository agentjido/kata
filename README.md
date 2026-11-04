# Agent Jido Kata

[![Validate](https://github.com/agentjido/kata/actions/workflows/ci.yml/badge.svg)](https://github.com/agentjido/kata/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/agentjido/kata?display_name=tag&sort=semver)](https://github.com/agentjido/kata/releases)
[![License](https://img.shields.io/github/license/agentjido/kata)](LICENSE)
[![skills.sh](https://img.shields.io/badge/skills.sh-agentjido%2Fkata-black)](https://skills.sh/agentjido/kata)

An evidence-based knowledge-work system for coding agents.

Give `$jido` a normal-language goal. Jido selects the smallest useful route
through understanding, product decisions, planning, work, verification,
delivery, and reusable improvement. You can also use each Kata skill directly.

Agent Jido Kata complements the
[Jido Elixir framework](https://github.com/agentjido/jido), but it is a separate
project. Use the Jido framework to build distributed agent applications in
Elixir. Use Kata to guide the engineering work around those applications or
any other software project. Kata does not depend on the Jido runtime.

## Install

From the project where you use your coding agent:

```sh
npx skills add agentjido/kata
```

Select your coding agent and install `jido` with the leaf skills you want. Start
a new agent session if the host requires it. Then give Jido a goal:

```text
$jido review this repository for a public release and make the approved local changes
```

You can also ask your agent to install Kata for you:

```text
Install Agent Jido Kata from https://github.com/agentjido/kata for my user
account. Use npx skills as the default installer. Select this coding agent as
the target. Confirm that the jido skill is available. Tell me if I must start a
new session.
```

See the [installation guide](docs/guides/installation.md) for local checkouts,
host-specific options, and current compatibility limits.

## Why Kata

Coding agents often start work at the wrong level. They plan a known change,
implement an unclear idea, or report success without independent evidence.
Agent Jido Kata separates these result boundaries:

```text
Value:   understand -> idea? -> roadmap? -> plan -> work -> verify -> accept
Improve: maintain-skill -> write-skill -> accept
```

Jido enters at the first unresolved boundary. A small ready change can start at
work. An unclear problem starts with evidence. A long initiative can resolve
decisions before implementation planning.

The route does not expand authority. A request to inspect a repository does not
permit a commit, push, publication, live-system change, purchase, or deletion.

## Skills

### Primary workflow

| Skill | Result |
| --- | --- |
| `jido` | Route an explicit `$jido` goal to the smallest valid sequence. |
| `kata-understand` | Establish the current condition with evidence. |
| `kata-idea` | Settle product direction and requirements. |
| `kata-roadmap` | Resolve dependent long-horizon decisions. |
| `kata-plan` | Create a grounded software implementation plan. |
| `kata-work` | Produce one candidate result from ready work. |
| `kata-verify` | Judge a candidate against its acceptance contract. |
| `kata-shipit` | Commit, publish, watch, or land an accepted change. |

### Work-system improvement

| Skill | Result |
| --- | --- |
| `kata-maintain-skill` | Resolve one evidence-backed library finding. |
| `kata-write-skill` | Create, import, or convert one skill package. |
| `kata-dojo` | Evaluate an exact candidate only on explicit Dojo request. |

### Project support

| Skill | Result |
| --- | --- |
| `kata-debug` | Diagnose a reproducible failure and repair it when authorized. |
| `kata-docs` | Set up and maintain a project knowledge base. |
| `kata-orient` | Maintain scoped `AGENTS.md` and entry-point README files. |
| `kata-sitrep` | Report local and remote Git workbench state. |
| `kata-showme` | Explain a topic with focused diagrams and visuals. |
| `kata-technical-writing` | Write or review one technical artifact. |

### Elixir and Jido

| Skill | Result |
| --- | --- |
| `kata-build-jido` | Build current Jido actions, agents, runtime, and AI work. |
| `kata-ex-design-review` | Review an Elixir package as a principal engineer. |
| `kata-ex-quality` | Find and fix bounded Elixir package-quality findings. |

General skills use `kata-<task>`. Skills that require Elixir use
`kata-ex-<task>`. Read the [package guide](skills/README.md) to inspect the
layout and run the local catalog.

## Distribution and compatibility

Kata uses the [Agent Skills specification](https://agentskills.io/specification)
and a flat `skills/<name>/SKILL.md` layout. The primary distribution path is the
[`npx skills` installer](https://github.com/vercel-labs/skills). The repository
also includes manifests for Claude, Codex, Cursor, Grok, and Pi integrations.
An included manifest does not mean that native marketplace installation has
been verified for that host.

The repository has no runtime service, hook, or npm package. The `private: true`
setting in `package.json` prevents accidental npm publication. Some skills have
optional scripts or environment requirements, which their package documents.

Dojo is preserved experimental evaluation tooling. Normal use, validation, and
release do not run Dojo or start live model evaluations. Read the
[Dojo guide](dojo/README.md) only when you intentionally evaluate a skill.

## Project information

- [Documentation index](docs/README.md)
- [Installation guide](docs/guides/installation.md)
- [Release process](docs/guides/releasing.md)
- [Changelog](CHANGELOG.md)
- [Attribution](docs/reference/attribution.md)
- [Contributing](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

Agent Jido Kata is authored by Mike Hostetler and
[Jason Allum](https://github.com/jallum). It is licensed under
[Apache-2.0](LICENSE). Adapted material keeps its required package-specific
license notices and attribution.
