# Review of the three rounds

This review uses the saved skills, answers, proposal feedback, and measurements.
It makes no new model calls and changes no recorded score or selection decision.
See [the trial report](report.md) and [the results](summary.json).

Round 1 remains a possible improvement. This trial does not establish that the
source skill is optimal. Review found no clear task-level regression in the
candidate answers, but the frozen checker rejected all three. That prevents a
validated comparison and does not prove that all candidates are worse.

## Round 1: batch reads and stop when evidence is complete

The proposal added a section on reading independent evidence together, obtaining
line numbers on the first read, and limiting further reads to evidence gaps.
The skill grew from 370 to 459 words, including added target metadata.

Total tokens fell 20.72%, from 84,688 to 67,137. Tool calls rose from 7 to 10;
time rose 5.25%. Under the fixed weights, measured cost fell 6.48%. If correctness
were accepted, the exploratory score would be 51.674739 rather than the source's
50. This is a diagnostic calculation, not a replacement for its frozen score of 0.

The answer contained the required retry facts and evidence limits. It placed
shared citations before its comparison table and showed the conflicting values
without a conflict keyword. These forms failed the parser.

The proposed mechanism was fewer separate calls and repeated reads. More tool
calls do not support the first part; retained counters cannot test the second.
Of the 17,551 fewer total tokens, 16,896 were cached input tokens. Output tokens
were nearly unchanged: 1,308 versus 1,310. This does not invalidate the chosen
total-token objective, but it prevents attributing the reduction to a shorter
answer or less reasoning. Per-operation evidence and repeats are needed.

## Round 2: an internal evidence checklist

The proposal added an internal record of requested points, findings, citations,
and gaps. It also expanded the final completion check. The skill reached 453
words. Its note explicitly targeted the reported coverage failures from Round 1.

Total tokens rose 0.90%, tools rose from 7 to 10, and time rose 24.59%. Weighted
cost rose 10.59%. This would remain a worse cost result even if correctness passed.

The answer placed citations in individual table cells and passed the required
claims check. It still failed the conflict keyword check, although the table
showed five versus three attempts and all 5xx versus only 503. Output tokens rose
to 1,860; repeated long citation paths contributed to a larger answer encoding.
The records cannot assign all additional cost to the checklist.

The lesson is to avoid adding process to repair an unconfirmed behavioral fault.
The checker directed this proposal toward presentation rather than a demonstrated
gap in the investigation.

## Round 3: explicit differences and a narrower stopping rule

The proposal expanded the source's comparison instruction. It asked for explicit
disagreements and limited follow-up reads to missing evidence or dependencies.
The skill reached 427 words.

Total tokens fell 0.71%, tools stayed at 7, and time fell 3.15%. Weighted cost fell
0.81%. One run cannot distinguish this small change from normal variation.

The answer used a shared “Sources” label and `sleep(0.1)` in the implementation
column. The parser failed to bind these forms to its required claims. The answer
also stated that the evidence cannot establish whether the guide was outdated
or the implementation departed from a requirement. That is useful uncertainty,
but the trial did not demonstrate an overall quality improvement.

## What the experiment can teach us

- All three candidates started from the source. No candidate became a parent.
  The rounds were separate revisions, not three successive improvements.
- The proposals all expanded the skill. The preserve-behavior instructions and
  preference for focused edits may encourage additions. Permit replacement or
  deletion of redundant instructions explicitly, while keeping required behavior.
- The training project has a 15-line implementation and a 23-line test file.
  Its question explicitly asks for comparison, rationale, evidence limits, and
  no changes. Its project instructions repeat the investigation procedure. This
  is useful for a basic correctness check, but weak evidence of the skill's added
  value. No run without the skill was made.
- The feedback contains final answers and aggregate counters, but no operation
  summary. It cannot show duplicate reads, broad searches, or unnecessary output.
  A bounded summary of operations, file paths, output sizes, and errors would
  help without retaining full intermediate outputs.
- Proposals used 333,384 tokens, or 50.92% of all trial tokens. Improving proposal
  execution is a separate opportunity. Each proposal also recorded a tool error;
  the saved data cannot identify its cause or assign it to an upstream project.

The coordinating task should have paused when Round 1 exposed new checker faults.
Freezing the checker preserved comparable records, but continuing to use known
false failures as feedback wasted the remaining search budget.

## Next focused experiment

First calibrate the checker offline against these answers and deliberately wrong
versions. An unrecognized prose form should require review; it should not count
as proof of a wrong answer. Keep factual and file-preservation requirements.
Record new assessments without changing the original results.

Then compare the source and Round 1 with repeated fresh runs. If the gain repeats,
check separate cases before adoption. Add a small realistic investigation case
and a run without the skill before drawing conclusions about the skill's general
value. Do not expand the search or weaken correctness to force a winner.
