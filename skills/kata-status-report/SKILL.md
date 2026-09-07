---
name: kata-status-report
description: Give a short local and remote Git workbench report for one repository or a folder of active projects. Use before new work or repository cleanup; do not use for application health.
---

# Kata Status Report

Show the smallest useful view of the workbench. Report only. Do not change files,
branches, worktrees, or remote items. One fetch without pruning is permitted.

## Find the active roots

Start with local Git commands:

- Use `git rev-parse --show-toplevel` to find the current root.
- Use `git worktree list --porcelain` to find its linked worktrees.
- If the target is a folder of projects, use its workspace configuration when
  available. Otherwise, check its direct child directories with
  `git -C <path> rev-parse --show-toplevel`.

Inspect each Git root once. Do not search all nested directories. Exclude
repositories stored as dependencies, fixtures, generated output, or references
unless the user includes them.

## Check what needs a decision

Use `git status --short --branch`, `git worktree list`, and `git branch -vv` as
the core local checks. For each active repository, find:

- dirty or unfinished worktrees;
- current branch sync with its upstream;
- local branches that are unmerged, unpushed, or have no valid upstream.

Fetch the primary remote once when available. Check the Git provider only for
open pull requests authored by the current user, review requests for that user,
pull requests for local branches, and issues assigned to that user. Do not count
all upstream issues, pull requests, or remote branches. If access is unavailable,
mark remote status as unknown and continue. Do not retry the same failed check.

Do not run tests, builds, or history analysis.

## Show the result

Skip the preamble. If everything is clean, use one sentence. Use a table only
when two or more projects or worktrees need comparison:

`Project | Local | Sync | Open work`

Use one row per project. Group its worktrees in that row. Do not add a row for
each clean worktree. Keep local cleanliness separate from remote work.

Aim for this scale:

```text
Workbench needs attention.

| Project | Local | Sync | Open work |
| --- | --- | --- | --- |
| api | 1 dirty worktree | behind 2 | 1 unpushed branch |

- feature worktree: 3 untracked files

Next: review the untracked files.
```

After the table, use at most three short bullets for dirty paths, branches that
need a decision, or relevant remote items. Include links for remote items. End
with one `Next:` line that names the most useful cleanup action. Do not perform
that action unless the user requests it.
