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

For every public skill change:

- Keep one clear user goal, trigger boundary, expected input, work method,
  output, stop condition, and authority boundary.
- State both what the skill does and when to use it in the description.
- Keep `SKILL.md` below 500 lines. Put selected detail in linked references,
  deterministic work in scripts, and reusable output material in assets.
- Link support files from `SKILL.md` and explain when to read or run them.
  Avoid deep reference chains.
- Test direct and indirect requests, missing input, near-miss requests that
  must not activate the skill, and high-risk edge cases.
- Review every bundled file for unexpected network access, file access, writes,
  secrets, executable content, and license requirements.
- Keep explicit user instructions and host safety controls above skill
  guidance. A skill must not expand the authority in the current request.

Run the Elixir release validator:

```sh
elixir scripts/validate_release.exs
```

If the change affects the local catalog, also run:

```sh
elixir skills/catalog.exs --check
```

## Use Conventional Commits

Use a Conventional Commit subject for each direct commit and pull request
title. The allowed types are `build`, `chore`, `ci`, `docs`, `feat`, `fix`,
`perf`, `refactor`, `revert`, `style`, and `test`.

Use this form:

```text
type(optional-scope): short description
```

Examples are `feat(skills): add a delegation workflow` and
`docs: clarify the release process`. The `Validate` workflow enforces this
format for pull request titles. The shared `Jido Review` workflow also reports
the result in its review packet.

## Submit a pull request

Explain the problem, the selected change, preserved behavior, and the checks
that ran. Keep unrelated changes out of the pull request. A contribution that
you intentionally submit is licensed under the repository's
[Apache-2.0 license](LICENSE), unless you clearly state otherwise.

Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in all project spaces.
