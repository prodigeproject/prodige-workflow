# Pre-Merge Checklist

## Prodige Structural Checks
- [ ] Tests/checks run AND output verified (fresh run, with evidence)
- [ ] Code review completed
- [ ] Context files updated (ARCHITECTURE.md, DECISIONS.md)
- [ ] Debt recorded in registries if applicable
- [ ] Handoff document complete

---

## Quality Checks

### 1. TDD Compliance
- [ ] Every new function/component has test
- [ ] Tests were written BEFORE implementation (confirmed in git history/conversation)
- [ ] Tests failed first, then passed (RED-GREEN cycle verified)
- [ ] No code written before tests

**Verification:**
```bash
# Check test coverage
npm test -- --coverage

# Should show ≥90% coverage for new code
# Check git history shows test commits before implementation commits
```

**Red Flags:**
- Low test coverage (<90%)
- Implementation commit before test commit
- Tests pass immediately (didn't see them fail)
- Agent can't explain why test failed

### 2. Verification Evidence Provided
- [ ] Fresh verification run (not previous run or memory)
- [ ] Complete command provided
- [ ] Full output documented
- [ ] Pass/fail counts explicit

**Required Evidence Format:**
```
Verification:
Command: npm test -- <file>
Exit code: 0
Output: [paste relevant excerpt]
Result: X tests passed, Y failed
Coverage: Z%
```

**Red Flags:**
- "Tests should pass now" (no evidence)
- "I ran tests earlier" (not fresh)
- "Looks correct" (no verification)
- No command output provided

### 3. Systematic Debugging (For Bug Fixes)
- [ ] Root cause identified and documented
- [ ] 4-phase protocol followed (if /fix command)
- [ ] Regression test added (test reproduces bug)
- [ ] Fix verified via RED-GREEN cycle

**For Bug Fixes Only:**
- [ ] Phase 1: Root Cause Investigation completed
- [ ] Phase 2: Pattern Analysis completed
- [ ] Phase 3: Hypothesis tested
- [ ] Phase 4: Fix implemented with TDD
- [ ] If 3+ fixes failed: Escalated to Architect

---

## Engineering Discipline Checks

### 1. Simplicity Verification
- [ ] Code uses minimum abstractions needed
- [ ] No premature optimization
- [ ] No speculative features
- [ ] Lines of code proportional to problem complexity

**Red Flags:**
- 500 lines for a simple CRUD endpoint
- Design patterns for single use case
- Configuration system for hardcoded value
- Abstractions with only 1 usage

**Test:** Review largest file changed. Ask: "Is this as simple as it could be?"

### 2. Surgical Precision Verification
- [ ] Git diff shows ONLY task-related files
- [ ] No reformatting (quote style, spacing)
- [ ] No comment changes unrelated to task
- [ ] No "drive-by refactoring"

**Red Flags:**
- Files changed not mentioned in implementation plan
- Style changes ('' to "", spaces to tabs)
- Unrelated functions modified
- Dead code removed that wasn't created by this task

**Test:** For each changed file, ask: "Why is this file in the diff?"

### 3. Verification Completed
- [ ] All success criteria from implementation plan verified
- [ ] Tests written and passing
- [ ] Manual verification steps documented and completed
- [ ] No "looks like it works" without proof

**Test:** Check implementation plan. Every "Verify:" step should have evidence.

### 4. No Scope Creep
- [ ] Only requested features implemented
- [ ] No unrequested "improvements"
- [ ] No "while we're at it" additions

**Red Flags:**
- Features not in PRD
- Refactoring not in implementation plan
- Error handling for impossible scenarios

**Test:** List all features implemented. Cross-check with PRD.

---

## Git Diff Audit

### What to Look For

```bash
# Check files changed
git diff --stat main

# For each file, ask:
1. Is this file mentioned in implementation plan? → Should be YES
2. Are changes limited to task? → Should be YES
3. Are there style/format changes? → Should be NO
4. Are there comment-only changes? → Should be NO
```

### Acceptable Diff Example (✅ Good)
```diff
# File: src/auth/login.js
+ function authenticateUser(username, password) {
+   const user = db.findUser(username);
+   return user && user.checkPassword(password);
+ }
```

### Problematic Diff Example (❌ Bad)
```diff
# File: src/auth/login.js
+ function authenticateUser(username: string, password: string): boolean {
-   // check user
+   // Authenticate user
-   const user = db.findUser(username);
+   return db.findUser(username)?.checkPassword(password) ?? false;
  
# File: src/auth/register.js (NOT IN PLAN)
- function registerUser(username, password) {
+ function registerUser(username: string, password: string): boolean {
```

**Problems:**
- Added type hints (not requested)
- Changed comments (not related to task)
- Modified register.js (unrelated file)
- Reformatted code style

---

## Debt Check

If any shortcuts taken, must be recorded:

| If... | Then record in... |
|-------|------------------|
| Added TODO or FIXME | `.ai/governance/debt/technical-debt.md` |
| Skipped optimization | `.ai/governance/debt/technical-debt.md` |
| Hardcoded value that should be config | `.ai/governance/debt/technical-debt.md` |
| Simplified architecture temporarily | `.ai/governance/debt/architecture-debt.md` |
| Missing documentation | `.ai/governance/debt/documentation-debt.md` |

---

## Final Approval Decision

### ✅ MERGE if:
- All structural checks passed
- All behavioral checks passed
- Git diff is clean (only task-related changes)
- Evidence exists for all verification steps

### 🔄 REVISE if:
- Failed 1-2 behavioral checks
- Minor scope creep or unnecessary changes
- Can be fixed quickly

### ❌ REJECT if:
- Failed 3+ behavioral checks
- Major scope creep
- Obvious overcomplication
- Diff shows extensive unrelated changes

---

## Post-Merge Actions

- [ ] Update manifest.json with completion status
- [ ] Tag release if applicable
- [ ] Update CHANGELOG.md
- [ ] Archive snapshot
- [ ] Run `/sync` to verify context accuracy
