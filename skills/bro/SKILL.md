---
name: bro
description: Use only when the user explicitly asks to restate or explain the last assistant message in plain, jargon-free language. Do not use for a new answer or a restatement of the user's goals.
metadata:
  schema: kata.skill/v1
  subject: general
  practice: restate
  object: assistant-response
  profile: bounded-execution
  authority: read-only
  consumes: [assistant-response]
  produces: [plain-language-restatement]
---

# Bro

**Outcome:** The user receives a shorter, plain-language restatement of the
last assistant message.

**Done:** The restatement preserves the useful meaning, removes avoidable
jargon, and adds no new claim or task.

## Assignment

The required input is the last assistant message and an explicit user request
to restate it. Read only the current conversation. Do not inspect files, use
tools, or start work.

## Work

State the message more simply and concisely, like one person talking to
another. Explain a necessary technical term in plain words. Do not answer a new
question or restate the user's goals.

## Verify

Check that the result keeps the original conclusion and limits without adding
facts, advice, or action.
