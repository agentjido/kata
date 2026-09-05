# Broader skill search for Astra xhigh

Research date: 2026-09-05. The v3 implementation now freezes an outcome contract,
permits full rewrites, assigns three search directions, and continues after an
unchanged proposal. The known checker faults have calibration tests. A candidate
population and operation summaries remain proposals; they are not implemented.
Official skills still require separate verification and adoption.

## Relevant guidance

OpenAI's current Astra guide says that skills and project instructions can have
a strong effect on behavior. Unclear instructions can interrupt work, and small
coding tasks can receive more verification than they need. It recommends clear
autonomy boundaries and verification matched to the task. Our inference: reduce
unnecessary procedure in a skill before adding more rules.
[Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra).

The skill guide recommends one job per skill, explicit inputs and outputs, and
instructions unless scripts are needed for deterministic work. The prompting
guide says to emphasize the important boundaries without controlling every step.
[Build skills](https://learn.chatgpt.com/docs/build-skills),
[Prompting](https://learn.chatgpt.com/docs/prompting).

OpenAI's general reasoning guidance recommends direct instructions and explicit
goals. It discourages adding requests for step-by-step reasoning. This guidance
predates Astra; it supports a test hypothesis, not an Astra performance claim.
[Reasoning best practices](https://developers.openai.com/api/docs/guides/reasoning-best-practices).

Evaluation guidance calls for realistic cases and calibration of automated
scores against human review. The prompt optimizer guide states that improvement
depends on grader quality and specific feedback. We can apply these principles
in our local Elixir runner without adopting the hosted optimizer.
[Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices),
[Prompt optimizer guidance](https://developers.openai.com/api/docs/guides/prompt-optimizer).

## What to loosen

These are Kata design recommendations, not a prescribed OpenAI search algorithm.

| Current rule or behavior | Proposed change |
| --- | --- |
| One focused change, with a warning against a full rewrite for brevity | Permit deletion, reordering, replacement, and full rewrites. Require one clear hypothesis, not one small edit. |
| Preserve the behavior through the full source skill | Give the proposer a short list of required outcomes. Make clear that wording, headings, reading order, and internal checklists can change. |
| Only the best-scoring candidate becomes a parent | Keep at most two useful candidates for further search: the best valid measured result and one distinct approach. A candidate with a proven failure can supply a repair idea, but cannot be adopted. |
| Avoid a rejected approach | Distinguish wrong behavior, higher cost, and unresolved checker results. A parser failure is not evidence that a workflow is ineffective. |
| An unchanged proposal ends all search | Mark that approach exhausted, then try a different approach if the fixed budget permits. Do not evaluate identical text again. |
| Aggregate counters drive cost hypotheses | Supply bounded operation summaries: operation type, project path, output size, repeated reads, duration, and error status. Keep raw tool output out of Git. |

First repair the known checker faults offline. A required phrase that is absent
does not by itself prove an incorrect answer. Accept supported equivalent
wording; route unresolved extraction to review. Record the assessment separately
from the immutable execution. The score remains reproducible from saved evidence
and the named assessment version.

Keep the current cost weights during this experiment. Keep the profile at
`codex/gpt-6-astra/xhigh`. The 500-word limit did not exclude any candidate in the
three-round trial, and the runner already has no minimum word count. More budget
or a larger skill limit would not repair the demonstrated search problem.

The neckbeard outcome contract should require a correct answer, supporting source
references, a distinction between implementation and documented intent, honest
limits on rationale and runtime evidence, and preservation of project files.
Its procedure need not prescribe an internal checklist or a fixed reading order.
Project instructions that still apply to the task remain binding.

## Proposed core of the revision prompt

The runner would still provide the profile, training feedback, package constraints,
and numeric cost objective. This text replaces the conservative edit directions;
it is not a complete replacement for the whole prompt.

```text
Find a materially different way to complete this skill's job correctly with less
total work. Use the training evidence and the required outcome contract.

You may delete, reorder, combine, or replace any instruction, including a full
rewrite. Preserve required behavior, not the current wording or procedure.
Prefer removing unnecessary work before adding checks. Let the executing model
choose routine steps where the contract does not require a specific method.

Test the assigned search approach. Keep the complete skill within 500 words and
preserve its identity, scope, support references, and project safety boundaries.
Do not add fixture answers or checker-specific wording.

Explain the expected saving and main risk briefly outside the skill. If the
evidence cannot establish a cause, label the proposed mechanism as a hypothesis.
Do not claim an improvement before measurement.
```

## Next bounded search

After offline checker calibration, compare three distinct approaches:

1. **Remove procedure.** Retain the outcome contract and essential safeguards;
   remove redundant planning, reading, and reporting directions.
2. **Replace the workflow.** Rewrite how the agent finds and verifies evidence.
   Do not require it to preserve the source's sequence.
3. **Refine the useful candidate.** Reuse the first trial's Round 1 idea while
   removing redundant instructions. Do not repair valid prose to fit a regex.

Use separate temporary projects and the same profile and training inputs. Keep
the existing seven-call shape for a fresh one-case screen: one source execution,
three proposal calls, and three candidate executions. These are exploration
results. No new calls were made for this research note.

After screening, use the remaining explicit budget for a follow-up to the most
useful approach or repeated measurement. Any additional calls must be counted;
changing the search shape does not hide proposal costs.

Before adoption, require complete outcome passes, repeated source and candidate
executions, separate final cases, and a better fixed cost score. Preserve the
original experiment records; changes to search policy need a separate series.

Before claiming general skill value, also test a realistic investigation case
and compare with execution without the skill. The current training question and
project instructions state much of the procedure, which can hide the skill's
contribution. These controls are separate from the seven-call screen.
