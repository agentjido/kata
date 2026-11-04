# Releasing Agent Jido Kata

Status: Current

Last reviewed: 2026-11-04

This guide defines the maintainer process for one repository-wide release. A
release is a remote write. Do not push a tag or create a release without explicit
maintainer authority.

## Release contract

- `VERSION` is the canonical semantic version.
- All six versioned manifests must equal `VERSION`.
- A release tag is `v<VERSION>`.
- A tag creates a GitHub Release only after validation passes.
- Kata does not publish an npm package or another registry artifact.

## Prepare the release change

1. Confirm the worktree and preserve unrelated changes.
2. Update `VERSION`, all versioned manifests, and `CHANGELOG.md`.
3. Confirm that the changelog date is the intended release date.
4. Review the README, installation guide, license, notice, and attribution.
5. Run the same Elixir release validator used by CI.

Run the repository checks from the repository root:

```sh
elixir scripts/validate_release.exs
elixir skills/catalog.exs --check
elixir scripts/validate_release.exs --tag "v$(cat VERSION)"
```

Open and merge a reviewed pull request. Confirm that the `Validate` workflow
passes on the release source.

## Create the release

With explicit authority, create and push an annotated matching tag:

```sh
version="$(cat VERSION)"
git tag -a "v${version}" -m "Agent Jido Kata ${version}"
git push origin "v${version}"
```

The `Release` workflow validates the tagged source and uses GitHub-generated
release notes. Confirm the result:

```sh
gh run list --workflow Release --limit 5
gh release view "v$(cat VERSION)"
```

Do not move a published release tag. If released source is wrong, stop the
launch, assess impact, and prepare a corrective version. Delete or move a tag
only with explicit destructive authority and only when no consumer can depend
on it.

## Check distribution

After the GitHub Release exists:

1. Confirm that `npx skills add agentjido/kata --list` finds the current skills.
2. Inspect [the skills.sh page](https://www.skills.sh/agentjido/kata).
3. If the page is stale, collect the current revision, expected package names,
   stale names, and installer result.
4. With explicit remote-write authority, request a refresh in the
   [`vercel-labs/skills` issue tracker](https://github.com/vercel-labs/skills/issues).
5. Delay the main launch announcement until the listing is accurate or clearly
   direct users to the GitHub source.

## Configure repository protection

After the first successful validation run, enable branch protection for `main`:

- require a pull request;
- require the `validate` job;
- require the branch to be current before merge; and
- block force pushes and deletion.

Repository settings are remote state and need separate authority.
