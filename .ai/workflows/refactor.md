# Workflow: Refactor

## Purpose
Improve code structure without changing behavior. Extract, rename, reorganize for clarity and maintainability.

**Core principle:** Surgical precision. Change structure, preserve behavior, maintain test coverage throughout.

---

## Steps

### 1. Load Context and Understand Current State

Load relevant context for refactoring scope:
- Read affected files completely
- Review ARCHITECTURE.md for current boundaries
- Check DECISIONS.md for past design choices
- Review `.ai/governance/debt/technical-debt.md` for known issues

**Verify:** You understand what code does and why it's structured this way.

### 2. Define Refactor Scope with HITL

**State explicitly:**
- What code will be refactored (files, functions, modules)
- Why it needs refactoring (complexity, duplication, coupling)
- What will NOT be refactored (boundaries)

**Complexity signals:**
- Functions >50 lines
- Cyclomatic complexity >10
- Duplicated logic across files
- High coupling between modules
- Poor naming or unclear structure

**Ask for approval:**
```
Refactor scope:
- Target: [specific files/functions]
- Issues: [complexity/duplication/coupling]
- Out of scope: [what won't change]

Proceed?
```

**Skill:** `clean-code` (Think before coding - state assumptions)

### 3. Confirm Zero Behavior Change

**Refactoring rule:** Behavior stays identical. No new features, no bug fixes, no changes to outputs.

If behavior must change:
- Stop. This is not refactoring.
- Create separate task for behavior change
- Complete behavior change first OR after refactoring (never during)

**State explicitly:** "This refactoring changes NO behavior. All inputs produce identical outputs."

### 4. Capture Current Behavior in Tests

**Before touching code:**

Run existing tests and document baseline:
```bash
npm test [affected-modules]
```

**Verify:**
- All tests pass
- Note test count: X tests passing
- If no tests exist → Write characterization tests first
- Save test output as baseline

**Why:** Tests are your safety net. Passing tests before + after = behavior preserved.

**Skill:** `test-driven-development` (ensure test coverage exists)

### 5. Identify Refactoring Opportunities

**Use `systematic-debugging` skill to analyze code:**

Scan for:
- **Duplication:** Same logic in multiple places
- **Complexity:** Nested conditionals, long functions
- **Coupling:** Tight dependencies between modules
- **Naming:** Unclear variable/function names
- **Structure:** Misplaced responsibilities

List opportunities with priority:
```
High priority:
- [Issue 1] in [file:line] - [impact]

Medium priority:
- [Issue 2] in [file:line] - [impact]

Low priority:
- [Issue 3] in [file:line] - [impact]
```

**Surgical principle:** Fix highest-impact issues only. Don't refactor everything.

### 6. Create Incremental Refactoring Plan

**Break refactoring into small, testable steps.**

Each step:
- Changes one thing
- Takes <30 minutes
- Can be verified independently

**Plan format:**
```
Step 1: Extract function X from Y
  → Verify: Tests still pass

Step 2: Rename variable A to B across module
  → Verify: Tests still pass, no build errors

Step 3: Move function Z to new module
  → Verify: Tests still pass, imports work

Step 4: Simplify conditional in function W
  → Verify: Tests still pass, same outputs
```

**Engineering principle:** Surgical changes. One thing at a time.

**Ask for approval:** Present plan before starting.

### 7. Apply First Refactoring Step

Implement step 1 from plan:
- Make minimal change
- Update imports/references
- Keep code in working state

**No scope creep:**
- Don't fix unrelated issues
- Don't reformat code style
- Don't add features
- Touch only what's necessary for THIS step

**Skill:** `clean-code` (Surgical changes only)

### 8. Verify Tests Still Pass (After Each Step)

**MANDATORY after every step:**

```bash
npm test [affected-modules]
```

**Verify:**
- Same test count passing
- No new failures
- No new errors/warnings
- Exit code 0

**If tests fail:**
- STOP immediately
- Revert last change
- Investigate why tests broke
- Fix refactoring approach
- Re-apply step correctly

**Skill:** `verification-before-completion` (Fresh verification required)

### 9. Commit Incremental Change

After each step passes:

```bash
git add [changed-files]
git commit -m "refactor: [specific change made]"
```

**Why:** Small commits make debugging easy. If refactoring breaks something later, you can pinpoint exact change.

**Commit message format:**
```
refactor: extract validateUser from authController

- No behavior change
- Tests passing: 15/15
```

### 10. Repeat Steps 7-9 for Remaining Steps

Work through refactoring plan:
- One step at a time
- Verify tests after each
- Commit each change
- Stay surgical

**If you discover new refactoring opportunities:**
- Note them in `.ai/governance/debt/technical-debt.md`
- Don't expand scope mid-refactoring
- Finish current plan first

### 11. Run Full Test Suite and Verification

After all refactoring steps complete:

**Run complete verification:**
```bash
npm test              # All tests
npm run lint          # Linting
npm run build         # Build check
```

**Verify:**
- All tests pass (same count as baseline)
- No lint errors
- Build succeeds
- No new warnings

**Skill:** `verification-before-completion` (Complete verification before claiming done)

### 12. Run RoastMe Self-Critique

Execute self-critique for surgical precision:

```
/roastme build
```

**Check for violations:**
- [ ] Changed files unrelated to refactoring scope?
- [ ] Drive-by improvements to unrelated code?
- [ ] Style changes (quotes, spacing, formatting)?
- [ ] Comment changes unrelated to refactoring?
- [ ] New features or behavior changes?

**If violations found:** Revert non-surgical changes.

**Skill:** `roastme` command (behavioral discipline check)

### 13. Update Architecture Documentation (If Boundaries Changed)

**Only if module boundaries or structure changed:**

Update ARCHITECTURE.md:
- New module structure
- Changed dependencies
- Updated component diagram

Update DECISIONS.md:
- Why refactoring was needed
- What approach was chosen
- Tradeoffs made

**If only internal refactoring (same interfaces):** No docs update needed.

### 14. Review Diff for Surgical Precision

**Final check before merge:**

```bash
git diff main
```

**For each changed file, ask:**
- Is this file in refactoring scope? → YES
- Are changes limited to refactoring? → YES
- Any style/format changes? → NO
- Any behavior changes? → NO

**The test:** Every line changed traces to refactoring plan.

**Skill:** Pre-merge checklist surgical test

### 15. Request Code Review

**Prepare review request:**
```
Refactoring complete:

Scope: [what was refactored]
Files changed: [list]
Behavior changes: NONE
Tests: [X/X passing, same as baseline]
Complexity reduction: [before/after metrics if applicable]

Ready for review.
```

**Run pre-merge checklist:** See `checklists/pre-merge.md`

**Agent:** Delegate to `reviewer` if configured.

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Zero behavior change** | Refactoring ≠ new features | Tests pass before and after |
| **Surgical precision** | Touch only refactoring scope | Every line traces to plan |
| **Incremental steps** | Small changes, frequent verification | Commit after each step |
| **Tests as safety net** | Passing tests = behavior preserved | Run tests after each step |

---

## Red Flags - STOP

- Tests failing after refactoring step
- Scope expanding beyond original plan
- Changing behavior "while we're here"
- Files changed unrelated to refactoring
- Style changes mixed with refactoring
- Skipping test verification between steps

**If you see these:** STOP. Revert. Re-assess approach.

---

## Integration Points

**Skills:**
- `systematic-debugging` - Analyze code structure (Step 5)
- `test-driven-development` - Ensure test coverage (Step 4)
- `verification-before-completion` - Verify after each step (Step 8, 11)
- `clean-code` - Surgical changes, simplicity (Steps 2, 7, 12)

**Commands:**
- `/roastme build` - Self-critique (Step 12)

**Checklists:**
- `pre-merge.md` - Final approval (Step 15)

---

**Remember:** Refactoring is structure change with zero behavior change. Tests passing throughout = success.
