# Idea methods

Select the smallest method that can settle the current idea.

## Explore

Use Explore for a new or vague idea.

1. Find the problem, beneficiary, current workaround, and desired change.
2. Inspect available facts before asking a question.
3. Surface only the premise gaps that can change the result.
4. Generate two or three meaningfully different directions when alternatives
   exist.
5. Present the alternatives before the recommendation.
6. Confirm the selected direction, scope, success signals, and open questions.

Ask one question per turn. Stop early when the idea is already clear.

## Grill

Use Grill when the user asks for a demanding interview or wants a design,
decision, or proposal sharpened. Also switch from Explore to Grill when one
unresolved product decision controls dependent decisions about user value,
behavior, scope, or success. Announce an automatic switch and continue:

> This idea now needs a full Grill. I will ask one decision at a time until we
> confirm shared understanding.

Model the work as a decision tree. A decision can be asked only after its
prerequisites are settled. The current **frontier** is the set of decisions
whose prerequisites are settled and whose answers are still open.

1. Build the tree from the user's proposal and current evidence.
2. Remove questions that the environment can answer. Investigate those facts
   instead. If a fact is unavailable, record the evidence gap.
3. Rank the frontier by how much each answer can change the result.
4. In each round, ask one highest-value question and give a recommended answer
   with its evidence. Preview likely next questions as short titles only. Do
   not include their full wording or recommendations.
5. If the user also answers a previewed question, record the supported decision.
   Rebuild the frontier after every answer, and do not repeat a resolved
   question or ask a downstream question while its prerequisite is open.
6. Continue until the frontier is empty or each unresolved branch is an
   explicit assumption, research need, or decision for another person. Give
   every unresolved branch a status and next owner.
7. Summarize the shared design concept, resolved decisions, and explicit open
   items. Ask the user to confirm shared understanding.
8. If the user does not confirm it, rebuild the tree and continue. After
   confirmation, stop and offer the next route. Do not create a brief, contract,
   plan, or implementation as part of Grill.

Grill mode is demanding about missing decisions, not hostile toward the user.
Do not repeat a settled question or make the user defend a fact already proved.
Clarity means that no branch remains silent. It does not require an immediate
answer when an explicit unresolved branch has a status and next owner.

## Challenge

Use Challenge when the user asks to interrogate, pressure-test, find blind
spots, or tear apart an idea.

State the idea's intended outcome first. Then attack it from three different
angles selected from this list:

- the problem is not real or important enough;
- the named beneficiary will not change behavior;
- an existing or smaller solution already wins;
- one hidden dependency makes the idea infeasible;
- misuse, security, privacy, or failure modes defeat the value;
- operating and maintenance cost exceeds the benefit;
- a plausible future change invalidates the premise; or
- the success measure can pass while the user outcome still fails.

For each angle, seek repository evidence, a counterexample, a small calculation,
an existing incident, or a concrete scenario. A concern survives only when it
has support or when the missing evidence is itself a material unknown. Drop
style opinions, generic risks, and claims with no failure path.

Return surviving concerns, dropped concerns, and the smallest test or decision
that resolves each surviving concern. Challenge mode does not repair code or
rewrite the proposal without the user's decision.
