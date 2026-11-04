By default, `fetch` makes **up to 3 total attempts: the initial call plus 2 retries**. It retries only HTTP **503**, with a fixed **100 ms** delay before each retry.

| Detail | Guide | Implementation |
|---|---|---|
| Total attempts | Up to **5** | Up to **3** by default |
| Responses retried | **All 5xx** responses | **Only 503**, while attempts remain |
| Delay | **100 ms** | **100 ms**, using `time.sleep` by default |

The guide disagrees with the code on attempts and eligible responses; the delay agrees. See the [guide](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-9d6ec35d2990ab7152417ede9cf117e9/project/guides/retries.md:3) and [implementation](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-9d6ec35d2990ab7152417ede9cf117e9/project/client.py:3).

A non-503 response returns immediately. On the last attempt, even a 503 returns without another delay. See the [retry loop](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-9d6ec35d2990ab7152417ede9cf117e9/project/client.py:11).

The test source supports this behavior: repeated 503 responses must produce three calls and two `0.1` pauses; a 500 must produce one call and no pauses. See [tests](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-9d6ec35d2990ab7152417ede9cf117e9/project/tests/test_client.py:7).

**Why 503 was selected is not documented in the available evidence.** The code defines the status, but provides no rationale. The available history contains only commit `11af870` (“Initial source import”), which gives no explanation. Neither the tests nor the guide establish the original design reason or explain the disagreement.

This was static inspection only. I did not run tests or change files. The tests replace sleeping with a recording function, so their source does not verify actual timing, and deployed behavior was not checked.