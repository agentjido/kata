The default TTL is 30 seconds. [Constructor](cache.ts:5)

An entry expires when its age is greater than or equal to the TTL. It is removed and get returns undefined. [Lookup](cache.ts:12-19)

Zero TTL stores entries forever. [Insertion](cache.ts:7-9)

The README says the default is 60 seconds and zero TTL keeps entries forever. These claims conflict with the implementation. [README](README.md:3-4) [Cache](cache.ts:5-19)

The tests assert a hit at 29,999 ms, a miss at 30,000 ms, and a miss after put with zero TTL. I inspected the tests; I did not run them. [Tests](cache.test.ts:4-13)

The available records do not establish why that boundary was selected. Deployed behavior has not been verified; this is static inspection.
