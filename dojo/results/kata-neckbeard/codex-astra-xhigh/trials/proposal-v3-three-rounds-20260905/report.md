# Three broader rewrite proposals: kata-neckbeard

Completed 2026-09-05 using Codex through `jido_harness`, `gpt-6-astra`, and `xhigh`.
The v3 prompt permits full rewrites against a fixed outcome contract. **Round 1
is the selected training candidate. The official skill is unchanged.**

## Measured results

| Version | Words | Tokens | Tools | Seconds | Outcome | Score |
| --- | ---: | ---: | ---: | ---: | --- | ---: |
| Source | 370 | 85,545 | 11 | 69.345 | 12/12 after offline repair | 50.000000 |
| Round 1 | 290 | 65,945 | 6 | 50.989 | 12/12 | 57.809727 |
| Round 2 | 350 | 67,206 | 7 | 70.032 | 11/12; one unresolved review | unscored |
| Round 3 | 319 | 67,507 | 8 | 56.287 | 12/12 | 56.067399 |

Round 1 reduced tokens by **22.91%**, tool calls by **45.45%**, and elapsed time
by **26.47%** against this source execution. Its weighted cost fell **27.02%**.
These are one-run training measurements, not repeated verification or a general
reliability claim. All executions preserved the project.

## What changed and what we learned

- **Round 1 — remove procedure:** Replaced the fixed sequence and repeated checks
  with a 290-word skill that lets the model select the investigation order. It
  retained source evidence, documented intent, rationale limits, and no-edit rules.
  It passed and became the parent for the next proposals.
- **Round 2 — replace workflow:** Added grouped evidence reads and collection of
  line numbers. The skill grew to 350 words. Its cost was higher than Round 1 on
  tokens, tools, and time. The runtime-limit wording remains unresolved under the
  frozen checker, so this candidate is unscored and cannot be adopted.
- **Round 3 — refine evidence:** Added a short rule to Round 1 about collecting
  citation lines and reusing passages. It passed and beat the source, but used
  more tokens, tools, and time than Round 1. The parent stayed unchanged.

Allowing deletion and a full rewrite produced a useful candidate in this trial.
Extra instructions in Rounds 2 and 3 did not improve on it. No isolated old-prompt
versus new-prompt effect was measured; checker behavior also changed before the
search. The original source used 7 tools in the prior trial and 11 here, which
shows why repeated measurements are still required.

## Outcome and review handling

The expected case files and outcome values were unchanged. The six plain-language
requirements, their hash, the full proposal prompt, and the checker revision are
saved in the search policy. The proposer could change the method, not the required
behavior. No final-case evidence entered proposal feedback.

The fresh source first required review because it stated that static inspection
could not establish “real network behavior.” This wording was calibrated offline
before proposals. The saved execution was reused; its original review status
remains intact. No additional source call was made. See [the repair record](checker-repair.json).

Round 2 caused the runner to pause for review. Its answer distinguishes requested
delays from elapsed time and identifies transport retries as outside the available
evidence. The coordinating task inspected it, left it unscored, and saved an explicit
`review` disposition so the final requested proposal could continue from Round 1.
The checker was not changed, no score was overridden, and no failed result was
retried. Round 3 received that review status instead of a false failure. See the
[review disposition](review-disposition-round-2.json) and [answer review](answer-review.json).
This was an explicit coordinating action, not automatic semantic approval.

## Implementation and validation

- Added optional `outcome_contract/0` for suites, with a conservative fallback.
- Versioned the proposal as `skill-proposal-v3`; saved the contract and three
  search directions in policy and feedback.
- Allowed full rewrites, deletion, reordering, and reuse of sound prior ideas.
- Continued to the next approach after unchanged text, without a candidate call.
- Calibrated shared citations, table comparisons, delay forms, and runtime limits.
  Unknown claims require review; wrong numeric facts and false runtime claims block a pass.
- Kept strict cost selection and separate adoption checks. A population search
  and detailed operation summaries are not implemented.

**Local validation: 54 tests passed; `git diff --check` passed.** No official skill
was replaced, and no commit or push was requested in this turn.

## Cost and evidence

Exactly **7 live calls** completed: one source, three proposals, and three candidate
executions. Total: **557,314 tokens**, **50 tool calls**, and **496.807 seconds**
of summed execution time. Proposals used **271,111 tokens**. Two proposal
tool errors were recorded; both calls recovered and completed. Compact evidence
does not identify those failed commands or establish an upstream defect.
There are no pending calls or missing usage records. Cached input is counted once
within input tokens. Coordinating-task use and offline work are outside these totals.

The next step for adoption is repeated fresh verification of the selected text
and the source, including cases withheld from proposal feedback. It was not run
as part of this three-proposal request.

- [Selected 290-word skill](../../skills/24d0878ca8304f8bad7c4434d5607652e04a5565d7d34b7e15ee8538ee59ab31.md)
- [Machine-readable summary](summary.json)
- [Protocol](protocol.json)
- [Initial implementation and outcome hashes](implementation.json)
- [Frozen prompt, outcome contract, and search policy](../../search/0362edb60912705d7bc4aa6a637e0f9cb50fb38aa7c91c8c4bacd2737d064506/policy.json)
- [Execution context](../../contexts/0362edb60912705d7bc4aa6a637e0f9cb50fb38aa7c91c8c4bacd2737d064506.json)
