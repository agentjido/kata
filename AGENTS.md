# Working on Kata

- Use ASD-STE100 Simplified Technical English.
- Do not use skills unless the user explicitly requests them.
- Use `kata-ex-<task>` for Elixir skills and `kata-<task>` for language-agnostic skills.
- `jido` is the approved bare dispatcher for explicit `$jido` requests. Use
  `jido-sdk` when a name refers specifically to the Jido Elixir SDK.
- A small conversational or writing command can keep a distinctive bare name when the user explicitly approves the exception and the name has low collision risk. Bare commands must say that they require explicit invocation.
- Mark Elixir skills with `metadata: {language: elixir}`. No language marker means language-agnostic.
- Keep the plugin small. Add a skill when an actual task shows a need.
- Keep each skill self-contained in `skills/<name>/SKILL.md`.
- Keep author attribution in README.md, not in SKILL.md files. Preserve required license files.
- Use standard `name` and `description` frontmatter. Match the name to its directory.
- Use host-neutral instructions. Do not require a specific tool API or another
  installed skill. An approved dispatcher can route to sibling packages bundled
  in the same plugin when it verifies each target and has a self-contained
  fallback.
- Keep the name, version, and description consistent across plugin manifests.
- Do not add install tests, release automation, or distribution tooling unless requested.
- Treat `dojo/` as preserved, opt-in evaluation tooling. Do not run commands
  from `dojo/`, use its catalog, run its tests, inspect its saved evaluations,
  or change its code unless the user explicitly requests Dojo in the current
  task. A skill change does not imply Dojo use.
- Never start a live Dojo model evaluation unless the user explicitly requests
  the live run and supplies or approves its profile and token or call budget.
- Do not use Dojo as the default verification path for skill or documentation
  changes. Use direct file inspection and checks that do not enter `dojo/`.
- Keep this repository public-only. Private skills stay in a separate
  repository. Do not add them, or links to them, under `skills/`. Public files
  can describe the optional extra-skills index but must not name a private
  skill.
- Keep marketing material outside this repository.
- Preserve the user's existing files and work when changing a target project.
