# Jido Work System skills

This directory contains two discoverable Agent Skills:

```text
skills/jido/SKILL.md
skills/tutor/SKILL.md
```

Invoke it with `$jido` and a normal-language goal. Jido routes work through
internal Kata contracts below `skills/jido/references/katas/`. Detailed methods
and their required source notices are below
`skills/jido/references/methods/`.

Internal Katas and methods are not separate Agent Skills or public commands.
Invoke Tutor with `$tutor` for guided learning. Its internal commands, lessons,
and concepts are not separate Agent Skills. Do not add another public package
without a new product and library decision.

## Package layout

```text
skills/jido/
├── SKILL.md
├── agents/
└── references/
    ├── katas/
    └── methods/
skills/tutor/
├── SKILL.md
└── references/
    ├── commands/
    └── learning/
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

The release check requires exactly the Jido and Tutor public packages,
validates their frontmatter and links, and checks the preserved license
notices.
