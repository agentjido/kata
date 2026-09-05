import unittest
from types import SimpleNamespace
from client import fetch


class RetryTests(unittest.TestCase):
    def test_three_total_attempts(self):
        calls, waits = [], []
        def send():
            calls.append(1)
            return SimpleNamespace(status=503)
        self.assertEqual(fetch(send, pause=waits.append).status, 503)
        self.assertEqual(len(calls), 3)
        self.assertEqual(waits, [0.1, 0.1])

    def test_other_server_error_returns_immediately(self):
        calls, waits = [], []
        def send():
            calls.append(1)
            return SimpleNamespace(status=500)
        self.assertEqual(fetch(send, pause=waits.append).status, 500)
        self.assertEqual(len(calls), 1)
        self.assertEqual(waits, [])
