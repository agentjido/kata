# Initial Jido commands

This file is the routing source for the initial `$jido` skill. Check explicit
commands before inferred routes. Do not add aliases during execution.

| Command | Trigger | Non-trigger | Primary Kata | Default authority |
| --- | --- | --- | --- | --- |
| `status` | Report local or remote Git workbench state for one repository or a folder of repositories. | Application health, service health, or progress on a non-Git task. | `../kata-status-report/SKILL.md` | `read-only` |
| `investigate` | Explain how an existing system works, where behavior is implemented, or why repository evidence supports a conclusion. | A request that authorizes a fix or asks for a durable implementation plan. | `../kata-neckbeard/SKILL.md` | `read-only` |
| `plan` | Create, revise, deepen, or break down a multi-step plan. | Exploratory discussion with no request for a plan artifact. | `../kata-plan/SKILL.md` | `local-write` |
| `work` | Execute a supplied plan or a clear build request and verify the result. | Open-ended diagnosis, an unclear product decision, or a report-only request. | `../kata-work/SKILL.md` | `local-write` |
| `help` | List the implemented Jido commands and examples. | A request to perform project work. | None | `read-only` |

## Inference order

When there is no explicit command, use this order:

1. Select `status` for a Git workbench status request.
2. Select `plan` for an explicit request to create or deepen a plan.
3. Select `investigate` for a read-only question about existing system behavior.
4. Select `work` for an explicit plan path or a clear implementation request.
5. Otherwise, use `base-loop`.

User constraints always apply. For example, "investigate and fix" does not fit
the read-only `investigate` route. It uses `base-loop` until a stable fix Kata
exists, unless the user explicitly selects `work` with a clear implementation
target.

## Examples

```text
$jido status this repository
$jido investigate where retry limits are enforced
$jido plan the migration in docs/requirements.md
$jido work docs/plans/migrate-storage.md
$jido help
```
