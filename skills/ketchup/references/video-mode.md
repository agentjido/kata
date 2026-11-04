# Video mode

Read this file only when the user explicitly asks for a video catch-up.

Use the verified changes and action items from the main Ketchup workflow. Show
what happened in a short subtitled slide video instead of a prose summary.
Writing and rendering the video outside the target repository is the only
allowed state change.

The reply has one opening sentence, the embedded video, one line that names
work the agent can still do, and the action items. When the video shows a
decision's options, use the same option names in the action items. If the render
fails, state the blocker in one line and give only the decisions.

## Slides

Use the screenshots, recordings, diffs, and data the work produced. Do not use
the chat's prose as visual evidence. Before you draw, write the one sentence the
user should remember and one line for each slide. Do not put these notes in the
reply. Remove a slide when it does not change what the user knows. Use no more
than 10 slides, and use fewer when possible.

Each slide makes one point. Build the slides on one picture and change it from
slide to slide when possible. Do not cut to an unrelated picture without a
reason. A color or shape must have the same meaning on every slide.

Show the work in pictures. Examples include how a system works, a pull-request
stack with each current state, a before-and-after view, or options side by side.
Use arrows, highlights, and motion to point at changes. Do not use a slide as a
bullet list, status list, table, or set of boxes with no connections.

Keep text short. Put each label on the item that it names. Use words that the
user would say. Do not caption what a picture already shows. Do not repeat one
fact across slides or in the text below the video.

Show the result of each item that the user requested. State whether it is done,
running, failed, or not checked. Do not show an item as done when it still waits
for the user. Show a defect found and corrected during the work. If a visible
change has no screenshot, state this on its slide and name the screen change.
Use only verified facts. Do not invent a number or draw a screen that was not
captured.

## Subtitles

Give each slide one short subtitle line of about 10 words. State the slide's
point in the same words that you would use when you speak to the user. Use only
facts shown by that slide.

Put the subtitle in a strip below the slide. Use the same strip height on every
slide. Keep the strip empty except for the subtitle. The strip must not cover
the slide. Use text that stays readable when the video plays at chat size.

## Render

Render one silent landscape video, such as an MP4 file, with motion between
slides. Each frame contains the full slide above its subtitle strip. Make the
frames from the slides. Do not record a screen. Burn each subtitle into all
frames for its slide.

Hold each complete slide long enough to read its new words. Use at least one
second for each three new words. New words include the subtitle and words that
were not present on the previous slide. A changed label counts as new words.
All words on the first slide count. Words inside a screenshot do not count.
The hold time does not include motion into or out of the slide.

## Verify the render

Before you embed the video, inspect the rendered file. View one frame from each
slide at chat size. Confirm that each subtitle is readable and covers nothing.

Measure each hold by matching the file's frames to the slide. Do not use a
still-frame detector because it can count the faint ends of a fade as a full
hold. Count each slide's new words and compare them with its measured hold.

Correct any slide that is not readable in its hold time. Render and inspect the
video again. Embed it only after all frame, subtitle, and timing checks pass.
