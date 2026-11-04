---
name: kata-verify
description: Verify one candidate result against its acceptance conditions with direct evidence. Use when a result exists and needs judgment; do not use to create, repair, or improve the result.
argument-hint: "[candidate result and acceptance conditions]"
metadata:
  schema: kata.skill/v1
  subject: general
  practice: verify
  object: candidate-result
  profile: bounded-execution
  authority: read-only
  consumes: [candidate-result, work-evidence, acceptance-contract, verification-request]
  produces: [verified-result, verified-change, verification-finding]
---

# Verify

**Outcome:** The acceptor or next consumer receives a supported verdict for one
candidate result.

**Done:** Each material acceptance condition has current evidence and a pass,
fail, or unknown result. The report does not repair the candidate or replace an
acceptor's unresolved business judgment.

## Assignment

The required inputs are one candidate result, its context, and the acceptance
conditions that matter to its consumer. Work evidence is optional and must
match the candidate's current state. Derive an obvious acceptance condition from
the request only when it does not change value, scope, cost, or authority. Ask
the accountable owner when those choices remain subjective or material.

Direct user authority or inherited caller authority permits read-only inspection
and the smallest direct checks of the candidate. Temporary isolated files that
a check requires are permitted when they do not change the target and are
removed after the check. Do not edit, repair, publish, approve, commit, or change
the candidate or its live state. A failed result returns to its work owner.

The skill verifies observable conditions. The next consumer can accept a result
when its contract permits this. Ask the accountable owner only for a material
value tradeoff or missing authority.

## Build the evidence set

1. Identify the candidate by path, version, state, date, or another stable
   identity. Reject evidence for a different state.
2. List the material acceptance conditions and the direct evidence for each.
3. Select checks that match the result type:
   - For an artifact, inspect its content, structure, rendering, and usability.
   - For research or a recommendation, check source quality, dates, reasoning,
     uncertainty, and support for the conclusion.
   - For an operation, observe final state, scope, failure handling, and recovery.
   - For software, run relevant behavior, tests, static checks, and risk checks.
   - For a skill, use the dedicated Dojo route when behavior or efficiency must
     be tested across controlled cases.
4. Run focused checks before broad checks. Do not use a passing indirect check
   as proof of a direct acceptance condition.
5. Record unavailable checks and the exact limit. Do not turn missing evidence
   into a pass.

For software verification, load only the focused method that the acceptance
condition needs:

- [references/benchmark.md](references/benchmark.md) for a measured performance
  claim;
- [references/blast-radius.md](references/blast-radius.md) for effects outside
  the visible change;
- [references/adversarial-review.md](references/adversarial-review.md) when the
  user asks to challenge, stress test, or interrogate a change; and
- [references/comment-review.md](references/comment-review.md) when comment or
  suppression quality is an acceptance condition.

These methods can create temporary isolated proof files. Remove them after the
check. A retained test, harness repair, comment edit, or production fix belongs
to a work assignment, not verification.

## Return the verdict

Return one status:

- **Pass:** Every material condition has sufficient current evidence.
- **Fail:** At least one material condition is proven false.
- **Unknown:** A required condition lacks reliable evidence.
- **Blocked:** The check needs authority, access, or an accountable decision
  that is not available.

Produce `verified-change` only for a passing local mutation that is ready for a
Git consumer. Other passing results produce `verified-result`. A failure or
unknown produces `verification-finding` for the work owner.

Report the candidate identity, conditions, checks, evidence, status, missing
evidence, and the next owner. Do not claim acceptance unless the consumer
contract or an acceptance record supports it.
