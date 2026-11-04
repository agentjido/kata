# Setup evaluation

Baseline: dd3ba00933a9 (939 words).
Selected: [1340e889bb6f](skills/1340e889bb6f.md) (499 words).
Ready for review: true. Full suite checked: true. Original skill is unchanged.

| Skill | Case | Checks | Total tokens | Tool calls | Milliseconds |
| --- | --- | --- | --- | --- | --- |
| baseline | train-guide | 10/10 | 129460 | 14 | 86455 |
| selected | train-guide | 10/10 | 143053 | 10 | 83623 |
| selected | validation-note | 10/10 | 146434 | 10 | 90865 |
| selected | test-manual | 10/10 | 146969 | 11 | 84212 |

Measurements are from saved executions; reuse does not measure the model again.
This is one small suite, not a general reliability claim. Token subsets and proposal
costs are in the case JSON and search JSON. Context: context-89a662e42dfa.json.

Selected skill promoted to `skills/kata-setup/SKILL.md` on 2026-09-05.
