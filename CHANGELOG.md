# Changelog

This file records material changes to Agent Jido Kata.

## [Unreleased]

### Added

- `kata-tutor` for adaptive agentic-leadership teaching through real work.
- `kata-scope` for bounded, portable work briefs.
- `kata-delegate` for clear assignments and check, watch, or drive follow-through.
- `kata-security` for security guidance and source-first security audits.
- An optional `<user-home>/.jido/extra-skills.md` index that Jido reads only
  when its included skill registry has no match.
- A release check that rejects symbolic links in the public skill catalog.

### Changed

- Kata is now positioned for agentic productivity in general, not only for
  coding agents.
- The README is shorter. The skill list moved to the package guide, and host
  details moved to a host compatibility reference.
- `kata-docs` now owns scoped `AGENTS.md` and entry-point README orientation.
- Technical explainer production moved out of the public pack.

### Removed

- The marketing plan. Marketing material is kept outside this repository.
- The separate `kata-orient` public package. Its method is in `kata-docs`.
- The public technical-explainer package.

## [1.0.0] - 2026-11-04

### Added

- The `$jido` front door for evidence-based work routing.
- Twenty active Agent Skills for understanding, product direction, planning,
  implementation, verification, delivery, documentation, and Elixir work.
- Agent Skills, Claude, Codex, Cursor, Grok, and Pi package metadata.
- Apache-2.0 project licensing, contribution guidance, a security policy, and a
  code of conduct.
- A common repository validator and tag-driven GitHub Release workflow.

### Changed

- Public naming now uses **Agent Jido Kata**.
- Kata facet lists now use Agent Skills-compatible string metadata.
- The README is a short product and first-use guide. Detailed installation and
  attribution information now have focused documents.

### Known limits

- Dojo remains opt-in experimental evaluation tooling. It is not a release
  requirement or a claim about all current skills.
- Native loading through every included host manifest has not been verified.
  The primary distribution path is `npx skills add agentjido/kata`.
- Skills directories can cache earlier source versions. Confirm that a listing
  shows the current packages before relying on it for release discovery.
