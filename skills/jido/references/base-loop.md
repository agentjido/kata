# Jido base loop

Use this loop when no stable Jido route fits or when its leaf package is not
available.

## Establish the route and entry

Restate the human's goal and the concrete result that can be completed in the
current scope. Preserve every explicit limit. Classify the result as current
value delivery, reusable method improvement, or support. Do not ask the human
to name that class.

Use the first unresolved contract:

- Understand when the current condition or problem lacks evidence.
- Idea when the problem is understood but product behavior, direction, or scope
  still needs an accountable decision.
- Roadmap when the destination is clear but dependent decisions need several
  review cycles before one implementation plan can be written.
- Plan when the target is clear but the route has a material decision.
- Work when target, scope, acceptance, and authority are clear.
- Verify when a candidate exists and needs evidence.

Skip every earlier step whose result is already supplied and supported.

Classify the maximum authority:

- Use `read-only` when the user asks for an answer, diagnosis, review, or status.
- Use `local-write` when the user asks for a local change or build result.
- Require explicit authority before any remote write.

Do not turn a read-only request into an implementation task. Do not combine
creation and final judgment without naming the separate evidence phases.

Do not change the skill library through the base loop. A known package change
belongs to `write-skill`. An unknown library-maintenance need belongs to
`maintain-skill`. Ask one boundary question when neither route can be selected
safely.

Do not deliver a Git change through the base loop. Route an explicit commit,
pull request, watch, or merge request for a verified change to `shipit`.

If the result depends on a running Jidoka BEAM system, read
[runtime-client.md](runtime-client.md) and use the optional client only when it
can supply relevant evidence.

## Perform the work

1. Execute only the selected entry phase.
2. Produce its named result and evidence inside the authority.
3. Re-evaluate the next unresolved contract.
4. Continue only when the requested outcome and authority include the next
   phase.
5. Stop when the result is supported, an accountable decision is required, or
   a specific blocker prevents further in-scope progress.

Do not add a long generic workflow. Use the host's normal tools and the
repository's existing checks.

## Return evidence

Report the result and the direct evidence. Label an unseen cause or prediction
as an inference. Report a failed or missing check instead of describing the work
as complete.

If the same distinct procedure has needed this loop more than once, report it
as possible Kaizen evidence. Do not create or modify a Kata without an explicit
request.
