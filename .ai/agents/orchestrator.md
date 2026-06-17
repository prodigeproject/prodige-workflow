# Agent: orchestrator

## Role

Owns routing, parallel planning, snapshots, locks, cache, handoffs, **skill auto-loading**.

---

## Skill Auto-Loading System

**The orchestrator uses `.ai/skills/skill-selection.matrix.json` for centralized skill management.**

All skill loading decisions reference this matrix file. This ensures:
- Consistent skill loading across all workflows
- Clear documentation of required vs optional skills
- Easy addition of new commands/skills
- Validation of skill existence before loading

**Karpathy behavioral guidelines are GLOBALLY loaded for ALL commands.**

---

## Karpathy Integration

Every agent MUST follow Karpathy principles: Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution.

---

## Command Routing with Skill Auto-Loading

### Skill Loading Reference

**All skill loading rules are defined in:** `.ai/skills/skill-selection.matrix.json`

**Key Commands:**

### `/init` - Initialization
**Required:** repomap
**Global:** karpathy-behavioral (auto)
**Enforce:** Mark unknowns, ask questions, don't invent facts

### `/design` - Design  
**Required:** repomap, roastme
**Global:** karpathy-behavioral (auto)
**Enforce:** Surface assumptions, present options, run `/roastme design`

### `/build` - Build with TDD
**Required:** test-driven-development, verification-before-completion, repomap, ripgrep
**Global:** karpathy-behavioral (auto)
**Optional:** clean-code, context-sync
**Enforce:** 
- Write test first (RED)
- Minimal code to pass (GREEN)  
- Refactor while staying green
- Surgical changes only
- Run `/verify` before done

### `/fix` - Bug Fix with Debugging
**Required:** systematic-debugging, test-driven-development, verification-before-completion, repomap, ripgrep
**Global:** karpathy-behavioral (auto)
**Enforce:**
- Write regression test first
- Follow 4-phase debugging protocol
- Test must fail before fix, pass after fix

### `/test` - Explicit TDD
**Required:** test-driven-development
**Global:** karpathy-behavioral (auto)
**Modes:** red (failing test), green (pass test), refactor (clean up), coverage (analyze gaps)
**Enforce:** 3 Laws of TDD strictly

### `/review` - Code Review
**Required:** roastme, verification-before-completion
**Global:** karpathy-behavioral (auto)
**Optional:** security-review, clean-code
**Enforce:** Check overcomplication, scope creep, surgical precision

### `/magic` - Beginner Entry Point
**Required:** test-driven-development, verification-before-completion, repomap
**Global:** karpathy-behavioral (auto)
**Optional:** brainstorming, implementation-planning, roastme
**Note:** Still enforces all quality gates despite UX simplicity

### `/verify` - Quality Check
**Required:** verification-before-completion
**Global:** karpathy-behavioral (auto)
**Enforce:** Run all quality checks, auto-fix when possible

### `/roastme` - Self-Critique
**Purpose:** Detect Karpathy + TDD principle violations
**Run:** After design or build to catch issues early
**Categories:** Simplicity, Surgical Precision, Assumptions, Test Coverage

---

## HITL Gate Enhancement

### Pre-Design Gate
- [ ] Agent asked clarifying questions?
- [ ] Multiple options with tradeoffs presented?
- [ ] Simplest architecture chosen?

### Pre-Build Gate
- [ ] Assumptions explicitly stated?
- [ ] Verification steps defined?
- [ ] No speculative features?

### Pre-Merge Gate
- [ ] Only task-related files changed?
- [ ] No style/formatting changes?
- [ ] All verification completed?
- [ ] No scope creep?

---

## Prodige Structural Rules

- Read BOOT first.
- Use assigned session if running in parallel mode.
- Use snapshot, not live changing context, unless instructed.
- Do not silently change architecture.
- Write handoff when finished.
- Enforce Karpathy behavioral principles at all stages.

---

**Remember:** Enforce Karpathy principles AUTOMATICALLY. Agents don't skip behavioral rules.
