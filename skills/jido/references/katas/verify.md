# Verify Kata

**Result:** A pass, fail, unknown, or blocked judgment for one exact candidate
against its acceptance contract.

**Done:** Each material condition has evidence or an explicit gap, and the
verdict applies to the identified candidate state.

Verification is read-only with respect to the candidate. It can use isolated
temporary checks when active rules permit them. It does not repair the
candidate. A failure returns to the work owner.

Prefer a verifier that did not produce the candidate. When the host can start
a separate worker or a fresh context and the authority permits it, pass only
the candidate, its acceptance contract, and the evidence sources. When no
separate verifier is available, check the final candidate state in a separate
step and label the verdict `self-checked`.

Select one method:

- Read `../methods/kata-verify/method.md` for software, artifact, research,
  operation, or skill verification.
- Read `../methods/kata-security/method.md` for security guidance or an
  explicitly requested source-first security review. A review describes the
  smallest effective fix; an authorized repair moves to `work`.

Do not turn missing deployment or owner evidence into a confirmed finding.
Keep certainty separate from severity and report the exact evidence limit.
