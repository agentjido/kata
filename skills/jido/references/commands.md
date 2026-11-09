# Internal Kata registry

These are internal routes of the single `jido` Agent Skill. They are not
public commands or separately installable skills.

| Kata | Fixed path | Detailed methods |
| --- | --- | --- |
| `understand` | `references/katas/understand.md` | understand, debug diagnosis, Git workbench |
| `shape` | `references/katas/shape.md` | idea, roadmap, scope, software plan |
| `lead` | `references/katas/lead.md` | tutor, delegate |
| `work` | `references/katas/work.md` | general work, debug repair, docs, routines, visual explanation, technical writing |
| `verify` | `references/katas/verify.md` | general verification, security review |
| `improve` | `references/katas/improve.md` | maintain method, write method |
| `ship` | `references/katas/ship.md` | Git delivery |
| `dojo` | `references/katas/dojo.md` | saved or live controlled evaluation |

## Selection rules

1. Select the result domain first: delivery, learning, reusable-method
   improvement, support, or explicit Dojo evaluation.
2. Select the first unresolved Kata from `loops.md`.
3. Read one detailed method only when its condition applies.
4. A method cannot change the route, authority, or Jido's integration duty.
5. If no internal method fits, use `base-loop.md`. Name the missing specialist
   method. Do not install, search for, or invent one.

The words status, plan, work, test, or review do not select a Kata by
themselves. Interpret the complete requested result.

For help, explain the eight Katas with one natural-language `$jido` example for
each. Do not tell the user to invoke an internal Kata as a separate skill.
