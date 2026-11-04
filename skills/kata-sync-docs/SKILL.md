---
name: kata-sync-docs
description: Check repository documentation against current code and correct stale APIs, setup, examples, configuration, commands, and links. Use for a README refresh or wider docs-to-code sync.
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: synchronize
  object: repository-documentation
  profile: bounded-execution
  authority: local-write
  consumes: [repository, documentation-scope]
  produces: [verified-documentation-change]
---

# Sync Documentation to Code

**Outcome:** The selected documentation matches current repository behavior,
and unresolved product intent is clearly recorded instead of guessed.

**Done:** Every selected material claim has current evidence or an explicit
unresolved conflict, changed links and examples have proportionate checks, and
the final diff contains only the accepted documentation scope.

This skill checks and corrects current documents. Use `kata-setup` only to
create Docs Kata and collect unreviewed material.

## Set the scope

The required inputs are one repository and a selected document or documentation
scope. Direct user authority or inherited caller authority permits inspection
of repository evidence and edits to the selected documentation. Do not change
code, configuration, workflows, package state, or remote state. Ask when a
product decision is needed to choose the documented behavior.

Read active instructions, Git status, the documentation index, and the user's
requested files. A README request stays limited to the README and the source
files needed to verify it. A broader request can include guides, examples,
module docs, configuration, workflows, and public API references.

Inventory each selected document and its local links. Find the code,
configuration, tests, package metadata, or workflow that is authoritative for
each material claim. Preserve local edits and fixed-path consumers.

## Reconcile claims

Check names, signatures, options, defaults, errors, environment variables,
install steps, commands, telemetry, examples, badges, links, package status,
and support statements.

Use current code and tests as evidence for implemented behavior. Use an
approved decision or specification as evidence for intended behavior. When
they conflict, state the conflict. Do not silently change code to match docs,
and do not present intent as implemented behavior.

Edit only the selected documentation. Keep useful structure and voice. Remove
unsupported claims. Make runnable examples match current APIs. Mark an example
as illustrative when it cannot run by itself. Preserve attribution, license
notices, and published paths.

Repair relative links and references after a move or rename. Do not change a
public URL or required path without proof that its consumers still work.

## Verify

Check all changed local links. Run the narrowest command that proves an example
or documented command. Use existing docs checks when present. Do not install a
new tool only to check a documentation edit.

Review the final diff for unrelated rewrites. Report files checked, drift
fixed, commands run, illustrative examples, and unresolved conflicts.
