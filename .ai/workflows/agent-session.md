# Workflow: Agent Session

## Purpose
Run a single worker-agent session end to end: load just enough context, pick up one
scoped task, work surgically with TDD, verify, and write a clean handoff. Pairs with
`commands/agent.md`.

**Core principle:** Stay in scope. One agent, one task, one handoff. Touch only what the
task requires.

---

## Steps

### 1. Boot and Load Context

**Load the minimum context needed for the task:**
- Read `BOOT.md` (or project boot entry point) to orient.
- Read relevant `.ai/context/` files only:
  - `.ai/context/PRD.md` — requirements, constraints, open questions
  - `.ai/context/ARCHITECTURE.md` — architecture, tech stack, dependencies, patterns
  - `.ai/context/DECISIONS.md` — past tradeoffs (if relevant)
- Skim cache (`.ai/runtime/cache/`) for the repo map instead of re-reading the whole codebase.

**Rule:** Load what the task needs, nothing more. Avoid loading the entire context.

### 2. Pick Up the Scoped Task

**Identify the single task for this session:**
- From a `/parallel` handoff: read the assigned session file
  (`.ai/runtime/sessions/[stream-name].md`) and its snapshot + `locks.md`.
- From a plan: read the relevant phase in `.ai/context/IMPLEMENTATION.md`.

**Confirm scope before touching code:**
- Files to create/modify (in scope)
- Files to NOT touch (out of scope / locked)
- Acceptance criteria and dependencies

**If scope is unclear or blocked:** record it in the handoff and stop — do not guess.

### 3. Work Surgically with TDD

**Implement the task incrementally:**
- Write the failing test first (RED).
- Write the minimal code to pass (GREEN).
- Refactor while keeping tests green.
- Repeat per small unit, in dependency order.

**Stay surgical:**
- Only modify files in your task scope.
- Never modify locked files — note the needed change in the handoff instead.
- No drive-by refactoring, no style-only changes, no scope creep.

**Skill:** `test-driven-development`, `clean-code` (surgical precision)

### 4. Verify

**Run the full verification suite before handoff:**
```bash
npm test        # all tests, not just new ones
npm run lint
npm run build
```
- All tests pass, no new lint or type errors, build succeeds.
- Review your diff: every changed line traces to the task.

**If anything fails:** fix it before writing the handoff. Do not hand off red.

**Skill:** `verification-before-completion`

### 5. Write the Handoff

**Record the result so the next agent/main window can pick up cleanly:**
- For a `/parallel` stream: fill `.ai/runtime/handoffs/[stream-name]-handoff.md`.
- Otherwise write a short handoff covering:
  - Files created/modified and why
  - Tests written and pass status
  - Acceptance criteria met / blocked (with reason)
  - Locked-file changes needed (if any)
  - Next steps and merge notes

**Notify completion:** "Session complete, ready for review."

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Minimal context** | Load only what the task needs | No whole-codebase reload |
| **One scoped task** | Single responsibility per session | Clear in/out of scope |
| **Surgical TDD** | Test-first, smallest change | Clean diff, RED→GREEN evidence |
| **Verify before handoff** | Never hand off red | Full suite green |
| **Clean handoff** | Next agent can continue | Handoff complete |

---

## Red Flags - STOP

- Loading entire context instead of task-relevant files
- Working without a clearly scoped task
- Modifying locked or out-of-scope files
- Skipping tests or verification
- Handing off with failing tests or no handoff written

**If you see these:** STOP. Re-confirm scope and verify before continuing.

---

## Integration Points

**Context Files:**
- Reads: `.ai/context/PRD.md`, `.ai/context/ARCHITECTURE.md`, `.ai/context/DECISIONS.md`
- Reads: `.ai/runtime/sessions/*`, snapshots, `locks.md` (for handoff pickup)
- Writes: `.ai/runtime/handoffs/[stream-name]-handoff.md` (or session handoff notes)

**Skills:**
- `test-driven-development` - RED-GREEN-REFACTOR (Step 3)
- `clean-code` - Surgical precision (Steps 2, 3)
- `verification-before-completion` - Verify before handoff (Step 4)

**Commands:**
- `/agent` - Triggers this workflow (`commands/agent.md`)

**Workflows:**
- `parallel.md` - Dispatches scoped sessions to worker agents
- `build.md` - Full feature build (this is the single-session variant)
- `review.md` - Reviews the handoff after the session completes

---

**Remember:** A worker session is one focused unit of work. Load light, stay in scope,
test-drive, verify, and hand off clean.
