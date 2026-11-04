---
name: kata-blast-radius
description: "Find what a change could break outside its visible diff and prove its key safety fact by running real code. Use for 'blast radius of X', 'what could this break', or a focused review of one change; use kata-review-pr for a complete pull-request readiness review."
metadata:
  schema: kata.skill/v1
  subject: software-engineering
  practice: analyze
  object: change-set
  profile: bounded-execution
  authority: local-write
  consumes: [change-set, change-intent]
  produces: [blast-radius-report, verified-change]
---

# Blast radius

**Outcome:** The change owner receives a focused impact report with one key
safety fact proved by execution or marked unproven.

**Done:** Confirmed and cleared risks have evidence, the key fact has the
strongest practical proof, temporary work is cleaned up, and any retained proof
change passes its focused check.

## Assignment

The required inputs are one scoped change, its intended result, and the target
repository. Direct user authority or inherited caller authority permits
read-only impact analysis and the smallest local script or test needed to prove
one safety fact. Keep proof work isolated when it does not belong in the
product. Do not change production behavior, stage, commit, push, publish, or
change remote state. Ask when the intended result or retained-proof scope is
unclear.

Find what a change breaks somewhere else, before it ships. Use for "blast radius of X", "what could this break", or reviewing a small diff you don't trust yet.

Listing the callers is not the job. The agent can grep those in a second. The job is the breakage grep won't show you.

## Don't trust your own writeup

A blast-radius writeup that sounds right is worthless. It reads as convincing whether or not it's true. So don't hand back the writeup. Find the one or two facts the whole thing depends on and prove them by running code.

### How sure are you

For each fact the change's safety depends on, get it as far down this list as is cheap, and say where it stopped.

1. You said so. Worthless on its own.
2. You pointed at the line. A real `file:line`, or the library's own source.
3. You showed the bad case can't happen. You walked the failure step by step and it doesn't reach.
4. You ran it. A script or test that calls the real code and fails loud if you're wrong.
5. You reproduced it in the running app.

Step 4 is usually one small script that imports the same library the app ships and calls the exact function you're worried about.

## Steps

1. Read the change, its commits, and its pull-request description when present. Identify the symbols it adds, changes, and deletes, and what it now does differently, including the part the diff does not spell out.
2. Find the one fact it's safe because of. Most changes that look risky are safe because of a single fact, like "this call only drops already-dead cache entries and does nothing else". Find that fact. If it holds, most risky cases are cleared at once. Spend your time here, not on a long list of maybes.
3. Look where grep stops. Read the source of the library you call, and check its pinned version and any local patch. Work out when things run: microtasks, unmount and teardown, Solid versus React. Follow what a symbol search misses: the JSON an API returns, a DB column, a wire format, another language reading the same bytes, a feature flag, code three hops downstream.
4. Be honest about each risk. Give it a real chance of happening and a real cost if it does. Keep the risks you confirmed. List the ones you checked and cleared separately. Cite a real `file:line`; a search that finds nothing is still an answer. Never make up a caller or an API.
5. Prove the one fact. Write a script or test that runs the real code, run it, and paste what happened.
6. For a big or wide change, use independent reviewers only when the user requests parallel review. Give them the same scope and merge their evidence. Otherwise, inspect each risk angle in sequence.

## Verify and report

- **What it does.** What changed, including the part that isn't obvious.
- **The one fact it's safe because of.** State it, say which step you got it to, and show the proof. If you couldn't prove it, write unproven.
- **Risks.** Each names how it breaks, the `file:line`, how likely and how bad, and how to check. Paste the proof for the ones that matter.
- **Cleared.** What you checked and why it's fine.
- **Before you merge.** The cheapest test or repro that catches the real bug, including the script you wrote.

Produce `verified-change` only when an in-scope proof script or test remains in
the repository and its focused check passes. A report with temporary proof work
produces only `blast-radius-report`.

Use plain language, cite real code, and strip anything private before it goes anywhere public.

**Reply:** the writeup above, with the one safety fact either proven or marked unproven.
