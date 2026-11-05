# Existing skill improvement backlog

Purpose: Adapt seven useful methods from the reference skill collections into
the current Kata owners without adding seven new packages.

Status: Complete

Last reviewed: 2026-11-04

## Maintenance finding

- **Observation:** The reference survey found seven useful methods, but the
  current import queue does not give them a durable owner or an implementation
  boundary.
- **Evidence:** The source packages define distinct methods for test value,
  application control, agent-run diagnosis, workflow learning, AI evaluation,
  MCP security, and reproducible research. Current Kata packages cover each
  general job, but they do not contain the focused method.
- **Consequence:** A later import can create duplicate skills, or the useful
  methods can remain unused because no backlog item owns them.
- **Canonical owner:** The current Kata skill named in each backlog item.
- **Disposition:** Refine the existing owners through seven bounded work items.
  Do not add a package from this plan.

## Constraints

- Keep the active catalog at 20 skills or fewer.
- Do not create `kata-prototype` from this plan.
- Do not import a visual-design skill. Route visual-design work to Impeccable.
- Keep all Kata instructions host-neutral.
- Preserve the Work and Verify authority boundary. Work can create a candidate;
  Verify can inspect it but cannot repair it.
- Treat each reference skill as source evidence. Do not copy its host commands,
  model names, telemetry, service setup, or product-specific paths.
- Preserve each required license and add author credit when adapted text is
  substantial.
- Complete and verify one backlog item before work starts on another item.

## Priority and order

| ID | Priority | State | Existing owner | Improvement | Depends on |
| --- | --- | --- | --- | --- | --- |
| KSI-01 | P0 | Complete | `kata-ex-quality` | Test value and test-asset governance | None |
| KSI-02 | P0 | Complete | `kata-work`, `kata-verify` | Local application control and verification | None |
| KSI-03 | P1 | Complete | `kata-debug` | Agent-run failure diagnosis | KSI-02 methods can supply a reproduction harness |
| KSI-04 | P1 | Complete | `kata-maintain-skill` | Evidence-based workflow learning from chats | None |
| KSI-05 | P0 | Complete | `kata-verify` | AI capability and regression evaluation | None |
| KSI-06 | P1 | Complete | `kata-verify` | Security and MCP dependency review | None |
| KSI-07 | P2 | Complete | `kata-understand`, `kata-verify` | Reproducible research and source synthesis | None |

P0 work fills a current verification or quality gap. P1 work improves safety
and maintenance. P2 work improves research rigor but does not block normal
software work.

## KSI-01: Test value and test-asset governance

**State:** Complete. Implemented from gstack revision `913aca6ac098` and
Everything Claude Code revision `b38be6a7f635`. The backlog tool accepted a
`test-value-gap` finding and rejected its automatic selection because the rule
is `judgment-required`.

**Outcome:** `kata-ex-quality` can find tests that cost more than the distinct
behavior they protect, and it can record test gaps without using test count or
coverage alone as proof.

**Source evidence:**

- [gstack `test-audit`](../../../references/software-delivery/gstack/test-audit/SKILL.md)
- [ECC `test-collaboration`](../../../references/agent-engineering/everything-claude-code/.agents/skills/test-collaboration/SKILL.md)

**Implemented changes:**

1. Add a versioned `test-value-gap` rule to the Tests rule group.
2. Define evidence for unique behavior, defect history, boundary protection,
   maintenance cost, runtime cost, and test-only production code.
3. Keep test deletion as `judgment-required`. Require explicit authority for
   deletion and proof that no distinct behavior loses protection.
4. Add a small test-asset map only when a project already has one or requests
   one. Do not require a new `TESTS.md` file for every project.
5. Update the rule index and managed rule data with the new rule version.

**Changed files:**

- `skills/kata-ex-quality/SKILL.md`
- `skills/kata-ex-quality/references/rules/tests.md`
- `skills/kata-ex-quality/references/rule-catalog.md`
- `skills/kata-ex-quality/scripts/quality_backlog.exs`
- `skills/kata-ex-quality/LICENSE-GSTACK`
- `skills/kata-ex-quality/LICENSE-EVERYTHING-CLAUDE-CODE`

**Acceptance evidence:**

- One low-value candidate and one important test both receive correct, different
  dispositions.
- The method does not propose deletion from coverage percentage alone.
- An approved deletion batch keeps its declared behavior and quality gates.
- The backlog tool accepts the new rule and evidence fields.

## KSI-02: Local application control and verification

**State:** Complete. Implemented from Cursor plug-ins revision
`6ea74587e384`. Harness creation belongs to `kata-work`; read-only execution and
judgment belong to `kata-verify`. Visual-design judgment routes to Impeccable.

**Outcome:** Kata can create a bounded local harness for a CLI, TUI, browser,
IDE, or Electron application and can verify behavior through that harness.

**Source evidence:**

- [Cursor `control-cli`](../../../references/agent-engineering/cursor-plugins/cursor-team-kit/skills/control-cli/SKILL.md)
- [Cursor `control-ui`](../../../references/agent-engineering/cursor-plugins/cursor-team-kit/skills/control-ui/SKILL.md)

**Implemented changes:**

1. Add an application-harness method to `kata-work`. It can build or adapt the
   smallest local harness that the accepted task needs.
2. Add an application-verification method to `kata-verify`. It can use an
   existing harness, observe the real behavior, and return Pass, Fail, Unknown,
   or Blocked.
3. Define capability-neutral options: PTY or terminal control for CLI and TUI;
   browser or CDP control for web, IDE, and Electron applications.
4. Require stable candidate identity, repeatable setup, captured observations,
   cleanup, and a clear boundary between product state and temporary proof.
5. Keep screenshots and visual diffs as evidence only. Send visual-design
   judgment and design changes to Impeccable.

**Changed files:**

- `skills/kata-work/SKILL.md`
- `skills/kata-work/references/application-harness.md`
- `skills/kata-work/LICENSE-CURSOR`
- `skills/kata-verify/SKILL.md`
- `skills/kata-verify/references/application-review.md`
- `skills/kata-verify/references/routing.md`
- `skills/kata-verify/LICENSE-CURSOR`

**Acceptance evidence:**

- A CLI case drives an interactive flow and checks one observable result.
- A browser or Electron case checks one behavior without changing source code.
- Verify does not create or repair the harness.
- Temporary processes, profiles, files, and ports are removed or reported.

## KSI-03: Agent-run failure diagnosis

**State:** Complete. Implemented from Everything Claude Code revision
`b38be6a7f635`. The method separates current-run recovery from a durable repair
and requires external evidence for an agent self-report.

**Outcome:** `kata-debug` can diagnose a failed agent execution with the same
causal standard that it uses for a software failure.

**Source evidence:**

- [ECC `agent-introspection-debugging`](../../../references/agent-engineering/everything-claude-code/.agents/skills/agent-introspection-debugging/SKILL.md)

**Implemented changes:**

1. Extend the accepted failure types to include an agent run that has an
   observable wrong result, tool failure, loop, unsafe action, or missing stop.
2. Define a capture record for input, relevant context, tool sequence, observed
   result, expected result, model or host facts when available, and redactions.
3. Trace the cause through request, context, selection, tool boundary, state,
   and final result. Do not use an agent self-report as proof.
4. Separate contained recovery from a durable repair. A retry is not a repair.
5. Require a repeatable case or a saved replay artifact before a verified
   repair claim.

**Changed files:**

- `skills/kata-debug/SKILL.md`
- `skills/kata-debug/references/agent-run.md`
- `skills/kata-debug/LICENSE-EVERYTHING-CLAUDE-CODE`

**Acceptance evidence:**

- One failed run produces a complete causal chain and a bounded diagnosis.
- One non-reproducible run returns Unknown with the missing evidence.
- Sensitive prompts, credentials, and personal data do not enter the report.
- A recovery action does not receive a verified-repair label.

## KSI-04: Evidence-based workflow learning from chats

**State:** Complete. Implemented from Cursor plug-ins revision
`6ea74587e384`. Chat inspection needs a user-named source range, and persistence
needs separate user authority.

**Outcome:** `kata-maintain-skill` can use chat history to propose one durable
workflow improvement without treating one comment as a stable preference.

**Source evidence:**

- [Cursor `workflow-from-chats`](../../../references/agent-engineering/cursor-plugins/cursor-team-kit/skills/workflow-from-chats/SKILL.md)

**Implemented changes:**

1. Add a chat-evidence intake method for explicit corrections, repeated
   preferences, repeated friction, and successful repeated procedures.
2. Require an evidence count, dates or task identities, confidence, scope, and
   counterevidence.
3. Distinguish a personal preference, repository rule, general method, and
   one-task instruction before selecting the owner.
4. Produce a maintenance finding or conversion brief. Do not silently write a
   skill, memory, or project rule.
5. Require user authority before persistent personal data is recorded.

**Changed files:**

- `skills/kata-maintain-skill/SKILL.md`
- `skills/kata-maintain-skill/references/chat-evidence.md`
- `skills/kata-maintain-skill/LICENSE-CURSOR`

**Acceptance evidence:**

- One isolated correction is rejected or deferred as insufficient evidence.
- Two or more consistent examples can produce one bounded finding.
- Conflicting examples lower confidence or stop the proposal.
- The output names the correct owner and persistence boundary.

## KSI-05: AI capability and regression evaluation

**State:** Complete. Implemented from Everything Claude Code revision
`b38be6a7f635` and K-Dense revision `a25cf9ec00e2`. The method fixes the
candidate and evaluation contract, separates grader types, and keeps Dojo
explicit and skill-specific.

**Outcome:** `kata-verify` can judge an AI feature or agent behavior with fixed
cases, suitable graders, repeated runs, and visible uncertainty.

**Source evidence:**

- [ECC `eval-harness`](../../../references/agent-engineering/everything-claude-code/.agents/skills/eval-harness/SKILL.md)
- [K-Dense `experimental-design`](../../../references/science-and-research/scientific-agent-skills/skills/experimental-design/SKILL.md)

**Implemented changes:**

1. Add an AI-behavior verification method with separate capability and
   regression cases.
2. Define deterministic, model-based, and human grading boundaries. Prefer a
   deterministic grader when it can judge the contract.
3. Fix the candidate, cases, grader, environment, and run count before a
   comparison. Record any change to these inputs.
4. Report per-case results, repeatability, cost when measured, uncertainty, and
   known contamination or selection risk.
5. Keep this method separate from Dojo. Dojo evaluates Kata skill candidates
   only when the user explicitly requests Dojo.

**Changed files:**

- `skills/kata-verify/SKILL.md`
- `skills/kata-verify/references/ai-behavior-review.md`
- `skills/kata-verify/references/routing.md`
- `skills/kata-verify/LICENSE-EVERYTHING-CLAUDE-CODE`
- `skills/kata-verify/LICENSE-K-DENSE`

**Acceptance evidence:**

- A deterministic case fails a known bad candidate and passes a known good one.
- A variable-output case reports repeated-run evidence and uncertainty.
- A model grader cannot be the only proof for a claim that code can check.
- The route does not activate Dojo without an explicit Dojo request.

## KSI-06: Security and MCP dependency review

**State:** Complete. Implemented from Everything Claude Code revision
`b38be6a7f635` with the existing Addy Osmani security method at revision
`301b02b12bff`. The MCP branch is repository-scoped, static, and does not
execute discovered server commands.

**Outcome:** `kata-verify` can statically inspect repository MCP configuration
and report reproducibility or supply-chain risk without starting the configured
server.

**Source evidence:**

- [ECC `mcp-dependency-review`](../../../references/agent-engineering/everything-claude-code/.agents/skills/mcp-dependency-review/SKILL.md)
- [Addy Osmani `security-and-hardening`](../../../references/agent-engineering/addyosmani-agent-skills/skills/security-and-hardening/SKILL.md)

**Implemented changes:**

1. Extend security review with an MCP configuration branch.
2. Locate repository-scoped MCP files and parse them as untrusted data.
3. Classify exact versions, ranges, tags, branches, URLs, local paths, and
   unpinned command downloads.
4. Distinguish reproducibility risk from a confirmed vulnerability.
5. Recommend the smallest stable selector and a normal update path. Do not
   execute the discovered server or install its package during static review.

**Changed files:**

- `skills/kata-verify/references/security-review.md`
- `skills/kata-verify/references/mcp-dependency-review.md`
- `skills/kata-verify/references/routing.md`

**Acceptance evidence:**

- Exact, ranged, tagged, branch, URL, and local-path examples receive correct
  classifications.
- The method makes no network call and starts no server during static review.
- The report separates confirmed exposure, mutable selection, and hardening.
- Any copied method preserves the MIT license and author credit.

## KSI-07: Reproducible research and source synthesis

**State:** Complete. Implemented from K-Dense revision `a25cf9ec00e2`. Kata
adopts the reproducibility, screening, synthesis, and citation-support rules but
does not import the source scripts, paid services, or scientific-domain output
templates.

**Outcome:** `kata-understand` can produce a reproducible research synthesis,
and `kata-verify` can check the resulting claims and source coverage.

**Source evidence:**

- [K-Dense `literature-review`](../../../references/science-and-research/scientific-agent-skills/skills/literature-review/SKILL.md)

**Implemented changes:**

1. Add a research-synthesis method to `kata-understand` for questions that need
   several sources or a stated search boundary.
2. Record the question, source classes, queries, dates, selection rules,
   exclusions, and evidence limits.
3. Separate discovery coverage from exhaustive or systematic-review claims.
4. Group conclusions by finding or theme. Do not write one summary per source
   when cross-source synthesis is required.
5. Extend research review to check search coverage, selection bias, citation
   support, counterevidence, and reproducibility.

**Changed files:**

- `skills/kata-understand/SKILL.md`
- `skills/kata-understand/references/research-synthesis.md`
- `skills/kata-understand/LICENSE-K-DENSE`
- `skills/kata-verify/references/research-review.md`

**Acceptance evidence:**

- Another worker can repeat the recorded search boundary.
- Every material claim links to direct support or has an Unknown label.
- The conclusion shows conflicting evidence and important exclusions.
- A normal engineering survey does not claim systematic-review completeness.

## Integration evidence

- The live catalog check passes with 20 skill packages.
- The focused Markdown link check passes for the six changed packages and the
  related repository documents.
- The quality backlog tool accepts two `test-value-gap` examples and rejects
  automatic selection for the judgment-required rule.
- The source license notices are present in each package that adapts a source.
- `git diff --check` reports no whitespace errors.
- No Dojo run, install test, remote write, or source reference script was used.
  Live application and AI-behavior cases need a real candidate and stay part of
  the first-use acceptance for those methods.

## Deferred and excluded work

- `kata-prototype` is not part of this backlog.
- Visual design, UI critique, design systems, visual polish, and design variants
  go to Impeccable. Kata can verify stated behavior and supplied acceptance
  conditions, but it does not own visual-design judgment.
- MCP server construction is not part of KSI-06. Add it only after repeated
  Jido or general MCP implementation work proves a separate method is needed.
- Host setup, telemetry, model routing, recurring automation, and remote service
  configuration remain outside these items.

## Execution contract

For each item:

1. Confirm one current task or failure that needs the method.
2. Re-read the named source package and all support files used by the method.
3. Record the source commit, exact adapted files, author, and license.
4. Write a bounded change contract for the existing owner.
5. Use `kata-write-skill` to change the package.
6. Verify activation, authority, result shape, links, metadata, and the focused
   acceptance cases.
7. Update this backlog with the result and evidence. Do not mark an item done
   from prose review alone.

No item in this plan authorizes a commit, push, package deletion, rename, or
remote write.
