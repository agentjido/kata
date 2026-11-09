# Releasing the Jido Work System

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
- Release Please creates the tag and GitHub Release from the reviewed release
  pull request only after validation passes.
- Kata does not publish an npm package or another registry artifact.
- Dojo is an internal support tool. It has separate maintenance automation. It
  is not a release gate, release artifact, version source, or release-notes
  source.

## Prepare the release pull request

Every push to `main` starts the `Validate and Release` workflow. The workflow
first runs the release validator, changelog tests, formatting check, and
catalog check. It then reads Conventional Commits and creates or updates one
release pull request. That pull request updates `package.json`, the other five
versioned manifests, `.release-please-manifest.json`, and `CHANGELOG.md`.

A normal push does not publish immediately. A maintainer must review and merge
the release pull request. That merge is another push to `main`. After the same
checks pass, Release Please creates the matching `v<version>` tag and GitHub
Release.

The release pull request merge is the publication trigger. Do not create the
tag or GitHub Release by hand during the normal process. The workflow must own
both results so that they identify the checked release commit.

1. Review the proposed version and changelog.
2. Confirm that all six public version files and the Release Please manifest
   use the same version.
3. Preserve the generated release pull request body. Release Please parses it
   after merge to identify the version and create the tag and GitHub Release.
   Put detailed release notes in `CHANGELOG.md`; do not replace the pull
   request body with a custom template.
4. Review the README, installation guide, license, and attribution when the
   release changes those contracts.
5. Run the same Elixir release validator used by CI.

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

Ordinary pull requests cannot change release-owned versions, the Release
Please manifest, or `CHANGELOG.md`. CI permits those files only on the Release
Please branch. Changes limited to `.github/`, `docs/`, `dojo/`, and `scripts/`
do not cause a public skills release.

Do not add Dojo checks to the release pull request or release workflow. The
separate `Dojo Maintenance` workflow owns scheduled and dependency checks for
that tool.

## Configure the release GitHub App

Create one private GitHub App for release automation. Do not enable webhooks,
user authorization, or organization permissions.

Grant these repository permissions only:

- Contents: Read and write.
- Issues: Read and write.
- Pull requests: Read and write.
- Metadata: Read-only. GitHub grants this permission automatically.

Install the app on this repository only. Generate one private key, then add:

- repository variable `RELEASE_APP_CLIENT_ID`, set to the app Client ID;
- repository secret `RELEASE_APP_PRIVATE_KEY`, set to the complete PEM private
  key, including its begin and end lines.

The workflow requests a one-hour installation token for the current repository
and narrows it again to the four permissions above. The token is masked and is
revoked when the release job ends. Never commit the private key or put it in a
repository variable.

After configuration, use the workflow dispatch control once. A successful run
with no releasable commits can finish without a release pull request. This is a
valid token and configuration test.

## Confirm the automatic release

After a release pull request merges, confirm the workflow, tag, and release:

```sh
version="$(node --print 'require("./package.json").version')"
gh run list --workflow "Validate and Release" --limit 5
gh release view "v${version}"
```

Do not move a published release tag. If released source is wrong, stop the
launch, assess impact, and prepare a corrective version. Delete or move a tag
only with explicit destructive authority and only when no consumer can depend
on it.

## Check distribution

After the GitHub Release exists:

1. Confirm that `npx skills add agentjido/skills --list` finds `jido` and
   `tutor`, with no former public `kata-*` packages.
2. Inspect [the skills.sh page](https://www.skills.sh/agentjido/skills).
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
