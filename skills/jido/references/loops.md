# Jido work system

Jido uses two internal routes. These names explain the system; they are not
words that the human must use.

## Value delivery

```text
understand -> plan -> work -> verify -> consumer acceptance
```

Each skill is one transition. Enter at the first unresolved contract:

| Step | Enter when | Skip when | Result |
| --- | --- | --- | --- |
| Understand | The current condition, problem, cause, or limit lacks support. | Supplied evidence bounds the problem and current state. | `understood-context` or `work-brief` |
| Plan | The target is clear, but the route has material decisions or dependent steps. | The target, scope, acceptance, and action are already clear. | `work-plan` or `implementation-plan` |
| Work | The target, scope, acceptance conditions, and authority are resolved. | A candidate result already exists. | `candidate-result` and `work-evidence` |
| Verify | A candidate result exists and its acceptance needs evidence. | Current matching evidence already proves each material condition. | `verified-result`, `verified-change`, or `verification-finding` |
| Consumer acceptance | Evidence is ready for the result's next consumer. | The assignment or downstream contract already defines acceptance. | Acceptance, rejection, or new direction |

An answer can use `understand -> verify`. A clear bounded change can use
`work -> verify`. An existing candidate can use `verify` only. A multi-step
request can use the full route. Re-evaluate readiness after every step because
new evidence can expose a missing decision.

The verification step does not repair its candidate. A failure returns a
finding to the work owner. The work step can run direct local checks, but it
does not certify its own output.

## Kaizen

```text
maintain-skill -> write-skill -> consumer acceptance

dojo -> consumer acceptance
```

Enter at the first unresolved contract:

| Step | Enter when | Skip when | Result |
| --- | --- | --- | --- |
| Maintain skill | A reusable library problem or opportunity is supported, but its disposition or owner is unclear. | The required package change is already known. | A resolved finding, conversion brief, or work request |
| Write skill | A new or changed package has a clear contract and source rights. | The exact candidate already exists. | A conforming skill package |
| Dojo | The current request explicitly names Dojo and supplies an exact candidate or saved context. | Dojo was not explicitly requested. | Skill-evaluation evidence and an adoption recommendation |
| Consumer acceptance | Adoption evidence is ready for the skill owner or next system. | The assignment already defines the adoption decision and authority. | Adopt, retain, reject, or revise |

Dojo is an optional side route, not a required Kaizen gate. Do not infer it from
a request to improve, test, verify, or adopt a skill. Dojo evidence can reveal a
new library finding and return to maintenance. Dojo does not edit or adopt the
source skill. Only the approved library owners can change it.

Consumer acceptance does not require a synchronous human checkpoint. A person,
skill, agent, or system can consume a result. Ask the accountable owner only
when value remains subjective, authority is missing, or the evidence exposes a
material tradeoff or irreversible effect.

A maintenance result can leave the Kaizen route. When it produces a clear
non-package work request, enter value delivery at `work`, then run `verify`.
Do not add `understand` or `plan` when the maintenance evidence already resolved
those contracts. A clear skill-package change can end after `write-skill` and
consumer acceptance. Use Dojo only after a separate explicit request.

## Altitude rule

Altitude is the first unresolved contract, not the size or prestige of a task.
Use the lowest step that can act without guessing. Move upward only when the
required facts, route, result, or evidence are missing.
