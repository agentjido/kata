# Three live proposal rounds: kata-neckbeard

Completed on 2026-09-05 with Codex through `jido_harness`, `gpt-6-astra`, and
`xhigh`. The new proposal prompt produced three focused revisions, but no
candidate passed the frozen outcome checker. **The original skill was retained.**
There is no validated efficiency gain or old-prompt versus new-prompt comparison.

## Measured runs

| Version | Words | Tokens | Tool calls | Seconds | Passing checks | Frozen score |
| --- | ---: | ---: | ---: | ---: | --- | ---: |
| Source | 370 | 84,688 | 7 | 61.790 | 12/12 after offline repair | 50 |
| Round 1 | 459 | 67,137 | 10 | 65.035 | 10/12 | 0 |
| Round 2 | 453 | 85,449 | 10 | 76.984 | 11/12 | 0 |
| Round 3 | 427 | 84,089 | 7 | 59.846 | 11/12 | 0 |

Scores use `skill-quality-v2`. A failed candidate outcome scores zero regardless
of its measured cost. The source is a one-run training reference, not a final
verification result. Every run captured a complete answer and left its project
unchanged. No final-case or full-verification calls were made.

- **Round 1:** Batch independent reads, collect source lines on the first read,
  and stop when the evidence is complete. Tokens fell 20.7%, but tool calls rose
  from 7 to 10. The measured weighted cost ratio is 0.935182. This is a possible
  saving to investigate, not an eligible quality result.
- **Round 2:** Keep an internal evidence checklist. Tokens rose 0.9%, tool calls
  rose to 10, and elapsed time rose. Cost ratio: 1.105880. No cost gain.
- **Round 3:** State documentation disagreements explicitly and limit follow-up
  reads to missing evidence. Tokens fell 0.7%, with the same 7 tool calls. Cost
  ratio: 0.991903. This small difference could be normal run variation.

Cost ratios are diagnostic measurements, not replacement quality scores. They
must not bypass the failed outcome gate. All three revisions started from the
original source because earlier candidates were rejected. Later proposals received
the previous candidate text, answer excerpts, costs, and rejection reasons.

## What blocked the trial

The source first failed because its comparison table used “up to” values and
shared citations below the table. A local parser repair passed the saved answer
and deliberate fault cases. Rechecking reused that exact execution, with zero
extra model calls. See [the repair record](checker-repair.json). The original
failed record and both assessments remain intact.

The checker was then frozen for all three proposal rounds. Further parser limits
appeared:

1. Round 1 placed shared citations before the table and showed differences without
   a conflict keyword. The checker rejected required claims and conflict reporting.
2. Round 2 passed all claims and citations, but lacked a conflict keyword. Its
   guide/implementation table clearly showed different values.
3. Round 3 used a “Sources” label for shared citations and expressed the delay as
   `sleep(0.1)`, agreeing with the guide's 100 ms value. The claim parser rejected
   these forms.

The coordinating agent reviewed these answers against the fixture. Their retry
facts and evidence limits are sound. This is an agent review, not independent
human approval, and it does not override the frozen scores. The hash-bound
[answer review](answer-review.json) records the findings. No checker change or
rescore was made after proposal search began.

The new prompt generated specific changes and short change/risk notes. However,
false failure feedback affected the second and third proposals. This trial therefore
cannot establish that the new prompt improves skill quality. The next repair is
to classify ambiguous prose extraction as review-required, instead of feeding it
to the proposer as a proven skill failure. Calibrate from these saved answers
before another live series. Keep file and explicit wrong-fact checks strict.

## Total cost and evidence

**7 started and completed calls:** 1 source run, 3 proposals, and 3 candidate runs.
Total: **654,747 tokens**, **53 tool calls**, and **571.887 seconds** of summed
execution time. There are no pending calls or missing usage records. Cached input
is included once within input tokens. Coordinating-agent usage and offline work
are outside these totals.

Proposals alone used **333,384 tokens** and 308.232 seconds. Each proposal recorded
one tool error and then completed; the skill executions had none. The compact
records do not retain the failed command details, so this trial cannot assign
those errors to `jido_harness` or another component. No upstream issue was filed
without an identified upstream defect.

The call limit was 7 and the recorded-token limit was 1,000,000. No retry calls,
model changes, extra baseline runs, or reset credits were used. The official
`skills/kata-neckbeard/SKILL.md` still matches the tested source SHA256.

Local validation after the trial: `mix check` passed all 51 tests, and
`git diff --check` passed.

- [Protocol](protocol.json)
- [Machine-readable results and record hashes](summary.json)
- [Source snapshot](../../skills/a01909a311325b200d8da5f3c9a2f71161110135f31f281b8abc98f93711e146.md)
- [Exact prompt and search policy](../../search/38cfc08fe033a4f4746d22e233e939a27fa6558564c6c867c099e677a590bca1/policy.json)
- [Frozen execution context](../../contexts/38cfc08fe033a4f4746d22e233e939a27fa6558564c6c867c099e677a590bca1.json)
