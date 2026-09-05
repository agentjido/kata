---
name: kata-ex-hunt-dead-code
description: Find unused Elixir modules and module groups through reachability analysis. Use when auditing dead code, checking abandoned subsystems, or removing confirmed unused code and its tests.
metadata: {language: elixir}
---

# Kata Hunt Dead Code

Treat code unreachable from declared production roots as a candidate for removal.
Tests do not establish production reachability. A group whose only callers are
its own members and tests can still be unused. Static analysis proposes candidates;
source review and verification determine what can be removed.

## Establish roots and run

Read project instructions and Git status. Preserve existing edits. Resolve
`<skill-directory>` to the absolute directory containing this file and
`<project-root>` to the requested Elixir project. The analyzer reads source files;
it supports ordinary Mix projects and umbrellas without project dependencies.

Inspect existing root declarations. If needed, copy the bundled `roots.exs`
template to `.kata/dead-code-roots.exs` in the target repository. Preserve an
existing file. Fill `public_api` with application entry points or the library's
supported public modules. Add dynamic entry points under `roots`, with reasons.
Paths are relative to the target repository. Do not put project entries in a
shared skill directory. An empty root list can make live code appear unused.

```sh
elixir "<skill-directory>/scripts/dead_code.exs" --root "<project-root>" --roots .kata/dead-code-roots.exs --json
```

`--roots` is relative to `--root`; absolute paths also work. Without `--roots`,
the analyzer uses the target's `.agents/skills/kata-ex-hunt-dead-code/roots.exs`, then
the bundled template. JSON output needs Elixir 1.18+; omit `--json` for text.

## Check each candidate

Read [reference.md](reference.md) for known analysis limits. Search code, tests,
configuration, `priv/`, documentation, and history for each module and runtime
name. Check macros and quoted code, behaviours, protocols, dynamic dispatch,
telemetry handlers, supervision children, and work still in progress.

Treat unused public API and function lists as advisory. External users can call
public modules. Function detection uses names without distinguishing arities;
callbacks and intentional test helpers need review. Missing static callers alone
do not justify removal.

## Remove and verify

For an audit, report findings. When removal is requested, work on one confirmed
group at a time. Remove its modules and dedicated tests; edit only the relevant
blocks in mixed test files. Update affected aliases, Mix entries, and documentation.

Run `mix compile --force --warnings-as-errors`, formatting checks, tests, and the
project's configured analysis checks. For dynamic runtime connections, also run
the integration or application-start checks that exercise them. Report missing
checks as limits on confidence.

If verification shows a module is used, undo only your removal and record its
entry point and reason in the project's roots file. Follow project rules for
branches and commits. Report candidates, retained modules and reasons, changes,
checks, and unresolved runtime paths.
