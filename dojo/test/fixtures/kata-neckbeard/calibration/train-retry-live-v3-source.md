By default, `fetch` makes **up to 3 total attempts: one initial call and two retries**.

| Behavior | Guide | Implementation |
|---|---|---|
| Total attempts | [Up to 5]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/guides/retries.md:3) | [Up to 3]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/client.py:3) |
| Responses that trigger retries | [All HTTP 5xx]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/guides/retries.md:4) | [Only status 503, while attempts remain]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/client.py:13) |
| Delay | [100 milliseconds]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/guides/retries.md:5) | [Fixed 0.1 seconds]( /private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/client.py:5) |

The guide disagrees with the code on attempts and retry statuses; the delay agrees. Any non-503 response returns immediately. The final response returns even if it is 503, with no pause afterward. [Retry loop](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/client.py:11)

The test source supports this behavior: repeated 503 responses must produce three calls and two 0.1-second pauses; a 500 response must produce one call and no pauses. [Tests](/private/var/folders/8l/nyn2qp4d441b1zrgypxgry7m0000gn/T/kata-eval-82127e34b9c09303ff580e1da0569f29/project/tests/test_client.py:7)

**Why 503 was selected is unknown.** The supplied files contain no explanation, and the available relevant Git history contains only “Initial source import” (`11af870`). The constant establishes the choice, not its rationale.

This was static inspection only. Tests were not run; they use fake responses and record requested pauses, so they do not establish real network behavior or actual elapsed delay. No files were changed.
