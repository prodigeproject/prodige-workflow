---
name: systematic-debugging
description: Disciplined 6-phase debugging for hard bugs, performance regressions, and systematic root cause analysis. Build feedback loop → reproduce → analyze → hypothesize → fix → cleanup. Mandatory for all bug fixes. Use when debugging, fixing bugs, or investigating failures.
triggers: [debug, fix bug, investigate, troubleshoot, root cause, systematic debugging]
auto_load: [fix]
mandatory: true
applies_to: [backend, frontend, qa, architect]
---

# Systematic Debugging: 6-Phase Protocol

Fix the root cause, not the symptom. No guessing. No shortcuts.

**The Iron Law**: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

> **Canonical skill.** Single source of truth for debugging in Prodige. Merges the
> Superpowers `systematic-debugging` material with the Prodige-synthesized 6-phase
> `diagnose` protocol (Matt Pocock). The former `diagnose` skill is now an alias.
> Not to be confused with the `/diagnose` **command**, which is a project health check.

---

## The Protocol

```
Phase 1: BUILD FEEDBACK LOOP  ← This is THE skill
Phase 2: REPRODUCE            ← Confirm exact symptom
Phase 3: ROOT CAUSE ANALYSIS  ← Gather evidence systematically
Phase 4: HYPOTHESIZE          ← 3-5 ranked, falsifiable predictions
Phase 5: FIX + REGRESSION     ← TDD, minimal change
Phase 6: CLEANUP & POST-MORTEM ← Document and improve
```

**Key insight**: Phase 1 (feedback loop) is 90% of debugging. Everything else is mechanical.

---

## Quick Start

### When Bug is Reported

```
1. DON'T jump to fixes
2. DON'T guess root cause
3. DO build fast feedback loop (Phase 1)
4. DO follow all 6 phases in order
```

### Red Flags - STOP and Follow Process

Catch yourself thinking:
- "Quick fix for now" → **NO. Phase 1 first.**
- "Just try changing X" → **NO. Hypothesis first (Phase 4).**
- "I see the problem" → **Maybe. Verify with Phase 1-3.**
- "Skip the test" → **NO. TDD mandatory (Phase 5).**
- "One more attempt" (after 2 fails) → **NO. Question architecture.**

---

## Phase 1: Build Feedback Loop

**This is the skill.** Everything else consumes this signal.

Fast, deterministic, agent-runnable pass/fail signal = bug is 90% fixed.

### Goal

Agent can run a command/script that:
- Takes < 5 seconds
- Returns clear pass/fail
- Reproduces bug reliably (deterministic or high rate)
- Runs without human intervention

### 10 Ways to Build Feedback Loop

**Try in this order**:

1. **Failing test** at any seam (unit/integration/e2e)
2. **Curl / HTTP script** against dev server
3. **CLI invocation** with fixture, diff against snapshot
4. **Headless browser** (Playwright/Puppeteer) with assertions
5. **Replay captured trace** (request/payload/event log)
6. **Throwaway harness** (minimal system subset)
7. **Property/fuzz loop** (1000 random inputs, find failure)
8. **Bisection harness** (`git bisect run` automation)
9. **Differential loop** (old vs new version, diff outputs)
10. **HITL bash script** (structured human-in-loop as last resort)

**Be aggressive. Be creative. Refuse to give up.**

→ See [PHASE1-FEEDBACK-LOOP.md](./PHASE1-FEEDBACK-LOOP.md) for detailed strategies

### Iterate the Loop Itself

Once you have **a** loop, make it **better**:

- **Faster?** Cache setup, skip unrelated init, narrow scope
- **Sharper signal?** Assert specific symptom, not "didn't crash"
- **More deterministic?** Pin time, seed RNG, isolate filesystem

**30-second flaky loop** = barely useful  
**2-second deterministic loop** = debugging superpower

### Non-Deterministic Bugs

Goal: Raise reproduction rate until debuggable.

- Loop trigger 100×
- Parallelize
- Add stress
- Narrow timing windows
- Inject sleeps

**50% flake** = debuggable  
**1% flake** = not debuggable

→ See [condition-based-waiting.md](./condition-based-waiting.md) for race/timing bugs.

### Cannot Build Loop?

**STOP. Say so explicitly.**

List what you tried. Ask user for:
- Access to reproducing environment
- Captured artifact (HAR, logs, core dump, screen recording)
- Permission for production instrumentation

**Do NOT proceed to Phase 2 without a loop.**

---

## Phase 2: Reproduce

Run the loop. Watch the bug appear.

### Verify

- [ ] Failure matches **user's** description (not a different bug)
- [ ] Reproducible across multiple runs (or high rate)
- [ ] Exact symptom captured (error message, wrong output, timing)

**Cannot reproduce? Gather more data. Don't guess.**

---

## Phase 3: Root Cause Analysis

Systematic evidence gathering. No assumptions.

### 1. Read Error Messages Carefully

Extract every detail: error type, location (file, line), stack trace, context values.

### 2. Check Recent Changes

```bash
git log --oneline -10
git log --oneline -- path/to/file
git diff HEAD~1
git bisect start  # Find introducing commit
```

### 3. Trace Data Flow

Follow values backward from error point:
- Where does failing value originate?
- What transforms it along the way?
- Which step introduces the problem?

→ See [root-cause-tracing.md](./root-cause-tracing.md) for tracing strategy.

### 4. Gather Multi-Component Evidence

Add diagnostic logging at EACH boundary (frontend props/state, backend request/response per layer, database query inputs/results). **Run once, analyze which layer fails.**

### 5. Check Dependencies

Services running? Correct versions? Config correct? Network accessible?

→ See [INSTRUMENTATION.md](./INSTRUMENTATION.md) for logging strategies.

---

## Phase 4: Hypothesize

Generate **3-5 ranked hypotheses** before testing ANY.

### Format

Each hypothesis must be **falsifiable**:

```
IF <X> is the cause,
THEN <changing Y> will make bug disappear
   OR <changing Z> will make it worse
```

**Can't state prediction? Discard or sharpen hypothesis.**

### Checkpoint with User

**Show ranked list to user BEFORE testing.** They may have ruled one out or know a recent change that re-ranks instantly. **Don't block** - proceed if user AFK.

→ See [HYPOTHESIS-GUIDE.md](./HYPOTHESIS-GUIDE.md) for formation strategies.

---

## Phase 5: Fix + Regression Test

Write regression test FIRST, then fix (uses `test-driven-development`).

### 1. Write Failing Test (TDD RED)

```typescript
test('handles duplicate email gracefully', async () => {
  await createUser({ email: 'test@example.com' });
  const result = await createUser({ email: 'test@example.com' });
  expect(result.status).toBe(409);
  expect(result.error).toBe('Email already exists');
});
```

**Run and watch it FAIL** - confirms bug exists.

### 2. Apply Minimal Fix (TDD GREEN)

Address root cause from Phase 3-4. **ONE change. No bundled improvements.**

### 3. Verify (TDD GREEN)

```bash
npm test -- users.test.ts  # New test passes
npm test                   # All tests pass
```

### 4. Re-run Phase 1 Loop

Confirm original scenario (un-minimized) now works.

### If Fix Doesn't Work

- **Attempt 1 failed?** Return to Phase 3, re-analyze, new hypothesis.
- **Attempt 2 failed?** Return to Phase 1, question assumptions, gather evidence.
- **Attempt 3 failed?** **STOP.** Architecture problem (not bug). Escalate to Architect.

**Pattern indicating architecture issue**: each fix reveals new shared-state issue, each fix needs "massive refactoring", fixes conflict with existing patterns, system fights the fix. **Don't attempt fix #4.**

→ See [REGRESSION-TESTING.md](./REGRESSION-TESTING.md) and [defense-in-depth.md](./defense-in-depth.md).

---

## Phase 6: Cleanup + Post-Mortem

Required before claiming done:

- [ ] Original repro no longer reproduces (Phase 1 loop)
- [ ] Regression test passes (or lack of seam documented)
- [ ] All `[DEBUG-...]` instrumentation removed (`grep` the prefix)
- [ ] Throwaway prototypes deleted
- [ ] Hypothesis documented in commit/PR message

### Post-Mortem

**Ask: What would have prevented this bug?** If the answer involves no good test seam, tangled callers, hidden coupling, or architectural limitation → document as architecture debt and recommend **after** the fix is in.

---

## Integration with Prodige

### Auto-Loaded By
- `/fix` workflow (mandatory)

### Works With
- `test-driven-development` - For Phase 5 (fix implementation)
- `verification-before-completion` - For fix validation

### Updates
- `.ai/context/DECISIONS.md` - Documents root cause and lesson
- `.ai/context/CHANGELOG.md` - Records fix
- `.ai/governance/debt/architecture-debt.md` - If temporary fix

### Enforced By
- Quality gates - No fixes without Phase 1-3 complete
- Orchestrator - Verifies phase completion

---

## Agent-Specific Quick Guides

- **Backend** — Database connection, API errors, performance. Focus: service logs, query plans, middleware chains.
- **Frontend** — Component crashes, API integration, state bugs. Focus: props/state, loading states, async handling.
- **QA** — Flaky tests, cross-browser, E2E failures. Focus: test isolation, timing, environment setup.

---

## Verification Checklist

Before claiming bug is fixed:

- [ ] Phase 1: Feedback loop built and validated
- [ ] Phase 2: Bug reproduced reliably
- [ ] Phase 3: Root cause identified with evidence
- [ ] Phase 4: Hypotheses ranked, user notified
- [ ] Phase 5: Failing test → fix → passing test
- [ ] Phase 6: Cleanup done, post-mortem documented
- [ ] Full test suite passes (no regressions)
- [ ] Original scenario works

**Can't check all boxes? You haven't completed diagnosis.**

---

## Final Rule

```
Symptom fix = Wrong fix
Root cause fix = Right fix

Follow the 6 phases. No exceptions without human approval.
```

---

**Related Skills**: test-driven-development, verification-before-completion, clean-code  
**Enforcement**: Mandatory via `/fix` workflow  
**Version**: 3.0 (Merged: Superpowers systematic-debugging + Prodige `diagnose` + Matt Pocock)
