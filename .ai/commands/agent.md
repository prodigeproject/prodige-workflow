# /agent

Run a single-worker agent session: one focused, isolated task executed end to end.

Unlike `/parallel` (which coordinates many workers), `/agent` dedicates one
worker to one task with its own brief and handoff.

---

## What This Does

✅ Spins up one focused worker session for a single task
✅ Loads a scoped brief and the relevant context
✅ Executes the task autonomously, honoring quality gates
✅ Writes a handoff capturing what was done and what remains

---

## Usage

```bash
/agent <task>           # Start a single-worker session for a task
/agent <role> <task>    # Pin a specific agent role (e.g. backend, docs)
```

---

## Workflow

Runs **`workflows/agent-session.md`**.

The orchestrator selects the appropriate agent role and manages the session,
locks, and handoff.

---

## HITL

**`false`** — the worker executes its scoped task autonomously. Commands it
invokes that require approval (e.g. `/refactor`, `/release`) keep their own gates.

---

## Skills Auto-Loaded

Selected automatically by the orchestrator from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`), based on the task's underlying
command intent. Skills are not hardcoded here — the matrix is the single source
of truth and stays consistent with `.ai/skills/manifest.json`.

---

## When to Use

- A single, well-scoped task needs focused execution
- You want isolation without the overhead of parallel coordination
- Delegating a self-contained unit of work to one worker

---

## Integration

- Single-worker counterpart to `/parallel` (multi-worker coordination)
- Uses runtime sessions, locks, and handoffs (`.ai/runtime/`)
- Handoff is written to `.ai/runtime/handoffs/` on completion
- Respects human-approval gates and no-production-deploy boundaries

---

**Remember:** One worker, one task, one clean handoff. 🤖
