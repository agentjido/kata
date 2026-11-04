# Skill packages

This directory contains the active Kata skill packages. Each direct child
directory with a `SKILL.md` file is one package. Use the
[project README](../README.md) for the skill catalog, workflow overview, and
installation instructions.

Read a package's `SKILL.md` before its support files. The frontmatter in that
file is the canonical source for the package name, selection description, and
classification metadata.

## Package layout

```text
skills/<name>/
├── SKILL.md       Required skill contract
├── references/    Optional detail loaded for a selected branch
├── scripts/       Optional deterministic helpers
├── assets/        Optional files used in generated output
├── README.md      Optional package-specific guide
└── LICENSE*       Required source notices when applicable
```

Only `SKILL.md` is required. Add another file only when the skill has a clear
reason to read, run, preserve, or produce it.

General packages use `kata-<task>`. Elixir-specific packages use
`kata-ex-<task>`. A package keeps a bare name only when the project approves a
small conversation command or dispatcher as an exception.

## Browse the catalog

Run the live catalog from the repository root:

```sh
iex skills/catalog.exs
```

The Phoenix Playground reads each package's current `SKILL.md` frontmatter.
Use **Reload source** after a file change. Set `KATA_CATALOG_PORT` to use another
port or `KATA_CATALOG_OPEN_BROWSER=false` to keep the browser closed.

Agent Skills metadata values are strings. Kata stores multi-value `consumes`
and `produces` facets as comma-separated strings. The catalog parses them into
ordered lists for filtering and display. Kata stores a portable command hint,
when useful, as the custom `metadata.kata-argument-hint` string instead of a
host-specific top-level field.

Check the catalog without starting the server:

```sh
elixir skills/catalog.exs --check
```

## Change a package

1. Read the [project instructions](../AGENTS.md) and the complete target
   package.
2. Edit the canonical files in this directory. Do not edit an installed copy.
3. Keep the package self-contained and independent of one coding host.
4. Preserve source notices, attribution, supported metadata, and unrelated
   behavior.
5. Update the project README when a package name or public job changes.
6. Run the package's applicable checks and inspect the final diff.

Do not install, publish, or add distribution tooling unless the current request
includes that work.

## Related information

- [Project documentation](../docs/README.md)
- [Agent Skills specification](https://agentskills.io/specification)
