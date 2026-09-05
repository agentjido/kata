# Working on Kata

- Use ASD-STE100 Simplified Technical English.
- Do not use skills unless the user explicitly requests them.
- Keep this repository private unless the user asks to change its visibility.
- Prefix every skill name and its directory name with `kata-`.
- Use `kata-ex-<task>` for Elixir skills and `kata-<task>` for language-agnostic skills.
- Mark Elixir skills with `metadata: {language: elixir}`. No language marker means language-agnostic.
- Keep the plugin small. Add a skill when an actual task shows a need.
- Keep each skill self-contained in `skills/<name>/SKILL.md`.
- Use standard `name` and `description` frontmatter. Match the name to its directory.
- Use host-neutral instructions. Do not require a specific tool API or another installed skill.
- Keep the name, version, and description consistent across plugin manifests.
- Do not add install tests, release automation, or distribution tooling unless requested.
- Preserve the user's existing files and work when changing a target project.
