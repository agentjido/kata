# Tutor routing acceptance cases

Use these cases to review a Tutor routing change. They do not grant actions.

## Activation cases

| Request | Expected behavior |
| --- | --- |
| `$tutor help me learn how to verify agent work.` | Use Tutor and select `verify-work`. |
| `Help me learn how to verify agent work.` | Use Tutor because the learning intent is clear. |
| `Verify this agent result for me.` | Do not select Tutor. This is ordinary work execution. |
| `Teach me microbiology.` | Do not select Tutor. The subject is outside the curriculum. |
| `$tutor` | Use Tutor. Give a short welcome, ask for one real task, and offer `first-win` or the topic list. Do not guess a topic. |

## Learning cases

| Learning request | Mode | Commands | Expected boundary |
| --- | --- | --- | --- |
| Explain how agent authority works. | Office Hours | `how` | Select `direct-agents`. Explain directly. Do not require practice. |
| What can I learn here? | Explore | `how` | Show only approved curriculum topics. |
| Explain how and why this router selects commands. | Office Hours | `how`, `why` | Weave one answer and preserve rationale uncertainty. |
| Help me improve this agent assignment. | Review | `feedback`, then a needed explanation or practice | Use the supplied assignment. Do not infer a score. |
| Teach me to state a clear outcome. | Lesson | `how`, `practice`, then `feedback` after a return | Use the `first-win` lesson and stop for the learner's attempt. |
| Do this task for me. | Coach | as needed | Tutor can prepare a handoff. It does not execute the task. |
| Teach why agent work needs verification, then help me apply it. | Office Hours | `why`, then a handoff | Explain the principle, then offer a ready-to-use `$jido` verification brief. Do not invoke Jido. |
| Find a current course about agent delegation. | Resource support | `resources` | Use a supplied valid catalog and return no more than two items. With no supplied catalog, name no external item. |
| Use this local verification skill for practice. | Coach | as needed | Use it only when it is exposed and declares `verify-work`; do not execute it. |
| When should I use Jido and when should I ask directly? | Lesson | `how`, `practice` | Select `use-jido` and the `choose-the-entry` lesson. |
| Help me give an agent a safe code change. | Coach | as needed | Select `agentic-engineering` and the `bound-a-code-change` lesson. Do not make the change. |
| Give me a note of what I practised. | Coach | `feedback` | Return the progress note from observed attempts only. Do not store it or claim mastery. |

The Mode column uses the five engagement modes from `loops.md`. Resource
support is not a mode.

For every case, check that Tutor loads only registered commands, returns one
integrated answer, and stops when the learning request is complete.
