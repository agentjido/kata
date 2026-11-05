# Agent Jido Kata

[![Validate](https://github.com/agentjido/kata/actions/workflows/ci.yml/badge.svg)](https://github.com/agentjido/kata/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/agentjido/kata?display_name=tag&sort=semver)](https://github.com/agentjido/kata/releases)
[![License](https://img.shields.io/github/license/agentjido/kata)](LICENSE)
[![skills.sh](https://img.shields.io/badge/skills.sh-agentjido%2Fkata-black)](https://skills.sh/agentjido/kata)

**Lead your agents. Deliver verified work.**

Kata is a skill pack for agentic productivity. Give `$jido` a goal. It selects
work steps to research, decide, produce a result, and check it.

Use it for research, reports, content, operations, and software. You set the
goal and limits. Your agent uses the tools and models available in its host.

## Install

Run this command from the workspace where you use your agent:

```sh
npx skills add agentjido/kata
```

Select your agent host. Install `jido` and the Kata skills you want it to use.
Start a new agent session if your host requires it.

See the [installation guide](docs/guides/installation.md) for more detail.
List optional installed skills in `<user-home>/.jido/extra-skills.md`; Jido reads
this file only when no included skill matches and ignores it when it is absent.

## Give Jido a task

```text
$jido turn these source notes into a decision brief and check its claims
```

Include the source files, desired result, and limits in your request. Jido
starts with the first step that needs work. A clear task can start at execution.
An unclear problem starts with research. Verification checks the result against
the request.

A route does not expand authority. A request to inspect a project does not
permit a commit, push, publication, live-system change, purchase, or deletion.

You can also ask Jido to:

- Teach you how to turn one real task into a clear first assignment.
- Scope a rough request into bounded work with completion evidence.
- Delegate defined work and manage its return.
- Compare proposals against your requirements.
- Turn meeting notes into a report with decisions and next actions.
- Prepare launch content and check its product claims.
- Investigate a software failure and verify an authorized fix.
- Turn a repeated process into a reusable skill.

## Lead and delegate

Define the result, give the agent a clear task, and review the evidence. Change
the work steps when new facts change the problem. An automation can use the same
process when it defines its inputs, allowed actions, outputs, and checks. Your
host or automation system provides model access, delegation tools, and
scheduling.

Start with [`kata-tutor`](skills/kata-tutor/SKILL.md) when you want guided
practice. Use [`kata-scope`](skills/kata-scope/SKILL.md) to bound a rough
request and [`kata-delegate`](skills/kata-delegate/SKILL.md) to assign defined
work. These steps are optional. Jido skips them when the work is already clear
or one direct worker is enough.

General Kata skills work across languages and domains. The pack also includes
specialist skills for Elixir and the [Jido framework](https://github.com/agentjido/jido).
Kata does not require the Jido runtime.

## Learn more

- [Skill list and package guide](skills/README.md)
- [Installation guide](docs/guides/installation.md)
- [Documentation index](docs/README.md)
- [Contributing](CONTRIBUTING.md)
- [Release process](docs/guides/releasing.md)
- [Changelog](CHANGELOG.md)
- [Attribution](docs/reference/attribution.md)
- [Security policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

Agent Jido Kata is authored by Mike Hostetler and
[Jason Allum](https://github.com/jallum). It is licensed under
[Apache-2.0](LICENSE). Adapted material keeps its required package-specific
license notices and attribution.
