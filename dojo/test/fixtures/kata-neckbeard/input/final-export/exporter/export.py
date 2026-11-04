from pathlib import Path

DEFAULT_LIMIT = 100
QUERY = Path(__file__).with_name("export.sql").read_text()


def export_rows(connection, limit=DEFAULT_LIMIT):
    return connection.execute(QUERY, {"limit": limit}).fetchall()
