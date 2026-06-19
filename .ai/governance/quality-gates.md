# Quality Gates

## Prodige Structural Quality

Code must be:
- ✅ **Correct:** Solves the stated problem
- ✅ **Modular:** Clear separation of concerns
- ✅ **Readable:** Clear naming, reasonable complexity
- ✅ **Tested via TDD:** Tests written BEFORE implementation (RED-GREEN-REFACTOR)
- ✅ **Secure:** No obvious vulnerabilities
- ✅ **Documented:** Behavior changes reflected in docs
- ✅ **Verified:** Completion claims backed by evidence (command output)

---

## TDD Enforcement

### For All Implementation Work

**Mandatory Process: RED → GREEN → REFACTOR**

1. **RED:** Write failing test first
   → Verify: Test fails for expected reason (not typo, not error)

2. **GREEN:** Write minimal code to pass
   → Verify: Test passes, all other tests still green

3. **REFACTOR:** Clean up while staying green
   → Verify: Tests remain green after refactoring

**Check:**
- [ ] Every function/component has test written FIRST
- [ ] Watched test fail before implementing
- [ ] Test failed for right reason (feature missing, not config issue)
- [ ] Minimal code written (no YAGNI violations)
- [ ] Refactored while staying green

**Red Flags:**
- ❌ Code written before test
- ❌ Test passes immediately (didn't see it fail)
- ❌ Can't explain why test failed
- ❌ Test written after implementation

**If violated:** DELETE code, start with test first

**Skills:** `.ai/skills/test-driven-development/SKILL.md`

---

## Verification Before Completion

### For All Completion Claims

**Mandatory 5-Step Process:**

1. **IDENTIFY:** What command proves success?
2. **RUN:** Execute command (fresh run, not previous)
3. **READ:** Read FULL output (not just exit code)
4. **VERIFY:** Confirm success explicitly
5. **CLAIM:** Only then claim "done" WITH evidence

**Evidence Required:**
```
Command: [exact command]
Exit code: [0 or error code]
Output: [relevant excerpt]
Result: [X tests passed, Y failed]
```

**Check:**
- [ ] Fresh verification run (not memory/previous run)
- [ ] Complete output read (not assumption)
- [ ] Evidence provided (command + output)
- [ ] Regression tests verified

**Red Flags:**
- ❌ "Should work now" (no verification)
- ❌ "Tests passed earlier" (not fresh)
- ❌ "Looks correct" (no evidence)
- ❌ Expressing satisfaction before verification

**If violated:** Run verification, provide evidence, THEN claim

**Skills:** `.ai/skills/verification-before-completion/SKILL.md`

---

## Behavioral Discipline Quality

Code must demonstrate:
- ✅ **No silent assumptions:** Ambiguities were clarified before coding
- ✅ **Minimum viable complexity:** Simplest solution that works
- ✅ **Surgical precision:** Only requested changes, no scope creep
- ✅ **Verifiable success:** Clear success criteria, not "looks like it works"

---

## Verification Process

### For /design Stage

**Run:** `/roastme design`

**Check:**
1. Are there 3+ abstraction layers for a simple feature? → RED FLAG
2. Did agent ask clarifying questions? → GREEN FLAG
3. Are tradeoffs explicitly documented? → GREEN FLAG
4. Is architecture simpler than it could be? → Ask: "Show simpler version"

**Pass criteria:**
- 0-2 simplicity violations
- Assumptions surfaced and documented
- Multiple options with tradeoffs presented

---

### For /build Stage

**Run:** `/roastme build`

**Check:**
1. Lines changed / lines requested ratio > 3? → RED FLAG
2. Git diff shows reformatting or comment changes? → RED FLAG
3. Success criteria from plan all verified? → GREEN FLAG
4. Files changed all mentioned in plan? → GREEN FLAG

**Pass criteria:**
- 0-2 surgical violations
- All verification steps completed
- No scope creep (unrequested features)

---

### For Merge Stage

**Run:** Pre-merge checklist

**Check:**
1. Debt registry updated if shortcuts taken? → Must be GREEN
2. Context files (ARCHITECTURE.md, DECISIONS.md) synced? → Must be GREEN
3. Tests passing? → Must be GREEN
4. RoastMe violations resolved? → Must be GREEN

**Pass criteria:**
- All structural gates passed
- All behavioral gates passed
- Clean git diff (surgical changes only)

---

## Gate Enforcement

| Gate Failed | Action |
|-------------|--------|
| Structural quality issue | Block merge, require fix |
| Behavioral quality issue | Run roastme, require revision |
| 3-5 discipline violations | Request changes, re-review |
| 6+ discipline violations | Major revision required, restart review |

---

## Metrics

Track quality metrics in manifest.json:

```json
{
  "quality_metrics": {
    "structural_gates_passed": true,
    "behavioral_gates_passed": true,
    "simplicity_score": 0.85,
    "surgical_precision_score": 0.92,
    "test_coverage": 0.78,
    "last_quality_check": "2026-06-17T10:30:00Z"
  }
}
```

---

## Relationship to Review Gates

These quality gates and the review gates in `.ai/governance/review-gates.md` form one
coherent system, viewed from two angles:

- **Quality gates (this file)** are *content* checkpoints: they judge whether the work
  itself is good, on two axes - structural quality (correct, modular, tested via TDD,
  secure, documented, verified) and behavioral discipline (no silent assumptions,
  minimum viable complexity, surgical changes, verifiable success). They are enforced
  at the `/design`, `/build`, and merge stages.
- **Review gates** are *lifecycle / phase* checkpoints: they decide when a phase
  (PRD -> Architecture -> Implementation -> Code Review -> Release) is complete enough
  to advance, and who must approve.

### Mapping

| Quality-gate stage | Review gate (phase) it backs |
|--------------------|------------------------------|
| Pre-design discipline (clarify, simplest scope) | Gate 1 PRD |
| `/design` stage (`/roastme design`) | Gate 2 Architecture |
| `/design` -> `/build` handoff (verifiable success criteria) | Gate 3 Implementation |
| `/build` stage + merge stage (surgical diff, TDD evidence, debt + context synced) | Gate 4 Code Review |
| Structural quality bar (tests/build/security verified) | Gate 5 Release |

Rule of thumb: a phase cannot pass its review gate until the matching quality-gate
checks pass. Review gates decide *when* to advance; quality gates decide *whether the
work is good enough* to advance.

---

**Remember:** Quality gates enforce both WHAT is built (structural) and HOW it's built (behavioral).
- synchronized with context
