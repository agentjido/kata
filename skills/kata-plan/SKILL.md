---
name: kata-plan
description: Define a target condition and a small implementation plan. Use when the user requests a plan, needs to resolve an approach, or has a change with important unknowns.
---

# Plan

Choose the smallest useful change that moves the project toward the target.

## Method

1. Read the request, project instructions, relevant code, and available observations. Reuse established facts.
2. State the target in terms of observable behavior. Include the acceptance conditions and the limits of the work.
3. Identify the most important unknown. If it affects the design, propose a small experiment and state what its result will decide.
4. Choose an approach that fits the existing project. Explain material tradeoffs without adding options that do not affect the decision.
5. List the implementation steps, likely files, and checks. Include failure cases that matter to the change.
6. Identify decisions that require user input. Continue independent work when possible. Do not request approval that the user has already given.

## Result

Provide a short plan with the target, scope, steps, checks, and unresolved decisions. Use an existing project planning location when a file is useful. A small change can use a few lines in the conversation.

## Constraints

- Scale the plan to the work. Do not require a specification document for every task.
- Mark uncertain file names, behavior, and estimates as assumptions.
- A plan is ready when the next implementation step and its success check are clear.
