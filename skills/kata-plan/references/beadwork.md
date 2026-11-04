# Beadwork plan integration

Use Beadwork automatically for a Durable repository plan only when the command
exists and the target repository is already initialized. Never initialize
Beadwork from this skill.

## Detect Beadwork

After the Git root is known, run these read-only checks:

1. Resolve `bw` with `command -v bw`.
2. Run `bw -C <git-root> list --all --json`.

Set `BEADWORK_MODE=active` only when both checks succeed. A missing command,
nonzero probe, invalid repository, permission error, or corrupt state sets
`BEADWORK_MODE=plan-only`. Record the exact reason. Do not run `bw init`, repair,
upgrade, sync, import, or another tracker as a fallback.

When active, run `bw -C <git-root> prime` and read the current workflow context.
Inspect existing issues with `bw -C <git-root> list --all --json` to avoid a
duplicate epic or task graph.

Detection grants authority only to create the epic, child tasks, descriptions,
and dependency edges required by this plan. Do not start, close, delete, sync,
push, assign, or reprioritize issues unless the user asks.

## Prepare the plan

The plan remains the source of truth. Use its existing requirements, key
technical decisions, stable U-IDs, implementation units, verification contract,
and definition of done. Do not create a second plan template.

Before ticket creation, make sure every implementation unit has:

- one primary outcome;
- explicit dependencies that represent real blockers;
- exact repository-relative paths or bounded path patterns;
- a direct implementation procedure;
- observable acceptance criteria;
- exact verification commands and expected results;
- forbidden scope when scope growth is likely;
- an integration or branch-base rule when it depends on another unit.

For source imports or migrations, also require exact source asset counts,
dispositions, and old-to-current API or behavior mappings.

Split a unit when it combines independent outcomes, unrelated runtime owners,
separate verification command families, or a decision that must be resolved
first. Independent siblings must not depend on each other only to impose order.

Add or update these parts of the plan in its native Markdown or HTML format:

- a dependency graph whose arrows mean blocker to blocked;
- a ticket register that maps each U-ID to a provisional ticket key;
- the branch or integration rule for each unit.

## Create the graph

Read [the ticket contract](beadwork-ticket-contract.md) before creation. Create
one root epic and one child task for each implementation unit. Use a nested epic
only when a named phase has several children and needs a real ownership boundary.

Use these command forms:

```text
bw -C <git-root> create "<directive title>" --type epic --description "<epic body>" --silent
bw -C <git-root> create "<directive title>" --type task --parent <epic-id> --description "<ticket body>" --silent
bw -C <git-root> update <ticket-id> --description "<ticket body with real IDs>"
bw -C <git-root> dep add <blocker-id> blocks <blocked-id>
```

Pass multiline descriptions as data through the host's safe argument mechanism.
When using a shell, write each body to a temporary file, read it into a quoted
variable, and pass that quoted variable as one `--description` argument. Never
use `eval` or concatenate issue text into an executable shell string.

Use two passes:

1. Create the epic and all child tasks with provisional dependency keys. Record
   every returned ID.
2. Update each task body with real IDs, then add dependency edges.

The epic body links the plan path and states the goal, non-goals, and definition
of done. Each task body follows the ticket contract and points to its U-ID.

If any creation or update fails, stop further mutation. Keep the plan accurate,
report the successful IDs and failed command, and do not delete partial issues
without explicit approval.

## Verify and update the plan

Run:

```text
bw -C <git-root> show <epic-id> --json
bw -C <git-root> list --parent <epic-id> --json
bw -C <git-root> ready --json
```

Read every created task back with `bw show <ticket-id> --json`. Confirm:

- every plan unit has one task and every task has one plan unit;
- titles are directive and each task has one outcome;
- descriptions contain exact files, acceptance criteria, verification, and scope;
- every dependency edge matches the plan and no cycle exists;
- independent siblings have no hidden branch dependency;
- every multi-parent task says how blocker outputs combine;
- at least one leaf is ready when implementation can start.

Replace provisional keys in the plan ticket register and graph with real IDs.
Set their plan state to `Created`. Run a final plan-to-graph consistency check;
do not rerun general document review only because IDs changed.

Report the plan path, epic ID, ready tasks, created task count, important
assumptions, and any partial-creation blocker.
