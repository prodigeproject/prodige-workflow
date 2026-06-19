# Memory Bank System

## Purpose

The Memory Bank provides **persistent context across AI sessions**, solving the "20-minute re-explanation problem" where developers had to re-brief the AI at the start of each conversation.

---

## Memory vs Context: Clear Hierarchy

### `.ai/memory/` - Session State (Ephemeral)

**Owner:** memory-manager agent  
**Lifespan:** Current development session (hours to days)  
**Purpose:** Track active work, progress, session-specific learnings  
**Update Frequency:** Every session start/end

**Files:**

*Index (read FIRST):*
- `index.md` - **Searchable index of all entries (owner: memory-manager; read this FIRST, see below)**

*Indexed historical files (entries carry `### M-NNNN — <topic>` anchors):*
- `sessionHistory.md` - Rolling log of recent sessions
- `decisionLog.md` - Recent technical decisions (not yet formalized)
- `conventions.md` - Learned patterns specific to this project's style
- `progress.md` - Task completion status

*Current-state files (read directly, NOT indexed, no anchors):*
- `activeContext.md` - What you're currently working on
- `projectContext.md` - Quick project identity reference

*Other memory assets:*
- `review-patterns.json` - Review heuristics (owner: **review-learning** skill, updated by `.ai/scripts/update-review-patterns.js` — NOT memory-manager)
- `lessons/` - Durable lessons (owner: memory-manager; read by project-history)
- `patterns/` - Reusable patterns (owner: memory-manager; read by project-history)

**When to use:**
- Session continuity (resume work after break)
- Track daily/weekly progress
- Remember informal decisions
- Learn team-specific patterns

---

## Token-Efficient Retrieval (3-Layer)

**Do not read every memory file in full.** The Memory Bank grows over time; loading it all wastes ~8-20k tokens per session. Use the `memory-search` skill instead:

```
1. Read index.md            → scan entry table (id, date, type, topic)
2. Filter to relevant IDs   → discard the rest
3. Fetch only those entries → jump to the M-NNNN anchor in the source file
```

- `index.md` keeps one line per entry (~10-30 tokens each).
- Each full historical entry (`sessionHistory.md`, `decisionLog.md`, `conventions.md`, `progress.md`) lives in its source file under a `### M-NNNN — <topic>` anchor.
- `activeContext.md` and `projectContext.md` are small current-state files — read them directly; they are not indexed and carry no anchors.
- The index is maintained automatically at `/session-end` (memory-manager). If it drifts, rebuild it per the instructions in `index.md`.

This mirrors the "filter before fetch" discipline of search-backed memory systems, but stays pure-markdown and git-trackable (no runtime, no database required).

---

### `.ai/context/` - Formal Documentation (Permanent)

**Owner:** Architect, designer, reviewer  
**Lifespan:** Permanent project documentation  
**Purpose:** Approved architectural decisions, requirements, implementation plans  
**Update Frequency:** Major milestones, after HITL approval

**Files:**
- `PROJECT.md` - Project identity, vision, scope
- `PRD.md` - Product requirements
- `ARCHITECTURE.md` - System design and data flow
- `IMPLEMENTATION.md` - Technical implementation plan
- `DECISIONS.md` - Formal Architecture Decision Records (ADRs)
- `CHANGELOG.md` - Project-level changes
- `manifest.json` - Versions and approval status

**When to use:**
- Design phase approval
- Architecture documentation
- Formal decision recording
- Release documentation

---

## Relationship & Sync Protocol

### Hierarchy

```
Context (Permanent, Formal) > Memory (Ephemeral, Informal)
```

**Rule:** If conflict exists, **context files take precedence**.

### Promotion Path

```
Informal decision (memory/decisionLog.md) 
  → Discussion & approval (HITL) 
  → Formal ADR (context/DECISIONS.md)
```

### Sync Protocol

**On Session Start:**
1. Load memory bank (current state)
2. Load context files (permanent docs)
3. If conflict detected → Flag for human review

**On Session End:**
1. Save current progress to memory/progress.md
2. Save learnings to memory/conventions.md
3. If major decision made → Prompt to update context/DECISIONS.md

**Weekly:**
1. Review memory/decisionLog.md
2. Promote significant decisions to context/DECISIONS.md
3. Clear resolved items from memory

---

## Commands

### Session Management
- `/session-start` - Load memory bank, resume work
- `/session-end` - Save progress, capture learnings

### Memory Updates (Automatic)
- memory-manager agent updates memory files during workflow
- No manual editing required (but allowed)

### Context Updates (Manual + HITL)
- Context files require human approval before changes
- Use `/design`, `/build`, `/review` workflows to update
- Architect agent owns context integrity

---

## File Responsibilities

| File | Owner Agent | Update Trigger | Approval Required |
|------|-------------|----------------|-------------------|
| memory/index.md | memory-manager | Session end / entry recorded | No |
| memory/sessionHistory.md (indexed) | memory-manager | Session end | No |
| memory/decisionLog.md (indexed) | memory-manager | Decision made | No |
| memory/conventions.md (indexed) | memory-manager | Pattern learned | No |
| memory/progress.md (indexed) | memory-manager | Task completion | No |
| memory/activeContext.md (current-state, not indexed) | memory-manager | Session start/end | No |
| memory/projectContext.md (current-state, not indexed) | memory-manager | Session start | No |
| memory/review-patterns.json | review-learning (skill) | `.ai/scripts/update-review-patterns.js` | No |
| memory/lessons/ | memory-manager | Durable lesson captured (read by project-history) | No |
| memory/patterns/ | memory-manager | Reusable pattern captured (read by project-history) | No |
| context/PROJECT.md | architect | Project init | Yes (HITL) |
| context/PRD.md | architect | Design phase | Yes (HITL) |
| context/ARCHITECTURE.md | architect | Design phase | Yes (HITL) |
| context/IMPLEMENTATION.md | architect | Design phase | Yes (HITL) |
| context/DECISIONS.md | architect | Major decision | Yes (HITL) |
| context/CHANGELOG.md | reviewer | Merge/release | Yes (HITL) |
| context/manifest.json | orchestrator | Version change | Auto |

---

## Best Practices

### DO:
✅ Use memory for day-to-day work tracking
✅ Use context for approved formal documentation
✅ Promote significant decisions from memory to context
✅ Run `/session-start` at beginning of each work session
✅ Run `/session-end` when taking breaks or ending day
✅ Review memory/conventions.md monthly for formalization

### DON'T:
❌ Put formal ADRs directly in memory
❌ Skip session-start/end commands (lose continuity)
❌ Edit manifest.json manually
❌ Store secrets in memory or context files
❌ Bypass HITL gates for context updates

---

## Migration Guide

### For Existing Projects (Already Using Context)

**Step 1:** Initialize memory bank
```
/session-start
```

**Step 2:** Memory-manager will ask:
- What are you currently working on?
- What's your current task?
- Any recent decisions not yet documented?

**Step 3:** Continue working normally
- Memory bank updates automatically
- Context files remain unchanged

**Step 4:** At end of session
```
/session-end
```

### For New Projects

**Step 1:** Initialize project
```
/init
```

**Step 2:** This creates both memory/ and context/ folders

**Step 3:** Start first session
```
/session-start
```

---

## Troubleshooting

### Issue: Memory and context conflict
**Diagnosis:** Check dates - which is newer?
**Fix:** Context takes precedence, update memory to match

### Issue: Memory files stale
**Diagnosis:** Check sessionHistory.md - last session date
**Fix:** Run `/session-start` to refresh

### Issue: Lost session continuity
**Diagnosis:** Forgot to run /session-end
**Fix:** Manually update progress.md with what was done

---

## Technical Details

### Storage Format
- All files are Markdown for human readability
- Structured sections for programmatic parsing
- Git-trackable (can see history)

### Size Management (Compaction Policy)

One compaction policy, triggered at `/session-end` and `/sync`, guarded by size (~5000 tokens / ~50KB):

- **sessionHistory.md**: rolling 30-day window. Older entries move to `.ai/memory/archive/sessionHistory-<YYYY-Qn>.md`. **Keep their index rows**, but set each row's `source_file` to `archive/...`.
- **conventions.md**: soft cap of ~50 patterns (oldest pruned).
- **archive/**: created lazily (only when the first archive write happens).

### Performance
- Memory files loaded in <100ms
- No impact on workflow speed
- Files kept small (<50KB each)

---

## References

- Implementation: See `/session-start` and `/session-end` commands
- Agent: See `memory-manager.md` agent documentation
- Philosophy: Part of the v2.0 UX & governance hybrid (see CHANGELOG.md)

---

**Last Updated:** 2026-06-17  
**Version:** 2.0.0  
**Status:** Production Ready
