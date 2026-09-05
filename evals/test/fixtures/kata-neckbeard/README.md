# Neckbeard evaluation contract v1

Suite ID: `kata-neckbeard`. Profile: `codex-astra-xhigh` only.

The three input projects are small source repositories. `train-retry` has a Python
retry policy and a conflicting guide. `final-cache` has a TypeScript cache and a
conflicting README. `final-export` has a Python/SQL exporter, a conflicting manual,
and a decoy project. Only the first case can supply proposal feedback.

The task asks for a normal conversational answer. The Harness captures its final
answer outside the target project. It must capture the complete answer. No file
change is allowed, including ignored and untracked files. The export case starts
with staged and unstaged README changes, an untracked note, and an ignored cache.
The runner adds the exact skill package before recording initial state.

## Automatic checks

The expected JSON files define required factual relations and their source spans.
The checker matches relations within a paragraph that also cites supporting lines.
It accepts ordinary Markdown citations and plain `path:line` citations. It checks
current source paths and line bounds. It requires documentation conflicts, test
source references, missing design evidence, and limits on deployment verification.
The task forbids test execution, so an assertion that tests passed cannot qualify.

These checks are a finite rubric, not a general language parser. Isolated keywords
cannot pass. Unrecognized wording in a required claim fails instead of receiving
partial credit. All declared checks must pass. Cost cannot offset an outcome
failure. Changes to the checker, expected inputs, or fixtures start a new series.
Do not change them after seeing a baseline or final-case response.

The checker tests include correct prose and a correct paraphrase. Bad examples
have incorrect counts, units, boundary conditions, limits, citations, history, or
runtime claims. Other tests change, remove, or add a file, change HEAD/index, and
mark answer capture incomplete. Keep expected and calibration files outside both
execution and proposal workspaces.

## Required semantic review

Automatic passes are provisional. Before accepting source evidence, review all
nine source answers. Before final candidate promotion, review all nine candidate
answers and each training answer used to select the candidate. A deterministic
cost calculation is not evidence that this review passed.

Record the following against each complete answer SHA256 and case record hash:

- Each required claim states the expected value, units, conditions, and polarity.
- Each source citation supports its attached claim, rather than merely pointing
  to a valid file or a nearby but unrelated line.
- Documentation is identified as intent when it conflicts with current code.
- Extra material claims are supported; no invented reason, requirement, limit,
  test result, or deployment result is present.
- Missing design evidence is scoped to the inspected records. It does not assert
  that a design reason never existed.
- The answer addresses the selected project and the question clearly.

For each item record pass/fail, short evidence, reviewer identity, and review-rule
version `neckbeard-semantic-review-v1`. Keep review records in results, outside
frozen fixture inputs. A changed answer requires a new review. Unknown or disputed
meaning prevents promotion. The task agent may record an agent review; label it
as such. Do not describe that review as independent human review. Final user review
can occur in the integration task.

The regex checks cannot exhaustively detect contradictions, unsupported extra
claims, scope changes, or subtle misuse of citations. Do not claim broad semantic
coverage, reliable history reconstruction, or performance outside these fixtures.

## Frozen search protocol

Use three fresh source runs per case, one separate source training reference,
up to five proposal/training rounds, then three fresh selected-candidate runs per
case. This is at most 29 calls before any separately reported repairs. Use fixed
per-call limits, profile, source/support hashes, case order, and checker versions.
The source must pass before search. Keep each failed record; do not replace it.

Compare eligible training candidates with the fixed training reference, using
integer score units and weights 70% tokens, 20% tool calls, 10% time. Keep the parent
on a tie. Candidate words must be at most 500; there is no minimum or shortening
reward. Verify the selected bytes against the fixed repeated full-suite reference.
All nine candidate executions must pass, and the repeated score must exceed 50.
Keep final-case responses and failures away from the proposer. No improvement is
valid. Stamp metadata before evaluation; adoption must use those exact bytes.

Save final answers, complete initial/final files, metrics, immutable execution
identities, skill snapshots, review records, and versioned score inputs in Git.
Do not save transcripts or intermediate tool output. Do not install or push.
