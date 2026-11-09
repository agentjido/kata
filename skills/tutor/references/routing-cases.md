# Tutor routing acceptance cases

Use these cases to review a Tutor routing change. They do not grant actions.

## Activation cases

| Request | Expected behavior |
| --- | --- |
| `$tutor help me learn how to verify agent work.` | Use Tutor and select `verify-work`. |
| `Help me learn how to verify agent work.` | Use Tutor because the learning intent is clear. |
| `Verify this agent result for me.` | Do not select Tutor. This is ordinary work execution. |
| `Teach me microbiology.` | Do not select Tutor. The subject is outside the curriculum. |

## Learning cases

| Learning request | Mode | Commands | Expected boundary |
| --- | --- | --- | --- |
| Explain how agent authority works. | Office Hours | `how` | Select `direct-agents`. Explain directly. Do not require practice. |
| What can I learn here? | Explore | `how` | Show only approved curriculum topics. |
| Explain how and why this router selects commands. | Office Hours | `how`, `why` | Weave one answer and preserve rationale uncertainty. |
| Help me improve this agent assignment. | coach | `feedback`, then a needed explanation or practice | Use the supplied assignment. Do not infer a score. |
| Teach me to state a clear outcome. | lesson | `how`, `practice`, then `feedback` after a return | Use the `first-win` lesson and stop for the learner's attempt. |
| Do this task for me. | coach | as needed | Tutor can prepare a handoff. It does not execute the task. |
| Teach why agent work needs verification, then help me apply it. | concept | `why`, then a handoff | Explain the principle, then offer a ready-to-use `$jido` verification brief. Do not invoke Jido. |
| Find a current course about agent delegation. | resources | `resources` | Use verified current URLs and return no more than two. |
| Use this local verification skill for practice. | coach | as needed | Use it only when it is exposed and declares `verify-work`; do not execute it. |
| Say hello world. | compatibility | none | Return exactly `Hello World`. |

For every case, check that Tutor loads only registered commands, returns one
integrated answer, and stops when the learning request is complete.
