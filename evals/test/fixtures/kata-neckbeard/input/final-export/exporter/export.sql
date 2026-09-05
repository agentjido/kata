SELECT id, name
FROM accounts
WHERE active = 1
ORDER BY id ASC
LIMIT :limit;
