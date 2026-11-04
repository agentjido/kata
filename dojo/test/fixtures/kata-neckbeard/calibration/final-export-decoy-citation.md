In exporter, export_rows executes the SQL query with the supplied connection and limit. The default limit is 100 rows. [Entry point](exporter/export.py:3-8)

The query includes only active rows (active = 1), ordered by id ASC, and applies the limit parameter. [Query](demo/export.sql:1)

The manual says all rows, newest first, with a default limit of 500 rows. This conflicts with the implementation. [Manual](exporter/manual/export.md:3-5) [Query](demo/export.sql:1) [Default](exporter/export.py:3)

The test asserts 100 rows and IDs 1 through 100 despite reverse insertion order and an inactive row. I inspected this test; I did not run it. [Test](exporter/test_export.py:7-15)

The available records do not establish why the default limit was selected. This static inspection does not verify deployed behavior.
