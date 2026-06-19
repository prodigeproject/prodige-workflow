# BOOT

Every AI window must read this first.

> **Entry point:** Tools reach this file via `AGENTS.md` at the repo root (the universal,
> tool-agnostic entry). `AGENTS.md` is a thin router; **this file is the spec** — obey it.

## Mandatory startup sequence

1. Read `README.md`.
2. Read `.ai/SOUL.md`.
3. **🆕 Load Memory Bank (PRIORITY):**
   - `.ai/memory/activeContext.md` - Current session state
   - `.ai/memory/projectContext.md` - Project identity
   - `.ai/memory/progress.md` - Task tracking
4. **🆕 Read Boundaries (IMPORTANT):**
   - `.ai/boundaries/README.md` - Out-of-scope items
   - Understand what Prodige will NOT do
5. Read `.ai/orchestrator/ORCHESTRATOR.md`.
6. Read `.ai/context/manifest.json`.
7. **Load global behavioral skills (MANDATORY):**
   - `.ai/skills/clean-code/SKILL.md`
   - `.ai/skills/efficient-communication/SKILL.md` (Clear, concise responses)
   - **Note:** Command-scoped skills (TDD, verification-before-completion, systematic-debugging, etc.) are auto-loaded per command by the orchestrator via the skill-selection matrix.
8. Load relevant context **if populated** (these files ship as templates):
   - `.ai/context/PROJECT.md`
   - `.ai/context/PRD.md`
   - `.ai/context/ARCHITECTURE.md`
   - `.ai/context/IMPLEMENTATION.md`
   - `.ai/context/CONTEXT.md` (NEW) - Domain glossary if exists
   - `.ai/context/docs/adr/*.md` (NEW) - Architecture Decision Records if exist
   - **Placeholder-aware:** Treat any unfilled `[bracket]` placeholder as empty. Load only real, populated facts; never hallucinate state from template scaffolding.
9. Load state **if populated** (these files ship as templates):
   - `.ai/state/CURRENT.md`
   - `.ai/state/SPRINT.md`
   - `.ai/state/BACKLOG.md`
   - `.ai/state/STATUS.md`
   - **Placeholder-aware:** Treat any unfilled `[bracket]` placeholder as empty (no hallucinated state).
10. Check runtime:
   - active sessions
   - current snapshot
   - locks
   - cache status
   - **🆕 verification status**
11. Route user command through command registry.
12. Select workflow and skills automatically.
13. Follow HITL gates.
14. **Apply engineering behavioral principles at all stages.**

## Critical rules

### Structural Rules (Prodige)
- **🆕 Start sessions with `/session-start`** - Load memory bank context
- **🆕 End sessions with `/session-end`** - Save progress to memory
- Do not code before design approval for major features.
- Do not invent missing project facts.
- **🆕 Respect boundaries** - Check .ai/boundaries/ before attempting operations.
- **🆕 Use CONTEXT.md vocabulary consistently** - Domain terms must match glossary.
- Mark unknowns clearly.
- Use cache before reading large files.
- Use snapshot for multi-window work.
- **🆕 Create checkpoints before risky operations** - Use `/checkpoint`
- Update context when major decisions change.
- **🆕 Create ADR for hard-to-reverse architectural decisions** - Use `.ai/context/docs/adr/*.md` format.
- **🆕 Update CONTEXT.md when new domain terms are introduced** - Maintain glossary.
- **🆕 Update memory bank when learning patterns** - Invoke memory-manager
- Update debt registry when debt is found or created.
- **🆕 Run `/verify` before completion** - Quality is mandatory

### Behavioral Rules (behavioral)
- **Think Before Coding:** Ask questions, don't assume. Present tradeoffs.
- **Simplicity First:** Minimum code. No speculative features. No premature abstraction.
- **Surgical Changes:** Only touch task-related files. No drive-by refactoring.
- **Goal-Driven:** Define verifiable success criteria for every step.

### Quality Enforcement Rules
- **🆕 TDD Mandatory:** Write failing test FIRST, always. Code before test = DELETE code.
- **🆕 Verification Required:** No "done" without evidence (command + output + result).
- **🆕 Systematic Debugging:** Root cause FIRST, then fix. No random attempts.
- **🆕 3-Strike Rule:** After 3 failed fixes, escalate to Architect (don't attempt #4).

## Skill Auto-Loading Matrix (illustrative)

> **Source of truth:** `.ai/skills/skill-selection-matrix.json`. The table below is
> illustrative only — when it disagrees with the matrix JSON, the JSON wins.

| Command | Auto-Loaded Skills |
|---------|-------------------|
| `/build` | test-driven-development, verification-before-completion |
| `/fix` | systematic-debugging, test-driven-development, verification-before-completion |
| `/refactor` | test-driven-development, verification-before-completion |
| ALL commands | verification-before-completion (universal gate) |

**Skills Location:** `.ai/skills/`

**Note:** Only the 2 global skills (clean-code, efficient-communication) are loaded at boot. All other skills are command-scoped — the orchestrator auto-loads them per command via the skill-selection matrix. Agents don't choose; skills are mandatory protocols.


## Phase 2-5 Skills (Now Active)

**Phase 2: Design Enhancement**
- brainstorming (Socratic design exploration)
- implementation-planning (detailed implementation plans)

**Phase 3: Execution Enhancement**
- subagent-driven-development (automated task dispatch)
- executing-plans (fallback for non-subagent platforms)
- requesting-code-review (automated review)
- receiving-code-review (feedback handling)

**Phase 4: Parallel Work Safety**
- using-git-worktrees (workspace isolation)
- dispatching-parallel-agents (concurrent work)

**Phase 5: Workflow Completion**
- finishing-a-development-branch (branch completion)
- writing-skills (skill creation methodology)

**Status:** All phases active in the skill-selection matrix (`.ai/skills/skill-selection-matrix.json`, the source of truth). The list above is illustrative. ✅
