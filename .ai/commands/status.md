# /status

Report the current project state: phase, active work, and outstanding items.

A fast snapshot to orient yourself at any point in a session. It reads the canonical
state files, then refreshes the `.ai/state/STATUS.md` snapshot and `.ai/state/CURRENT.md`.

---

## What This Does

✅ Summarizes current phase and active sessions
✅ Reports progress against the sprint and backlog
✅ Surfaces open items: locks, handoffs, pending reviews
✅ Highlights recent changes and next suggested actions
✅ Refreshes the `.ai/state/STATUS.md` snapshot and updates `.ai/state/CURRENT.md`

---

## Usage

```bash
/status                 # Full project status snapshot
/status --short         # One-line summary
```

---

## Workflow

Runs **`workflows/status.md`**.

Reads from `.ai/state/` (CURRENT, SPRINT, BACKLOG, STATUS) and runtime metadata.
Writes the refreshed snapshot to `.ai/state/STATUS.md` and updates `.ai/state/CURRENT.md`.
State files are the canonical project-state docs; the memory bank is session-ephemeral.

---

## HITL

**`false`** — status reports without requiring approval. The only writes it makes are
to the canonical state snapshot (`.ai/state/STATUS.md`) and the current-state pointer
(`.ai/state/CURRENT.md`); it does not modify code or context.

---

## Skills Auto-Loaded

Selected automatically by the orchestrator from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`). Status is primarily a state read,
so it loads only what the matrix specifies — no skills are hardcoded here.

---

## When to Use

- At the start of a session to orient
- Before deciding what to work on next
- After a break to recover context
- Before `/parallel` to confirm a clean state

---

## Integration

- Reads state maintained by `/sync` and the runtime system
- Complements `/diagnose` (health) and `/sync` (drift)
- Suggested next actions can route into `/design`, `/build`, or `/fix`

---

**Remember:** Check `/status` first — know where you stand before you move. 📊
