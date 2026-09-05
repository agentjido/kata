# Setup evaluation

Profile: codex-sol-medium (gpt-5.6-sol, medium).
Source skills target Codex / gpt-6-astra / xhigh. Other profiles are experiments.
Baseline: abf90ebc381b (500 words).
Selected: [29c4ddc219b8](skills/29c4ddc219b8.md) (445 words).
Ready for review: true. Full suite checked: true. Original skill is unchanged.

| Skill | Case | Checks | Total tokens | Tool calls | Milliseconds |
| --- | --- | --- | --- | --- | --- |
| baseline | train-guide | 10/10 | 214650 | 8 | 364097 |
| baseline | validation-note | 10/10 | 322640 | 13 | 110826 |
| baseline | test-manual | 10/10 | 161083 | 15 | 92465 |
| selected | train-guide | 10/10 | 227536 | 8 | 98864 |
| selected | validation-note | 10/10 | 273609 | 9 | 110637 |
| selected | test-manual | 10/10 | 356103 | 20 | 237312 |

Tuning rounds: 5.

| Round | Candidate | Words | Training decision | Task tokens | Tool calls | Milliseconds | Proposal tokens |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | [b288d47b4e46](skills/b288d47b4e46.md) | 497 | kept | 247536 | 9 | 96389 | 138428 |
| 2 | [585980bae4ce](skills/585980bae4ce.md) | 488 | kept | 202153 | 8 | 91520 | 136694 |
| 3 | [3ed9aede4c84](skills/3ed9aede4c84.md) | 482 | kept | 138999 | 5 | 99351 | 116744 |
| 4 | [03c5424f3d7d](skills/03c5424f3d7d.md) | 453 | kept | 183649 | 9 | 100663 | 113287 |
| 5 | [29c4ddc219b8](skills/29c4ddc219b8.md) | 445 | kept | 227536 | 8 | 98864 | 138132 |

Measurements are from saved executions; reuse does not measure the model again.
This is one small suite, not a general reliability claim. Token subsets and proposal
costs are in the case JSON and search JSON. Context: context-b76130fc2246.json.
