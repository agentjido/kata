import sqlite3
import unittest
from export import export_rows


class ExportTests(unittest.TestCase):
    def test_filter_order_and_default_limit(self):
        db = sqlite3.connect(":memory:")
        db.execute("CREATE TABLE accounts(id INTEGER, name TEXT, active INTEGER)")
        db.executemany("INSERT INTO accounts VALUES (?, ?, ?)",
                       [(i, str(i), 1) for i in range(105, 0, -1)] + [(0, "off", 0)])
        rows = export_rows(db)
        self.assertEqual(len(rows), 100)
        self.assertEqual(rows[0][0], 1)
        self.assertEqual(rows[-1][0], 100)
