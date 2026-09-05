---
name: kata-verify
description: Check implemented behavior against the intended result and report evidence. Use when the user requests verification, acceptance checks, or confirmation that a change works.
---

# Verify

Use evidence to determine whether the result meets the target.

## Method

1. Read the request, acceptance conditions, applicable instructions, and current diff. Identify what changed since any earlier checks.
2. Map each important acceptance condition to a useful check. Use project commands and existing tests where possible.
3. Check the normal case and the failure or boundary cases that matter. Use the running application when the behavior requires it and the available tools permit it.
4. Run only checks within the authorized scope. Record the command or action, the observed result, and the code state it applies to.
5. Distinguish a passed check, a failed check, and a check that could not run. State what each result establishes and what remains unknown.
6. If a failure is within an authorized fix task, correct it and repeat affected checks. Otherwise, report the defect and the next action.

## Result

Report whether the acceptance conditions are met. Include the important evidence and any unverified conditions. Keep a durable record only when the project needs one.

## Constraints

- Static inspection does not establish that runtime behavior works.
- A passing test does not prove behavior that the test does not check.
- Do not weaken tests or change the intended result to obtain a pass.
- Respect an explicit request to skip tests. State the resulting verification limit.
