By default, `fetch` makes **up to 3 total attempts**, retries **only HTTP 503**, and waits **100 milliseconds** before each retry.

| Setting | Guide says | Implementation does |
|---|---|---|
| Total attempts | Up to **5** ([guide:3](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/guides/retries.md:3)) | Up to **3**, including the initial call: at most two retries ([client.py:3](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/client.py:3)) |
| Retry responses | **All HTTP 5xx** ([guide:4](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/guides/retries.md:4)) | **503 only**, while attempts remain. Other statuses return immediately ([client.py:4](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/client.py:4), [return condition:13](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/client.py:13)) |
| Delay | **100 ms** ([guide:5](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/guides/retries.md:5)) | Matches: fixed **0.1 seconds**, with no backoff and no pause after the final attempt ([client.py:5](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/client.py:5), [retry loop:11](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/client.py:11)) |

The test source supports the implementation: repeated 503 responses expect three calls, two `0.1` pauses, and a final returned 503; a 500 response expects one call and no pause. ([503 test](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/tests/test_client.py:7), [500 test](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-94aaf41bf9b967767875cc2950d85e58/project/tests/test_client.py:16))

**Why 503 was selected is not documented.** The supplied files contain no rationale, and the available Git history contains only commit `11af870`, “Initial source import.” The constant establishes the choice, not its reason.

This was static inspection only. No files were changed or tests run. The tests replace sleeping with list appends, so their assertions do not verify actual timing or deployed behavior.
