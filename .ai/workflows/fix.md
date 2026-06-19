# Workflow: Fix

## Purpose
Systematic bug fixing workflow following surgical precision and root cause analysis principles. Fix only what's broken, nothing more.

**Core principle:** Understand first, fix second. Minimal change that addresses root cause.

---

## Steps

### 1. Load Context and Understand Bug Report

**Gather information:**
- Read bug report or issue description completely
- Review steps to reproduce
- Check expected vs. actual behavior
- Note environment details (OS, version, browser, etc.)
- Review any error messages or stack traces
- Check related issues or similar past bugs

**Load relevant context:**
- Read ARCHITECTURE.md for system understanding
- Check DECISIONS.md for design context
- Review CHANGELOG.md for recent changes that might relate

**Verify:** You understand what should happen vs. what is happening.

**Skill:** `systematic-debugging` (Start with understanding)

### 2. Reproduce Bug or Infer Failure Path

**If reproduction steps provided:**
```bash
# Follow exact steps from bug report
npm run dev
# Execute reproduction steps
# Document what you observe
```

**Verify:**
- Can you consistently reproduce the bug?
- What are the exact conditions that trigger it?
- Is it environment-specific?

**If cannot reproduce:**
- Review code paths logically
- Infer failure scenarios from error messages
- Check edge cases and boundary conditions
- Review recent commits for breaking changes

**Document reproduction steps for verification later.**

**Skill:** `systematic-debugging` (Reproduce before fixing)

### 3. Locate Relevant Code

**Use systematic search:**

**From error stack trace:**
- Identify file and line numbers from error
- Read function where error occurs
- Trace backwards through call stack

**From behavior description:**
- Search for relevant feature code
- Identify components involved
- Check data flow and state management

**Tools:**
```bash
# Search for relevant functions/variables
grep -r "functionName" src/
# Check recent changes
git log --oneline -n 20 [file-path]
# Check git blame for context
git blame [file-path]
```

**Create mental map:** What code path leads to the bug?

### 4. Find Root Cause (Not Just Symptoms)

**Critical distinction:** Fix the cause, not the symptom.

**Ask debugging questions:**
- Why does this code fail?
- What assumptions are violated?
- Is this a logic error, edge case, or timing issue?
- What input causes the failure?
- Is this problem in validation, processing, or output?

**Common root causes:**
- Incorrect conditional logic (&&, ||, !)
- Missing null/undefined checks
- Off-by-one errors in loops/arrays
- Race conditions in async code
- Incorrect default values
- Type coercion issues
- State mutation bugs

**Use systematic debugging:**
- Add logging to trace execution
- Check variable values at failure point
- Verify assumptions about data shape
- Test edge cases (null, empty, undefined, 0, negative)

**Verify:** You understand WHY the bug occurs, not just WHERE.

**Skill:** `systematic-debugging` (Root cause analysis)

### 5. Apply Minimal Surgical Fix

**Engineering principle:** Change only what's necessary to fix the bug.

**The fix should:**
- Address the root cause directly
- Be the smallest possible change
- Not refactor surrounding code
- Not add unrelated improvements
- Not change formatting or style

**Acceptable fix:**
```javascript
// Before: Missing null check causes crash
function getUsername(user) {
  return user.name.toUpperCase();  // Crashes if user is null
}

// After: Minimal fix
function getUsername(user) {
  return user?.name.toUpperCase() ?? 'Guest';  // Fixed null case
}
```

**Unacceptable fix:**
```javascript
// DON'T: Refactoring, renaming, style changes mixed in
function getUserDisplayName(currentUser) {  // Renamed function
  // Validate user object structure
  if (!currentUser) {
    return "Guest User";  // Changed quotes, added space
  }
  
  // Convert to uppercase for display
  const displayName = currentUser.name.toUpperCase();
  return displayName;
}
```

**The test:** Would git diff show only the bug fix? Or extra changes?

**Skill:** `clean-code` (Surgical precision)

### 6. Write Test That Catches the Bug

**Before claiming fix complete:**

**Write failing test first:**
```javascript
// Test that reproduces the bug
test('getUsername handles null user', () => {
  expect(getUsername(null)).toBe('Guest');  // Currently fails
});
```

**Then verify fix:**
```bash
npm test
```

**Test should:**
- Reproduce the original bug (fail before fix)
- Pass after fix is applied
- Cover the specific edge case
- Be clear about what it's testing

**Why:** Test prevents regression. Proves fix works.

**Checklist:** Follow `.ai/checklists/testing.md` to ensure the bug test and coverage are adequate.

**Skill:** `test-driven-development` (Test for bug)

### 7. Run Full Verification Suite

**Ensure fix doesn't break anything else:**

```bash
# Run all tests
npm test

# Run linting
npm run lint

# Run type checking (if applicable)
npm run type-check

# Build project
npm run build
```

**Verify:**
- All tests pass (not just new test)
- No new lint errors
- No type errors
- Build succeeds
- No new warnings

**If anything fails:** Fix is incomplete or introduced regression.

**Skill:** `verification-before-completion` (Complete verification required)

### 8. Test Fix in Original Bug Context

**Final verification:**

**Manually test:**
- Follow original reproduction steps
- Verify bug no longer occurs
- Test related scenarios
- Check edge cases
- Verify in same environment as bug report

**Document verification:**
```
Verification steps:
1. [Step 1 from original bug report] - ✅ Works
2. [Step 2 from original bug report] - ✅ Works
3. Edge case: [additional test] - ✅ Works

Bug fixed. No regressions detected.
```

### 9. Update Documentation (Only If Behavior Changed)

**Most bug fixes:** No documentation update needed.

**Update docs only if:**
- Bug fix changes public API behavior
- Bug fix reveals incorrect documentation
- Bug fix changes user-facing features

**Update:**
```markdown
CHANGELOG.md:
- Fixed: [brief description of bug fixed]

DECISIONS.md (only if architectural):
- Document why bug occurred and prevention strategy
```

**Don't update docs for:**
- Internal bug fixes
- Logic corrections
- Edge case handling
- Performance fixes

### 10. Review Diff for Surgical Precision

**Final check before commit:**

```bash
git diff
```

**For each changed line, ask:**
- Is this line part of the bug fix? → YES
- Any style/format changes? → NO
- Any refactoring? → NO
- Any "while I'm here" improvements? → NO

**Acceptable diff:**
- Bug fix code only
- New test for bug
- Necessary imports for fix
- Documentation if behavior changed

**Unacceptable diff:**
- Reformatting existing code
- Variable renames
- Comment changes
- Code style updates
- Refactoring unrelated functions

**Skill:** `clean-code` (Clean, surgical diff)

### 11. Commit with Clear Bug Fix Message

**Commit format:**
```bash
git add [changed-files]
git commit -m "fix: [brief description of bug]

- Root cause: [what was wrong]
- Solution: [what was changed]
- Tested: [verification performed]

Fixes #[issue-number]"
```

**Example:**
```bash
git commit -m "fix: prevent crash when user is null

- Root cause: Missing null check in getUsername()
- Solution: Added optional chaining and default value
- Tested: New test + full suite passing

Fixes #123"
```

### 12. Run Pre-Merge Checklist

**Before requesting review:**

From `checklists/pre-merge.md`:

**Verification:**
- [ ] Tests pass (all, not just new test)
- [ ] Bug reproduced and verified fixed
- [ ] No regressions detected
- [ ] Clean git diff (surgical changes only)

**Behavioral:**
- [ ] Root cause identified and documented
- [ ] Minimal fix applied (no extra changes)
- [ ] Test written that catches bug
- [ ] Manual verification performed

### 13. Request Code Review

**Prepare review request:**
```markdown
Bug Fix: [Issue title]

**Bug:** [Brief description]

**Root cause:** [What was wrong]

**Fix:** [What was changed]

**Verification:**
- New test: [test name] - passing
- Full suite: [X/X tests passing]
- Manual test: [steps verified]

**Files changed:** [list]
**Lines changed:** +[added] -[removed]

Ready for review.
```

**Skill:** `requesting-code-review` (Context for reviewer)

**Agent:** Can delegate to `reviewer` agent if configured.

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Understand first** | Know why bug occurs before fixing | Can explain root cause |
| **Surgical precision** | Fix only the bug, nothing else | Clean git diff |
| **Test the fix** | Write test that catches bug | Test fails before, passes after |
| **Verify completely** | Ensure no regressions | Full test suite passes |

---

## Red Flags - STOP

- Fixing without understanding root cause
- Refactoring while fixing bug
- No test written for bug
- Skipping verification suite
- "Fixing" multiple unrelated things
- Style changes mixed with fix
- Cannot reproduce bug but "fixing" anyway

**If you see these:** STOP. Re-assess approach.

---

## Integration Points

**Skills:**
- `systematic-debugging` - Root cause analysis (Steps 1, 2, 4)
- `test-driven-development` - Write test for bug (Step 6)
- `verification-before-completion` - Complete verification (Step 7)
- `clean-code` - Surgical changes, simplicity (Steps 5, 10)
- `requesting-code-review` - Prepare for review (Step 13)

**Commands:**
- `/roastme build` - Self-critique (optional supplement)

**Checklists:**
- `testing.md` - Test depth and coverage (Step 6)
- `pre-merge.md` - Final verification (Step 12)

**Agents:**
- `reviewer` - Code review (Step 13)

---

## Related Workflows

| Workflow | When to Use | Relationship |
|----------|------------|--------------|
| **[build.md](./build.md)** | To implement new features | Alternative - fix is for bugs, build is for features |
| **[test.md](./test.md)** | To write comprehensive tests | Supporting - ensures fix has proper coverage |
| **[review.md](./review.md)** | After fix complete | Sequential - follows fix |
| **[verify.md](./verify.md)** | Before marking fix complete | Final gate - mandatory verification |
| **[refactor.md](./refactor.md)** | If bug reveals structural issues | Follow-up - after fixing immediate bug |
| **[audit.md](./audit.md)** | If bugs indicate systemic issues | Follow-up - broader quality check |

---

**Remember:** Fix the cause, not the symptom. Make the minimal change that solves the problem. Test thoroughly. Keep it surgical.
