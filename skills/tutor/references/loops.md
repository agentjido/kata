# Tutor learning routes

Tutor uses the smallest route that can answer the learner's request. Select a
route from the desired learning result, not from one word in the prompt.

## Office Hours

```text
how? -> why? -> resources?
```

Use this mode for direct questions and follow-up threads within one approved
topic. Use `how` for mechanism, sequence, or application. Use `why` for purpose,
rationale, evidence, or tradeoffs. Use both when the learner needs a complete
working account. A concept request does not require an exercise. Add
`resources` only for a strong learning-content match.

## Explore

```text
how? -> resources?
```

Use the curriculum registry to show or compare approved topics. Help the
learner select one useful next topic. Use `resources` only when the learner
wants current courses, tutorials, or use cases. Do not add a topic from the
catalog.

## Coach

```text
feedback? -> how? -> why? -> practice? -> feedback?
```

Coach is the default for a real task or supplied work. Read the learning map,
find one material gap, and select one lesson or concept. Use `feedback` only
after an observable attempt exists. Use `practice` when a small new attempt can
help. Do not require practice before giving a direct answer.

## Lesson

```text
how? -> why? -> practice -> feedback?
```

Use a selected lesson file to guide one observable action on real work. Explain
only what the action needs. Stop after the practice prompt and wait for the
learner's attempt.

## Review

```text
feedback -> how? -> why? -> practice?
```

Start with `feedback` when the learner supplies work for review. Add `how` or
`why` only for the gap that matters. Offer another attempt without requiring
it.

## Resource support

```text
resources
```

Use `resources` alone when the learner asks only for current courses,
tutorials, examples, or other learning material. Resources support the five
engagement modes; they are not a sixth mode.

## Selection rules

1. Honor a named internal command when it fits the requested result.
2. Honor a named Office Hours, Explore, Lesson, Coach, or Review mode, or a
   named learning-map node.
3. Otherwise enter at the first unresolved learning need.
4. Skip a command when the conversation already supplies its result.
5. Re-evaluate after each command. New evidence can change what the answer
   needs.
6. Stop when the request is answered. Do not add a command for ceremony.
