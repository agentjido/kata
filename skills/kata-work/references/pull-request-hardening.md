# Pull Request Hardening

Use this route only when the user identifies a pull request and asks to fix,
repair, or harden it. A request to review a pull request is read-only and does
not enter this route.

## Establish authority and state

The hardening request authorizes focused code and test edits for the pull
request. It does not by itself authorize a push, label change, submitted
review, merge, history rewrite, or change to the base branch.

Read active repository instructions. Record the current checkout, dirty files,
branch, upstream, and worktrees. Preserve all user work. Do not switch a dirty
checkout or include an unrelated file in a commit.

Read the pull request metadata, base and head revisions, changed files, checks,
reviews, comments, merge state, and existing findings with the available
code-host tool or CLI. If remote data is unavailable, continue only with work
that the local branch and supplied findings can prove.

Use the existing writable head branch when it is safe. Otherwise, use an
isolated worktree or stop with the exact write limitation. Never edit the base
branch for this route.

## Fix the blockers

Create one list of confirmed blocking findings. For each finding:

1. Confirm that its cited code still matches the finding.
2. Make the smallest correction that fixes the behavior.
3. Add or strengthen a regression test at the lowest reliable layer.
4. Run the focused test and record its result.

Do not apply a finding that needs a product or architecture decision. Record it
as unresolved. Do not broaden the pull request with cleanup that is not needed
for correctness, security, tests, CI, or merge readiness.

After focused checks pass, run the repository's documented validation. Recheck
the diff against the pull request goal and confirm that unrelated user files
are absent.

## Finish within the authorized boundary

Local hardening is complete when confirmed blockers are fixed, regression
tests pass, repository validation passes, and unresolved items are listed.

Commit only files owned by the hardening request. Use the repository's commit
rules. Push only when the user or active project workflow authorizes it. After
a push, read the resulting CI state. Do not report merge readiness while CI is
failing or pending, the branch conflicts with the base, or a blocking finding
remains.

Do not merge the pull request. Do not change review-state labels unless the
user or active project rules explicitly require that external change.

Report fixed findings, tests, validation, commit and push state, CI and merge
state, unresolved blockers, and the next required action.
