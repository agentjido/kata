# Changelog

This file records material changes to the Jido Work System.

## [0.7.0](https://github.com/agentjido/skills/compare/v0.6.0...v0.7.0) (2026-11-09)


### Features

* **skills:** simplify Jido routing and add Tutor lesson content ([7ec8b1d](https://github.com/agentjido/skills/commit/7ec8b1d1750dc7d656e18c48e434fe4e68f8690f))
* **skills:** simplify Jido routing and add Tutor lesson content ([b88d456](https://github.com/agentjido/skills/commit/b88d4569879be7e7aca283f8f0c22ab8a0edd0b2))


### Bug Fixes

* **skills:** make Jido plans reviewable and checks proportionate ([c3d7e5e](https://github.com/agentjido/skills/commit/c3d7e5efebc69bd1e06b08959067a99ed3dd8f19))

## [0.6.0](https://github.com/agentjido/skills/compare/v0.5.0...v0.6.0) (2026-11-09)


### Added

- The public `$tutor` skill with six approved topics, guided practice,
  feedback, and explicit handoffs to Jido.
- Release Please automation that creates a checked release pull request and
  creates the matching tag and GitHub Release after merge.

### Changed

- `$jido` now selects the first unresolved contract from eight internal Katas
  and continues through repair and verification.
- Detailed work methods are now internal Jido references instead of separate
  public skills.
- Installation now provides the two public skills `jido` and `tutor`.
- Public library links and package metadata now use `agentjido/skills`.

### Removed

- The former public `kata-*` skill entry points and compatibility wrappers.
  The `v0.5.0` release remains available as the last multi-skill package.

## [0.5.0] - 2026-11-05

### Added

- The `$jido` front door for evidence-based work routing.
- Twenty-three active Agent Skills for leadership, understanding, product
  direction, planning, implementation, verification, delivery, documentation,
  security, and Elixir work.
- Agent Skills, Claude, Codex, Cursor, Grok, and Pi package metadata.
- Apache-2.0 project licensing, contribution guidance, and a code of conduct.
- `kata-tutor` for adaptive agentic-leadership teaching through real work.
- `kata-scope` for bounded, portable work briefs.
- `kata-delegate` for clear assignments and check, watch, or drive follow-through.
- `kata-security` for security guidance and source-first security audits.
- A release check that rejects symbolic links in the public skill catalog.
- A changelog-driven, tag-based GitHub Release workflow.
- A shared Jido pull request review that reports conventional commit titles and
  workflow risks.
- Installation trust guidance.

### Changed

- Public naming now uses **Agent Jido Kata**.
- Kata facet lists now use Agent Skills-compatible string metadata.
- Kata is now positioned for agentic productivity in general, not only for
  coding agents.
- The README is shorter. The skill list moved to the package guide, and host
  details moved to a host compatibility reference.
- `kata-docs` now owns scoped `AGENTS.md` and entry-point README orientation.
- Technical explainer production moved out of the public pack.
- Public plugin metadata now declares the portable schema, license, homepage,
  and discovery keywords.
- Public author and copyright references now name Jidoka Labs and licensed
  contributors.

### Removed

- The marketing plan. Marketing material is kept outside this repository.
- The separate `kata-orient` public package. Its method is in `kata-docs`.
- The public technical-explainer package.

### Known limits

- Native loading through every included host manifest has not been verified.
  The primary distribution path is `npx skills add agentjido/kata`.
- Skills directories can cache earlier source versions. Confirm that a listing
  shows the current packages before relying on it for release discovery.
