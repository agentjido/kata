<p align="center">
  <img src="assets/jido-work-system-logo-v1.png" alt="Jido Work System logo" width="180">
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

The Jido Work System gives your AI agent two skills:

- `$jido` carries one goal to a checked result. It plans the smallest set of
  steps, works inside the authority that you give, and checks the result.
- `$tutor` teaches you to direct and check agent work. It uses your real task
  for practice and gives feedback on what you write.

You set the goal, the limits, and the authority. You decide whether the result
is useful.

## Install

You need Node.js and npm. Open the workspace where you use your agent, then
run:

```sh
npx skills add agentjido/skills
```

Select `jido` and `tutor`. Start a new agent session so that the host loads
them.

This README uses `$jido` and `$tutor`. If your host uses a different skill
syntax, such as `/jido`, use that syntax. See the
[installation guide](docs/guides/installation.md) for host options and the
trust boundary.

## Start here: your first real task

Use this path if you are new to agent work or new to Jido. It takes one real
task from a clear request to a checked result.

1. **Start Tutor.** Send `$tutor` with no other text. Tutor welcomes you and
   asks which real task you have now. This reply also shows that the install
   works.
2. **Bring one real task.** Pick a small task that you need this week. Tutor
   helps you state the result that you need and a check that shows when it is
   done. Tutor gives feedback, and you revise.
3. **Get a Jido request.** Ask Tutor to turn your work into a `$jido` request.
   Tutor writes the request, but it does not run it.
4. **Run it with Jido.** Send the request. Jido states its sequence and
   authority in one line, does the work, and returns the result with evidence.
5. **Check the result.** Send `$tutor review this result against my done
   check`. Tutor helps you accept the result or write a specific repair
   request.

An example start. The exact words change with the host and model:

```text
You:   $tutor
Tutor: Welcome. Which real task do you have now? We can start with a
       first win on that task, or I can show the topics.
You:   I need to compare three vendors for my team lead.
Tutor: What should exist when the work is done, and how will your team
       lead check it?
```

The Jido request that comes from this lesson can look like this:

```text
$jido compare vendors A, B, and C on price, support hours, and contract length, with one source for each cell. Read only the vendor sites and my budget note. Do not contact a vendor.
```

Jido starts with one sequence and authority line, for example:

```text
Jido | Sequence: produce comparison table → check each source | Authority: read-only — vendor sites and budget note only; no external contact.
```

## Fast path: go straight to Jido

If you already direct agents, give Jido a goal and a limit:

```text
$jido find why the nightly report job failed, fix it locally, and show the passing run. Do not commit or push.
```

Tell Jido what you need, not how to do it. Jido selects the steps.

If you need a quick reminder, ask for the capability menu:

```text
$jido help
```

The menu groups Jido's 19 detailed methods below eight internal routes. It
gives one natural-language request for each capability. You still give Jido a
goal in ordinary language. The routes and methods are not separate commands.

## Optional project role

A project can define Jido's job in `docs/ROLE.md`. When that fixed file exists,
Jido reads its purpose, responsibilities, decision rights, reserved decisions,
and success measures before it selects the work route. The role can describe
named reviews, but it does not run them or create a schedule.

The live request still supplies the goal and authority. The role cannot select
a Kata or override active project instructions. Jido's documentation setup
creates a light default role when the file is missing.

## Which entry to use

| You want | Use | Example |
| --- | --- | --- |
| An answer or one small action | A direct request | What does this error message mean? |
| A checked result from work with several steps or an unclear part | `$jido` | `$jido turn these notes into a decision brief and check its claims` |
| To learn how to direct, check, or improve agent work | `$tutor` | `$tutor help me check this agent's report` |

Jido and Tutor do not start each other. Jido can recommend a `$tutor` request
for a learning gap. Tutor can write a `$jido` request for you to send.

## Give authority in the request

A request grants only the actions that it names. State the limit with the goal:

| Limit | Example request |
| --- | --- |
| Inspect and report | `$jido explain why the export test fails. Do not change files.` |
| Change local files | `$jido fix the export test locally. Do not commit.` |
| Named external actions | `$jido fix the export test, commit it, and open a pull request. Do not merge.` |

Each action needs its own authority. Inspection does not permit a write. A
local change does not permit a commit. A commit does not permit a push. A push
does not permit a merge, tag, or release.

Jido asks a question only when the answer can materially change the result,
scope, cost, risk, authority, owner, or an irreversible effect.

## How Jido works

Jido uses only the steps that your goal needs, in this order:

| Step | What it does |
| --- | --- |
| Investigate | Establish facts, causes, and current state. |
| Plan | Set direction, scope, decisions, and sequence. |
| Delegate | Give bounded work to separate workers and integrate the return. |
| Produce | Make one candidate result. |
| Check | Check the candidate against its acceptance conditions with evidence. |
| Deliver | Commit, push, open a pull request, merge, tag, or release, only with that authority. |

Jido starts at the first step that your request does not already resolve. Its
startup line uses these verbs, so you can see the selected sequence. The same
line shows the authority level and the important limits. A separate request
to improve a reusable work method uses an `improve` step.

For a material or risky check, Jido uses a separate worker when the host
supports one. When it cannot, it labels the verdict `self-checked`.

These steps are internal methods, called Katas, in `skills/jido/references/`.
You do not need their names to use Jido.

## How Tutor works

Tutor teaches effective AI work through the Jido Work System. It can coach
you on a task in any field, but it teaches the work method, not the field. For
example, it can help you direct an agent on a biology task, but it does not
teach biology.

You can:

- ask a direct question about agent work;
- explore the topics and choose one;
- get coaching on a real task;
- take one short lesson on a real task; or
- get a review of work that you or an agent produced.

The topics are: define useful work, direct agents, use Jido, verify work,
improve work, and agentic engineering for software work.

Tutor is read-only. It does not edit files, run work, or store a learner
profile. At the end of a practice exchange, it can give you a short progress
note. You keep the note and can bring it back next time.

## Local routines

A project can define repeatable local work in `docs/routines/`. Jido can list,
show, make, validate, or run these routines:

```text
$jido make a dependency health routine
$jido run the dependency health routine
$jido run all routines
```

A routine produces a bounded work request. It cannot grant authority. Task
systems, schedulers, and notification services are outside the routine loop.

## Specialist skills

Jido can use a separate team or domain skill only when the host already
exposes it. Jido does not scan the file system or install missing skills.
Elixir and Jido SDK specialist methods are not part of this general package.

## Make Jido a default

Use Jido without `$jido` for substantial work by adding a standing preference
to your host. For Codex, add this line to `~/.codex/AGENTS.md`:

```text
Prefer $jido for substantial or ambiguous work that benefits from routing, coordination, or verification; skip it for simple questions, direct commands, and small self-contained tasks.
```

This is a preference, not a requirement for every request. A direct `$jido`
request remains available.

## Upgrading from 0.5

Version 0.6 replaces the former public `kata-*` commands with two public
skills: Jido and Tutor. The detailed work methods remain internal to Jido.
There are no aliases or compatibility wrappers. The `v0.5.0` release remains
the last multi-skill package.

## Maintainers

Dojo is opt-in evaluation tooling for one exact method candidate. Jido uses it
only when a request names Dojo. See [Contributing](CONTRIBUTING.md) before you
change a skill.

## Project links

- [Jido package guide](skills/README.md)
- [Installation guide](docs/guides/installation.md)
- [Host compatibility](docs/reference/host-compatibility.md)
- [Latest releases](https://github.com/agentjido/skills/releases)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
- [Release process](docs/guides/releasing.md)
- [Attribution](docs/reference/attribution.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Documentation index](docs/README.md)

The Jido Work System is authored by [Jidoka Labs](https://jidokahq.com) and
licensed contributors. It is licensed under [Apache-2.0](LICENSE). Adapted
material keeps its required license notices and attribution.
