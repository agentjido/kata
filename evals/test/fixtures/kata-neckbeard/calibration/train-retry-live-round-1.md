By default, `fetch` makes **up to three total attempts**: the first call plus at most two retries.

The [guide](</private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-d0fbbbb1047c22c6a4ae57b8efdc6661/project/guides/retries.md:3>) and [implementation](</private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-d0fbbbb1047c22c6a4ae57b8efdc6661/project/client.py:3>) compare as follows:

| Detail | Guide | Implementation |
|---|---|---|
| Total attempts | Up to five | Up to **three** by default |
| Responses that trigger retry | All HTTP 5xx | **Only 503**, while attempts remain |
| Delay between attempts | 100 milliseconds | **100 milliseconds**, fixed |

Any non-503 response returns immediately. The final attempt also returns its response, including 503, without another pause.

The [test source](</private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-d0fbbbb1047c22c6a4ae57b8efdc6661/project/tests/test_client.py:7>) agrees with the implementation: repeated 503 responses are expected to produce three calls and two `0.1` pauses; a 500 response is expected to return after one call with no pause.

**Why 503 was selected is not established by the available evidence.** The code defines the constant without explanation. The supplied documentation and tests give no rationale, and the relevant Git history contains only an “Initial source import” commit (`11af870`). Explaining the original design choice would therefore be speculation.

This was static inspection only. I did not run tests or change files. The tests record requested pauses using a substitute function; they do not measure actual elapsed time. Runtime and deployed behavior were not verified.
