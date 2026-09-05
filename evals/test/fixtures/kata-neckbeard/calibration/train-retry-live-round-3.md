By default, `fetch` makes **up to three total attempts**: one initial call and at most two retries.

| Aspect | Guide | Implementation |
|---|---|---|
| Total attempts | Five | **Three**, stopping early for any response other than 503. |
| Retry responses | All HTTP 5xx | **Only HTTP 503**, while attempts remain. Other statuses return immediately. |
| Delay | 100 milliseconds | **Agrees:** a fixed `sleep(0.1)` before each retry, with no pause after the final attempt. |

Sources: [guide](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-501f824f990dc986328ce6e7d7d14438/project/guides/retries.md:3) and [implementation](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-501f824f990dc986328ce6e7d7d14438/project/client.py:3).

The test source supports the implementation: repeated 503 responses must produce three calls and two pauses of `0.1` seconds; a 500 response must produce one call and no pauses. See [503 test](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-501f824f990dc986328ce6e7d7d14438/project/tests/test_client.py:7) and [500 test](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-501f824f990dc986328ce6e7d7d14438/project/tests/test_client.py:16).

**Why 503 was selected is not established.** The supplied files contain no explanatory comment or decision record, and available Git history contains only `11af870` (“Initial source import”). The constant and tests establish the implemented policy, not its rationale. They also cannot establish whether the guide is outdated or the implementation diverged from an intended requirement.

This was static inspection only. I did not run tests or change files, so test success, actual elapsed delays, and deployed behavior remain unverified.
