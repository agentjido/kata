---
id: release-gates
status: active
authority: read-only
---

# Release gates

## Outcome

The local deterministic CI gates outside the package-specific Jido check pass,
or each failure has exact command evidence.

## Trigger

Run before a commit, pull request, merge, tag, or release decision.

## Scope

Include local repository validation only. Exclude remote CI, Git writes, pull
requests, tags, releases, and Dojo.

## Inputs

- `.github/workflows/ci.yml`
- `scripts/validate_release.exs`
- `scripts/release_changelog_test.exs`
- `skills/catalog.exs`
- Repository manifests, Markdown files, and release configuration read by the
  commands

## Steps

1. Run `elixir scripts/validate_release.exs`.
2. Run `elixir scripts/release_changelog_test.exs`.
3. Run `mix format --check-formatted scripts/*.exs`.
4. Run `elixir skills/catalog.exs --check`.

The `jido-package` routine owns `elixir scripts/validate_jido_package.exs`.

## Findings

Create one finding for each failed command. Keep the first failing assertion,
affected files, and exit status. Do not lower a gate or modify release-owned
files to make a check pass.

## Done

All four commands pass, or every failure has a bounded finding and repair
owner. The run does not change repository or remote state.

## Handoff

Send an authorized local repair to the delivery loop and return it to the
failed gate. Git delivery remains a separate `ship` request.
