# Kata

Personal engineering practices for coding agents.

Observe. Build. Verify. Improve.

This is a small, private spike for Mike Hostetler's process. The skills are a starting point. Change them as actual work shows what helps.

## Process

Understand the current condition. Set a clear target. Make a small change. Check the result. Keep useful lessons.

Use the amount of planning that the work needs. A small fix can use a few lines in the conversation. A larger change can use a written plan. Specifications are one tool in the process.

| Skill | Job |
| --- | --- |
| `kata-observe` | Inspect the current behavior, code, and constraints. |
| `kata-plan` | Set the target and choose the smallest useful change. |
| `kata-build` | Make the change and respond to evidence. |
| `kata-verify` | Check the result against the target. |
| `kata-review` | Find defects and unnecessary complexity in a change. |
| `kata-reflect` | Record a useful lesson and improve the working method. |

Use a skill by name when you need it. The skills can run separately. The full cycle is observe, plan, build, verify, review, then reflect. A small task does not need six separate requests or documents.

## Personal installation

The repository must remain private. Installation requires Git access to `agentjido/kata`.

From the project where you want to use Kata:

```sh
npx skills add agentjido/kata --agent codex
```

Select another host with `--agent claude-code` or `--agent cursor`. To use the local checkout:

```sh
npx skills add ~/Source/Kata/kata --agent codex
```

These commands install skills at project scope. Installation was not tested for this spike.

Ask the host to use a skill by name. For example: "Use kata-observe to inspect the retry failure." Skill invocation syntax depends on the host.

## Package structure

```text
skills/<name>/SKILL.md          Shared skill content
plugin.json                    Root plugin metadata
.claude-plugin/plugin.json     Claude plugin metadata
.claude-plugin/marketplace.json Local-source marketplace entry
.codex-plugin/plugin.json      Codex plugin metadata
.cursor-plugin/plugin.json     Cursor plugin metadata
```

The package follows the root skills layout used by [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/57e409e5c8c2c472106bd7d87ac72b724b70826b). The skill text is specific to Kata. Each skill is self-contained and uses the [Agent Skills format](https://agentskills.io/specification).

[`npx skills`](https://github.com/vercel-labs/skills) installs the skill files. The small host manifests provide a base for native plugin use later. No native host loading was tested for this spike.

There is no build step, runtime service, hook, or package dependency. No npm publication or public marketplace submission is part of this spike.
