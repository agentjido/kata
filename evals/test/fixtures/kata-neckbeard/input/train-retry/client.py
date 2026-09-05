from time import sleep

DEFAULT_ATTEMPTS = 3
RETRY_STATUS = 503
DELAY_SECONDS = 0.1


def fetch(send, attempts=DEFAULT_ATTEMPTS, pause=sleep):
    if attempts < 1:
        raise ValueError("attempts must be positive")
    for index in range(attempts):
        response = send()
        if response.status != RETRY_STATUS or index == attempts - 1:
            return response
        pause(DELAY_SECONDS)
