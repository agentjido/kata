---
name: kata-setup
description: Set up Docs Kata in a project. Create docs/inbox and docs/AGENTS.md, inspect existing documentation, and move unprocessed documents into the inbox without losing content or breaking known consumers. Use when the user requests Kata setup or adoption of Docs Kata.
metadata: {optimized_for: "codex/gpt-5.6-sol/medium"}
---

# Kata Setup

Collect documentation for review. Do not rewrite, classify, or claim to verify its content.

## Inspect first

- Resolve the project root. Ask if it is unclear. Read applicable instructions, Git status, the root README, documentation indexes, intake records, Docs Kata rules, and `templates/docs-agents.md` beside this skill. Preserve local edits.
- Inventory documents and assets. Find relative links and fixed consumers such as builds, sites, URLs, and packages. A file type or category directory does not show that content was reviewed.
- Protect root entry points, policies, licenses, changelogs, and all agent instruction files. Exclude source, tests, fixtures, dependencies, generated or vendored content, installed skills, separate repositories, and symlinks that leave the project.
- For first setup, select unprocessed category documents. For a repeat, preserve inbox files and processed documents. Keep and report items with unclear state.
- Show the inventory, proposed moves, and fixed-path exceptions. Ask only when an instruction, content, path, or behavior conflict is unresolved.

## Set up and collect

1. Create missing `docs/AGENTS.md`, `docs/README.md`, and `docs/inbox/README.md`. Use the template for new instructions. Preserve existing instructions and merge one reusable `## Docs Kata` section.
2. Preserve index content. Link the documentation index to the rules, inbox, and processed documents. Add the index link to the root README only when missing. Create category directories only during processing.
3. Preserve intake provenance. For each completed move, record the original project-relative path, actual destination, date, status, and exceptions.
4. Move each selected file below `docs/inbox/` and retain its project-relative path. Reserve setup and instruction files. Exclude the inbox. Never move a directory into itself or a descendant.
5. Check each destination. Never overwrite or discard a copy, even when content is identical. On collision, use an unused suffix and record the actual destination.
6. Hash each current source before the move so local edits are included. Verify destination content before link repair. Do not restore from Git or stage changes.
7. Repair only relative links affected by moves. Check moved files and files that refer to them, including assets, fragments, and reference-style links. Do not change external URLs. Keep fixed consumers in place unless they remain valid after a move.
8. Record only completed moves. On interruption or repeat, reconcile sources, destinations, hashes, and intake records. Preserve different copies. Do not duplicate moves, sections, records, or links.

## Verify and report

Check setup files, inventory, assets, local edits, relative links, fixed consumers, and the diff. Run an existing documentation check without installing tools. Report the root, created files, move count, exceptions, unresolved items, and checks. State that inbox content awaits review.
