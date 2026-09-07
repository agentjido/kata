# Kata integration

These rules take precedence over integration steps in the other bundled files.
Keep their planning, implementation, evidence, and preservation requirements.

## Host and model

Use the active host, model, and reasoning level. Native execution is the default.
Select another model, external CLI worker, goal, or scheduled run only when the
user requests it. Use only tools available and permitted in the current host.
Honor authorization already given; do not ask again for an approved action or
settled decision. Keep required questions limited to unresolved decisions.

Use the target project's documentation paths and rules. CE configuration is
optional; absent configuration uses the bundled defaults. Read local lessons
from the project's documented location, including `docs/lessons/` in Docs Kata.

## Optional companion skills

`kata-work` is the packaged workflow. Other `ce-*` names refer to
optional companion skills. They are not installation requirements.
Do not install or create a missing companion to complete this task.

- Workspaces: use native Git operations when `ce-worktree` is absent. Preserve
  the workspace inventory, isolation, and file ownership rules.
- Simplification: if `ce-simplify-code` is absent, use the scoped simplification
  rules in `references/implementation-loop.md` within `kata-work`.
- Code review: if `ce-code-review` is absent, use a native review tool when
  available. Otherwise review the actual diff locally, resolve material findings,
  and record `Code review: local diff review (ce-code-review unavailable)`.
  This is a valid additional completion state for Kata's work and shipping gates.
  It does not claim an independent review or a CE review receipt.
- Delivery: use native Git and repository tools when commit or shipping skills
  are absent. Commit, push, PR creation, and issue creation follow the user's
  requested scope and existing authorization. If delivery was not requested,
  return the verified local changes and their check results.
- Other optional routes: state when a requested companion is unavailable. Keep
  the completed artifact and report that action separately; do not invent a
  result or block completion of the supported planning or implementation task.

Keep upstream protocol identifiers and script interfaces unchanged. Record only
actual tool results. A missing optional capability is never a successful receipt.
