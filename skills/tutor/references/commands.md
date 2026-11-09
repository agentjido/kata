# Internal tutor command registry

These commands are internal parts of the single `$tutor` Agent Skill. They are
not separate skills.

| Command | Fixed path | Use when |
| --- | --- | --- |
| `how` | `references/commands/how.md` | Explain a mechanism, sequence, example, or application. |
| `why` | `references/commands/why.md` | Explain purpose, rationale, evidence, or tradeoffs. |
| `practice` | `references/commands/practice.md` | Guide one small learner action on real work. |
| `feedback` | `references/commands/feedback.md` | Review an observed attempt and suggest one revision. |
| `resources` | `references/commands/resources.md` | Find and select current external learning material. |

## Rules

1. Select only the commands needed for the full learning request.
2. An internal command cannot add authority or change Tutor's learning role.
3. Tutor integrates command results. Do not return separate command reports.
4. If no command fits, answer the supported part and name the missing teaching
   method.
