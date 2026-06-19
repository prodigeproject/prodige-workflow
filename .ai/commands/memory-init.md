# /memory-init

Initialize (scaffold) the Memory Bank for this project.

Run this once, the first time a project uses Prodige — or whenever `/session-start` reports the
Memory Bank is uninitialized (files contain only `[bracketed]` placeholders).

---

## What This Does

1. Creates any missing Memory Bank files in `.ai/memory/`.
2. Initializes the index with zero entries and `Next ID: M-0001`.
3. Seeds `projectContext.md` from `/init` context (PROJECT/PRD/ARCHITECTURE) if available.
4. Leaves `activeContext.md` / `progress.md` as empty current-state files (no fabricated history).

It never overwrites an already-populated Memory Bank — if real entries exist, it reports and stops.

---

## Instructions

Invoke the **memory-manager** agent to execute the init protocol:

### Tasks

1. **Detect state.** Treat a file as uninitialized if it is missing or still contains only
   `[bracket]` placeholders. If real (non-placeholder) entries already exist, STOP and report
   "Memory Bank already initialized" — do not clobber.

2. **Create the canonical files** (per `.ai/memory/README.md` ownership table) if missing:
   - Index: `index.md` (empty table, footer `Next ID: M-0001`).
   - Indexed historical files (entries carry `### M-NNNN — <topic>` anchors):
     `sessionHistory.md`, `decisionLog.md`, `conventions.md`, `progress.md`.
   - Current-state files (read directly, no anchors): `activeContext.md`, `projectContext.md`.
   - Subfolders: `lessons/`, `patterns/` (with `.gitkeep`).
   - Do NOT create `review-patterns.json` — it is owned by the `review-learning` skill.

3. **Seed `projectContext.md`** from `.ai/context/PROJECT.md` / `PRD.md` / `ARCHITECTURE.md`
   if those exist (project name, purpose, tech stack). Otherwise leave the template placeholders.

4. **Report**:
   ```markdown
   📚 Memory Bank Initialized

   Created: [list of files created]
   Index:   Next ID = M-0001 (no entries yet)
   Seeded:  projectContext.md [from /init context | left as template]

   Next: run `/session-start` to begin, and `/session-end` to capture this session.
   ```

---

## When to Use

- First session on a new project.
- When `/session-start` detects an empty/placeholder Memory Bank.
- After accidental deletion of memory files (recovery — re-scaffold, then restore from git if possible).

---

## Related

- `.ai/agents/memory-manager.md` — the agent that owns and writes the Memory Bank.
- `.ai/commands/session-start.md` / `.ai/commands/session-end.md` — the everyday loop.
- `.ai/memory/README.md` — file inventory, ownership, and lifecycle policy.

---

**Tip**: You only need `/memory-init` once. After that it's `/session-start` → work → `/session-end`.
