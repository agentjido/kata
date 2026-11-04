# Library contract

Resolve this contract for every skill that enters the library. The final skill
can combine fields when their meaning stays explicit. Omit only fields marked
conditional. Do not create empty sections to display the contract.

## 1. Outcome contract

| Field | Required value |
| --- | --- |
| Result | The artifact, decision, or state the skill produces. |
| Consumer | The person, agent, skill, or system that uses the result next. |
| Done | One observable skill-level completion condition. |
| Intent | A non-obvious purpose, only when it changes the approach. |

Every route must end in a result, required question, routed action, or explicit
blocker.

## 2. Activation contract

| Field | Required value |
| --- | --- |
| Name | The target library's stable package name. |
| Description | The distinctive result or mechanism and one deciding condition for each real branch. |
| Adjacent non-trigger | A boundary when a nearby skill can receive the same words but owns another result. Conditional. |
| Deliberate use | A direct-use path when automatic routing is unavailable. |

## 3. Work contract

| Field | Required value |
| --- | --- |
| Context | Prerequisites, constraints, and facts that are not safe or cheap to derive. |
| Protocol | Falsifiable fields, gates, order, counts, scope, evidence, coverage, failure, and handoff rules. |
| Judgment | Valid choices left to the executor, plus only demonstrated guidance. |
| Capability | Specialist knowledge and methods needed to judge the work. |
| Failure direction | The safe result when a required input, capability, permission, or check is unavailable. |

## 4. Authority contract

A read-only, single-step skill can state a read-only boundary. A consequential
skill must define this authority envelope:

| Field | Required value |
| --- | --- |
| Source | Direct user authority or inherited caller authority. |
| Target | The files, system, account, or state in scope. |
| Permitted actions | Action classes allowed without another decision. |
| Exclusions | Destructive, external, costly, or scope-expanding actions outside the envelope. |
| Confirmation | The condition that requires the accountable owner or operator. |

Active system, organization, project, and user limits remain in force. Inherited
authority can narrow but cannot broaden. A live instruction can narrow or revoke
the envelope.

## 5. Responsibility contract

Name a role only when its authority or relationship affects the result:

| Role | Responsibility |
| --- | --- |
| Operator | Starts and interacts with the work. |
| Coordinator | Selects the skill, assigns work, and integrates delegated results. |
| Executor | Performs the assignment inside the authority envelope. |
| Accountable owner | Owns the larger result and grants authority. |
| Acceptor | Decides whether the result meets the assignment. |
| Verifier | Checks evidence within assigned authority. |
| Maintainer | Owns later changes to the reusable skill. |

One participant can hold several roles. A resource is not an actor. Delegation
transfers bounded execution responsibility. It does not transfer integration or
acceptance responsibility unless the assignment says so.

## 6. Assignment contract

The skill defines supported work and maximum boundaries. Each invocation
supplies the actual assignment:

| Field | Required value |
| --- | --- |
| Objective and scope | The result requested now and its boundaries. |
| Output and acceptance | The required artifact and evidence. |
| Granted authority | The active envelope for this invocation. |
| Time horizon | The deadline and how far ahead decisions must account for effects. |
| Resources | Available tools, context, budget, and dependencies. |
| Review | Review points, verifier, and acceptor. |
| Escalation | The condition and recipient for a question, handoff, or stop. |

The skill states required inputs and safe defaults. It cannot grant itself
authority. Infer a missing value only when the choice is safe, reversible, and
does not materially change scope, cost, or authority.

## 7. Faceted metadata contract

| Dimension | Required value |
| --- | --- |
| Schema | `kata.skill/v1`. |
| Subject | The knowledge domain needed to judge the result. |
| Practice | The kind of work performed. |
| Object | The primary thing examined or changed. |
| Profile | `bounded-execution`, `coordination`, `system-design`, or `direction`. |
| Authority | The normal action class: `read-only`, `local-write`, `external-write`, or `destructive`. This value does not grant permission. |
| Consumes | A list of stable input-type identifiers. |
| Produces | A list of stable output-type identifiers. |
| Execution profile | Model, tools, memory, budget, and review frequency supported by evidence. Conditional. |

The assignment selects the profile:

- `bounded-execution` produces one result inside known scope and acceptance
  conditions.
- `coordination` integrates several bounded assignments.
- `system-design` defines reusable structures, contracts, or operating rules.
- `direction` sets objectives and constraints across future assignments.

These profiles are not ranks. One skill can support more than one profile when
it states the deciding condition. Runtime, job title, model name, and agent count
do not select a profile.

Use lowercase hyphenated identifiers for subject, practice, object, inputs, and
outputs. Tools can derive workflow candidates where one skill's output matches
another skill's input. Matching metadata identifies an overlap candidate, not a
duplicate; compare the outcome, activation, authority, and next consumer before
changing ownership.

## 8. Information contract

Keep the outcome, required protocol, load-bearing route, authority envelope, and
done condition inline. Put substantial conditional or late material behind a
pointer that states when to read it. Keep each rule in one authoritative place.

## 9. Verification contract

| Layer | Required evidence |
| --- | --- |
| Mechanical | Frontmatter, names, paths, links, stable fields, scripts, licenses, packaging, and taxonomy metadata that apply. |
| Behavioral | Targeted checks for changed activation, execution, authority, restraint, or consumer behavior. Conditional on change risk. |
| Completion | Exact results, untested behavior, and blockers. |

Verification must be proportionate to the skill's reach, mutation risk, and
contract change. A passing mechanical check does not prove behavior.
