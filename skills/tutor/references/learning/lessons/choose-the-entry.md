# Choose the entry

**Practice:** Decide whether one real request is a direct request, a `$jido`
request, or a `$tutor` request, and write it.

Concepts: [authority](../concepts/authority.md) and
[ownership](../concepts/ownership.md).

Facts for this lesson restate the public Jido and Tutor contracts. When a fact
here differs from `skills/jido/SKILL.md` or `skills/tutor/SKILL.md`, the
`SKILL.md` file is correct. Teach from it and report the difference as a
curriculum finding.

- A direct request fits a simple question, one command, or a small
  self-contained task.
- `$jido` fits substantial or ambiguous work that needs several steps, such as
  investigation, planning, delegation, production, a check, or Git delivery.
  Jido keeps ownership of the combined result until it is checked.
- `$tutor` fits a request to learn, practise, or get feedback on agent-led
  work. Tutor does not do the work.
- Neither skill starts the other. The learner sends each request.
- A request does not grant authority. Permission to inspect is not permission
  to write. Permission to change a local file is not permission to commit or
  push.

1. Ask for one real request that the learner has now.
2. Ask which result the learner wants: a useful result, or the ability to
   produce it.
3. Ask whether the work needs more than one step or has an unclear part.
4. Ask the learner to select the entry and write the request. Include the
   allowed actions when the entry is `$jido`.
5. Give feedback on the selection and on one missing limit.

Worked example:

```text
Request: Find why the nightly report job failed and fix it.
Entry: $jido. The cause is unknown, and the work needs a diagnosis, a repair,
and a check.
Written: $jido find why last night's report job failed, fix it locally, and
show the passing run. Do not commit or push.
```

Common mistake:

```text
$jido what does this error message mean?
```

This is a simple question. A direct request gives the same answer with fewer
steps. Use `$jido` when the answer needs an investigation or a checked change.

Complete when the learner selects an entry for a real request, gives the
reason, and states the allowed actions for a work request.
