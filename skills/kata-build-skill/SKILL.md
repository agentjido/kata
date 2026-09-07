---
name: kata-build-skill
description: Create or revise an original agent skill from a real task, with focused instructions, useful support files, and validation. Use when the user wants to build a skill from scratch or improve one they own; do not use to copy an external skill.
---

# Build Skill

**Outcome:** A valid, focused skill package with an observable outcome, complete
resources, and evidence from proportionate checks.

Build the smallest complete skill that makes a repeated task more reliable. Work
in the requested skill repository. Read its active instructions and preserve
unrelated changes. Resolve the destination and skill name from context; ask only
when they remain unclear.

## Shape the behavior

Start from the real request or failure that created the need. Define:

- the outcome the skill must produce;
- the requests that should and should not select it;
- the decisions, safeguards, and stopping conditions that are not obvious;
- the evidence that will show the skill worked.

Write one clear outcome near the start of the new skill. It must name the result
or state that the skill produces and how the agent knows the work is complete.
An activity or procedure is not an outcome.

Use the frontmatter description as a selection pointer. State the skill's job and
one distinct trigger for each request branch; remove trigger synonyms.

End each required step with a checkable condition that covers all relevant items
or checks.

Assume the agent already has general reasoning and coding ability. Do not add
generic advice, long fixed procedures, or speculative edge cases. Narrow a broad
idea before writing. Do not turn one temporary preference into a universal rule.

## Build the package

Use a short, action-based, lowercase name with hyphens. Create the matching
directory and `SKILL.md` with standard `name` and `description` frontmatter.
Keep the main instructions focused and host-neutral unless the user requests a
specific host.

Add only resources with a clear job:

- scripts for repeated work that benefits from deterministic execution;
- references for substantial detail needed only in some cases;
- assets that belong in generated output;
- interface metadata required by the target package.

Keep common steps in `SKILL.md`; put branch-specific detail in references. Keep
each rule in one place, and remove instructions that do not change normal agent
behavior.

Follow the repository's package, documentation, attribution, and naming rules.
When revising a skill, preserve supported metadata and inspect resource callers
before removal. Do not install, publish, or release the skill unless requested.

## Verify and report

Validate frontmatter, directory names, links, and referenced files. Run each new
or changed script with representative input. When practical, run one realistic
skill request in a temporary workspace and inspect the result. Static validation
does not prove behavior.

Report the created or changed files, checks, untested behavior, and any decision
the user still needs to make. Keep design notes outside `SKILL.md`.
