# Skill library architecture

Status: working model

## Purpose

Keep Kata useful as it grows. Keep fewer than 20 active skills. Make `jido` the
main entry point. Add a skill only when real work proves that a separate package
is useful.

## Nucleus

Jido is the front door to two internal routes:

```text
Value delivery: understand -> plan -> work -> verify -> consumer acceptance
Kaizen:         maintain-skill -> write-skill -> dojo -> consumer acceptance
```

The requester states the goal in normal language and grants authority. Jido
uses delegated judgment, selects the route, and starts at the first unresolved
contract. The requester does not need to use the terms Value delivery, Flow, or
Kaizen.

The nucleus has eight skills: `jido` and the seven transition skills shown
above. `commit` is an optional software support action. It is not part of either
core route.

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
understand -> plan -> work -> verify -> consumer acceptance
                              |
                              v
maintain-skill -> write-skill -> dojo -> consumer acceptance
       ^                          |
       +---- evaluation evidence--+
```

| Facet | Main question | Normal result |
| --- | --- | --- |
| Understand | What is true now? | Evidence and a bounded problem |
| Plan | What sequence can reach the target? | A decision-ready plan |
| Work | What change or result must be made? | A candidate result with local checks |
| Verify | Does the result meet its contract? | Pass, fail, or an evidence gap |
| Maintain skill | What reusable problem or opportunity exists? | A resolved finding or bounded brief |
| Write skill | What reusable transition must change? | A conforming skill candidate |
| Dojo | Does the candidate work across controlled cases? | Evaluation evidence and an adoption recommendation |

`verify` is a first-class facet. `work` can run fast local checks, but it does
not declare its own result verified. This keeps creation and judgment separate.
`jido` can run `work` and `verify` as the complete route when the request is
already ready. Altitude is the first unresolved contract, not task size.

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

## Verify dispatcher

`verify` selects evidence that matches the result:

| Profile | Required evidence examples |
| --- | --- |
| Software | Executed behavior, tests, static checks, and relevant risk checks |
| Document or artifact | Correct content, valid structure, rendered output, and usable links |
| Research | Source quality, dates, uncertainty, and support for each conclusion |
| Operation | Observed final state, scope, failure handling, and recovery evidence |
| Skill | Trigger behavior, outcome checks, boundaries, and live-task evidence |

Focused methods such as coverage review, blast-radius checks, adversarial
review, and benchmark checks can first be commands or references under
`verify`. Promote one to a full skill only when it has a distinct trigger,
method, result, and repeated use.

## Domain map

Track domains as rows and facets as columns. Do not use package count as the
coverage measure.

| Domain | Understand | Plan | Work | Verify | Kaizen |
| --- | --- | --- | --- | --- | --- |
| Skill library | Core | Core | Skill writing | Dojo | Specialist |
| General software | Core | Core | Software profile | Software profile | Core |
| Elixir and OTP | Lens | Core | Lens | Lens | Core |
| Jido SDK | Lens | Core | Lens | Lens | Core |
| AI and LLM systems | Lens | Core | Lens | Gap to assess | Core |
| Documentation | Core | Core | Artifact profile | Artifact profile | Core |
| Operations and homelab | Lens | Core | Operation profile | Operation profile | Core |
| Research and decisions | Core | Core | Research profile | Research profile | Core |

Use four states in a generated map:

- **Core**: a general skill covers the cell.
- **Lens**: domain guidance extends a general skill.
- **Specialist**: a dedicated skill has proven value.
- **Gap**: actual work lacks a reliable method or result.

An empty or weak cell does not require a skill. It becomes a skill candidate
only after real tasks show repeated friction or failure.

The map belongs to library maintenance. Add a `map` command to
`maintain-skill`, and expose it as `$jido map`. Do not add a separate mapping
skill.

## Skill budget

Use a target of 16 active skills and a hard limit of 19.

| Group | Target | Examples |
| --- | ---: | --- |
| Core work system | 8 | `jido`, understand, plan, work, verify, maintain-skill, write-skill, dojo |
| Conversation | 4 | `bro`, `sharpen`, `ketchup`, `showme` |
| Domain packages | 3 | Jido SDK, Elixir, documentation |
| Principle library | 1 | `principled` with internal commands |
| Reserve | 3 | New capabilities proven by real work |

The target is a portfolio shape, not an immediate rename or deletion list.
Keep a small command when its name has clear value and its behavior is narrow.
Merge variants into commands or modes when they use the same method and produce
the same type of result.

Likely consolidation paths include:

- Keep video catch-ups under `ketchup` as an explicit output mode.
- Put `in-your-own-words` under `sharpen` or an understand command.
- Put `unslop`, documentation checks, and technical-writing rules in one
  documentation package.
- Put Jido action, agent, AI, and testing methods in one Jido SDK package with
  focused commands or references.
- Put coverage, dead-code, design, pull-request, benchmark, blast-radius, and
  adversarial checks behind `verify` commands. Keep a separate package only
  when its context or procedure cannot stay small.
- Put recall and repository status behind understand or `$jido status` when their
  work contracts overlap.

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
5. Classify the current 38 packages as keep, command, lens, merge, or retire.
6. Move toward 16 active skills through normal maintenance, not one bulk edit.
