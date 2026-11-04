---
name: in-your-own-words
description: "Use only when the user explicitly asks for a restatement of their goals and the problem they are trying to solve. Do not use to restate the assistant's last message or to start the work."
metadata:
  schema: kata.skill/v1
  subject: general
  practice: restate
  object: work-intent
  profile: bounded-execution
  authority: read-only
  consumes: [user-request, conversation-context]
  produces: [goal-restatement]
---

# In your own words

**Outcome:** The user receives a concise restatement of their goal and the
problem behind it.

**Done:** The restatement separates the desired result from the current
problem, preserves uncertainty, and does not begin the task.

## Assignment

The required input is an explicit request and the relevant conversation. Read
only that conversation. Do not inspect files, use tools, make decisions for the
user, or start work.

## Work

State what you think the user wants to be true and what prevents it now. Mark
an inference as an inference. Keep choices that belong to the user open.

## Verify

Check that the result contains the goal and problem, adds no unsupported
requirement, and is short enough for the user to correct directly.
