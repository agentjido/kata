# Changelog

This file records material changes to the Jido Work System.

## [0.7.0](https://github.com/agentjido/skills/compare/v0.6.0...v0.7.0) (2026-11-09)


### Features

* add leadership workflows and extra skill fallback ([cc15fd8](https://github.com/agentjido/skills/commit/cc15fd8717f48a36e9afe413d6a7a3471eb5d542))
* add Tutor curriculum system ([17e5dbc](https://github.com/agentjido/skills/commit/17e5dbc9c72839d781ea4e3b9e86f60bf0161b4b))
* improve Kata completion and release contracts ([a9d8c88](https://github.com/agentjido/skills/commit/a9d8c880d62fd2ba4276e5d257cafb8d5a149ba7))
* **jido:** add dispatcher and dojo ([1cc9876](https://github.com/agentjido/skills/commit/1cc9876fa2dfb2e24baf295056d49976bf8570d5))
* **jido:** route skill writing and maintenance ([fd03c6c](https://github.com/agentjido/skills/commit/fd03c6c609e3f4b65151569f383b4f67f650332f))
* **kata:** evolve work system and Dojo tooling ([2bcaaad](https://github.com/agentjido/skills/commit/2bcaaadb30136c284558f6b2a2c411853e000463))
* position Kata for agentic productivity and separate local skills ([74f8ab0](https://github.com/agentjido/skills/commit/74f8ab0c24a95907581f4f5a0a95914c44361299))
* prepare Agent Jido Kata 1.0 ([6d98c07](https://github.com/agentjido/skills/commit/6d98c07018f7a92b6ee2237681d419a827df0239))
* refine Kata routing and work boundaries ([7af35a9](https://github.com/agentjido/skills/commit/7af35a94ed78a0eb5c4534246bf744123b203f88))
* **skills:** add Elixir design review skill ([71e5faa](https://github.com/agentjido/skills/commit/71e5faa233b75ab07649ef785a783beddcf2873f))
* **skills:** add security audit workflow ([e3f9bbd](https://github.com/agentjido/skills/commit/e3f9bbdaef91a1e0241f06fbd698fbc4a517dbfa))
* **skills:** add technical explainer production ([2df2b1d](https://github.com/agentjido/skills/commit/2df2b1d1b886ef6f5a02203e837b11e64b305f8c))
* **skills:** add verified commit boundary ([a3bf1d8](https://github.com/agentjido/skills/commit/a3bf1d853966df511fd2f676da6d43560dad2710))
* **skills:** complete the maintenance fix loop ([a5e5dbe](https://github.com/agentjido/skills/commit/a5e5dbe99658f8853e86be8d2cfd3f9fcabd8584))
* **skills:** consolidate Elixir quality tooling ([fbc2456](https://github.com/agentjido/skills/commit/fbc2456382890805120aeba84f19f2dfd73985ab))
* **skills:** expand Kata workflow and add roadmap ([f3af8c2](https://github.com/agentjido/skills/commit/f3af8c2c532746a52a49e7d2028b5259c1645b1d))
* **skills:** expand Kata workflow and add roadmap ([#2](https://github.com/agentjido/skills/issues/2)) ([c921116](https://github.com/agentjido/skills/commit/c921116ea1505b67044e89868d3e32dab19cb117))
* **skills:** integrate planning and review expansions ([ab9d804](https://github.com/agentjido/skills/commit/ab9d804ef1b055cb53555b37391ea4567140cf18))
* **skills:** migrate Jido skills into Kata ([9548fbe](https://github.com/agentjido/skills/commit/9548fbe03b93ca2c1ae44748950bbdbf5549e16e))
* **skills:** unify writing and maintenance workflows ([13edd78](https://github.com/agentjido/skills/commit/13edd78a2ad019fb1b868e10acbbb0f50d0fe40a))


### Bug Fixes

* **deps:** remove unused castore after eMudhra CA compromise ([#1](https://github.com/agentjido/skills/issues/1)) ([8729440](https://github.com/agentjido/skills/commit/8729440213dcd37477a8c6afe69116f834e91272))
* **evals:** resolve harness path and support ACP runs ([afdf6ee](https://github.com/agentjido/skills/commit/afdf6ee8696d706f98543f7977f823d93afb4706))
* **plan:** stop routing knowledge work to kata work ([fb1626e](https://github.com/agentjido/skills/commit/fb1626e1389b87d6d25a162af885d1e0c40313fa))

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
