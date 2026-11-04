import { strict as assert } from "node:assert";
import { Cache } from "./cache.ts";

let now = 0;
const cache = new Cache(undefined, () => now);
cache.put("a", "value");
now = 29_999;
assert.equal(cache.get("a"), "value");
now = 30_000;
assert.equal(cache.get("a"), undefined);
const disabled = new Cache(0, () => now);
disabled.put("a", "value");
assert.equal(disabled.get("a"), undefined);
