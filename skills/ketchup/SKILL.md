---
name: ketchup
description: "Use only when the user explicitly asks to catch up on what changed in this chat. Return a plain text catch-up by default; when the user explicitly asks for video, render a short subtitled slide video and keep waiting decisions in text."
metadata:
  schema: kata.skill/v1
  subject: general
  practice: summarize
  object: conversation-state
  profile: coordination
  authority: local-write
  consumes: [conversation-history, work-state, media-evidence]
  produces: [decision-ready-catch-up, catch-up-video, decision-list]
---

# Ketchup

**Outcome:** The user receives a plain-language catch-up that explains what
changed and every decision or action that still belongs to them. An explicit
video request returns the catch-up as a short subtitled slide video and keeps
the waiting decisions in text.

**Done:** Each material change has current evidence, each waiting item has
enough context for a decision, and unknowns are explicit. In video mode, the
render also passes frame, subtitle, and timing checks.

## Assignment

The required inputs are the current conversation and the state of work that
this conversation touched. Video mode also uses available media evidence.
Direct user authority permits read-only local and remote inspection needed to
verify that state. An explicit video request also permits local rendering
outside the target repository. Do not change project files, start work, post
messages, or update remote items. Ask only when the requested catch-up range
cannot be resolved safely. If video rendering is unavailable, return the
decision list and the explicit render blocker.

Catch the user up on what changed in this chat since the last message they wrote before invoking this skill, and help them understand each change, not only where it stands. Then lay out every call waiting on them so they can make it from your reply alone. Notifications and delegated-worker results are not their messages. Assume the user remembers their last message and nothing after it.

Use plain words, short sentences, and no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each pull request, branch, or worker by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.

## Select the output mode

Use text mode unless the user explicitly asks for a video catch-up. For video
mode, gather and verify the same information, then read and follow
[references/video-mode.md](references/video-mode.md). The video replaces the
prose summary. The waiting decisions stay in text so the user can act without
searching the video.

## Gather what changed

Keep the target work read-only. Do not change code, start an app or a job, or post anything. In video mode, local render artifacts outside the target repository are the only allowed state change. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.

An action item is a call or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one line and no visual.

One call can cover many items, such as each PR in a set awaiting merge. For each item, collect its link, what it changes for users, the evidence behind your pick, its risk, and your pick. Write "unknown" for a fact the call needs that you do not know. Leave out a link you do not have.

## Write the text reply

Spend words on the calls, not on the story. Keep what happened under 100 words, not counting pictures, and shorter when less happened. Leave out work that changed nothing for the user. Give each item about 30 words. The reply grows with the number of items: two items need well under 150 words in all, not counting pictures, and thirty need far more. Never cut items or shrink them to stay under a word count: no count in place of a list, and no link in place of an item. A link can add depth, but the reply alone must be enough to decide.

Open with one short sentence that names what waits on the user, or says nothing does. The action items give the detail. If nothing happened and nothing waits on the user, say so and stop.

Then show what happened, pictures first. Embed inline the screenshots and videos the work produced, then any diagram that explains a change. Then sum up in one short bullet per thing the user asked for: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each line must stay true when read alone. Never mark something done that still waits on the user, and leave out anything the action items say. Under the summary, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.

Then list the action items. Ask the call the user owns, such as merge, approve, or pick, and give your pick. A step you would take first goes in your pick. So does anything that must happen first, and anything that cannot be undone. Give the number or link of each PR, issue, or agent a call is about, also in a call between options.

Fit the shape to the call. A call about one item is one bullet: the call, your pick, what it changes for users, the evidence behind your pick, and its risk, with the item named once. When items share a call, write the call and your pick once, then give each item its own bullet, riskiest first: its link and name, what it changes for users, the evidence behind your pick, and its risk. Name an item's pick only where it differs from the call's. Give each item's risk even when it is low, such as "Low risk: only the colors change." Say what waiting costs only when it is more than a delay, such as a deadline or lost data.

For a call between options, give every option the work weighed, each with what it gets the user and what it costs, and the current state when there is one. Those costs are the call's risk, so add no separate risk line. When the screenshots above show the options, write each option's gain and cost under its screenshot.

## Visuals

A visual is a picture: a screenshot, a video, a Mermaid diagram, a chart or diagram from the host's charting or plotting tool, or a generated image. A Markdown table is not a visual, even with before and after columns.

When something is easier to grasp as a picture than as sentences, draw it: how a design or system works, a PR stack or dependency chain with each PR's state, a before and after of a fix, or options side by side. Never draw a status list, a list of action items, or boxes with nothing connecting them. Never give a fact twice, in text or across visuals.

Keep each visual small enough to read at a glance: at most six boxes, with at most eight words in each. Write labels as plain words a person would say, not tags like "Tests: pass". A fact that needs a sentence belongs in the text, or nowhere.

Embed screenshots and videos inline when the change is visible and the host can render them. Otherwise link the saved file. If a visible change has none, mark its summary line "No screenshot yet," and say there what changed on screen. Draw diagrams and charts from facts you have: a Mermaid diagram for how things connect and a chart from the host's charting or plotting tool for numbers. Never invent a number, and never draw or generate a picture of a screen you did not capture. Link only artifacts that exist.

## Verify

Check each status and number against its source. Confirm that the reply contains
every user-owned decision, contains no action that the agent can still take,
and does not repeat one fact in both text and a visual. In video mode, also
apply every check in the video-mode reference before you embed the result.
