# Jido routes

The human can state a goal in normal language. The names below are optional
entry overrides and help terms. Do not ask the human to choose one when the goal
already selects a route.

## Value-delivery steps

| Step | Trigger | Non-trigger | Primary Kata | Default authority |
| --- | --- | --- | --- | --- |
| `understand` | Establish the current condition, explain a cause, answer a domain question, or bound an unclear problem. | The current condition and work target are already supported. | `../kata-understand/SKILL.md` | `read-only` |
| `plan` | Resolve a route with material decisions, dependencies, or several coordinated steps. | The work request is already executable, or the user only wants an answer. | `../kata-plan/SKILL.md` | `local-write` |
| `work` | Produce a candidate from a request with known target, scope, acceptance, and authority. | A material value decision or route remains open, or a candidate already exists. | `../kata-work/SKILL.md` | `local-write` |
| `verify` | Check an existing candidate against its acceptance conditions. | The result still needs to be produced or repaired. | `../kata-verify/SKILL.md` | `read-only` |

## Kaizen steps

| Step | Trigger | Non-trigger | Primary Kata | Default authority |
| --- | --- | --- | --- | --- |
| `maintain-skill` | Resolve one supported library finding when the disposition or required change is not known. | A known package change is ready to write. | `../kata-maintain-skill/SKILL.md` | `local-write` |
| `write-skill` | Create, import, convert, or revise a skill package with a known contract. | The library concern still needs a finding or ownership decision. | `../kata-write-skill/SKILL.md` | `local-write` |
| `dojo` | The request explicitly names Dojo and asks to inspect saved evidence or evaluate an exact candidate. | Any inferred need for testing, verification, efficiency evidence, or adoption support. | `../kata-dojo/SKILL.md` | `local-write` |

## Support steps

| Step | Trigger | Non-trigger | Primary Kata | Default authority |
| --- | --- | --- | --- | --- |
| `docs` | Establish or maintain project docs, process an inbox item, or preserve durable project knowledge. | Author a plan or perform a broad code-to-document content sync. | `../kata-docs/SKILL.md` | `local-write` |
| `status` | Report local or remote Git workbench state for a repository or folder. | Application health, business status, or general progress. | `../kata-status-report/SKILL.md` | `read-only` |
| `commit` | Create one local Git commit from an accepted verified change. | The change still needs work, verification, or consumer acceptance. | `../kata-commit/SKILL.md` | `local-write` |
| `help` | Explain available routes with natural-language examples. | A request to perform work. | None | `read-only` |

## Selection rules

1. Determine what the requested result changes. A current domain result uses
   value delivery. A reusable skill or work method uses Kaizen. Project docs,
   Git status, commit, and help use support.
2. Honor an explicit step only as an entry request. Continue to a later step
   only when the user's requested result and authority include it.
3. Without an explicit step, select the first unresolved contract in
   `loops.md`. Never infer Dojo as that step.
4. Re-evaluate after every step. Stop for an accountable decision, missing
   authority, failed gate, or completed requested result.
5. Do not make the human repeat the request with an internal term.

Examples:

```text
$jido explain why customer renewals fell last quarter
$jido prepare a launch approach from these constraints
$jido update this report to meet the supplied acceptance rules
$jido check whether this result meets the contract
$jido make this repeated review process reusable
$jido dojo inspect the saved evidence for this skill
$jido record this verified finding in the project docs
$jido save the accepted verified change as a local commit
```
