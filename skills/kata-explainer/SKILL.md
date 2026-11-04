---
name: kata-explainer
description: Produce or revise one evidence-based technical explainer video through a selected production stage. Use when the durable result is a video project, reviewed preview, or explicitly requested render; use kata-showme for a small conversational visual and kata-technical-writing for a script-only document.
metadata:
  schema: kata.skill/v1
  subject: technical-communication
  practice: produce
  object: explainer-video
  profile: bounded-execution
  authority: local-write
  consumes: "explainer-request, source-material, visual-style-profile, visual-template"
  produces: "explainer-project, production-records, video-review, rendered-video"
---

# Explainer

**Outcome:** The user receives the requested stage of one accurate technical
explainer video in its target workspace.

**Done:** The requested production stage is complete, the production records
match the current project, important claims have source evidence, applicable
stage checks pass, and no unrequested render, paid call, upload, or publication
occurred.

## Assignment

The required inputs are an explainer request, a target workspace or output
location, a topic, and enough source material to check important claims. Resolve
the audience, main idea, target duration, requested production stage, source
boundary, visual style, and acceptance evidence before substantial scene work.
Infer a missing choice only when it is safe, reversible, and does not change
scope, cost, or authority.

This skill owns a durable explainer-video result. Use `kata-showme` when the
user needs one small diagram, visual answer, or focused HTML artifact. Use
`kata-technical-writing` when the selected result is only a script or another
technical document.

Direct user authority or inherited caller authority permits local writes to the
named video project and its production records. It does not permit a paid
narration call, a new paid service, publication, upload, remote write, or final
render. Get explicit authority before each such action. An explicit request to
render or export permits one local final render to the resolved output path. Do
not put rendered media, generated audio, build output, or dependencies in this
skill package.

## Select the production stage

Enter at the first stage needed by the request. Preserve valid work from earlier
stages.

- **Written package:** Produce or revise the source lock, brief, script, and
  storyboard. Do not generate narration, implement scenes, or render media.
- **Preview:** Complete the written package, narration when authorized, scene
  implementation, local build checks, and visual review. Do not create a final
  media file.
- **Render:** Start from a reviewed preview. Render only after an explicit
  render or export request. Verify the complete media file.
- **Revision:** Change only the affected records, narration, scenes, and review
  evidence. Do not treat evidence from an earlier script or timeline as current.

If the request names only a topic and does not identify a stage, produce the
written package and stop for editorial acceptance before narration or scene
implementation.

## Select the visual style

Active target instructions remain in force. Within those instructions, use this
order:

1. Use the visual-style profile or template that the user names.
2. Otherwise, use the style profile selected by the target project.
3. Otherwise, read and use
   [references/default-visual-style.md](references/default-visual-style.md).

A style source can be a Markdown profile, a template project, or a stable set of
components. Treat it as read-only reference unless the assignment permits a
copy or the target supplies an established scaffold command. Record the style
source, version or revision when present, and local substitutions in the
production records. Do not silently combine profiles or make an old video
depend on mutable files from another video project.

## Lock sources and records

Use primary sources for technical claims. Record the source repository or
document set, exact branch or tag, commit or revision when available, local
change state, access date, direct source locations, product version, and release
status. Check each important behavior claim against code or another primary
source as well as explanatory text when both exist. State an evidence gap
instead of inventing a claim.

Use the target project's established production records. When it has no
equivalent, create these records before substantial scene work:

- `PROMPT.md`: exact user prompts that changed the production request, plus the
  current interpreted request. Exclude hidden instructions, tool output, and
  secrets.
- `BRIEF.md`: topic, audience, main idea, duration, style source, production
  stage, and acceptance boundary.
- `SCRIPT.md`: final narration by scene and measured scene times when audio
  exists.
- `STORYBOARD.md`: layout, reveal order, camera or transition behavior, and
  visible text by scene.
- `SOURCES.md`: the source lock and claim checks.
- `REVIEW.md`: checks, direct evidence, current status, and known limits.
- `TEMPLATE.md`: the project scaffold and style-profile version or revision.

Do not replace one video's records, script, narration, or scenes with another
video's work. Use one project for one topic, script, source lock, narration, and
timeline. Keep alternate formats of that same video in the project.

## Produce the requested stage

1. Read the target instructions and inspect its current project, template,
   worktree, and generated-output rules. Preserve unrelated work.
2. Resolve the production stage, style source, source lock, project location,
   review location, and final-media location. Use the target's scaffold when it
   has one. Do not copy a sibling project as an implicit template.
3. Write or update the production records. Give the video one main idea. Make
   the problem, mental model, mechanism, example, limits, and closing model
   agree when that sequence fits the topic.
4. For narration, scene implementation, preview, or render work, read and follow
   [references/production-and-review.md](references/production-and-review.md).
5. Update the review record with evidence from the current script, narration,
   timeline, build, and media only. Mark every skipped or blocked check.

Stop with the completed earlier stage when editorial acceptance, source access,
a style decision, a paid call, credentials, or render authority is missing.
Keep valid completed work intact and name the next required decision.

## Report

Report the completed stage, project and output paths, style source, source lock,
files changed, checks and results, skipped checks, known limits, and the next
review or authority gate. Do not call a written package preview-ready, call a
preview rendered, or call a render published.
