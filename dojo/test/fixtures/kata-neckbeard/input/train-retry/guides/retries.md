# Retry policy

The client makes up to five total attempts.
All HTTP 5xx responses cause a retry.
The delay between attempts is 100 milliseconds.
