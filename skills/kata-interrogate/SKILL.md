---
name: kata-interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Adversaries try to break a change or design, and only findings proven by a run survive."
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: adversarial-review
  object: change-set
  profile: coordination
  authority: local-write
  consumes: [change-set, design-intent]
  produces: [verified-findings]
---

# Interrogate

Adversaries try to break a change or a design. A finding survives only when a run proves it. Report the findings. Do not apply fixes.

**Outcome:** An adversarial report that contains only failures proven against
the scoped change or design.

**Done:** Each surviving finding has a reproducible command and observed wrong
result, every unproved claim is dropped, independence limits are stated, and the
primary workspace remains unchanged.

## Assignment

The required inputs are one change or design, its intended result, and the
target repository. Direct user authority or inherited caller authority permits
read-only inspection of the primary workspace and local isolated worktrees,
reproduction files, and checks needed to prove findings. Adversaries inherit
only that scope. Do not edit the primary change, apply fixes, stage, commit,
push, or change remote state.

## Frame

The scope is what the user names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree. Restate the intent in plain words from the user's message, the commits, and the pull-request description. Ask the user when the intent is unclear.

## Fan out

When the user requests parallel or multi-agent review, run three independent adversaries. Give each one an isolated worktree that includes the scoped uncommitted changes. Give every adversary the scope, the intent, and this brief:

> Break this change. Prove each finding with a run against the real code, such as a failing test, a repro script, or command output that shows the wrong behavior. For a design or plan, run a prototype or probe the current tree. Keep repros in your own worktree. Report each finding with a title, the exact command, the output it printed, and the output the intent requires. Leave out anything you did not run. That covers style, naming, structure, and risks that need a future change to matter. No findings is a valid result.

## Verify

If the user did not request delegation, or independent workers are unavailable, play three adversarial angles inline in turn and state that the result is not independent.

Rerun the proof command for each finding in the primary workspace when it is safe to do so. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause. Independent adversaries can find different failures, so keep every verified finding instead of selecting one review.

## Output

- **Intent**: the restatement.
- **Findings**: for each verified finding, the command, its output, how it breaks the intent, and the adversaries that found it. Say "no verified findings" when none survive.
- **Dropped**: for each adversary, the count of dropped findings and why.
