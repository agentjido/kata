<p align="center">
  <img src="assets/agent-jido-kata.png" alt="Jido logo" width="180">
</p>

<h1 align="center">Jido Work System</h1>

<p align="center"><strong>WorkTutor teaches. Jido guides. The user leads.</strong></p>

<p align="center">
  <a href="https://github.com/agentjido/skills/actions/workflows/ci.yml"><img src="https://github.com/agentjido/skills/actions/workflows/ci.yml/badge.svg" alt="Validate status"></a>
  <a href="https://github.com/agentjido/skills/releases"><img src="https://img.shields.io/github/v/release/agentjido/skills?display_name=tag&amp;sort=semver" alt="Latest release"></a>
  <a href="https://skills.sh/agentjido/skills"><img src="https://img.shields.io/badge/skills.sh-agentjido%2Fskills-black" alt="Jido on skills.sh"></a>
  <a href="https://jido.run"><img src="https://img.shields.io/badge/website-jido.run-0f172a" alt="Jido website"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/agentjido/skills" alt="Apache 2.0 license"></a>
</p>

The Jido Work System contains two Agent Skills with separate jobs:

- `$jido` guides useful work. It selects the smallest internal work method,
  acts within your authority, checks the result, and continues through repair
  when a required check fails.
- `$tutor` teaches productive AI work through explanation, practice, and
  feedback. It is the first WorkTutor skill. Invoke it directly or use a clear
  request to learn, explore, practise, or review agent-led work.

You set the goal, limits, and authority. Jido coordinates work. Tutor supports
learning. Internal Katas and Tutor commands are not separate public skills.

## Install

Run this command from the workspace where you use your agent:

```sh
npx skills add agentjido/skills
```

Select `jido` and `tutor`, then start a new agent session if your host requires
it. Give Jido a goal:

```text
$jido turn these source notes into a decision brief and check its claims
```

For Codex, you can also make Jido a preference for substantial work. Add this
line to `~/.codex/AGENTS.md`:

```text
Prefer $jido for substantial or ambiguous work that benefits from routing, coordination, or verification; skip it for simple questions, direct commands, and small self-contained tasks.
```

This is a preference, not a requirement for every request. A direct `$jido`
request remains available when you want to select it yourself.

See the [installation guide](docs/guides/installation.md) for host options and
the trust boundary.

## How Jido works

Jido uses seven normal internal Katas and one explicit maintainer Kata:

| Kata | Purpose |
| --- | --- |
| Understand | Establish facts, causes, and current state. |
| Shape | Set direction, scope, decisions, and technical sequence. |
| Lead | Delegate bounded work. |
| Work | Produce one candidate result. |
| Verify | Check the candidate with evidence. |
| Improve | Maintain and revise reusable work methods. |
| Ship | Commit, publish, monitor, merge, tag, or release only with the required authority. |
| Dojo | Evaluate one exact method candidate only when the user explicitly names Dojo. |

These Katas are internal references in the `jido` package. They are not public
commands. Jido starts at the first unresolved contract and skips work that the
request already supplies.

## How Tutor works

Tutor has one public entry point: `$tutor`. It routes one learning goal through
the smallest useful combination of explanation, practice, feedback, and
current resources. Tutor can prepare a work handoff, but it does not perform
the work or grant itself new authority. Jido can recommend Tutor for a learning
gap. Tutor can prepare a `$jido` handoff to apply or verify what it teaches.
Neither skill invokes the other automatically.

## Authority

A route does not grant authority. Inspection does not permit a write. A local
change does not permit a commit. A commit does not permit a push. A push does
not permit a merge, tag, or release.

Jido asks for a decision only when the missing answer can materially change the
result, scope, cost, risk, authority, owner, or an irreversible effect.

## Local routines

A project can define repeatable local work in `docs/routines/`. Jido can list,
show, make, validate, or run these routines through the normal `$jido` entry
point:

```text
$jido make a dependency health routine
$jido run the dependency health routine
$jido run all routines
```

A routine can produce a bounded work request for the existing Jido Katas. It
cannot grant authority. Task systems, schedulers, and notification services are
extension points rather than part of the routine loop.

## Specialist skills

Jido can use a separate team or domain skill only when the host already exposes
it. Jido does not scan the file system or install missing skills. Elixir and
Jido SDK specialist methods are not part of this general package.

## Version 1.0

Version 1.0 removes the former public `kata-*` commands. There are no aliases
or compatibility wrappers. The published `v0.5.0` release remains the last
multi-skill package.

## Project links

- [Jido package guide](skills/README.md)
- [Installation guide](docs/guides/installation.md)
- [Latest releases](https://github.com/agentjido/skills/releases)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
- [Release process](docs/guides/releasing.md)
- [Attribution](docs/reference/attribution.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Documentation index](docs/README.md)

Jido Skills is authored by [Jidoka Labs](https://jidokahq.com) and licensed
contributors. It is licensed under [Apache-2.0](LICENSE). Adapted material keeps
its required license notices and attribution.
