<p align="center">
  <img src="assets/agent-jido-kata.png" alt="Agent Jido Kata logo" width="180">
</p>

<h1 align="center">Agent Jido Kata</h1>

<p align="center"><strong>Lead your agents. Deliver verified work.</strong></p>

<p align="center">
  <a href="https://github.com/agentjido/kata/actions/workflows/ci.yml"><img src="https://github.com/agentjido/kata/actions/workflows/ci.yml/badge.svg" alt="Validate status"></a>
  <a href="https://github.com/agentjido/kata/releases"><img src="https://img.shields.io/github/v/release/agentjido/kata?display_name=tag&amp;sort=semver" alt="Latest release"></a>
  <a href="https://skills.sh/agentjido/kata"><img src="https://img.shields.io/badge/skills.sh-agentjido%2Fkata-black" alt="Kata on skills.sh"></a>
  <a href="https://jido.run"><img src="https://img.shields.io/badge/website-jido.run-0f172a" alt="Jido website"></a>
  <a href="https://jido.run/discord"><img src="https://img.shields.io/badge/discord-join-5865F2?logo=discord&amp;logoColor=white" alt="Join the Jido Discord"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/agentjido/kata" alt="Apache 2.0 license"></a>
</p>

Kata is an open-source skill pack that gives an AI agent a clear path from a
goal to a checked result. Start with `$jido` and state the result that you need.
Jido selects the smallest useful work route and starts at its first unfinished
step.

Use Kata for research, reports, content, operations, and software. You set the
goal, source material, limits, and approval boundaries. Your agent uses the
tools and models that its host provides.

## Install

Run this command from the workspace where you use your agent:

```sh
npx skills add agentjido/kata
```

Select your agent host. Install `jido` and the Kata skills you want it to use.
Start a new agent session if your host requires it.

See the [installation guide](docs/guides/installation.md) for host options,
local installation, and the trust boundary.

## Give Jido a task

```text
$jido turn these source notes into a decision brief and check its claims
```

Include the source files, desired result, and limits in your request. Jido can:

1. Research missing facts.
2. Scope or plan work when the result is not ready to produce.
3. Produce one candidate result.
4. Check the result against your request.

Jido uses only the steps that the task needs. A clear task can start at
execution. An unclear problem starts with research.

Jido keeps responsibility for the requested outcome through failed checks,
repair, and verification. It resolves necessary discovered work within your
scope and authority. It continues while an authorized next action remains,
respects review points and resource limits, and reports the exact unmet
condition when completion is blocked. A request for an answer, review, or plan
ends at that result.

A route does not expand authority. A request to inspect a project does not
permit a commit, push, publication, live-system change, purchase, or deletion.

Example goals include:

- Teach you how to turn one real task into a clear first assignment.
- Scope a rough request into bounded work with completion evidence.
- Delegate defined work and manage its return.
- Compare proposals against your requirements.
- Turn meeting notes into a report with decisions and next actions.
- Prepare launch content and check its product claims.
- Investigate a software failure and verify an authorized fix.
- Turn a repeated process into a reusable skill.

## Choose a skill directly

Kata includes 23 skill packages. You can invoke one package directly when you
already know the work that you need. Use the [skill list](skills/README.md) to
find packages for research, scoping, planning, implementation, verification,
documentation, security, Git delivery, Elixir, and the Jido framework.

Start with [`kata-tutor`](skills/kata-tutor/SKILL.md) when you want guided
practice. Use [`kata-scope`](skills/kata-scope/SKILL.md) to bound a rough
request and [`kata-delegate`](skills/kata-delegate/SKILL.md) to assign defined
work. These steps are optional. Jido skips them when the work is already clear
or one direct worker is enough.

General Kata skills work across languages and domains. The pack also includes
specialist skills for Elixir and the [Jido framework](https://github.com/agentjido/jido).
Kata does not require the Jido runtime.

## Add private or team skills

Keep private skills in a separate repository. List optional installed skills in
`<user-home>/.jido/extra-skills.md`. Jido reads this file only when no included
skill matches. Jido ignores the file when it is absent.

Review each optional skill before you list it. Kata does not validate private
or third-party skills.

## Community and project links

- [Skill list and package guide](skills/README.md)
- [Installation guide](docs/guides/installation.md)
- [Latest releases](https://github.com/agentjido/kata/releases)
- [Changelog](CHANGELOG.md)
- [Jido community](https://jido.run)
- [Jido Discord](https://jido.run/discord)
- [Contributing](CONTRIBUTING.md)
- [Release process](docs/guides/releasing.md)
- [Attribution](docs/reference/attribution.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Documentation index](docs/README.md)

Agent Jido Kata is authored by [Jidoka Labs](https://jidokahq.com) and licensed
contributors. It is licensed under [Apache-2.0](LICENSE). Adapted material keeps
its required package-specific license notices and attribution.
