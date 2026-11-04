# Skill library architecture

Status: Current

Last reviewed: 2026-11-04

## Current review

Direct inspection found 21 active skills with `kata.skill/v1` metadata. The
2026-11-04 curation folded focused imported methods into core packages, retired
small commands, combined the Jido build packages, and later added `kata-debug`
and `kata-idea`. `kata-roadmap` now owns durable multi-session decision routes
between idea and implementation planning. `kata-verify` routes focused
verification methods, and `kata-shipit` replaces the local-only `kata-commit`.
The `kata-correct` method now belongs to `kata-work` and `kata-verify`. The
`kata-explainer` package owns the repeated technical-video production method.
The catalog remains below the hard limit of 25. Skill frontmatter and live
package files remain the inventory authority.

## Purpose

Keep Kata useful as it grows. Make `jido` the main entry point. Add a skill only
when real work proves that a separate package is useful.

## Nucleus

Jido is the front door to two internal routes:

```text
Value delivery: understand -> idea? -> roadmap? -> plan -> work -> verify -> consumer acceptance
Kaizen:         maintain-skill -> write-skill -> consumer acceptance
Optional:       dojo -> consumer acceptance, only by explicit request
```

The requester states the goal in normal language and grants authority. Jido
uses delegated judgment, selects the route, and starts at the first unresolved
contract. The requester does not need to use the terms Value delivery, Flow, or
Kaizen.

The nucleus has nine skills: `jido` and the eight default transition skills
shown above. `kata-dojo` and `kata-shipit` are optional actions. They are not
part of either core route.

## Four separate dimensions

Do not make one skill for every combination. Classify work with four separate
dimensions.

1. A **facet** says which part of the work life cycle is active.
2. A **profile** says what type of result the agent must produce.
3. A **domain lens** adds subject rules and checks.
4. A **command** gives the user a short and stable entry point.

For example, a Jido API change can use the `work` facet, the software-change
profile, and the Jido SDK lens. These three values do not require three skills.

## Work-system routes

```text
understand -> idea? -> roadmap? -> plan -> work -> verify -> consumer acceptance

maintain-skill -> write-skill -> consumer acceptance

dojo -> consumer acceptance, only by explicit request
```

| Facet | Main question | Normal result |
| --- | --- | --- |
| Understand | What is true now? | Evidence and a bounded problem |
| Idea | What should exist, for whom, and why? | A decision-ready idea brief or Product Contract |
| Roadmap | Which dependent decisions must become clear across several review cycles? | A durable decision roadmap and planning handoff |
| Plan | What technical sequence can deliver the software target? | A software implementation plan |
| Work | What change or result must be made? | A candidate result with local checks |
| Verify | Does the result meet its contract? | Pass, fail, or an evidence gap |
| Maintain skill | What reusable problem or opportunity exists? | A resolved finding or bounded brief |
| Write skill | What reusable transition must change? | A conforming skill candidate |
| Dojo | What does an explicitly requested controlled experiment show? | Evaluation evidence and an adoption recommendation |

`verify` is a first-class facet. `work` can run fast local checks, but it does
not declare its own result verified. This keeps creation and judgment separate.
`jido` can run `work` and `verify` as the complete route when the request is
already ready. Altitude is the first unresolved contract, not task size.
Dojo is not a required gate and Jido must not infer it.

## Work dispatcher

`work` uses one common contract:

```text
classify -> set target -> act -> run local checks -> hand off
```

It selects one profile:

| Profile | Typical result |
| --- | --- |
| Software change | Code, configuration, or a test |
| Document or artifact | A document, diagram, data file, or other artifact |
| Research or synthesis | An evidence-based answer or decision record |
| Operation | A confirmed change to a repository, service, or external system |

Each profile belongs in a small reference inside the `work` package. A profile
is not a new skill. If the target is unclear, `work` routes to understand or plan.
If the request is only to judge an existing result, it routes to `verify`.
The repository-guard reference is a focused work method. It produces a
candidate guard and work evidence after two occurrences are established.

## Verify dispatcher

`verify` selects evidence that matches the result:

| Profile | Required evidence examples |
| --- | --- |
| Software | Executed behavior, tests, static checks, and relevant risk checks |
| Document or artifact | Correct content, valid structure, rendered output, and usable links |
| Research | Source quality, dates, uncertainty, and support for each conclusion |
| Operation | Observed final state, scope, failure handling, and recovery evidence |
| Skill | Trigger behavior, outcome checks, boundaries, and live-task evidence |

Focused methods such as repository-guard proof, coverage review, blast-radius
checks, adversarial review, and benchmark checks can first be commands or
references under `verify`. Promote one to a full skill only when it has a
distinct trigger, method, result, and repeated use.

## Domain map

Track domains as rows and facets as columns. Do not use package count as the
coverage measure.

| Domain | Understand | Idea | Roadmap | Plan | Work | Verify | Kaizen |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Skill library | Core | Core | Core | Gap | Skill writing | Dojo | Specialist |
| General software | Core | Core | Core | Core | Software profile | Software profile | Core |
| Elixir and OTP | Lens | Lens | Core | Core | Lens | Lens | Core |
| Jido SDK | Lens | Lens | Core | Core | Lens | Lens | Core |
| AI and LLM systems | Lens | Lens | Core | Core | Lens | Gap to assess | Core |
| Documentation | Core | Core | Core | Gap | Artifact profile | Artifact profile | Core |
| Operations and homelab | Lens | Lens | Core | Gap | Operation profile | Operation profile | Core |
| Research and decisions | Core | Core | Core | Gap | Research profile | Research profile | Core |

The first `kata-plan` implementation covers software only. It is one deep
planning suite with a canonical Markdown artifact and optional HTML and
Beadwork adapters. `kata-roadmap` is domain-agnostic and owns decisions that
span several review cycles before this technical planning step. Do not route
non-software implementation planning through `kata-plan`. Add another planning
domain only after real work proves its method and result.

Use four states in a generated map:

- **Core**: a general skill covers the cell.
- **Lens**: domain guidance extends a general skill.
- **Specialist**: a dedicated skill has proven value.
- **Gap**: actual work lacks a reliable method or result.

An empty or weak cell does not require a skill. It becomes a skill candidate
only after real tasks show repeated friction or failure.

The catalog coverage map belongs to library maintenance. Add a `map` command to
`maintain-skill`, and expose it as `$jido map`. This is not the initiative
decision roadmap owned by `kata-roadmap`. Do not add a separate catalog-mapping
skill.

## Skill budget

Use a target of 16 active skills and a hard limit of 25. The current 21-skill
catalog remains below the hard limit.

| Group | Active | Skills |
| --- | ---: | --- |
| Core work system | 10 | `jido`, understand, idea, roadmap, plan, work, verify, maintain-skill, write-skill, dojo |
| Support | 3 | shipit, orient, sitrep |
| Domain and focused packages | 8 | build-jido, debug, docs, explainer, ex-design-review, ex-quality, showme, technical-writing |

The target is a portfolio shape, not an immediate rename or deletion list.
Keep a small command when its name has clear value and its behavior is narrow.
Merge variants into commands or modes when they use the same method and produce
the same type of result.

Applied consolidation paths include:

- Retire `bro`, `in-your-own-words`, `ketchup`, `kata-principled`, and `sharpen`.
- Put `unslop` under `kata-technical-writing`.
- Put Jido action, agent, AI, and testing methods in `kata-build-jido`.
- Put benchmark, blast-radius, adversarial, and comment-review methods under
  `kata-verify`.
- Put recall under `kata-understand`.
- Put existing-software explanation under `kata-understand`.
- Put coverage and dead-code analysis under `kata-ex-quality`.
- Put test-first repair and decision logging under `kata-work`.
- Put repository-guard creation under `kata-work` and its independent proof
  under `kata-verify`.
- Put project verification-skill creation under `kata-write-skill`.

## Admission and retirement rules

A new skill must have all of these properties:

1. At least two real tasks show the same need.
2. The trigger is clear and distinct.
3. The method is repeatable.
4. The result can be checked.
5. A command, profile, lens, or reference cannot cover the need well.
6. The library has a free slot, or one existing skill can merge or retire.

Review one skill at a time. Do not reorganize the whole library from a catalog
view alone. Use task evidence to decide each merge, split, promotion, or
retirement.

## Next steps

1. Test altitude routing on ready, ambiguous, and mixed natural-language goals.
2. Add the four `work` profiles as references, not as skills.
3. Add the coverage map to `maintain-skill` without a new mapping package.
4. Design a play contract before Dojo claims generic play evaluation.
5. Complete the shared repository issue-backend contract before issue-producing
   skills add GitHub or Jira writes.
6. Use real task evidence before the next package addition, consolidation, or
   retirement decision.
