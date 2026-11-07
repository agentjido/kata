# Releasing Agent Jido Kata

Status: Current

Last reviewed: 2026-11-07

This guide defines the maintainer process for one repository-wide release. A
release is a remote write. Do not push a tag or create a release without explicit
maintainer authority.

## Release contract

- `package.json` contains the canonical semantic version.
- The other five versioned manifests must match `package.json`.
- `.release-please-manifest.json` must match `package.json`.
- `CHANGELOG.md` must have a dated section for that version.
- A release tag is `v<version>`.
- A release tag must be annotated and must point to the reviewed release source.
- A tag creates a GitHub Release from its changelog section only after
  validation passes.
- Kata does not publish an npm package or another registry artifact.
- Dojo is an internal support tool. It has separate maintenance automation. It
  is not a release gate, release artifact, version source, or release-notes
  source.

## Prepare the release pull request

The `Release Please` workflow reads Conventional Commits on `main`. It creates
or updates one release pull request. That pull request updates `package.json`,
the other five versioned manifests, `.release-please-manifest.json`, and
`CHANGELOG.md`.

Release Please does not create the tag or GitHub Release. The repository keeps
that work in the annotated-tag release workflow.

1. Review the proposed version and changelog.
2. Confirm that all six public version files and the Release Please manifest
   use the same version.
3. Review the README, installation guide, license, and attribution when the
   release changes those contracts.
4. Run the same Elixir release validator used by CI.

Run the repository checks from the repository root:

```sh
version="$(node --print 'require("./package.json").version')"
elixir scripts/validate_release.exs
elixir scripts/release_changelog_test.exs
elixir skills/catalog.exs --check
elixir scripts/validate_release.exs --tag "v${version}"
elixir scripts/release_notes.exs "${version}"
```

Release Please uses a Conventional Commit title such as
`chore(release): prepare 0.6.0`. Merge the release pull request only after the
`Validate` and `Jido Review` workflows pass on the release source.

The workflow uses `RELEASE_PLEASE_TOKEN` when that Actions secret exists. It
otherwise uses the built-in `GITHUB_TOKEN`. GitHub does not start new workflows
for a pull request that the built-in token creates. Configure a fine-grained
token with only repository contents, issues, and pull request write access for
the normal automatic path. If the workflow uses the fallback token, do not
merge the release pull request until a trusted maintainer causes both checks to
run on its current head.

Do not add Dojo checks to the release pull request or release workflow. The
separate `Dojo Maintenance` workflow owns scheduled and dependency checks for
that tool.

## Create the release

With explicit authority, create and push an annotated matching tag:

```sh
version="$(node --print 'require("./package.json").version')"
git tag -a "v${version}" -m "Agent Jido Kata ${version}"
git push origin "v${version}"
```

The `Release` workflow validates the tagged source and extracts its notes from
the matching `CHANGELOG.md` section. It does not run Dojo. Confirm the result:

```sh
version="$(node --print 'require("./package.json").version')"
gh run list --workflow Release --limit 5
gh release view "v${version}"
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
