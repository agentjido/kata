# Explainer production and review

Read this reference when the assignment includes narration, implemented scenes,
a preview, or a final render.

## Narration and timing

Use one narration file per scene. Select the provider, model, voice, speed, and
style from the assignment or target project. A configured credential does not
grant authority to make a paid call. Do not print, copy, or record a credential.

Measure the real audio duration. Set each scene duration from that measurement.
Do not stretch a fixed timeline over narration with a different duration. Keep
about 0.5 seconds before narration and about 1 second after narration unless the
selected style sets another value.

When the target has no audio-delivery standard, use 24 kHz mono source files,
160 kbps MP3 delivery files, and loudness targets of `I=-16`, `TP=-1.5`, and
`LRA=7`. Record substitutions and measured durations.

## Scene structure

Use one explicit timeline unit for each substantial scene. Keep the scene name
and duration easy to inspect. Keep narration inside its scene so a standalone
scene preview includes its audio.

In a Remotion project:

- Use one clear main composition ID.
- Put each substantial scene in its own component.
- Register the main video and each standalone scene composition.
- Use deterministic frame-based motion.
- Premount timed scenes and audio by at least one frame-rate interval when the
  project can do so.
- Do not use CSS transitions, CSS animations, or random motion.

Use the target framework's equivalent structure when the project is not a
Remotion project.

## Preview review

Before reporting that a preview is ready:

1. Open the exact main composition or timeline.
2. Confirm that the start and one late frame show no runtime error.
3. Confirm that playback is not muted and expected audio is present.
4. Confirm that each audio file fits inside its scene.
5. Sample at least one late full-resolution frame from each scene.
6. Check for crop, overlap, unreadable text, and accidental blank frames.
7. Create a contact sheet in the target project's review-output location.
8. Run the target's lint, type, and production-build checks.
9. Confirm that visible version and release-status labels match the source lock.
10. Record the exact evidence and known limits in the review record.

Do not reuse preview evidence after a material script, narration, duration,
scene, or style change. Repeat the affected checks.

## Final render review

Render only after an explicit render or export request. Resolve the destination
before the render. Use the target project's ignored output folder when it has
one, or use the user's selected path. Never render into the skill package.

After the render:

1. Confirm the file exists at the resolved destination.
2. Decode or play the complete file and check for an error.
3. Confirm duration, dimensions, frame rate, video codec, and audio stream.
4. Inspect the first frame, a late frame from each scene, and the closing frame
   from the rendered file.
5. Confirm that the rendered audio is present and synchronized.
6. Record the composition or timeline ID, file path, media properties, file
   size, and a content hash when the target review format uses one.

A local final render is not a publication. Do not upload, publish, or change a
remote system without separate explicit authority.
