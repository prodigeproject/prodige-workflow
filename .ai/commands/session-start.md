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
1. Read all 6 memory files:
   - `projectContext.md` - Project identity
   - `activeContext.md` - Current state
   - `progress.md` - Task tracking
   - `decisionLog.md` - Decisions made
   - `conventions.md` - Patterns learned
   - `sessionHistory.md` - Past sessions

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

If memory files don't exist or are empty:

```markdown
📚 Memory Bank Not Initialized

This appears to be the first session or memory bank is empty.

Would you like to:
1. Initialize memory bank (`/memory-init`)
2. Continue without memory (not recommended)

Recommendation: Run `/memory-init` first to set up context.
```

---

**Tip**: Always start your session with `/session-start` to load context!
