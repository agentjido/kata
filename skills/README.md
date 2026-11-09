# Jido Agent Skill

This directory contains one discoverable Agent Skill:

```text
skills/jido/SKILL.md
```

Invoke it with `$jido` and a normal-language goal. Jido routes work through
internal Kata contracts below `skills/jido/references/katas/`. Detailed methods
and their required source notices are below
`skills/jido/references/methods/`.

Internal Katas and methods are not separate Agent Skills or public commands.
Do not add another `skills/<name>/SKILL.md` package without a new product and
library decision.

## Package layout

```text
skills/jido/
├── SKILL.md
├── agents/
└── references/
    ├── katas/
    └── methods/
```

Read `SKILL.md` first. It owns routing, authority, continuation, and final
integration. Read one Kata only after routing selects it. Read one detailed
method only when that Kata selects its branch.

## Checks

From the repository root:

```sh
elixir scripts/validate_release.exs
elixir skills/catalog.exs --check
```

The release check requires exactly one public `SKILL.md`, validates its
frontmatter and links, and checks the preserved license notices.
