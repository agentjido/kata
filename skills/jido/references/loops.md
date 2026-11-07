# Jido work system

Jido uses three internal routes. These names explain the system; they are not
words that the human must use.

## Value delivery

```text
understand -> idea? -> roadmap? -> scope? -> plan? -> delegate? -> work -> verify -> consumer acceptance
```

Each skill is one transition. Enter at the first unresolved contract:

| Step | Enter when | Skip when | Result |
| --- | --- | --- | --- |
| Understand | The current condition, problem, cause, or limit lacks support. | Supplied evidence bounds the problem and current state. | `understood-context` or `work-brief` |
| Idea | The problem is understood, but the desired behavior, product direction, scope, or success signal needs an accountable decision. | What to build and why are already clear. | `idea-brief` or `product-contract` |
| Roadmap | The destination is clear, but dependent decisions must be resolved across several review cycles or agent sessions before implementation planning. | The route is clear enough for one planning session, or a completed roadmap already supplies the decisions. | `decision-roadmap` and, when complete, `planning-request` |
| Scope | The outcome is clear, but the delivery boundary, exclusions, dependencies, or completion evidence remain unresolved. | The work request already defines target, boundary, acceptance, and authority. | `work-brief` or `scoped-work` |
| Plan | A software target is clear, but the technical route has material decisions or dependent steps. | The request is non-software, or target, scope, acceptance, and action are already clear. | `implementation-plan` |
| Delegate | Defined work benefits from separate ownership, parallel progress, or supervised follow-through. | One worker can perform the work directly, or no assignment is requested. | `work-assignment`, `returned-result`, or `integration-handoff` |
| Work | The target, scope, acceptance conditions, and authority are resolved. | A candidate result already exists. | `candidate-result` and `work-evidence` |
| Verify | A candidate result exists and its acceptance needs evidence. | Current matching evidence already proves each material condition. | `verified-result`, `verified-change`, or `verification-finding` |
| Consumer acceptance | Evidence is ready for the result's next consumer. | The assignment or downstream contract already defines acceptance. | Acceptance, rejection, or new direction |

An answer can use `understand -> verify`. A vague long-horizon request can use
`idea -> roadmap -> scope -> plan`. A clear bounded change can use
`work -> verify`. A defined assignment can use `delegate -> verify`. An
existing candidate can use `verify` only. Scope and delegation are optional;
do not add them when the supplied work contract and single-worker route are
already clear. Re-evaluate readiness after every step because new evidence can
expose a missing decision.

A failed verification returns to its work owner and then to verification. Jido
retains responsibility across the handoff until the requested outcome is
supported or a stated limit prevents further authorized progress. A request
for an answer, review, or plan ends at that result. It does not authorize
implementation.

## Leadership learning

```text
tutor -> optional work handoff -> learner reflection
```

Use `kata-tutor` when the human asks to learn, practise, or receive coaching on
leading agent work. The tutor can prepare an understood work brief but does not
start execution. If the human also asks to perform the work, leave tutoring and
enter value delivery at the first unresolved contract. After a result returns,
resume tutoring only when the learner wants feedback or reflection. Never make
tutoring a condition for normal value delivery.

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

For an authorized maintenance fix, a conversion brief is an intermediate
result. Continue through writing and the required checks. A feedback-only or
report-only request ends at its requested brief or finding.

## Altitude rule

Altitude is the first unresolved contract, not the size or prestige of a task.
Use the lowest step that can act without guessing. Move upward only when the
required facts, route, result, or evidence are missing.

## Local procedure selection

`commands.md` is the included step registry. Select the loop step and its
primary Kata before you consider a local skill. Consider a host-exposed local
skill only when:

- the request explicitly names a local, private, or team procedure; or
- the selected primary Kata defines the kind of work but does not supply the
  domain method needed for the result.

Use only skills that the host exposes as available in the current session. The
host owns installation, project discovery, and its trust controls. Do not scan
the filesystem, construct a skill path from task data, or load a package that
is absent from the host skill catalog.

Use the exposed name, description, classification metadata, and source path to
select a candidate. Prefer an explicitly named local procedure. Otherwise,
select a local skill only when its declared result and domain supply the method
that the primary Kata lacks. If two candidates remain and the difference can
change the result, authority, or risk, ask one question. Do not use a local
skill only because its name shares words with the request.

Reject a local skill that uses an included package name. Resolve the selected
host-supplied path, including symbolic links, and verify that the file exists
and its frontmatter name matches the exposed package name. Read its `SKILL.md`
in full before use. If identity or availability cannot be verified, use the
primary Kata when it can do the work; otherwise use `base-loop.md`.

Use the local skill as the procedure under the selected loop step. The actual
authority is the intersection of the request, context rules, Jido, and the
selected skill. Local selection does not authorize scripts, remote writes,
destructive actions, credentials, or other actions outside that intersection.
The local skill cannot change the route or replace Jido responsibility for
handoffs, re-evaluation, and final integration. Report its name and local
source in the route's `Procedure` line and in the final evidence.
