# Workflow: Build

## Purpose
Systematic implementation of approved designs into working code. Transform requirements and architecture into production-ready features through incremental, test-driven development.

**Core principle:** Small surgical changes, test after each step, preserve simplicity throughout.

---

## Steps

### 1. Verify Approved Design

**Before writing any code, confirm design approval:**
- Read PRD (Product Requirements Document)
- Review ARCHITECTURE.md for design decisions
- Check implementation plan exists and is approved
- Verify success criteria are clear

**Critical questions:**
- Has design been approved by stakeholder?
- Are requirements unambiguous?
- Is scope clearly defined?

**If no approved design exists:**
- STOP. Run `design` workflow first
- Do not proceed without approval

**Checklist:** Work through `.ai/checklists/pre-build.md` before writing code.

**Skill:** `clean-code` (Think before coding)

**Output:** Confirmed approved design loaded into context

### 2. Load Snapshot/Cache

**Load project context efficiently:**

Read cache files:
- `.ai/runtime/cache/repo-map.md` - Repository structure
- `.ai/runtime/cache/architecture-summary.md` - System overview
- `.ai/runtime/cache/module-summaries/` - Individual module details
- `.ai/memory/activeContext.md` - Previous session context

**Verify cache freshness:**
- Check cache timestamps
- Compare with recent git changes
- Invalidate if stale (>7 days or major changes)

**If cache is stale or missing:**
- Run `cache` workflow first
- Build fresh repo map

**Purpose:** Load project knowledge efficiently without re-reading entire codebase.

### 3. Build/Review Repo Map

**Create or verify repository structure understanding:**

Generate repo map showing:
- Directory structure
- Key modules and their relationships
- Entry points (main files, routes)
- Test locations
- Configuration files

**Map should answer:**
- Where does feature X live?
- What modules depend on Y?
- Where should new code go?

**Tool:** Use file tree tools or scripts

**Output:** Clear mental model of codebase organization

### 4. Search Existing Implementation

**Before building anything, check what already exists:**

Search for:
- Similar features already implemented
- Reusable utility functions
- Existing patterns and conventions
- Related tests

**Search methods:**
- Grep for relevant keywords
- Check module summaries in cache
- Review similar feature implementations
- Look for shared utilities

**Document findings:**
```
Existing relevant code:
- auth.js:L45-67 - User validation pattern
- utils/validators.js - Reusable validators
- tests/auth.test.js - Test pattern to follow
```

**Purpose:** Avoid reinventing the wheel, maintain consistency.

### 5. Make Reuse/Rebuild Decision

**Decide whether to reuse or rebuild components:**

**Reuse existing code if:**
- Functionality matches >80% of requirements
- Code quality is acceptable
- Easy to extend/modify
- Tests already exist
- Maintains consistency

**Rebuild from scratch if:**
- Existing code is overly complex
- Requirements differ significantly
- Technical debt is high
- Easier to rebuild than refactor
- Better patterns available

**Document decision:**
```
Decision: REUSE auth validation from auth.js
Rationale: Matches requirements, well-tested, easy to extend
Modifications needed: Add email validation
```

**Skill:** `clean-code` (Goal-driven pragmatism)

### 6. Create Modular File Plan

**Break implementation into small, independent modules:**

**Plan structure:**
```
Implementation Plan:

Module 1: [Name] (File: path/to/file.js)
  Purpose: [what it does]
  Dependencies: [what it needs]
  Interface: [exports/API]
  Tests: [test file location]
  Estimated lines: ~[number]

Module 2: [Name] (File: path/to/file.js)
  Purpose: [what it does]
  Dependencies: [Module 1]
  Interface: [exports/API]
  Tests: [test file location]
  Estimated lines: ~[number]

Integration: [how modules connect]
```

**Modular principles:**
- Each module has single responsibility
- Clear interfaces between modules
- Minimal dependencies
- Testable in isolation
- <200 lines per file (target)

**Dependency order:**
1. Utilities (no dependencies)
2. Core logic (depends on utilities)
3. Integration (depends on core)
4. Routes/Controllers (depends on all)

**Ask for approval before implementing:**
```
File plan created:
- 3 new files
- 2 modified files
- Estimated 400 lines total

Proceed with implementation?
```

**Skill:** `clean-code` (Surgical, modular design)

### 7. Implement with Small Changes (Test-Driven)

**Implement one module at a time using TDD:**

**For each module:**

**Step A: Write Test First (RED)**
```javascript
// tests/validator.test.js
describe('validateEmail', () => {
  it('should accept valid email', () => {
    expect(validateEmail('test@example.com')).toBe(true);
  });
  
  it('should reject invalid email', () => {
    expect(validateEmail('invalid')).toBe(false);
  });
});
```

**Run test - should FAIL:**
```bash
npm test validator.test.js
# Expected: FAIL (function doesn't exist yet)
```

**Step B: Write Minimal Implementation (GREEN)**
```javascript
// src/validator.js
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
```

**Run test - should PASS:**
```bash
npm test validator.test.js
# Expected: PASS (2/2 tests)
```

**Step C: Refactor if Needed**
- Simplify logic
- Improve naming
- Extract duplications
- Keep tests passing

**Repeat for each module in dependency order.**

**Key rules:**
- Write test BEFORE implementation (TDD)
- Verify test fails first (RED)
- Write simplest code to pass (GREEN)
- Refactor while keeping tests green
- Commit after each module

**Skill:** `test-driven-development` (RED-GREEN-REFACTOR cycle)

### 8. Run Tests and Checks After Each Module

**After implementing each module, run full verification:**

**Checklist:** Follow `.ai/checklists/testing.md` to verify test depth and coverage.

**Run tests:**
```bash
npm test                    # All tests
npm test -- --coverage      # With coverage
```

**Verify:**
- All tests passing (X/X)
- New tests included
- Coverage >90% for new code
- No skipped/pending tests

**Run linting:**
```bash
npm run lint
```

**Run build:**
```bash
npm run build
```

**Run type checking (if TypeScript):**
```bash
npm run type-check
```

**All checks must pass before proceeding to next module.**

**If checks fail:**
- STOP implementation
- Fix issues immediately
- Re-run checks
- Only proceed when green

**Commit after successful verification:**
```bash
git add [files]
git commit -m "feat: add email validation module"
```

**Skill:** `verification-before-completion` (Verify after each change)

### 9. Integration and End-to-End Testing

**After all modules implemented, test integration:**

**Integration tests:**
- Test modules working together
- Verify data flows correctly
- Check error handling across boundaries
- Test edge cases in integration

**Example integration test:**
```javascript
describe('User Registration Flow', () => {
  it('should validate and create user', async () => {
    const userData = { email: 'test@example.com', password: 'secret' };
    const result = await registerUser(userData);
    expect(result.success).toBe(true);
    expect(result.user.email).toBe('test@example.com');
  });
});
```

**Manual verification (if applicable):**
- Run application locally
- Test feature end-to-end
- Check UI/UX if frontend
- Verify in different scenarios

**Verify against success criteria from PRD.**

### 10. Run RoastMe Self-Critique

**Execute self-critique for quality assurance:**

```
/roastme build
```

**Check for violations:**

**Overcomplication:**
- [ ] Unnecessary abstractions added?
- [ ] More complex than needed?
- [ ] Premature optimization?
- [ ] Speculative features?

**Non-surgical changes:**
- [ ] Files changed outside scope?
- [ ] Style/format changes mixed in?
- [ ] Drive-by refactoring?
- [ ] Unrelated improvements?

**Missing verification:**
- [ ] Tests run and verified?
- [ ] Evidence of RED-GREEN cycle?
- [ ] Coverage checked?
- [ ] Linting passed?

**If violations found:**
- Revert non-surgical changes
- Simplify overcomplicated code
- Ensure fresh verification evidence

**Skill:** `roastme` command (behavioral discipline check)

### 11. Update Documentation

**Update relevant documentation:**

**Code-level documentation:**
- [ ] Add JSDoc/docstrings to public functions
- [ ] Comment complex logic (explain WHY, not WHAT)
- [ ] Update inline TODOs if applicable

**Project-level documentation:**
- [ ] Update ARCHITECTURE.md if structure changed
- [ ] Add entry to DECISIONS.md for significant tradeoffs
- [ ] Update README.md for user-facing changes
- [ ] Add entry to CHANGELOG.md

**Context files:**
- [ ] Update `.ai/state/CURRENT.md` with completion status
- [ ] Update `.ai/memory/activeContext.md` with learnings
- [ ] Document any technical debt in `.ai/governance/debt/technical-debt.md`

**Not every change needs docs:**
- Simple implementations following existing patterns → No docs
- New features or architectural changes → Docs required
- Public APIs → Documentation required

### 12. Update Cache

**Refresh cache with new implementation:**

Update affected cache files:
- `.ai/runtime/cache/repo-map.md` - If structure changed
- `.ai/runtime/cache/module-summaries/[module].md` - For modified modules
- `.ai/runtime/cache/architecture-summary.md` - If architecture evolved

**Run cache update:**
```bash
# If cache workflow available
/cache update
```

**Or manually update:**
- Regenerate repo map
- Update module summaries
- Update architecture summary
- Record cache timestamp

**Purpose:** Keep cache fresh for next build session.

### 13. Pre-Merge Review

**Final checks before requesting merge:**

**Run pre-merge checklist:**
- [ ] All tests passing (fresh run)
- [ ] Linting clean
- [ ] Build successful
- [ ] Coverage targets met (>90% for new code)
- [ ] Documentation updated
- [ ] CHANGELOG updated
- [ ] Clean git diff (surgical changes only)
- [ ] Commit messages clear
- [ ] No sensitive data in code/commits
- [ ] No hardcoded secrets

**Review git diff:**
```bash
git diff main --stat
git diff main
```

**Verify every changed line:**
- Traces to implementation plan?
- Part of approved design?
- No style-only changes?
- No commented-out code?

**Self-review checklist:** See `checklists/pre-merge.md`

### 14. Request Code Review

**Prepare review request:**

**Create review summary:**
```markdown
# Code Review Request: [Feature Name]

## Implementation Summary
[2-3 sentences describing what was built]

## Changes
- Files added: [count]
- Files modified: [count]
- Lines added: [+count]
- Lines removed: [-count]

## Testing
- Tests written: [count]
- Tests passing: [X/X]
- Coverage: [X%]
- Manual testing: [completed/not applicable]

## Documentation
- [x] Code comments added
- [x] ARCHITECTURE.md updated
- [x] CHANGELOG.md updated
- [x] README.md updated (if needed)

## Verification Evidence
- [x] Tests run: [timestamp]
- [x] Linting passed: [timestamp]
- [x] Build successful: [timestamp]

## Review Focus Areas
[List any specific areas needing careful review]

## Related Links
- PRD: [link]
- Design: [link]
- Implementation plan: [link]

Ready for review.
```

**Assign reviewer:**
- Delegate to `reviewer` agent if configured
- Or tag human reviewer

**Run review workflow:**
```
/review
```

### 15. Address Review Feedback

**After review, address all feedback:**

**For each review comment:**
- Understand the concern
- Make requested changes
- Test changes
- Reply to reviewer

**If major changes requested:**
- Create new implementation plan
- Get approval for changes
- Re-run build workflow for affected modules
- Request re-review

**After addressing feedback:**
```markdown
## Review Feedback Addressed

### Changes Made
1. [Change 1] - [reason]
2. [Change 2] - [reason]

### Re-verification
- Tests: [X/X passing]
- Linting: Clean
- Build: Successful

Ready for re-review or merge.
```

### 16. Merge and Cleanup

**After approval, merge to main:**

**Merge process:**
```bash
# Update branch
git fetch origin main
git rebase origin/main

# Run final verification
npm test
npm run lint
npm run build

# Merge (or create PR)
git checkout main
git merge feature-branch
git push origin main
```

**Post-merge cleanup:**
- [ ] Delete feature branch
- [ ] Close related issues/tickets
- [ ] Update project board
- [ ] Notify stakeholders
- [ ] Archive implementation docs if needed

**Update memory bank:**
```markdown
# Build Complete: [Feature Name]

## What Was Built
[Description]

## Key Learnings
[Lessons learned]

## Patterns Used
[Successful patterns to reuse]

## Date: [timestamp]
```

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Test-Driven Development** | Write tests before implementation | Tests fail first (RED), then pass (GREEN) |
| **Small incremental changes** | One module at a time | Each module independently testable |
| **Surgical precision** | Touch only what's needed | Git diff shows only planned changes |
| **Verify continuously** | Test after each change | All checks green before proceeding |
| **Keep it simple** | Simplest solution that works | No unnecessary abstractions |

---

## Red Flags - STOP

- No approved design exists
- Tests not written before implementation
- Tests passing immediately (no RED phase)
- Multiple modules failing together
- Non-surgical changes in diff
- Skipping verification steps
- Overcomplicated solution
- Missing documentation for new features

**If you see these:** STOP. Address the issue before continuing.

---

## Integration Points

**Skills:**
- `clean-code` - Think before coding, surgical changes, simplicity (Steps 1, 5, 6, 10)
- `test-driven-development` - RED-GREEN-REFACTOR cycle (Step 7, 8)
- `verification-before-completion` - Verify after each step (Step 8, 13)
- `systematic-debugging` - When issues arise during build

**Commands:**
- `/roastme build` - Self-critique (Step 10)
- `/cache update` - Update cache (Step 12)
- `/review` - Request code review (Step 14)

**Workflows:**
- **Prerequisite:** `/design` - Must complete before build
- **Supporting:** `/cache` - Load/update project context
- **Next:** `/review` - After implementation complete
- **Related:** `/fix` - If bugs found during build
- **Related:** `/refactor` - If code needs restructuring
- **Related:** `/test` - Comprehensive testing
- **Final:** `/verify` - Quality verification gate

**Checklists:**
- `pre-build.md` - Pre-implementation readiness (Step 1)
- `testing.md` - Test depth and coverage (Step 8)
- `pre-merge.md` - Final checks (Step 13)

**Agents:**
- `architect` - Design phase before build
- `backend` or `frontend` - Specialized implementation
- `reviewer` - Code review phase
- `qa` - Testing and verification

---

## Related Workflows

| Workflow | When to Use | Relationship |
|----------|------------|--------------|
| **[design.md](./design.md)** | Before starting build | Prerequisite - must complete first |
| **[cache.md](./cache.md)** | To optimize context loading | Supporting - improves build performance |
| **[review.md](./review.md)** | After implementation | Sequential - follows build |
| **[fix.md](./fix.md)** | When bugs found during build | Interrupt - switch to fix workflow |
| **[test.md](./test.md)** | For comprehensive testing | Parallel - continuous during build |
| **[refactor.md](./refactor.md)** | When code needs restructuring | Alternative - instead of continuing build |
| **[verify.md](./verify.md)** | Before marking complete | Final gate - mandatory before done |

---

## Common Scenarios

### Scenario: Large Feature
**Approach:**
- Break into smaller sub-features
- Build incrementally
- Merge small pieces frequently
- Use feature flags if needed

### Scenario: No Tests Exist
**Approach:**
- Set up test framework first
- Write tests for new code (TDD)
- Add tests for touched existing code
- Document testing patterns for team

### Scenario: Unclear Requirements
**Approach:**
- STOP implementation
- Go back to design workflow
- Clarify with stakeholder
- Update PRD with clarifications
- Resume build after approval

### Scenario: Integration Breaking
**Approach:**
- Roll back to last working state
- Debug integration issues systematically
- Add integration tests
- Fix incrementally
- Verify at each step

### Scenario: Performance Issues
**Approach:**
- Measure first (don't assume)
- Profile to find bottleneck
- Fix specific bottleneck
- Measure improvement
- Document optimization decision

---

## Troubleshooting

### Tests Keep Failing
**Check:**
- Are tests correctly written?
- Is implementation correct?
- Are dependencies set up?
- Are test fixtures valid?
- Is environment configured?

**Action:** Debug systematically, fix root cause, re-run.

### Build Breaking
**Check:**
- Syntax errors?
- Missing dependencies?
- Import paths correct?
- Configuration issues?

**Action:** Read error messages carefully, fix one at a time.

### Merge Conflicts
**Check:**
- Is branch up to date with main?
- Are changes overlapping?

**Action:** Fetch latest, rebase, resolve conflicts, test, merge.

### Review Rejected
**Check:**
- What specific issues found?
- Overcomplication?
- Non-surgical changes?
- Missing tests?

**Action:** Address feedback, don't argue, improve code, resubmit.

---

## Success Criteria

**Build is successful when:**
- ✅ All requirements from PRD implemented
- ✅ All tests passing (TDD evidence exists)
- ✅ Code coverage >90% for new code
- ✅ Linting clean, build successful
- ✅ Documentation updated
- ✅ Surgical git diff (clean changes)
- ✅ Code review approved
- ✅ Merged to main
- ✅ Stakeholder acceptance

---

**Remember:** Build is implementation phase. Follow TDD strictly, keep changes surgical, verify continuously, maintain simplicity. Quality over speed.
