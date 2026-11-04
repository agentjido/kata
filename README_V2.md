# Jido-Kata Skills V2

Status: Incremental implementation. The initial `skills/jido` dispatcher
implements `status`, `investigate`, `plan`, `work`, and `help`. The remaining
design stays a proposal until its success criteria pass.

## Purpose

Jido-Kata is a personal engineering skill system for coding agents. It gives the
user one front door, a library of focused work procedures, and a controlled way
to improve those procedures from real evidence.

`$jido` is the front door:

```text
$jido [optional command] <goal>
```

Jido selects and performs Kata. Dojo develops and proves them.

This use of Jido is wider than the Jido Elixir SDK. The SDK is a runtime for
Elixir agents. The `$jido` skill is the operator for this engineering skill
library. A `jido-sdk` lens supplies SDK-specific knowledge when the work needs
it.

## Vocabulary

Use each term for one purpose.

| Term | Definition |
| --- | --- |
| **Jido** | The user-facing dispatcher and operating policy. |
| **Kata** | One reusable procedure for a class of work. |
| **Dojo** | The process and tools that create, test, compare, and promote Kata. |
| **Command** | A stable word in the `$jido` user interface. |
| **Principle** | A focused decision rule that can affect several Kata. |
| **Lens** | Domain knowledge that adapts a Kata to a language, framework, package, or product. |
| **Tool** | Deterministic code used by a Kata, such as a script or CLI. |
| **Evidence** | A test result, trace, fixture, report, or artifact that proves a claim. |

A command is not a Kata. A command is part of the user interface. A Kata is the
procedure behind the command. One command can select from several Kata.

For example, `$jido review` can select a change-review Kata, a pull-request
review Kata, or an adversarial-review Kata. The target and the user's request
decide the route.

## System model

```text
User goal
   |
   v
 $jido
   |
   |-- select one primary Kata
   |-- add applicable lenses
   |-- apply relevant principles
   |-- run tools
   `-- collect evidence
              |
              v
            Result

 $dojo ---- tests and improves ----> Kata library
```

Jido owns routing and execution policy. A Kata owns the procedure. A lens owns
domain facts. A principle owns one decision rule. Dojo owns library change and
promotion.

## Design rules

### One front door

`$jido` is the normal entry point for non-trivial work. The user can give it a
natural-language goal or pin a command.

The skill runs only when the user explicitly invokes it. It does not become a
permanent repository rule and does not activate itself from task text alone.

Direct leaf skills remain available during the transition. They are expert
entry points and compatibility paths, not the main interface.

V2 does not require a separate `$kata` router. A future direct form such as
`$jido kata <name>` can expose the Kata catalog if real use shows a need.

### Fresh routing

Jido routes each invocation from the current goal. It does not silently keep a
previous route after the user's goal changes.

`$jido resume` is the explicit way to reconstruct and continue prior work.
`$jido status` reports state without continuing it.

An explicit command has priority over inferred intent. An explicit authority
limit, such as "do not change code," has priority over the command.

### One primary Kata

Each task has one primary Kata. Jido can add lenses, principles, and tools, but
it does not combine several complete workflows unless the selected Kata defines
that composition.

This rule keeps ownership clear. It also prevents a task from accumulating a
long chain of skills with conflicting procedures.

### Progressive loading

The Jido entry file contains only:

- the routing contract;
- the command index;
- the authority rules;
- the base loop; and
- the rules for loading Kata, lenses, and principles.

Jido reads only the selected Kata and applicable support files. It does not load
the full catalog or all principles for every task.

### Evidence before claims

Jido does not accept a success statement as proof. The selected Kata defines
the completion predicate and the required evidence.

When evidence is missing, the result is incomplete, uncertain, or blocked. It
is not successful.

### Authority stays explicit

A route declares one authority level:

| Level | Allowed work |
| --- | --- |
| `read-only` | Inspect and report. Do not change project or remote state. |
| `local-write` | Change local files and run local checks inside the requested scope. |
| `remote-write` | Change remote state only after explicit user authority. |

Authority to fix code does not imply authority to push, open a pull request,
merge, deploy, send a message, or update a ticket.

When route selection is uncertain and the options have different authority,
Jido selects the lower-authority route or asks one decision question.

### Host independence

Kata describe capabilities, outcomes, and evidence. They do not require one
tool name, model slug, chat storage path, worktree layout, or agent API.

The host selects the available terminal, file, browser, subagent, and task
tools. Missing optional host features must not make an otherwise valid Kata
unusable.

## `$jido` interface

The basic syntax is:

```text
$jido [command] [goal]
```

Examples:

```text
$jido users receive two notifications after a retry
$jido investigate the worker memory growth without changing code
$jido plan the Ash migration
$jido fix the duplicate webhook delivery
$jido review this branch
$jido verify the CSV export through the real command
$jido resume the migration work from this branch
```

If the first word is a stable command, Jido uses that command. Otherwise Jido
infers the route from the complete goal.

Before substantial work, Jido reports one short route line:

```text
Route: fix | Lenses: Elixir, Phoenix | Authority: local-write
```

The route line is a report, not a request for confirmation. Jido asks a question
only when a missing user decision can materially change the result or the
authorized scope.

### Initial command set

Start V2 with a small public vocabulary.

| Command | User intent | Default authority |
| --- | --- | --- |
| `investigate` | Explain, diagnose, or compare without making a project change. | `read-only` |
| `plan` | Produce a durable plan for multi-step work. | `local-write` |
| `work` | Execute a clear plan or concrete request and verify it. | `local-write` |
| `fix` | Reproduce, trace, correct, and verify a defect. | `local-write` |
| `review` | Review a change, branch, pull request, or design. | `read-only` |
| `verify` | Prove behavior through the real user or system path. | `read-only` unless a requested verification artifact needs a local write |
| `status` | Report repository or task state. | `read-only` |
| `resume` | Reconstruct prior state and continue the same goal. | Inherited from the resumed work, but never above the user's current authority |
| `help` | Show stable commands and short examples. | `read-only` |

Do not add a command only because a source skill has a name. Add a command when
users need a stable word for a distinct intent.

Possible later commands include `refactor`, `prototype`, `ship`, and `pause`.
Real tasks must prove that each command needs its own public route.

### Route selection

Each route record contains:

```yaml
command: fix
kata: bug-fix
authority: local-write
output: verified-change
lenses:
  - elixir
  - phoenix
principles:
  - fix-root-causes
  - prove-it-works
```

The command index is the single source for stable commands, aliases, route
targets, default authority, and maturity. Do not repeat the routing table in
several files.

If no stable Kata matches, Jido uses the base loop. It does not pretend that an
undefined procedure is a stable Kata.

## Base loop

The base loop handles useful work before a specialized Kata exists.

1. Restate the goal and the problem in concrete terms.
2. Inspect the current condition.
3. Select the smallest useful action inside the user's authority.
4. Perform that action.
5. Verify the result with available evidence.
6. Report the result, uncertainty, and next useful action.

The base loop is a fallback, not a universal workflow. Repeated use for the same
kind of work is evidence that the library needs a candidate Kata.

When the result depends on a running Jidoka BEAM system, the base loop can use an
optional `jido` or `jidoka` CLI as an evidence source. The client is never a
required dependency. Jido must discover its contract before use and must require
explicit authority for runtime mutations.

Jido can report that opportunity. It must not create or change a Kata unless the
user requests a library change.

## Kata contract

Each Kata owns one class of work and uses the same contract.

```yaml
name: bug-fix
intent: Correct a reproducible defect.
authority: local-write
output: verified-change
completion: The original failing path passes after the change.
maturity: practiced
```

Each Kata must define these fields:

1. **Trigger**: The user intent that selects the Kata.
2. **Non-trigger**: Similar work that belongs to a different Kata.
3. **Authority**: The maximum state change the Kata permits by default.
4. **Outcome**: The result or artifact that the Kata produces.
5. **Procedure**: The ordered work that guides execution.
6. **Completion predicate**: The observable fact that proves completion.
7. **Failure behavior**: The conditions that require an incomplete, uncertain, or blocked result.
8. **Applicable lenses**: The domain references that can refine the procedure.
9. **Applicable principles**: The rules that can change a decision in this procedure.
10. **Maturity**: The evidence level that controls automatic routing.

A Kata must not require another separately installed skill. A bundled Jido
distribution can route to sibling packages, but it must verify that the target
exists and provide the base loop when it does not.

## Lenses

A lens changes domain knowledge, not the primary work procedure.

Use these lens classes:

```text
lenses/
  languages/
    elixir.md
  frameworks/
    phoenix.md
    ash.md
  products/
    jido-sdk.md
```

For example, the design-review Kata owns the review procedure. The Elixir lens
adds OTP and supervision rules. The Phoenix lens adds web-boundary rules. The
Ash lens adds resource, action, policy, and data-layer rules. The Jido SDK lens
adds Agent, Action, Signal, directive, and runtime contracts.

Multiple lenses can apply to one task. A lens does not become a top-level skill
only because it supports a new package.

Add a new Kata when the user job, authority, output, or completion predicate
changes. Add a new lens when the procedure stays the same and domain knowledge
changes.

## Principles

A principle is a focused decision rule. It is not a complete workflow.

Examples include:

- fix root causes;
- prove it works;
- enforce boundary discipline;
- subtract before adding; and
- test behavior, not implementation.

A Kata lists the principles that can affect it. Jido loads a principle only
when it can change a decision in the current task.

Do not copy the complete principle catalog into the Jido entry file. Do not
claim that a principle affected the work unless Jido loaded it and used it for a
specific choice.

An expert-access command such as `$jido principle prove-it-works` can remain a
later option. It is not part of the initial command set.

## Dojo

Dojo owns changes to the skill system. Project work and library work are
different scopes.

Dojo can:

- capture a repeated work pattern;
- draft a candidate Kata;
- import and attribute an external procedure;
- create fixtures and outcome checks;
- run controlled evaluations;
- compare a candidate with a fixed baseline;
- promote a proven candidate;
- revise or retire a failing Kata; and
- check the command and lens indexes for drift.

Dojo does not modify the library during ordinary `$jido` work. The user must
request the Dojo operation.

### Maturity lifecycle

```text
observed -> candidate -> practiced -> proven -> stable
```

| State | Meaning | Automatic Jido routing |
| --- | --- | --- |
| `observed` | A repeated pattern is visible in real work, but no procedure exists. | No |
| `candidate` | The procedure and its outcome contract exist. | No |
| `practiced` | The candidate succeeded on real tasks and recorded corrections. | Only when explicitly pinned |
| `proven` | Fixed evaluations show acceptable correctness and cost. | Yes, with a route report |
| `stable` | Repeated evidence supports default use and compatibility. | Yes |

A stable Kata can return to `practiced` or `candidate` when real work shows a
material failure. Maturity is an evidence claim, not a release label.

### Admission rules

Create a candidate Kata only when all these statements are true:

- A real task showed a missing capability.
- The user job is distinct from current Kata.
- The outcome fits in one sentence.
- The authority boundary is clear.
- The completion predicate can be checked.
- A command, lens, or principle cannot express the difference more accurately.

Promote a candidate only when:

- required outcome checks pass;
- evaluation inputs and the baseline are fixed;
- important side effects are covered;
- the candidate does not duplicate a stable Kata; and
- a human review accepts the remaining trade-offs.

## Library organization

Use five logical groups even while packages remain physically flat.

```text
Jido-Kata library
  routing/
  katas/
  lenses/
  principles/
  dojo/
```

The host can still require `skills/<name>/SKILL.md`. Logical ownership does not
require an immediate file move.

### Current-package mapping

The current packages can support V2 during the transition.

| V2 group | Current examples |
| --- | --- |
| Kata | `kata-plan`, `kata-work`, `kata-tdd`, `kata-review-pr`, `kata-blast-radius`, `kata-interrogate`, `kata-status-report`, `kata-recall`, `kata-sync-docs`, `kata-correct`, `kata-no-comments` |
| Specialist Kata or future lenses | `kata-ex-design-review`, `kata-ex-coverage`, `kata-ex-hunt-dead-code`, `kata-jido-action`, `kata-jido-agent`, `kata-jido-ai`, `kata-jido-testing` |
| Dojo operations | `kata-build-skill`, `kata-import-skill`, `kata-create-verification-skill`, and `dojo/` |
| Principles | The commands and references in `kata-principled` |
| Interaction helpers | `bro`, `in-your-own-words`, `ketchup`, `ketchup-video`, `sharpen`, and `unslop` |

Interaction helpers are optional modifiers and aliases. They are not primary
engineering routes. They can remain directly invokable while `$jido` develops.

## Naming rules

- Use `jido` for the dispatcher and its operating policy.
- Use a short verb for a stable command.
- Use a clear job name for a Kata, such as `bug-fix` or `design-review`.
- Use a domain name for a lens, such as `elixir`, `phoenix`, `ash`, or `jido-sdk`.
- Use an imperative decision name for a principle, such as `prove-it-works`.
- Use `dojo` for library creation, evaluation, comparison, and promotion.
- Use `jido-sdk` when a name refers specifically to the Elixir SDK.
- Do not add `jido-`, `kata-`, or `dojo-` to every internal file name.
- Keep compatibility names until a measured migration justifies a rename.

The plugin name, skill package name, and command name are separate concerns.
Do not repeat a namespace only to make a file look organized.

## Proposed repository structure

The first implementation keeps current leaf packages and adds thin entry
points.

```text
skills/
  jido/
    SKILL.md
    references/
      authority.md
      base-loop.md
      command-index.md
      routing.md

  dojo/
    SKILL.md
    references/
      kata-contract.md
      lifecycle.md
      promotion.md

  kata-plan/
  kata-work/
  kata-review-pr/
  kata-ex-design-review/
  ...
```

This structure gives `$jido` a useful route catalog without moving or rewriting
all current skills.

A later version can move stable content into a shared internal library:

```text
library/
  katas/
  lenses/
  principles/
  tools/
  evidence/
```

Do not make that move until routing data shows which current packages are true
Kata, lenses, principles, helpers, or duplicate procedures.

## Migration rules

1. Add `$jido` as a thin dispatcher before any package merge.
2. Route to current leaf packages by exact file and verified availability.
3. Keep direct leaf invocation during the transition.
4. Record route choices and failures in evaluation evidence, not in user project files.
5. Merge packages only when real routes show the same user intent and authority.
6. Convert package-specific knowledge into lenses only when the primary procedure stays the same.
7. Keep external license files and attribution when content moves.
8. Do not change installed global skills as part of the design migration unless the user requests it.
9. Do not remove a compatibility name until its replacement works in each supported host.
10. Make each migration step independently reversible and testable.

## Non-goals

V2 does not try to:

- replace the Jido Elixir SDK;
- make every current skill an internal Kata immediately;
- hide direct skill invocation;
- select a fixed model or reasoning level;
- require subagents;
- initialize project services without a request;
- make remote changes without explicit authority;
- create a Kata from every completed task; or
- import all available external skill collections.

## Decisions required before implementation

Resolve these questions before the first code change:

1. Which current leaf packages are safe for automatic routing in the first `$jido` version?
2. Does the first version need `$dojo`, or can existing authoring and evaluation entry points remain until routing works?
3. What single file format will hold the command index and maturity state?
4. Where will route evaluation fixtures live?
5. Which command aliases are necessary for the first user test?
6. Should `$jido work` remain a public command, or should Jido select `feature`, `fix`, or another narrower route?
7. What evidence is sufficient to move a Kata from `practiced` to `proven`?
8. Which supported hosts can resolve sibling skill packages reliably?

## V2 success criteria

The first implementation is successful when:

- one explicit `$jido` invocation selects the correct route for representative tasks;
- an explicit command overrides inference;
- a new goal cannot inherit a stale route;
- the route line reports Kata, lenses, and authority;
- only selected support files enter context;
- missing leaf packages fall back safely;
- remote actions still require explicit authority;
- direct current skill invocation still works;
- route checks cover ambiguous and unsupported requests; and
- the implementation adds no unproved automatic library changes.

Until these criteria pass, this document remains a proposal and the current
Kata catalog remains the active system.
