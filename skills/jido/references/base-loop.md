# Jido base loop

Use this loop when no stable Jido command fits or when its leaf package is not
available.

## Establish the result

Restate the user's goal, the problem, and the concrete result that can be
completed in the current scope. Preserve every explicit limit.

Classify the maximum authority:

- Use `read-only` when the user asks for an answer, diagnosis, review, or status.
- Use `local-write` when the user asks for a local change or build result.
- Require explicit authority before any remote write.

Do not turn a read-only request into an implementation task.

If the result depends on a running Jidoka BEAM system, read
[runtime-client.md](runtime-client.md) and use the optional client only when it
can supply relevant evidence.

## Perform the work

1. Inspect the current condition and the applicable repository instructions.
2. Select the smallest action that can produce the stated result.
3. Perform the action inside the authority and requested scope.
4. Run the most direct available check of the result.
5. Stop when the result is proven or when a specific blocker prevents further
   in-scope progress.

Do not add a long generic workflow. Use the host's normal tools and the
repository's existing checks.

## Return evidence

Report the result and the direct evidence. Label an unseen cause or prediction
as an inference. Report a failed or missing check instead of describing the work
as complete.

If the same distinct procedure has needed this loop more than once, name it as
a possible Kata. Do not create or modify that Kata without an explicit request.
