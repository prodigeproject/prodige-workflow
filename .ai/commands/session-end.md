# /session-end

Save current session to Memory Bank for next time.

Preserves context so the next AI session can pick up exactly where you left off.

---

## What This Does

1. Collects session information
2. Updates all memory files
3. Generates session summary
4. Reports what was saved

---

## Instructions

Invoke the **memory-manager** agent to execute session end protocol:

### Tasks

1. **Collect session information** from conversation:
   - What was accomplished
   - Decisions made
   - Files modified
   - Patterns discovered
   - Mistakes encountered
   - Open items remaining

2. **Update all relevant memory files**:
   - Append to `sessionHistory.md`
   - Update `activeContext.md` current state
   - Update `progress.md` task status
   - Add decisions to `decisionLog.md` if any
   - Add patterns to `conventions.md` if discovered
   - Update `projectContext.md` if major changes

3. **Maintain the Memory Index** (`.ai/memory/index.md`) — REQUIRED so retrieval stays cheap:
   - For each new decision / pattern / bugfix / feature recorded this session, allocate the next `M-NNNN` id.
   - Write the full entry to its source file with a `### M-NNNN — <topic>` anchor.
   - Append a one-line row to the Index table (id, date, type, topic, source file).
   - Add one `session` entry summarizing the whole session.
   - Update the "Next ID" hint in the index footer.

4. **Generate save report**:
   - Session duration
   - Items accomplished
   - Files modified
   - What was preserved
   - Memory bank health status

5. **Perform maintenance / compaction (canonical policy)**:
   - **Trigger:** runs at `/session-end` (and `/sync`), **guarded by size** — only compact when a file is large (~5000 tokens / ~50KB).
   - **`sessionHistory.md`:** keep a rolling **30-day** window; move older entries to `.ai/memory/archive/sessionHistory-<YYYY-Qn>.md`. **Keep their index rows** in `index.md`, but repoint each row's source to `archive/...`.
   - **`conventions.md`:** soft cap of ~50 patterns; prune/merge beyond that.
   - **`archive/`:** created lazily — only when there is something to archive.

### Concurrency (write-lock)

All memory writes in this protocol happen under the write-lock `.ai/runtime/locks/memory.lock` — acquire it before allocating `M-NNNN` ids and writing, release it after. In `/parallel` mode, workers only record to their handoff; the **orchestrator** (not the workers) folds those handoff entries into the bank sequentially under the lock. See the **memory-manager** agent for detail.

### Output Format

Use the format specified in memory-manager agent:
- Summary of what was saved
- Count of items (accomplished, decisions, files)
- Context preserved for next session
- Memory bank health metrics

---

## When to Use

- At the end of every work session
- When context window is getting full
- Before switching to different task/project
- When you want to preserve important decisions

---

**Tip**: Make this a habit! Your future self (and future AI) will thank you. 💾
