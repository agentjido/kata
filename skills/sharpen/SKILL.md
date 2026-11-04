---
name: sharpen
description: "Use only when the user explicitly asks to make a task deeper, not bigger, and to rewrite the prompt. Do not use to expand scope or execute the task."
metadata:
  schema: kata.skill/v1
  subject: general
  practice: refine
  object: work-request
  profile: bounded-execution
  authority: read-only
  consumes: [work-request]
  produces: [refined-work-request]
---

# Sharpen

**Outcome:** The user receives a deeper version of the same task with a prompt
that asks for stronger source material, methods, and proof.

**Done:** The new prompt keeps the original scope, leaves user decisions open,
and states how evidence outside the conversation will show that the result is
correct.

## Assignment

The required input is one task and an explicit request to sharpen it. Read only
the supplied task and relevant conversation. Do not execute the task or add a
new deliverable.

## Work

Before you rewrite the prompt:

1. State what a top professional would do that the task does not ask for.
2. Name the raw source material they would use instead of a digested summary.
3. Name the specific methods and tools they would use.
4. State what evidence outside the user and assistant would prove the result.

Rewrite the prompt to ask for those things inside the original scope. Leave
choices that belong to the user open.

## Verify

Compare the old and new prompts. Remove any new objective, audience,
deliverable, or workstream that makes the task bigger instead of deeper.
