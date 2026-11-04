---
name: kata-plan
description: "Create structured plans for multi-step work, including software and non-software tasks. For durable repository plans, create a Beadwork graph when the repository is already initialized for Beadwork; otherwise create the plan file only. Use when asked to plan, break down implementation, plan from requirements, or deepen an existing plan; prefer ce-brainstorm for exploratory framing."
argument-hint: "[optional: feature description, requirements doc path, plan path to deepen, or any task to plan] [output:html]"
metadata:
  schema: kata.skill/v1
  subject: general
  practice: plan
  object: multi-step-work
  profile: direction
  authority: local-write
  consumes: [planning-request, source-material, understood-context]
  produces: [work-plan, implementation-plan, planning-brief, verified-change]
---

# Create Technical Plan

## Kata integration

Read `references/kata-integration.md` first. Its rules take precedence over the
CE integration steps below: use the active host and model, honor existing user
authorization, and use the defined native fallbacks for absent companion skills.
The source workflow and its bundled references remain the basis for this skill.

**Outcome:** The next executor receives a plan that it can start with confidence.
The result can be a few sentences in chat, a chat brief, or a durable plan
artifact. For a Durable repository plan, create a Beadwork epic and task graph
when `bw` is available and already initialized in that repository. Otherwise,
keep the plan as the only artifact. For software work, `ce-brainstorm` defines
**WHAT** to build as a requirements-only unified plan, `kata-plan` enriches it
with **HOW**, and `kata-work` executes it. A prior brainstorm is useful but is
not required.

**Done:** The selected output contract is complete, the result has its required
handoff or explicit blocker, and each durable local artifact passes its format
and consistency checks.

## Assignment

The required input is one planning request. Source material is optional. Resolve
the target, output contract, acceptance conditions, time horizon, and next
executor before you write a durable artifact. The normal work profile is
`direction`. A Direct or Chat brief route uses `bounded-execution`.

Direct user authority or inherited caller authority permits read-only research
and the local plan artifacts that this workflow requires. It also permits a
local Beadwork graph only when Beadwork is already initialized in the target
repository. Do not implement the plan, install a dependency, initialize or
repair Beadwork, change a branch, create a commit, change remote state, publish
an artifact, or change a live system. Ask the operator when a missing product
decision changes scope, cost, risk, or the next executor.

A response-only Direct or Chat brief route produces `planning-brief`. A durable
software route produces `implementation-plan` and `verified-change`. A durable
non-software route produces `work-plan` and `verified-change`. Durable outputs
are ready only after their local artifacts pass their checks.

**An explicit invocation always produces a plan.** Never classify a direct invocation as "not a planning task" and route out. It may select any output contract below, and the smallest valid plan is a few sentences in chat.

**Research, decide, and write the plan — never implement.** Creating the plan
and its Beadwork epic, tasks, and dependency edges is planning output, not product
implementation. Do not write production code, run implementation tests, or learn
from execution-time results. Directional pseudo-code and grammar sketches may
communicate design; changing code to see what happens belongs in `kata-work`.

## Mandatory Completion Contract

A run is complete when its output contract's done condition is met. Every normal interactive branch that produces a plan artifact or checkpoint is incomplete until its owning handoff question is presented: for a Durable software implementation-plan run that continues past Phase 0.1b, Beadwork detection and any required graph creation have completed, the Phase 5.4 menu is presented, and any selected action has actually fired. For Direct, the change is stated and the correct executor handoff is offered. For a Chat brief, the brief and its one-line save-or-execute offer are in chat. A software handoff can offer `kata-work`; a non-software handoff must use its owning workflow. Neither presents the Phase 5.4 menu or creates Beadwork issues. Non-software and approach-altitude routes use their reference workflow's terminal handoff. Answer-seeking may end after the answer unless its owner requires save/share.

Writing the file, checking confidence, and running or explicitly skipping `ce-doc-review` are intermediate milestones. Pipeline mode is complete only when the plan, confidence check, and non-interactive document-review state are returned to its caller; the caller owns the next action.

## Interaction Method

Ask one question at a time through the host's blocking question tool already in the current tool list. Match by capability; never probe a user-facing tool to discover it. If none is listed or a real question call errors, render numbered choices in chat; never silently skip a required question. If no feature description was supplied, ask what to plan and wait.

## Output Contract

The gate resolves at the start of Phase 0.6, before depth and the scoping synthesis. It applies only when no Phase 0.1 route fired and Phase 0.2 found no upstream artifact. Ground it with bounded inline reads of the surfaces the request names; dispatch no subagent. Select one:

An explicit `kata-plan` invocation that targets a Git repository always selects
**Durable** and writes a plan file under the configured artifact root, normally
`docs/plans/`. This is true even for a small change. Repository planning needs a
stable artifact for Beadwork detection, ticket mapping, or later execution. Use
Direct or Chat brief only for work with no repository, or when the user explicitly
requests chat-only output. A chat-only override creates no Beadwork graph.

- **Direct** — the work can be stated, done, and verified in one pass with no decision the user would weigh. State the change in a few sentences and offer the owning executor or the user. Offer `kata-work` only for software implementation. Execution starts only with implementation authority, which `references/output-contracts.md` defines.
- **Chat brief** — bounded work with at most one decision the user would weigh and no risk surface. Deliver it in chat and stop.
- **Durable** — everything else. Continue the workflow below.

`references/output-contracts.md` owns Direct and Chat brief; read it when either is selected. When the tier is still uncertain after those reads, take the heavier one. When a read surfaces a decision the user would weigh, a risk surface, or multi-pass verification, re-resolve to the heavier tier before emitting anything. Durable regardless of size: a run with no synchronous user to act on chat this turn (pipeline, headless, goal- or scheduler-driven), a request whose wording asks for a plan, a plan file, or an output format, a request that continues an existing plan's item, and a risk surface — authentication, payments, migrations, external contracts.

## Workflow

Phases run in order unless an owner routes out or short-circuits. Read a phase's required reference when that phase is entered, completely; a read made before that phase does not satisfy it, and a terminal owner is read again at its step even when already in context. If a required reference cannot be read, stop before its governed action and report the blocker and recovery path; never reconstruct the missing mechanism from memory. In pipeline mode, every required-owner failure returns `status: blocked`, `phase`, `blocker`, and `recovery_path`; include `artifact_path` and preserve the artifact when one exists. Blocked status outranks artifact presence.

### Phase 0: Output, Resume, and Scope

1. **Output first.** Read `references/output-mode.md` before interpreting any phase. It owns token parsing, output and confirmation precedence, renderer selection, artifact-root rules, and when a repository may be resolved.
2. **Resume, deepen, approach, and domain.** Read `references/resume.md` before acting. It owns repo-backed resume discovery, requirements-only enrichment, deepen fast paths, approach-altitude routing, and the software/non-software split. Follow any terminal route it selects; otherwise continue.
3. **Source and scope.** Read `references/intake.md` before Phase 0.2 and follow it through Phase 0.7. It owns upstream-contract discovery, preservation, bootstrap route-outs, blocking questions, depth, named-resource handling, and solo scoping synthesis; the Output Contract gate above resolves inside it. Do not cross a required gate that has not resolved.
4. **Beadwork mode.** For a Durable repository plan, read `references/beadwork.md` after the Git root is known and run only its read-only detection step. Record `active` or `plan-only`. Do not initialize or repair Beadwork.

### Phases 1-4: Research and Compose

5. Read `references/research.md` before gathering context. It owns local and external research, agent-native triage, consolidation, depth reclassification, and flow analysis.
6. Read `references/structure.md` before resolving questions or structuring the plan. It owns settled-decision handling, stable U-IDs, technical design, depth, and planning boundaries.
7. Compose from `references/plan-sections.md` plus the format-rendering reference selected by `output-mode.md`.

### Phase 5: Review, Write, Deepen, and Hand Off

8. Read `references/final-review.md` before pre-write review. It owns Phase 5.1 through 5.3.2, including scoping synthesis, write-path mechanics, unified-plan metadata, confidence mode, and the deepening gate. When directed, read `references/deepening-workflow.md` for steps 5.3.3-5.3.7.
9. **Model elevation.** Immediately before authoring, read `references/reasoning-elevation.md`, resolve the choice at this boundary, and follow it. Do not author until activation resolution has completed and any selected dispatch or transparent fallback has settled.
10. In pipeline mode, invalidating evidence against a session-settled decision stops the write. Return the exact token `settled-decision-invalidated`, the decision, and the reason; do not resolve it silently.
11. Write the plan before presenting options, then complete the confidence path owned by `final-review.md`.

**STOP. Read `references/plan-handoff.md` immediately before Phase 5.3.8 and 5.4.** Document review is mandatory for a Durable plan and the default is non-interactive (`mode:non-interactive`). The reference owns final checks, automatic Beadwork materialization, menu visibility, and every selected route. In interactive software runs, ask exactly: "Plan ready at `<absolute path to plan>`. What would you like to do next?" Present the owner-defined menu and wait. If the selection arrives after a user turn, reload `references/plan-handoff.md` before acting. Rendering the menu, receiving a selection, or announcing a route is not completion; execute the selected action.
