# /fix - Systematic Bugfix Workflow

## Purpose
Fix bugs using the 6-phase debugging protocol. No guessing, no shortcuts.

**The Iron Law**: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

## Prerequisites
- Bug description or error message
- Steps to reproduce (if available)
- Recent changes context (if known)

## Skills Auto-Loaded
- `.ai/skills/diagnose/SKILL.md` (MANDATORY - 6-phase protocol)
- `.ai/skills/tdd/SKILL.md` (for fix implementation)
- `.ai/skills/verification-before-completion.md` (for fix verification)

## 6-Phase Debugging Protocol

```
Phase 1: BUILD FEEDBACK LOOP  ← 90% of debugging work
Phase 2: REPRODUCE            ← Confirm exact symptom
Phase 3: ROOT CAUSE ANALYSIS  ← Gather evidence systematically
Phase 4: HYPOTHESIZE          ← 3-5 ranked, falsifiable predictions
Phase 5: FIX + REGRESSION     ← TDD, minimal change
Phase 6: CLEANUP & POST-MORTEM ← Document and improve
```

**Key Insight**: Phase 1 (feedback loop) is THE skill. Everything else is mechanical.

---

## Workflow

### Step 1: Load Diagnose Skill
```
Read .ai/skills/diagnose/SKILL.md
```

### Step 2: Phase 1 - Build Feedback Loop (CRITICAL)

**This is 90% of debugging.**

Build a fast, deterministic, agent-runnable pass/fail signal:
- Takes < 5 seconds
- Returns clear pass/fail
- Reproduces bug reliably
- Runs without human intervention

**10 Ways to Build Feedback Loop** (try in order):
1. Failing test at any seam (unit/integration/e2e)
2. Curl / HTTP script against dev server
3. CLI invocation with fixture, diff against snapshot
4. Headless browser (Playwright/Puppeteer) with assertions
5. Replay captured trace (request/payload/event log)
6. Throwaway harness (minimal system subset)
7. Property/fuzz loop (1000 random inputs, find failure)
8. Bisection harness (`git bisect run` automation)
9. Differential loop (old vs new version, diff outputs)
10. HITL bash script (structured human-in-loop as last resort)

**Be aggressive. Be creative. Refuse to give up.**

**Progressive Disclosure**: Load detailed strategies:
→ See `.ai/skills/diagnose/PHASE1-FEEDBACK-LOOP.md` for all 10 ways + iteration strategies

**Cannot build loop? STOP. Say so explicitly.** Ask user for help.

### Step 3: Phase 2 - Reproduce

Run the feedback loop. Watch the bug appear.

Verify:
- [ ] Failure matches user's description
- [ ] Reproducible across multiple runs (or high rate >50%)
- [ ] Exact symptom captured

**Cannot reproduce? Gather more data. Don't guess.**

### Step 4: Phase 3 - Root Cause Analysis

Systematic evidence gathering:

1. **Read error messages carefully** (full stack trace)
2. **Check recent changes** (`git log`, `git diff`, `git bisect`)
3. **Trace data flow** (backward from error point)
4. **Gather multi-component evidence** (boundary logging)
5. **Check dependencies** (services, versions, config)

**Progressive Disclosure**: Load instrumentation strategies:
→ See `.ai/skills/diagnose/INSTRUMENTATION.md` for tagged logging patterns

**DO NOT attempt fixes until root cause identified.**

### Step 5: Phase 4 - Hypothesize

Generate **3-5 ranked hypotheses** before testing ANY.

Each hypothesis must be **falsifiable**:
```
IF <X> is the cause,
THEN <changing Y> will make bug disappear
   OR <changing Z> will make it worse
```

**Checkpoint with user**: Show ranked list BEFORE testing (don't block if AFK).

**Progressive Disclosure**: Load hypothesis formation guide:
→ See `.ai/skills/diagnose/HYPOTHESIS-GUIDE.md` for IF-THEN format + ranking

### Step 6: Phase 5 - Fix + Regression Test (TDD)

**Write regression test FIRST, then fix:**

1. **RED**: Write failing test (reproduces bug)
2. **Verify**: Test fails (confirms bug exists)
3. **GREEN**: Apply minimal fix (root cause only)
4. **Verify**: Test passes, all tests pass
5. **Re-run Phase 1 loop**: Confirm original scenario works

**Progressive Disclosure**: Load test seam analysis:
→ See `.ai/skills/diagnose/REGRESSION-TESTING.md` for correct seam selection

**If Fix Doesn't Work:**

**Attempt 1 failed?**
- Return to Phase 3
- Re-analyze with new info
- Form new hypothesis

**Attempt 2 failed?**
- Return to Phase 1
- Question assumptions
- Gather more evidence

**Attempt 3 failed?**
- **STOP IMMEDIATELY**
- This is an architecture problem (not a bug)
- Escalate to Architect agent or human
- **DO NOT attempt fix #4**

**Pattern indicating architecture issue:**
- Each fix reveals new shared state issue
- Each fix needs "massive refactoring"
- Fixes conflict with existing patterns
- System fights against fix

**3-attempt limit is absolute. No exceptions.**

### Step 7: Phase 6 - Cleanup & Post-Mortem

Before claiming done:
- [ ] Original repro no longer reproduces (Phase 1 loop)
- [ ] Regression test passes
- [ ] All `[DEBUG-...]` instrumentation removed (grep the prefix)
- [ ] Throwaway prototypes deleted
- [ ] Hypothesis documented in commit/PR message
- [ ] Full test suite passes (no regressions)

**Post-Mortem: What would have prevented this bug?**

If answer involves architecture issues:
- Document for future improvement
- Make recommendation AFTER fix is in
- Update `.ai/governance/debt/architecture-debt.md` if temporary fix

### Step 8: Context Update

Update documentation:
- `.ai/context/DECISIONS.md` - Document root cause and lesson
- `.ai/context/CHANGELOG.md` - Record fix
- `.ai/governance/debt/technical-debt.md` - If temporary fix applied

Run `/sync` to verify context accuracy.

---

## HITL Gate
- **Conditional**: Complex bugs may need human approval before implementation
- **Mandatory**: If 3 attempts failed (architectural issue suspected)

---

## Example Usage

```
User: /fix Login button not working on mobile

Agent: Loading diagnose skill...

Phase 1: Build Feedback Loop (THE CRITICAL PHASE)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Building feedback loop...

Trying: Unit test for button click handler
Result: ✓ Fast (<1s), deterministic, reproduces issue

Feedback loop established:
  npm test -- LoginButton.test.tsx
  → FAIL: onClick not called on mobile viewport

Phase 2: Reproduce
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Running feedback loop:
  ✓ Desktop (1920px): Works
  ✗ Mobile (375px): Fails
  Reproducible: YES (100%)

Phase 3: Root Cause Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reading error:
  TypeError: Cannot read property 'click' of undefined
  at LoginButton.tsx:15

Recent changes:
  git log --oneline -- LoginButton.tsx
  - 2 days ago: "Add responsive design"
  
Tracing:
  Line 15: buttonRef.current.click()
  buttonRef: useRef attached to desktop button only
  Mobile: Desktop button hidden, separate mobile button has no ref
  
Root Cause Identified:
  Event handler attached to desktop button only.
  Mobile button exists but has no handler.

Phase 4: Hypothesize
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Hypothesis 1 (most likely):
IF handler missing from mobile button,
THEN adding handler to both buttons will fix it.

Hypothesis 2:
IF ref not attached to mobile button,
THEN attaching ref will enable click.

Hypothesis 3:
IF CSS hiding breaks events,
THEN visibility:hidden instead of display:none will work.

Proceeding with Hypothesis 1 (most direct).

Phase 5: Fix + Regression Test (TDD)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RED: Write failing test ✓
  describe('LoginButton mobile', () => {
    it('handles click on mobile viewport', () => {
      window.innerWidth = 375;
      const onClick = jest.fn();
      render(<LoginButton onClick={onClick} />);
      fireEvent.click(screen.getByRole('button'));
      expect(onClick).toHaveBeenCalled();
    });
  });

Verify RED:
  npm test -- LoginButton.test.tsx
  FAIL: onClick not called ✓

GREEN: Apply minimal fix
  // Before: handler only on desktop
  <button className="desktop-button" onClick={handleClick}>Login</button>
  <button className="mobile-button">Login</button>
  
  // After: shared component with handler
  const ButtonView = ({ className, onClick }) => (
    <button className={className} onClick={onClick}>Login</button>
  );
  
  return (
    <>
      <ButtonView className="desktop-button" onClick={handleClick} />
      <ButtonView className="mobile-button" onClick={handleClick} />
    </>
  );

Verify GREEN:
  npm test -- LoginButton.test.tsx
  PASS: 2/2 tests passed ✓

Re-run Phase 1 loop:
  npm test -- LoginButton.test.tsx
  PASS: Original issue resolved ✓

Regression check:
  npm test
  Result: 147/147 tests passed ✓

Phase 6: Cleanup & Post-Mortem
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- No debug instrumentation to remove
- Original loop confirms fix
- Hypothesis: Handler missing (confirmed)

Post-mortem: What would prevent this?
- Test mobile viewport in component tests
- Shared button component from start

Bug fixed and verified. No regressions.
```

---

## Anti-Patterns (DO NOT DO)

**❌ Random Fix Attempts**
```
"Let me try changing the timeout..."
[fails]
"Maybe it's the CSS..."
[fails]
"What if I reload the component..."
```
**→ Use Phase 1-4 instead**

**❌ Skipping Phase 1 (Feedback Loop)**
```
"I'll just manually test after each change"
```
**→ Build automated loop first**

**❌ Fixing Without Root Cause**
```
"I know what the issue is" → [applies fix without investigation]
```
**→ Complete Phase 3 before Phase 5**

**❌ Continuing After 3 Failures**
```
Fix #1: Failed
Fix #2: Failed
Fix #3: Failed
Fix #4: Let me try... ← STOP! Escalate instead
```
**→ 3-attempt limit is absolute**

**❌ Multiple Simultaneous Changes**
```
"I'll update the handler AND change the state AND refactor..."
```
**→ One minimal fix per attempt**

---

## Quality Gates

- [ ] Phase 1: Feedback loop built and validated (<5s, deterministic)
- [ ] Phase 2: Bug reproduced reliably (>50% or 100%)
- [ ] Phase 3: Root cause identified with evidence
- [ ] Phase 4: 3-5 hypotheses ranked, user notified (if available)
- [ ] Phase 5: Failing test → minimal fix → passing test
- [ ] Phase 6: Cleanup done, post-mortem documented
- [ ] Full test suite passes (no regressions)
- [ ] Original scenario works

**Can't check all boxes? You haven't completed diagnosis.**

---

## Success Metrics

- **First-time fix rate**: ≥85%
- **Root cause identification**: 100%
- **Regression rate**: <5%
- **3-strike escalations**: Track and review patterns

---

## Integration with Other Workflows

### With /build
```
/build user-login
→ Bug discovered during implementation
→ STOP build
→ /fix <bug>
→ Resume /build after fix verified
```

### With /review
```
/review feature-branch
→ Reviewer finds bug
→ /fix <bug>
→ Re-run /review after fix
```

### With TDD
Phase 5 uses TDD for regression test:
- RED: Write failing test (reproduces bug)
- GREEN: Apply fix (minimal change)
- REFACTOR: Clean up (while staying green)

---

## Progressive Disclosure Resources

**Phase 1 Deep Dive** (10 ways to build feedback loops):
→ `.ai/skills/diagnose/PHASE1-FEEDBACK-LOOP.md`

**Hypothesis Formation** (3-5 ranked, falsifiable):
→ `.ai/skills/diagnose/HYPOTHESIS-GUIDE.md`

**Instrumentation Strategies** (tagged logging, debugger preference):
→ `.ai/skills/diagnose/INSTRUMENTATION.md`

**Regression Testing** (correct seam analysis):
→ `.ai/skills/diagnose/REGRESSION-TESTING.md`

---

**Remember**: Find root cause BEFORE attempting fixes. Phase 1 (feedback loop) is 90% of the work.

**Skills Used**:
- `.ai/skills/diagnose/SKILL.md` (6-phase protocol - MAIN)
- `.ai/skills/tdd/SKILL.md` (fix implementation)
- `.ai/skills/verification-before-completion.md` (fix verification)
