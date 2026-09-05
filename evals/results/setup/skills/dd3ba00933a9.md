---
name: kata-setup
description: Set up Docs Kata in a project. Create docs/inbox and docs/AGENTS.md, inspect existing documentation, and move unprocessed documents into the inbox without losing content or breaking known consumers. Use when the user requests Kata setup or adoption of the Docs Kata structure.
---

# Kata Setup

Establish a place to collect, check, and maintain project knowledge. This skill
sets up the structure and collects existing documents. It does not rewrite or
classify their contents as part of setup.

## Inspect first

1. Resolve the target project from the user's request. In a workspace with
   several repositories, select the requested root; do not traverse all
   repositories by default. Ask only if the target cannot be determined.
2. Read applicable project instructions, the root README, and existing docs
   instructions. Inspect Git status when available. Preserve local edits.
3. List existing documentation in `docs/`, `doc/`, `guides/`, and other
   documentation locations shown by the project. Search for links and build
   configuration that use these paths. Include document assets in the inventory.
4. Read `templates/docs-agents.md` beside this skill. Use it as the standard
   for the target `docs/AGENTS.md`. Adapt project-specific details only when
   supported by the inspected files or the user's request.

## Set the move scope

- Keep root entry points and required files in place: README, AGENTS.md,
  CLAUDE.md, license notices, changelogs, contribution and security policies.
  Keep nested agent instruction files in place and preserve their scope.
- Exclude source files, tests, fixtures, dependencies, generated docs, vendored
  references, installed skills, and separate repositories. Do not follow
  symbolic links outside the target project.
- Collect existing prose documentation and its supporting assets. A file's
  extension alone is not proof that it is documentation.
- On first setup, include existing documents in the proposed final category
  folders. Their location does not prove that they have been reviewed.
- On later runs, read the existing Docs Kata rules, index, and intake log.
  Leave `docs/inbox/` and already processed documents in place. If the prior
  setup state is unclear, preserve the affected documents and report them.
- Keep documents required at fixed paths by a build, website, external link,
  or package consumer in place unless the same change can preserve that use.
  Record these as exceptions for later review. Do not break a published URL
  merely to empty a documentation folder.

Show a short inventory and the intended moves before making them. The request
to set up Docs Kata authorizes routine moves within this scope. Ask only about
an unresolved conflict that affects content, behavior, or required paths.
Continue with independent files while that conflict remains unresolved.

## Create the structure

Create these paths when absent:

```text
docs/
  AGENTS.md
  README.md
  inbox/
    README.md
```

- For a new `docs/AGENTS.md`, use the bundled template. If one exists, preserve
  its rules and merge a `## Docs Kata` section. Do not silently replace a
  conflicting rule. Reuse that section on later runs instead of appending it.
- Make `docs/README.md` the documentation index. Preserve an existing index's
  useful text and links, updating paths as needed. Link to the rules, inbox,
  and any existing processed documents. Do not list nonexistent files.
- Make `docs/inbox/README.md` the intake log. Preserve existing content and add
  a table with original path, inbox path, intake date, and status. Also record
  exceptions and their reasons. Do not add duplicate entries on later runs.
- Add a link to `docs/README.md` in the project README if no equivalent link
  exists. Preserve the rest of the README.
- Create category folders only when documents are processed into them. Setup
  must not create empty collections of plans or specifications.

## Collect existing documents

1. Build an explicit source-to-destination map. Preserve each source path
   relative to the project root below `docs/inbox/`. For example,
   `guides/auth.md` becomes `docs/inbox/guides/auth.md`, and
   `docs/design/cache.md` becomes `docs/inbox/docs/design/cache.md`.
2. Reserve setup files and instruction files before building the map. Never
   include the inbox itself, or move a directory into its own descendant.
   Move individual inventoried files, not an unfiltered directory tree.
3. Check destinations before moving. Never overwrite a file. For a collision,
   choose a free suffix such as `auth-2.md` and record the actual destination.
   Do not discard either file, even if they appear identical.
4. Record a content hash before each move. Move the current on-disk file,
   including any local edits, and verify its contents at the destination.
   Do not restore files from Git or stage changes automatically.
5. Update affected relative links in moved documents and known referring
   files. Resolve links from each file's old and new locations, including
   image paths, fragments, and reference-style links. Preserve external URLs.
   Keep content edits limited to these path repairs.
6. Check any documentation build paths affected by the move. If a required
   consumer cannot be preserved, leave that document in place and log why.
7. Record each completed move in the intake log. If interrupted, reconcile
   the source and destination files before resuming; do not repeat moves or
   delete either copy when their contents differ.

## Verify and report

- Confirm that the three setup files exist and agree on the Docs Kata rules.
- Reconcile the inventory: each document is moved, retained, or explicitly
  unresolved. Check that assets and local edits are accounted for.
- Check local links touched by the moves and inspect the diff. Run an existing
  docs check when available and appropriate; do not install new tooling.
- Check that repeating setup would not move processed docs, duplicate log
  entries, replace instructions, or add duplicate index links.
- Report the target root, created files, move count, exceptions, and checks.
  State that inbox contents await review. Do not claim that setup has verified
  the documents against the implementation.
