---
name: kata-shipit
description: "Finish a verified Git change through the exact delivery boundary the user requests: create a scoped local commit, push and open or update a pull request, monitor requested checks, or land an approved change. Preserve unrelated work and require explicit authority for each remote or merge action."
metadata:
  kata-argument-hint: "[commit|ship|open-pr|update-pr|watch|land] [scope or PR]"
  schema: kata.skill/v1
  subject: software-engineering
  practice: deliver
  object: git-change
  profile: coordination
  authority: external-write
  consumes: "verified-change, delivery-request, git-repository"
  produces: "git-commit, pull-request, shipped-change"
---

# Ship It

**Outcome:** The requested verified change reaches the exact Git delivery state
the operator selected, with its identity, evidence, and remaining work clear.

**Done:** The scoped change is either committed locally, published in one
identified pull request, monitored to the requested stop condition, or merged
under explicit authority. Required checks apply to the exact delivered state,
and unrelated work remains unchanged.

## Assignment and authority

The required inputs are one Git repository, one verified change, its scope, and
a delivery request. Verification must apply to the exact source state that will
be delivered. This skill does not implement or repair the change. A failed or
stale check returns to the work owner.

The request sets the highest permitted route:

- **Commit:** “commit,” “save this commit,” or equivalent permits one or more
  local commits only. It does not permit a push or pull request.
- **Ship:** “ship it,” “push this,” “open a PR,” or equivalent permits scoped
  commits, a normal push, and creation or update of one pull request.
- **Watch:** “watch,” “monitor,” “babysit,” or “wait for CI” permits observation
  and requested in-scope CI or review follow-up. It does not permit a merge
  unless the request also says to land or merge.
- **Land:** “land,” “merge,” or equivalent permits the named merge after its
  gates pass. It does not permit a force push, review dismissal, or check bypass
  unless the operator grants that exact authority.
- **Bare invocation:** A bare `kata-shipit` with no delivery outcome permits
  inspection only. Report the available delivery states and ask which one is
  wanted.

Authority can narrow during the run and never expands by implication. Do not
amend, rebase, reset, force push, delete a branch, remove a worktree, close a
pull request, dismiss a review, bypass a hook, or bypass a required check
without explicit authority for that exact action.

## Route the delivery

1. Read the repository instructions and resolve the Git root.
2. Record the current branch, `HEAD`, upstream, remote, worktree status, staged
   diff, unstaged diff, untracked files, recent commits, and relevant pull
   request state.
3. Identify the accepted change and its verification evidence. Stop when the
   intended files cannot be separated from unrelated staged or unstaged work.
4. Select the smallest route that reaches the requested delivery state:
   - local commit;
   - push and pull request;
   - watch an existing pull request; or
   - land an approved pull request.
5. State the route, target repository, branch, base branch, included paths, and
   highest authorized action before the first mutation.

Every probe is a snapshot. Re-check branch, `HEAD`, remote, pull request, and
required-check state immediately before the consequential action that uses it.
A failed remote query means remote state is unknown. It never means that no
pull request, review, or check exists.

## Prepare the exact change

Read [references/local-commit.md](references/local-commit.md) when the route
needs a new commit.

Before any commit or push:

- confirm that verification applies to the current source state;
- run only a required missing check that does not change scope;
- inspect the diff for unrelated content, generated noise, credentials, tokens,
  personal data, and access-bearing URLs;
- preserve existing user staging and all unrelated files; and
- stop when a required check fails or the scope cannot be isolated.

Do not hide a failed check in the pull request description. Do not weaken a
hook, assertion, or branch rule to make delivery pass.

## Publish a pull request

Read [references/pull-request.md](references/pull-request.md) when the selected
route includes a push, pull request, or pull request description update.

If the current branch is the default branch and the Ship route has work to
publish, create a feature branch before committing or pushing. Check for local
commits not present on the remote base. Ask whether to carry them when their
ownership is unclear. Do not push directly to the default branch.

Use the repository forge's supported CLI. For GitHub, prefer `gh`. Before a
normal push, confirm the live branch and push `HEAD` without force. Before
creating a pull request, query again for an existing open pull request from the
same repository owner and branch. Update that pull request when the request
permits it; do not create a duplicate.

## Watch or land

Read [references/land.md](references/land.md) when the request includes Watch or
Land.

Watching is complete at the user's requested stop condition: all required
checks finish, a failure needs work, review needs a decision, or a defined time
or iteration limit is reached. Stay quiet while state is unchanged unless the
user asked for periodic updates.

Landing requires current evidence that the intended pull request is mergeable,
required checks pass, required approvals exist, and no unresolved blocking
review remains. Use the requested merge strategy or ask when the repository
permits several materially different strategies. Re-check the merged state.
Leave branch and worktree cleanup to a separate explicit request.

## Report

Report:

- route and highest authority used;
- commit hashes and subjects created by this run;
- included paths and preserved unrelated state;
- verification evidence and its source identity;
- push target and pull request URL, when published;
- check and review state, when watched;
- merge identity and observed final state, when landed; and
- blockers, skipped actions, and the next owner.

Do not say “shipped” when the requested delivery state was not reached. A local
commit, an open pull request, and a merged change are different results.
