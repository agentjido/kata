# Jido routes

The human can state a goal in normal language. The names below are optional
entry overrides and help terms. Do not ask the human to choose one when the goal
already selects a route.

## Value-delivery steps

| Step | Trigger | Non-trigger | Primary Kata | Default authority |
| --- | --- | --- | --- | --- |
| `understand` | Establish the current condition, explain a cause, answer a domain question, or bound an unclear problem. This includes a repeated-mistake claim without evidence of two occurrences. | The current condition and work target are already supported. | `../kata-understand/SKILL.md` | `read-only` |
| `idea` | Explore, grill, or challenge what to build before implementation planning. | Product behavior, scope, and success signals are already settled. | `../kata-idea/SKILL.md` | `local-write` |
| `roadmap` | Create, advance, or report a durable decision roadmap for a clear long-horizon initiative. | The destination is unsettled, the route fits one planning session, or only implementation units remain. | `../kata-roadmap/SKILL.md` | `local-write` |
| `plan` | Create or deepen a software implementation plan with material technical decisions, dependencies, or several coordinated units. | The request is non-software, already executable, or only asks for an answer. | `../kata-plan/SKILL.md` | `local-write` |
| `work` | Produce a candidate from a request with known target, scope, acceptance, and authority. This includes an explicitly requested repository guard with evidence of at least two occurrences. | A material value decision or route remains open, repeated-mistake evidence is missing, or a candidate already exists. | `../kata-work/SKILL.md` | `local-write` |
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
| `docs` | Establish or maintain project docs, process an inbox item, preserve durable project knowledge, or reconcile selected docs with code. | Author a plan or make a product decision about disputed content. | `../kata-docs/SKILL.md` | `local-write` |
| `status` | Report local or remote Git workbench state for a repository or folder. | Application health, business status, or general progress. | `../kata-sitrep/SKILL.md` | `read-only` |
| `shipit` | Commit, publish, watch, or land an accepted verified Git change to the explicitly requested boundary. | The change still needs work or verification, or the requested delivery authority is unclear. | `../kata-shipit/SKILL.md` | `external-write` |
| `help` | Explain available routes with natural-language examples. | A request to perform work. | None | `read-only` |

## Selection rules

1. Determine what the requested result changes. A current domain result uses
   value delivery. A reusable skill or work method uses Kaizen. Project docs,
   Git status, shipping, and help use support.
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
$jido grill this product idea before we plan it
$jido create a decision roadmap for this long-horizon initiative
$jido prepare a launch approach from these constraints
$jido update this report to meet the supplied acceptance rules
$jido check whether this result meets the contract
$jido make this repeated review process reusable
$jido dojo inspect the saved evidence for this skill
$jido record this verified finding in the project docs
$jido ship the accepted verified change as a pull request
```
