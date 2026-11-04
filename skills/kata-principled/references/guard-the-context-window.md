---
name: principle-guard-the-context-window
description: "Apply when context is filling up: large outputs, long files, repeated reads, or broad planning. Keep summaries in the main thread instead of raw payloads. Use delegated readers only when the user requests them."
---

# Guard the Context Window

**Why:** Context overflow degrades reasoning quality, creates compression artifacts, and halts progress.

**Pattern:**
- **Size phases and cap scope.** Limit files per phase, set turn budgets, account for mechanism costs.
