# Repository issue backend support

Status: Queued

Last reviewed: 2026-11-04

## Goal

Give every issue-producing Kata one repository issue-storage contract at:

```text
docs/agents/issues.md
```

The contract selects exactly one backend. A skill must not create a second
issue store because another CLI or remote happens to be available.

## Backends

| Backend | Interface | Gate |
| --- | --- | --- |
| Beadwork | `bw` | Command exists and the repository is already initialized. |
| CSV | Standards-compliant CSV reader and writer | Repository-relative path and one active writer. |
| GitHub Issues | `gh` only | Command exists, repository identity and access are clear, guidance is complete, and remote writes are authorized. |
| Jira Issues | `twg` only | Command exists, site or workspace and project guidance are clear, tested commands are recorded, and remote writes are authorized. |

Do not substitute a connector, browser, direct HTTP client, or different Jira
CLI for `gh` or `twg`. If a command, access check, or guidance field is missing,
do not use that backend and do not guess.

At the 2026-11-04 local check, `gh` was available and `twg` was not on `PATH`.
No remote write was tested. Jira command guidance must wait for an available
`twg` installation or user-supplied tested guidance.

## Repository contract

Define one short Markdown schema for backend, location, CLI, authority,
relationship rules, labels or issue types, command guidance, and last check.
Keep credentials and access-bearing URLs outside the file.

When an existing repository has more than one issue store, require the owner to
select the authoritative one. Migration or synchronization is separate work.

## Work units

1. **Contract:** Finalize `docs/agents/issues.md` and add a safe setup or update
   path that preserves existing repository instructions.
2. **GitHub adapter:** Use `gh` for issue create, read, edit, comment, close,
   claim, relationship, and frontier operations. Use `gh api` only when a
   required GitHub operation has no stable high-level command.
3. **Jira adapter:** After `twg` is available, record and check the exact read,
   create, update, relationship, assignment, transition, and query commands.
   Keep Jira-specific guidance in the repository contract.
4. **Retrofit:** Apply the shared contract to `kata-roadmap`, the `kata-plan`
   issue-graph adapter, `kata-ex-quality` issue mirroring, and later issue or
   triage packages. Keep each skill's outcome and authority boundary separate.
5. **Verification:** Check absent CLI, failed access, missing guidance, unclear
   repository identity, read-only authority, duplicate issue prevention,
   partial writes, dependency direction, and correct frontier calculation for
   each backend.

## Done

- Every issue-producing Kata reads the same repository contract.
- One repository has one authoritative issue store.
- GitHub operations use only `gh`.
- Jira operations use only `twg` and stored tested guidance.
- A missing CLI, access failure, or unclear configuration stops that backend.
- Local and remote backends preserve stable Kata IDs and map them to backend
  IDs without changing the owning skill's work contract.
