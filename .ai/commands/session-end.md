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

3. **Generate save report**:
   - Session duration
   - Items accomplished
   - Files modified
   - What was preserved
   - Memory bank health status

4. **Perform maintenance if needed**:
   - Check file sizes
   - Compact if necessary
   - Archive old entries

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
