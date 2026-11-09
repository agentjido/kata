# Attribution

Status: Current

Last reviewed: 2026-11-09

The Jido Work System preserves source authorship and required license notices.
This page records the current sources and adaptations. The root project uses
Apache-2.0. A method-specific notice continues to apply to the adapted material
in that internal method.

Keep author credits here and in required license files, outside the Jido
instructions.

The Jido Work System is authored by [Jidoka Labs](https://jidokahq.com) and
licensed contributors.

- `kata-security` adapts Cloudflare's
  [security-audit skill](https://github.com/cloudflare/security-audit-skill/tree/c1c8a8c1471069fb0e188eeaff69b8e8db6564a8/skills/security-audit).
  Kata changes the package name and adds catalog metadata. The audit workflow,
  domain guides, schemas, validators, and tests remain from the reviewed source
  commit `c1c8a8c1471069fb0e188eeaff69b8e8db6564a8`. The internal method includes
  Cloudflare's [MIT license notice](../../skills/jido/references/methods/kata-security/LICENSE-CLOUDFLARE).
- The project-orientation operation in `kata-docs` is an original Kata workflow
  informed by the
  [AGENTS.md open format](https://agents.md/),
  [OpenAI guidance for lean repository instructions](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra),
  and
  [OpenAI guidance for scoped repository rules](https://developers.openai.com/blog/custom-code-review-rules-for-codex).
- `kata-write-skill` adapts skill-authoring concepts from Matt Pocock's
  [writing-for-agents](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/productivity/writing-for-agents)
  and Every's
  [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00).
  The internal method includes the source MIT notices:
  [Matt Pocock license](../../skills/jido/references/methods/kata-write-skill/LICENSE-MATT-POCOCK) and
  [Compound Engineering license](../../skills/jido/references/methods/kata-write-skill/LICENSE-COMPOUND-ENGINEERING).
- `kata-debug` adapts the reproducible feedback-loop, reduction, hypothesis,
  instrumentation, and regression-test method from Matt Pocock's
  [diagnosing-bugs](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/engineering/diagnosing-bugs)
  and the causal-chain, evidence-safety, bounded-repair, and handoff rules from
  Compound Engineering's
  [ce-debug](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00/skills/ce-debug).
  The Kata adaptation removes host modes, automatic branches, commits, pushes,
  Compound Packs, and source scripts. It adds Kata metadata and a diagnosis-only
  authority boundary. The internal method includes the source
  [Matt Pocock license](../../skills/jido/references/methods/kata-debug/LICENSE-MATT-POCOCK) and
  [Compound Engineering license](../../skills/jido/references/methods/kata-debug/LICENSE-COMPOUND-ENGINEERING).
  Its agent-run method also adapts the capture, contained recovery, and
  introspection boundary from Affaan Mustafa's
  [Everything Claude Code `agent-introspection-debugging`](https://github.com/affaan-m/everything-claude-code/tree/b38be6a7f635/.agents/skills/agent-introspection-debugging)
  and includes the source
  [MIT notice](../../skills/jido/references/methods/kata-debug/LICENSE-EVERYTHING-CLAUDE-CODE).
- `kata-idea` adapts requirements exploration and product-pressure methods from
  Compound Engineering's
  [ce-brainstorm](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00/skills/ce-brainstorm),
  dependency-ordered decision grilling from Matt Pocock's
  [grilling](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/productivity/grilling),
  and evidence-based challenge methods from pstack's
  [interrogate](https://github.com/painhardcore/pstack/tree/7f2d936bba86c2c512c4ad83e759752f4f065b7c/skills/interrogate).
  The Kata adaptation uses Explore, Grill, and Challenge methods and produces a
  Product Contract that `kata-roadmap` can resolve or `kata-plan` can enrich.
  The internal method includes the source
  [Compound Engineering](../../skills/jido/references/methods/kata-idea/LICENSE-COMPOUND-ENGINEERING),
  [Matt Pocock](../../skills/jido/references/methods/kata-idea/LICENSE-MATT-POCOCK), and
  [pstack](../../skills/jido/references/methods/kata-idea/LICENSE-PSTACK) license notices.
- `kata-roadmap` adapts the destination, decision frontier, fog, decision kinds,
  and one-decision review cycle from Matt Pocock's
  [wayfinder](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/engineering/wayfinder).
  Kata replaces issue-tracker setup, required companion-skill calls, automatic
  subagents, research branches, and pushes with a host-neutral decision
  contract and required local Beadwork or CSV state. The internal method includes the
  source [MIT license notice](../../skills/jido/references/methods/kata-roadmap/LICENSE-MATT-POCOCK).
- `kata-maintain-skill` adapts evidence classification and artifact-selection
  ideas from Cursor's
  [workflow-from-chats](https://github.com/cursor/cursor-plugins/tree/6ea74587e384/cursor-team-kit/skills/workflow-from-chats).
  Kata requires a user-named source range, repeated evidence or explicit stable
  confirmation, and separate authority before persistence. The internal method includes
  the source [Cursor MIT notice](../../skills/jido/references/methods/kata-maintain-skill/LICENSE-CURSOR).
- `kata-verify` is a Kata-owned compound verifier. Its code-review method adapts
  ideas from Compound Engineering's
  [ce-code-review](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00/skills/ce-code-review)
  and Matt Pocock's
  [code-review](https://github.com/mattpocock/skills/tree/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d/skills/engineering/code-review).
  Its security method is informed by Addy Osmani's
  [security-and-hardening](https://github.com/addyosmani/agent-skills/tree/301b02b12bff98e4688e6984af6556802322bbde/skills/security-and-hardening).
  The package preserves its pstack notice and adds the
  [Compound Engineering](../../skills/jido/references/methods/kata-verify/LICENSE-COMPOUND-ENGINEERING),
  [Matt Pocock](../../skills/jido/references/methods/kata-verify/LICENSE-MATT-POCOCK), and
  [Addy Osmani](../../skills/jido/references/methods/kata-verify/LICENSE-ADDY-OSMANI) notices.
  Its AI-behavior method adapts capability, regression, and grader ideas from
  Affaan Mustafa's
  [Everything Claude Code `eval-harness`](https://github.com/affaan-m/everything-claude-code/tree/b38be6a7f635/.agents/skills/eval-harness)
  and experimental control ideas from K-Dense's
  [experimental-design](https://github.com/K-Dense-AI/claude-scientific-skills/tree/a25cf9ec00e2/skills/experimental-design).
  The internal method includes the source
  [Everything Claude Code](../../skills/jido/references/methods/kata-verify/LICENSE-EVERYTHING-CLAUDE-CODE)
  and [K-Dense](../../skills/jido/references/methods/kata-verify/LICENSE-K-DENSE) MIT notices.
  Its MCP dependency method also adapts the static, no-execution review boundary
  and mutable-selector classification from Everything Claude Code's
  [mcp-dependency-review](https://github.com/affaan-m/everything-claude-code/tree/b38be6a7f635/.agents/skills/mcp-dependency-review).
- `kata-work` and `kata-verify` adapt local CLI, TUI, browser, IDE, and Electron
  harness methods from Cursor's
  [control-cli](https://github.com/cursor/cursor-plugins/tree/6ea74587e384/cursor-team-kit/skills/control-cli)
  and
  [control-ui](https://github.com/cursor/cursor-plugins/tree/6ea74587e384/cursor-team-kit/skills/control-ui).
  Kata separates harness creation from independent verification and routes
  visual-design judgment to Impeccable. Both packages include the source Cursor
  MIT notice.
- `kata-shipit` keeps Kata's strict scoped-commit boundary and adapts safe branch,
  push, pull-request, and completion ideas from Compound Engineering's
  [ce-commit-push-pr](https://github.com/EveryInc/compound-engineering-plugin/tree/406b85c4562de3d415927fccc5e614c6554aab00/skills/ce-commit-push-pr)
  and Jesse Vincent's
  [finishing-a-development-branch](https://github.com/obra/superpowers/tree/22f0b463e7a5e579904dd6211a520321035526f7/skills/finishing-a-development-branch).
  The internal method includes the source
  [Compound Engineering](../../skills/jido/references/methods/kata-shipit/LICENSE-COMPOUND-ENGINEERING) and
  [Superpowers](../../skills/jido/references/methods/kata-shipit/LICENSE-SUPERPOWERS) license notices.
- `kata-plan` is adapted from `ce-plan` in
  [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin/tree/57e409e5c8c2c472106bd7d87ac72b724b70826b),
  maintained by Kieran Klaassen and Trevin Chow with community contributions.
  The source is commit `57e409e5c8c2c472106bd7d87ac72b724b70826b`.
  Kata replaces the imported orchestration, model dispatch, companion-skill
  calls, and multi-domain workflow with one deep software planning method and
  Markdown, HTML, and Beadwork adapters. The internal method includes Every's original
  [MIT license notice](../../skills/jido/references/methods/kata-plan/LICENSE).

- `kata-showme` is adapted from `show-me`, written by Dex Horthy and published
  in [humanlayer/skills](https://github.com/humanlayer/skills). The original
  [MIT license notice](../../skills/jido/references/methods/kata-showme/LICENSE) is included with the skill.
- `kata-technical-writing` is adapted from
  [painhardcore/pstack](https://github.com/painhardcore/pstack/tree/7f2d936bba86c2c512c4ad83e759752f4f065b7c),
  maintained by Andrei Iurchenkov from Lauren Tan's original pstack work. The
  source is commit `7f2d936bba86c2c512c4ad83e759752f4f065b7c`.
  `kata-technical-writing` also contains the former `unslop` editing method.
  The pstack `correct` repository-guard method now belongs to `kata-work` for
  candidate creation and `kata-verify` for independent proof. Focused pstack
  methods for benchmarks, blast radius, adversarial review, comment review,
  recent-work recall, test-first repair, decision logs, and verification-skill
  creation also live as conditional references in `kata-verify`,
  `kata-understand`, `kata-work`, and `kata-write-skill`. Each affected package
  contains the source MIT license and copyright notice.


- `kata-understand` and `kata-verify` adapt reproducible search, selection,
  thematic synthesis, citation-support, and coverage-limit methods from
  K-Dense's
  [literature-review](https://github.com/K-Dense-AI/claude-scientific-skills/tree/a25cf9ec00e2/skills/literature-review).
  Kata keeps the method general, does not import its scripts or paid services,
  and reserves `systematic review` for work with the required protocol and
  screening evidence. `kata-understand` includes the source
  [K-Dense MIT notice](../../skills/jido/references/methods/kata-understand/LICENSE-K-DENSE); `kata-verify`
  uses its existing copy of the same notice.
