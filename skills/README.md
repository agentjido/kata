# Skill packages

This directory contains the active Kata skill packages. Each direct child
directory with a `SKILL.md` file is one package. Use the
[project README](../README.md) for the introduction and installation instructions.

Read a package's `SKILL.md` before its support files. The frontmatter in that
file is the canonical source for the package name, selection description, and
classification metadata.

## Skill list

### Primary workflow

| Skill | Result |
| --- | --- |
| `jido` | Route an explicit `$jido` goal to the smallest valid sequence. |
| `kata-understand` | Establish the current condition with evidence. |
| `kata-plan` | Create a grounded software implementation plan. |
| `kata-work` | Produce one candidate result from ready work. |
| `kata-verify` | Judge a candidate against its acceptance contract. |
| `kata-shipit` | Commit, publish, watch, or land an accepted change. |

### Decision altitudes

| Skill | Result |
| --- | --- |
| `kata-idea` | Settle product direction and requirements before planning. |
| `kata-roadmap` | Resolve dependent long-horizon decisions across plans. |

### Work-system improvement

| Skill | Result |
| --- | --- |
| `kata-maintain-skill` | Resolve one evidence-backed library finding. |
| `kata-write-skill` | Create, import, or convert one skill package. |
| `kata-dojo` | Evaluate an exact candidate only on explicit Dojo request. |

### Project support

| Skill | Result |
| --- | --- |
| `kata-debug` | Diagnose a reproducible failure and repair it when authorized. |
| `kata-docs` | Set up and maintain a project knowledge base. |
| `kata-explainer` | Produce and review an evidence-based technical explainer video. |
| `kata-orient` | Maintain scoped `AGENTS.md` and entry-point README files. |
| `kata-security` | Give security guidance or run a source-first software security audit. |
| `kata-sitrep` | Report local and remote Git workbench state. |
| `kata-showme` | Explain a topic with focused diagrams and visuals. |
| `kata-technical-writing` | Write or review one technical artifact. |

### Elixir and Jido

| Skill | Result |
| --- | --- |
| `kata-build-jido` | Build current Jido actions, agents, runtime, and AI work. |
| `kata-ex-design-review` | Review an Elixir package as a principal engineer. |
| `kata-ex-quality` | Find and fix bounded Elixir package-quality findings. |

General skills use `kata-<task>`. Skills that require Elixir use
`kata-ex-<task>`. You can use each skill directly or give `$jido` a goal.
Dojo requires an explicit request; normal use does not run model evaluations.

## Public and local skills

This directory contains public skills only. Keep private skills and the optional
`jido-local` route index in a separate package, and install them next to `jido`.
Do not add them or links to them here. `scripts/validate_release.exs` fails if
this directory contains `jido-local` or a symbolic link. Public files can
describe the [extension point](jido/references/local-extension.md), but they must
not name a private route or skill.

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
