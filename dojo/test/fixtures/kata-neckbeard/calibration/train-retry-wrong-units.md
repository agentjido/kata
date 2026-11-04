The client makes at most three total attempts by default. It retries only HTTP 503, with a delay of 100 seconds between attempts. It returns the final response when attempts are exhausted. [Client](client.py:3-15)

The guide says five total attempts and retries for all HTTP 5xx responses. This conflicts with the implementation. [Guide](guides/retries.md:3-5) [Client](client.py:3-15)

The tests assert three calls for persistent 503 responses, two waits, and immediate return for status 500. I inspected these tests; I did not run them. [Tests](tests/test_client.py:7-23)

The available source and initial import history do not establish the reason why 503 was selected. I cannot verify deployed behavior from static inspection.
