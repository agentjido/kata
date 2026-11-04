# Contributing to Agent Jido Kata

Thank you for improving Agent Jido Kata. Keep each change small, supported by a
real use case, and easy to review.

## Before you start

1. Read [AGENTS.md](AGENTS.md) and the relevant package or documentation guide.
2. Search existing issues and pull requests.
3. Open an issue before a broad workflow change, package rename, new skill, or
   public compatibility change.
4. Preserve package-specific licenses and the
   [attribution record](docs/reference/attribution.md).

## Make a change

- Keep each skill self-contained under `skills/<name>/`.
- Use the standard Agent Skills frontmatter fields. Put Kata facets under
  `metadata` as string values.
- Keep instructions independent of one coding host.
- Do not include credentials, private data, or copied material without clear
  reuse rights.
- Add or update direct checks for changed scripts and public contracts.
- Do not run Dojo unless the work explicitly requires a controlled evaluation.

Run the Elixir release validator:

```sh
elixir scripts/validate_release.exs
```

If the change affects the local catalog, also run:

```sh
elixir skills/catalog.exs --check
```

## Submit a pull request

Explain the problem, the selected change, preserved behavior, and the checks
that ran. Keep unrelated changes out of the pull request. A contribution that
you intentionally submit is licensed under the repository's
[Apache-2.0 license](LICENSE), unless you clearly state otherwise.

Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in all project spaces.
