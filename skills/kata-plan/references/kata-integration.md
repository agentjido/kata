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

`kata-plan` is the packaged workflow. Other `ce-*` names refer to
optional companion skills. They are not installation requirements.
Do not install or create a missing companion to complete this task.

- Planning: perform the bundled research, composition, confidence check, and
  final checks. If `ce-doc-review` is absent, use the existing `skill_unreachable`
  result and state that the separate review did not run. Offer only available
  follow-up actions. Keep implementation outside the planning task.
- Other optional routes: state when a requested companion is unavailable. Keep
  the completed artifact and report that action separately; do not invent a
  result or block completion of the supported planning or implementation task.

Keep upstream protocol identifiers and script interfaces unchanged. Record only
actual tool results. A missing optional capability is never a successful receipt.
