# Default dark spatial-board visual style

Profile ID: `dark-spatial-board/v1`

Use this profile when the assignment and target project do not select another
visual style. Scale pixel values in proportion when the assignment requires a
different frame size.

## Canvas and palette

- Canvas: 1920 by 1080 at 30 frames per second.
- Background: `#0a0a0a` with a quiet dot grid.
- Surface: `#121212`.
- Elevated surface: `#1a1a1a`.
- Main text: `#e8e8e8`.
- Muted text: `#666666`.
- Border: `#292929`.
- Primary action and success: green `#00ff88`.
- Input, data, and coordination: cyan `#00ccff`.
- Effects, observation, and caution: yellow `#ffb700`.
- Failure, warning, and hard boundaries: red `#eb7f7f`.

Use color to show meaning. Do not use color only as decoration.

## Type and safe areas

Use IBM Plex Mono for headings, labels, explanation text, code, and exact API
names. Use weight 700 for titles and key labels. Use weight 400 for supporting
text. Use local licensed font files so a render does not depend on a network
font. If the target cannot supply IBM Plex Mono, use its established monospace
font and record the substitution.

Keep important content at least 110 pixels from the left and right edges and 90
pixels from the top. Keep the center 150 pixels at the bottom clear when the
video uses captions. Use at least 84 pixels for the main title and at least 32
pixels for important supporting text.

Keep each frame focused on one main idea. Use short visible text. Put detail in
the narration.

## Visual model

Use one large spatial board when the topic has a connected flow. Move the
camera across the board to show detail, and then return to the complete model.
Use loose hand-drawn paths and shapes. Keep camera movement smooth and easy to
follow.

Use brand slots instead of fixed brand text:

- Opening brand: the assignment's brand and product name.
- Main top-left label: `BRAND · PRODUCT NAME`.
- Main bottom-left mark: the assignment's site or brand mark, when supplied.
- Main top-right cue: the current chapter for about 1.5 seconds after a chapter
  change, then fade it out.
- Main bottom-center: a clear caption area.
- Main bottom-right: no persistent chrome.

For a Jido video, use `JIDO · PRODUCT NAME` and `jido.run` for these slots.
Keep persistent chrome inside a 72-pixel safe inset. Use 18 to 22 pixel chrome
text at 1920 by 1080. Keep chrome quieter than the main diagram. Do not show
camera state, route text, frame numbers, or other production data.

## Opening, body, and closing

Use a 2 to 3 second opening. Show one brand line, one clear title, and at most
one short supporting line. Do not show diagrams, cards, code, badges, chapter
cues, or persistent chrome. Reveal the title first. Reveal the supporting line
only after the title is stable.

During the explanation, spread visual reveals across the narration. Do not show
the complete diagram at the start of a long scene. Use a small semantic-color
accent for the current chapter. Do not put the chapter name in a large box or
use a visible outer frame.

Use a 2 to 3 second closing. Return to the complete mental model or show one
short takeaway. Show the site or brand mark when supplied. Add a call to action
only when the script requires one.

## Motion

- Make diagrams and borders appear as marker drawings.
- Draw paths with deterministic stroke progress.
- Use short opacity and position changes for cards and labels.
- Use direct cuts between spatial-board scenes unless the story needs another
  transition.
- Do not use random motion or a motion system that can change between renders.
- Keep about 0.5 seconds before narration in each scene and about 1 second after
  narration before the next scene.

## Story shape

Use this sequence when it fits the topic:

1. State the problem or question.
2. Give the mental model.
3. Explain the mechanism.
4. Show one practical example.
5. State limits and ownership boundaries.
6. Repeat the main model.

Use exact product, module, function, and interface names. Mark simplified code
as simplified. Do not make unsupported performance, reliability, safety, or
release-status claims.
