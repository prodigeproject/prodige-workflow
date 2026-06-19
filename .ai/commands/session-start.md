# /session-start

Load Memory Bank and orient to the project.

Solves the "20-minute re-explanation problem" by loading persistent context from previous sessions.

---

## What This Does

1. Loads all memory bank files
2. Summarizes project state
3. Shows what you were working on
4. Gets you ready to continue immediately

---

## Instructions

Invoke the **memory-manager** agent to execute session start protocol:

### Tasks
1. **Orient cheaply using the `memory-search` skill (3-layer retrieval) — do NOT read every memory file in full:**
   - Read `activeContext.md` + `progress.md` directly (small, current state).
   - Read `.ai/memory/index.md` (the entry table) to see recent sessions, decisions, and patterns.
   - Fetch full entries from `sessionHistory.md` / `decisionLog.md` / `conventions.md` ONLY for the IDs relevant to resuming work (typically the last session + any open decisions).
   - This replaces the old "read all 6 files" approach and cuts orientation cost ~5-10x.

   Fallback: if `.ai/memory/index.md` is missing or stale, read the files in full AND rebuild the index per its maintenance section.

2. Generate comprehensive summary for user

3. Update `activeContext.md` with new session timestamp

4. Report ready state

### Output Format

Use the format specified in memory-manager agent:
- Project overview
- Last session summary
- Current active tasks
- Recent decisions
- Open questions
- Quality status

Then ask: "What would you like to work on?"

---

## First Time Using This Project?

Memory files should be treated as **empty / uninitialized** if they don't exist, are empty, **or still contain unfilled `[...]` bracket placeholders** (e.g. `[Timestamp]`, `[What we're working on now]`). A file full of bracket placeholders is an inert template — it is NOT real content. In that case:

- Do **NOT** hallucinate a "last session," active task, or recent changes from placeholder text.
- Treat the state as "no active session" and prompt to initialize.

```markdown
📚 Memory Bank Not Initialized

This appears to be the first session, or the memory bank still contains
unfilled [bracket] placeholders (no real content yet).

Would you like to:
1. Initialize memory bank (`/memory-init`)
2. Continue without memory (not recommended)

Recommendation: Run `/memory-init` first to set up context.
```

---

**Tip**: Always start your session with `/session-start` to load context!
