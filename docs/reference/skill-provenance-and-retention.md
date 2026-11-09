# Jido method provenance and retention

Purpose: Record the current ownership and source location of the internal Jido
methods after the single-command consolidation.

Last reviewed: 2026-11-09

## Public package

`skills/jido/SKILL.md` is the only public Agent Skill. The eight internal Kata
contracts are below `skills/jido/references/katas/`. Detailed methods are below
`skills/jido/references/methods/`.

The detailed method directory names retain their former `kata-*` identifiers
to keep source history, relative links, license mapping, and migration review
clear. They are not public commands.

## Internal ownership

| Internal Kata | Retained detailed methods |
| --- | --- |
| Understand | `kata-understand`, diagnosis from `kata-debug`, `kata-sitrep` |
| Shape | `kata-idea`, `kata-roadmap`, `kata-scope`, `kata-plan` |
| Lead | `kata-tutor`, `kata-delegate` |
| Work | `kata-work`, repair from `kata-debug`, `kata-docs`, `kata-showme`, `kata-technical-writing` |
| Verify | `kata-verify`, `kata-security` |
| Improve | `kata-maintain-skill`, `kata-write-skill` |
| Ship | `kata-shipit` |
| Dojo | `kata-dojo`, explicit request only |

The [attribution register](attribution.md) records adapted sources and required
license notices. Each notice remains beside its detailed internal method.

## Removed domain methods

The 1.0 general package does not contain these Elixir-specific methods:

- Jido SDK build guidance from `kata-build-jido`;
- Elixir and OTP design review from `kata-ex-design-review`;
- Elixir quality analysis from `kata-ex-quality`; and
- Elixir library documentation guidance from `kata-technical-writing`.

The pre-consolidation source is retained in the owner's `kata_bkp` copy and in
Git history. A separate domain repository can import that source with its
licenses and provenance after an owner decision.

## Admission rule

Do not add another public Agent Skill package to this repository only because
a method has a distinct name. Add a detailed method below Jido when one
internal Kata can own its result and authority. Use a separate repository when
the work needs specialist domain ownership, an independent release, or a
different installation decision.
