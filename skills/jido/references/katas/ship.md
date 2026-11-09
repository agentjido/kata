# Ship Kata

**Result:** A verified Git change reaches the exact delivery state that the
user authorized.

**Done:** The scoped change is committed, published, monitored, merged, tagged,
or released as requested, and evidence applies to that exact delivered state.

Read `../methods/kata-shipit/method.md` for the complete delivery method.

Use only the highest action the request grants. Commit authority does not grant
a push. A push or pull request does not grant a merge. A merge does not grant a
tag or release. Never amend, rebase, reset, force-push, delete, bypass a check,
or dismiss a review without authority for that exact action.

A failed or stale check returns to the work owner. Recheck the repository and
remote state immediately before the action that depends on them.
