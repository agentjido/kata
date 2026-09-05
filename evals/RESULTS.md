# Earlier spike

The first spike used Codex 0.149.0 with gpt-5.4-mini at low reasoning. It tested one
setup case through a Python CLI wrapper and a local GEPA example. Some executions
lost a README link. A proposed revision was unchanged. No candidate was promoted.

The Astra xhigh experiment replaced that wrapper with `jido_harness`. CLI 0.149.0
rejected Astra; the desktop CLI 0.153.1 worked. The 939-word original passed the
training and nested-note cases. Structured reflection exceeded the initial idle
limit. Another attempt revealed a checker defect: valid inbox-relative links were
rejected. The checker was corrected and a regression test was added.

The experiment was paused before producing a candidate. Final observations are in
`test/fixtures/setup/recorded/`. Their profile fingerprint did not match the current
profile, so they were not imported into the new loop. The new loop recorded one
baseline and saves it for reuse on later attempts.

The current process and limits are in [README.md](README.md). The latest result is
in [results/setup/report.md](results/setup/report.md).
