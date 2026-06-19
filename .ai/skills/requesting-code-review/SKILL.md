---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
auto_load: ["/review"]
applies_to: [orchestrator, backend, frontend, qa]
mandatory: true
---

# Requesting Code Review

## Prodige Integration

**Auto-Loaded By:** `/review` command, automatic after task completion  
**Integrated With:** Prodige Reviewer Agent (dedicated review agent)  
**Save Location:** `.ai/reports/reviews/`  
**Severity System:** Critical (🚫 blocks merge) | Important (⚠️ blocks next task) | Minor (💡 nice to have)

This skill dispatches the **Prodige Reviewer Agent** to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review early, review often. Critical issues block merge.

## When to Request Review

### Mandatory (Prodige Quality Gates)

**After each task in subagent-driven development:**
- Orchestrator dispatches task → Agent completes → **REQUEST REVIEW** → Review passes → Next task
- Review output: `.ai/reports/reviews/task-{N}-{timestamp}.md`

**After completing major feature:**
- All tasks done → **REQUEST FINAL REVIEW** → Review passes → Ready for merge
- Review output: `.ai/reports/reviews/feature-{name}-{timestamp}.md`

**Before merge to main:**
- Pre-merge checklist gate: "Code review completed with no Critical issues"
- Review output: `.ai/reports/reviews/pre-merge-{timestamp}.md`
- **BLOCKING:** Critical issues prevent merge approval

### Optional but Valuable

**When stuck (fresh perspective):**
- Multiple approaches failing
- Review output: `.ai/reports/reviews/diagnostic-{timestamp}.md`

**Before refactoring (baseline check):**
- Establish current state quality
- Review output: `.ai/reports/reviews/pre-refactor-{timestamp}.md`

**After fixing complex bug:**
- Multi-file changes, core system changes, security fixes
- Review output: `.ai/reports/reviews/bugfix-{issue}-{timestamp}.md`

## How to Request (Prodige Workflow)

### Step 1: Prepare Git Context

Get the commit range for the work to be reviewed:

```bash
# For task-based review (since last task)
BASE_SHA=$(git log --oneline | grep "Task [N-1]" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

# For feature review (since branch start)
BASE_SHA=$(git merge-base HEAD origin/main)
HEAD_SHA=$(git rev-parse HEAD)

# For pre-merge review (whole branch)
BASE_SHA=$(git merge-base HEAD origin/main)
HEAD_SHA=$(git rev-parse HEAD)

# Verify range
git log --oneline $BASE_SHA..$HEAD_SHA
git diff --stat $BASE_SHA..$HEAD_SHA
```

### Step 2: Dispatch Prodige Reviewer Agent

Use the **Prodige Reviewer Agent** (dedicated review agent, not general-purpose subagent):

Fill the template at [code-reviewer.md](code-reviewer.md) with:

**Required Context:**
- `{TYPE}` - Task Review | Feature Review | Pre-Merge Review | Diagnostic Review
- `{DESCRIPTION}` - Brief summary of what was built/changed
- `{REQUIREMENTS}` - Reference to PRD, spec, or implementation plan
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit
- `{REVIEW_AGAINST}` - List of documents to check compliance

**Prodige-Specific Fields:**
- `{SAVE_TO}` - `.ai/reports/reviews/task-N-review.md` (auto-generated filename)
- `{AGENT_NAME}` - Which agent did the work (Backend, Frontend, QA)
- `{SPECIAL_FOCUS}` - Any specific concerns (security, performance, complexity)

### Step 3: Reviewer Returns Severity-Based Report

**Prodige Reviewer classifies findings:**

#### Critical (🚫 Must Fix - Blocks Merge)
- Security vulnerabilities
- Data loss risks
- System crashes
- Breaking changes
- Incorrect core logic

**Response:** STOP IMMEDIATELY → Fix ALL Critical → Re-review → THEN proceed

#### Important (⚠️ Should Fix - Blocks Next Task)
- Code complexity/maintainability
- Missing error handling
- Incomplete tests
- Performance concerns
- Context drift

**Response:** Fix ALL Important before NEXT TASK → Brief verification → Continue

#### Minor (💡 Nice to Have)
- Code style inconsistencies
- Magic numbers
- TODO comments
- Documentation gaps

**Response:** Note in technical-debt.md → Fix if trivial (<5 min) → Otherwise proceed

### Step 4: Act on Feedback Based on Severity

```
IF Critical issues found:
  ❌ MERGE BLOCKED
  → Fix all Critical issues
  → Request follow-up review
  → DO NOT move to next task
  → DO NOT merge to main

ELSE IF Important issues found:
  ⚠️ MERGE CONDITIONAL
  → Fix all Important issues
  → Brief verification
  → THEN merge approved

ELSE IF only Minor issues found:
  ✅ MERGE APPROVED
  → Record Minor issues in technical-debt.md
  → Proceed to merge
```

### Step 5: Technical Pushback (When Appropriate)

If reviewer is wrong or lacks context, push back with technical reasoning:

**When to push back:**
- Reviewer suggests change that breaks existing functionality
- Reviewer lacks full context
- Reviewer suggests violating YAGNI (adding unused features)
- Legacy/compatibility reasons exist
- Conflicts with architectural decisions in DECISIONS.md

**How to push back:**
```markdown
**Re: Critical Issue - Remove legacy code**

Checked the suggested change. This code handles backward compatibility for API v1 clients.

Evidence:
- `git log` shows this added for v1 migration (commit a7b91f2)
- `grep -r "api/v1"` shows 47 references in test suite
- Removing breaks 12 integration tests

Recommendation: Keep legacy code OR explicitly decide to drop v1 support (breaking change).

Not a bug - intentional compatibility layer. Should I update comments to clarify?
```

## Example: Prodige Task Review Workflow

**Scenario:** Backend Agent completed Task 2 in subagent-driven development

```markdown
## Orchestrator: Task 2 Complete

Backend Agent finished Task 2 (Add verification function).
Requesting code review before Task 3.

### Prepare Git Context

```bash
BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

# Verify range
git log --oneline $BASE_SHA..$HEAD_SHA
# Output:
# 3df7661 Task 2: Add verifyIndex() with 4 issue types
# f892a43 Task 2: Add tests for verification function

git diff --stat $BASE_SHA..$HEAD_SHA
# Output:
# src/indexer/verify.js    | 127 +++++++++++++++
# src/indexer/verify.test.js | 89 +++++++++++
# 2 files changed, 216 insertions(+)
```

### Dispatch Reviewer

```markdown
## Review Request

**Type:** Task Review

**Description:**
Added verifyIndex() and repairIndex() functions with 4 issue type detections:
- Missing aliases
- Broken links
- Missing inbound links
- Orphaned files

**Requirements:**
Task 2 from `.ai/context/IMPLEMENTATION.md`:
"Implement verification function that scans index and detects common issues.
Must detect at least 3 issue types. Must return structured results."

**Commit Range:**
- Base: a7981ec
- Head: 3df7661
- Files Changed: 2 files, 216 lines added

**Review Against:**
1. PRD: `.ai/context/PRD.md`
2. Architecture: `.ai/context/ARCHITECTURE.md`
3. Implementation Plan: `.ai/context/IMPLEMENTATION.md`
4. Quality Gates: `.ai/checklists/pre-merge.md`

**Special Focus:**
- Are all 4 issue types tested?
- Is error handling complete?
- Any performance concerns for large indices?

**Save To:** `.ai/reports/reviews/task-002-20260617-143022.md`
**Agent:** Backend Agent

[Dispatch to Reviewer Agent]
```

### Reviewer Output

```markdown
# Code Review Report
**Date:** 2026-06-17 14:30:22
**Type:** Task Review
**Commit Range:** a7981ec..3df7661
**Reviewer:** Prodige Reviewer Agent

---

## Summary

**Files Changed:** 2
**Lines Added:** 216
**Lines Removed:** 0

**Overall Assessment:** APPROVED_WITH_CHANGES

**Merge Recommendation:**
⚠️ Safe to proceed to Task 3 after addressing 1 Important issue

---

## Strengths

- Clean separation: verify vs repair functions
- Comprehensive testing: all 4 issue types covered
- Good error handling: try/catch with context
- Real test fixtures (not mocked)
- Performance: streaming approach for large files

---

## Issues Found

### Critical (Must Fix - Blocks Merge)

None found.

### Important (Should Fix - Blocks Next Task)

**Issue:** Missing progress indicators for long-running verification
- **Location:** src/indexer/verify.js:100-127
- **Problem:** verifyIndex() can take 30+ seconds on large indices with no user feedback
- **Impact:** Poor UX - users think process is hung
- **Suggestion:** Add progress callback or console.log every 100 items

```javascript
// Suggested fix
function verifyIndex(indexPath, options = {}) {
  const { onProgress } = options;
  let processed = 0;
  
  for (const entry of index) {
    // ...verification logic...
    processed++;
    if (processed % 100 === 0 && onProgress) {
      onProgress({ processed, total: index.length });
    }
  }
}
```

### Minor (Nice to Have)

**Issue:** Magic number (100) for reporting interval
- **Location:** src/indexer/verify.js:145 (if implemented per suggestion)
- **Observation:** Hardcoded value makes tuning difficult
- **Suggestion:** Extract to constant `REPORT_INTERVAL = 100`

Low priority - record in technical-debt.md if not fixing now.

---

## Spec Compliance: ✅ PASS

- ✅ Detects 4 issue types (requirement: at least 3)
- ✅ Returns structured results
- ✅ No extra features added (YAGNI compliant)

---

## Recommendations

1. **Add progress reporting** (Important)
   - File: src/indexer/verify.js
   - Add `onProgress` callback option
   - Report every 100 items
   - Update tests to verify callback invoked

---

## Approval Decision

**Status:** APPROVED_WITH_CHANGES

**Rationale:**
Clean implementation that meets requirements. One Important issue (progress reporting) should be fixed before Task 3, since Task 3 builds on this verification function.

**Next Steps:**
1. Add progress reporting (Important issue)
2. Verify with test: `npm test src/indexer/verify.test.js`
3. Proceed to Task 3

---

**Report saved to:** `.ai/reports/reviews/task-002-20260617-143022.md`
**Review completed:** 2026-06-17 14:30:22
```

### Orchestrator Response

```markdown
## Review Complete: Task 2

**Status:** APPROVED_WITH_CHANGES
**Issues:** 1 Important, 1 Minor

### Addressing Important Issue

Dispatching Backend Agent to add progress reporting:

**Task:** Add progress reporting to verifyIndex()
**Context:** Review feedback from task-002-20260617-143022.md
**Requirement:** onProgress callback, report every 100 items

[Backend Agent implements fix]

### Verification

```bash
npm test src/indexer/verify.test.js
# Output: 12/12 tests passing
# Coverage: 96%
```

### Minor Issue

Recorded in technical-debt.md:
"Extract magic number (100) for reporting interval in verifyIndex()"

### Proceeding to Task 3

Important issue resolved. Moving to next task.
```
```

## Integration with Prodige Workflows

### Subagent-Driven Development (`/build` workflow)

**Pattern:**
```
Orchestrator:
  ├─ Dispatch Backend Agent → Task 1
  ├─ Task 1 complete
  ├─ **REQUEST REVIEW (Task 1)**  ← This skill
  ├─ Review: 1 Important issue found
  ├─ Dispatch Backend Agent → Fix Important issue
  ├─ Continue to Task 2
  └─ ...all tasks complete
      └─ **REQUEST FINAL PRE-MERGE REVIEW**  ← This skill
```

**Review Points:**
1. After EACH task completion
2. After ALL tasks complete (pre-merge)

### Executing Plans (Sequential workflow)

**Pattern:**
```
Agent:
  ├─ Execute Task 1
  ├─ Self-review checklist
  ├─ Continue to Task 2
  ├─ Execute Task 2
  ├─ Self-review checklist
  └─ ...all tasks complete
      └─ **REQUEST REVIEW** before merge  ← This skill
```

**Review Points:**
1. Self-review after each task (informal)
2. Full review before merge (formal)

### Ad-Hoc Development Workflow

**Pattern:**
```
Agent:
  ├─ Implement feature
  ├─ Tests pass
  └─ **REQUEST REVIEW** before merge  ← This skill
```

**Review Points:**
1. Before merge to main (mandatory)

### `/review` Command Integration

**Manual review trigger:**
```bash
/review

# Triggers:
1. Detect current branch
2. Calculate BASE_SHA (merge-base with main)
3. Get HEAD_SHA
4. Dispatch Reviewer Agent with commit range
5. Save report to .ai/reports/reviews/
6. Display summary with severity counts
```

## Pre-Merge Checklist Integration

The pre-merge checklist (`.ai/checklists/pre-merge.md`) requires:

```markdown
## Prodige Structural Checks
- [ ] Code review completed ← Review report exists in .ai/reports/reviews/
- [ ] No Critical issues found ← BLOCKING condition
- [ ] Important issues addressed ← BLOCKING condition
- [ ] Minor issues documented in technical-debt.md
```

**Merge Approval Logic:**
```
IF Critical issues found:
  ❌ MERGE BLOCKED
  → Fix all Critical issues
  → Request follow-up review
  → THEN proceed to merge

ELSE IF Important issues found:
  ⚠️ MERGE CONDITIONAL
  → Fix all Important issues
  → Brief verification
  → THEN merge approved

ELSE IF only Minor issues found:
  ✅ MERGE APPROVED
  → Record Minor issues in technical-debt.md
  → Proceed to merge
```

---

## Output Directory Structure

```
.ai/reports/reviews/
├── task-001-implement-auth-20260617-143022.md
├── task-002-add-validation-20260617-151533.md
├── feature-user-management-20260617-164422.md
├── pre-merge-auth-feature-20260617-170015.md
├── bugfix-login-timeout-20260617-091122.md
└── diagnostic-payment-flow-20260617-143055.md
```

**Naming Convention:**
- Task reviews: `task-{number}-{description}-{timestamp}.md`
- Feature reviews: `feature-{name}-{timestamp}.md`
- Pre-merge reviews: `pre-merge-{branch-name}-{timestamp}.md`
- Bug fix reviews: `bugfix-{issue}-{timestamp}.md`
- Diagnostic reviews: `diagnostic-{area}-{timestamp}.md`

---

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Move to next task while review has open Critical/Important issues
- Argue with valid technical feedback without evidence

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Reference working evidence (git log, grep results, test output)
- Involve Orchestrator/Architect if architectural conflict

**Always:**
- Request review after EACH task in subagent-driven development
- Request final review before merge
- Fix Critical issues immediately
- Fix Important issues before next task
- Document Minor issues in technical-debt.md

---

## Quick Reference

| Scenario | Review Type | When | Blocking Level |
|----------|-------------|------|----------------|
| After task in SDD | Task Review | After each task | Important issues block next task |
| Feature complete | Feature Review | After all feature tasks | Important issues block merge |
| Before merge | Pre-Merge Review | Before PR approved | Critical issues block merge |
| Multiple failures | Diagnostic Review | When stuck | Non-blocking (informational) |
| Bug fix | Bug Fix Review | After fix | Critical issues block merge |
| Before refactor | Pre-Refactor Review | Before starting | Non-blocking (baseline) |

---

## Integration with Other Skills

**Works With:**
- **subagent-driven-development** - Review after each task
- **executing-plans** - Review before merge
- **receiving-code-review** - How to handle feedback
- **verification-before-completion** - Pre-review quality checks

**Required By:**
- **Pre-merge checklist** - Review completion is mandatory gate
- **Quality gates** - Critical/Important issues must be resolved

See template at: [code-reviewer.md](code-reviewer.md)

---

# Prodige Reviewer Agent Integration

## What Makes Prodige Reviewer Different

The Prodige Reviewer agent is not a generic code reviewer. It enforces **engineering principles** and Prodige structural rules to prevent common AI-assisted development antipatterns before they reach main.

### Core Enforcement Areas

**1. Behavioral Discipline Rules:**
- **Assumption Clarity:** Did the agent ask questions before implementing? Are assumptions documented?
- **Simplicity:** Would a senior engineer call this overcomplicated? Are abstractions justified?
- **Surgical Precision:** Is the git diff limited to task-related changes only?
- **Verification Quality:** Are success criteria defined and verified with evidence?
- **Scope Discipline:** Does the PR include only requested features?

**2. Prodige Structural Rules:**
- Context file updates (ARCHITECTURE.md, DECISIONS.md)
- Snapshot vs live context usage
- Session assignment in parallel mode
- Handoff document completeness
- Registry updates for technical debt

### Why Not Use Generic Reviewers

Generic code reviewers focus on:
- Code style and formatting
- Basic best practices
- Surface-level patterns

**They miss:**
- Hidden assumptions and undocumented decisions
- Overcomplicated solutions that "work" but violate simplicity
- Scope creep disguised as improvements
- Drive-by refactoring mixed with legitimate changes
- Vague verification statements without evidence

Prodige Reviewer catches these AI-assisted development antipatterns because it understands the **workflow context** and enforces **behavioral principles**, not just code patterns.

### When to Use Prodige Reviewer vs General-Purpose

**Use Prodige Reviewer (preferred):**
- After completing any task in a planned workflow
- Before merge to main
- When following /build, /design, or /fix commands
- For reviews that need behavioral and structural compliance

**Use General-Purpose with Code-Reviewer Template:**
- For quick spot checks during exploration
- When Prodige Reviewer is unavailable
- For external code reviews (code not produced by Prodige agents)

**Key Difference:** Prodige Reviewer enforces workflow discipline and catches AI-specific antipatterns. General-purpose reviewers focus on code quality alone.

### Invoking Prodige Reviewer

**Method 1: Direct Agent Dispatch**

```bash
# Get SHAs
BASE_SHA=$(git rev-parse origin/main)
HEAD_SHA=$(git rev-parse HEAD)

# Dispatch reviewer agent
[Invoke Prodige Reviewer Agent]
  Context: Task 3 implementation from .ai/plans/user-auth-plan.md
  Base SHA: ${BASE_SHA}
  Head SHA: ${HEAD_SHA}
  Implementation Summary: Added JWT authentication with refresh tokens
```

**Method 2: Via /review Workflow**

The `/review` workflow is a shorthand that:
1. Automatically captures current git range
2. Loads relevant plan/task context
3. Dispatches Prodige Reviewer with proper context
4. Saves review report to `.ai/reports/reviews/`
5. Updates pre-merge checklist status

```bash
# After committing your work
git commit -am "feat: add JWT authentication"

# Trigger review
/review
```

The workflow will:
- Inspect the diff between HEAD and base branch
- Check correctness, security, modularity
- Check for context drift (ARCHITECTURE.md out of date, etc.)
- Classify findings by severity
- Generate merge decision
- Save report to `.ai/reports/reviews/review-{timestamp}.md`

---

# Severity Classification System

## Overview

Prodige uses a three-tier severity system that maps directly to **workflow blocking behavior**. Severity determines whether work can proceed, not just the "importance" of an issue.

| Severity | Blocks | Action Required | Timeline |
|----------|--------|-----------------|----------|
| **Critical** | Merge to main | Must fix before merge | Immediately |
| **Important** | Next task | Must fix before proceeding | Before next work |
| **Minor** | Nothing | Record in tech debt | Later (backlog) |

**Key Principle:** Severity is about **workflow impact**, not subjective importance. A missing config file that breaks production is Critical. A performance optimization that saves 50ms is Minor, even if it's "important" for UX.

## Critical Severity

### Definition

**Blocks merge to main.** Issues that would:
- Break production functionality
- Create security vulnerabilities
- Cause data loss or corruption
- Violate core requirements
- Make the codebase unmaintainable

**Test:** "If this reaches production, would we roll back immediately?"

If YES → Critical

### Common Examples

**1. Broken Functionality**
```javascript
// Task: Add user login endpoint
// Code implements logout instead
app.post('/api/login', (req, res) => {
  req.session.destroy();  // ❌ CRITICAL: Wrong functionality
  res.json({ message: 'Logged out' });
});
```

**Severity Justification:** Core requirement violated. Login endpoint must authenticate, not logout.

**2. Security Vulnerabilities**
```javascript
// SQL Injection vulnerability
function getUserByEmail(email) {
  return db.query(`SELECT * FROM users WHERE email = '${email}'`);
  // ❌ CRITICAL: SQL injection risk
}
```

**Severity Justification:** Exploitable vulnerability. Attacker can extract or modify any data.

**3. Data Loss Risk**
```javascript
// Task: Archive old orders
function archiveOrders(date) {
  db.exec(`DELETE FROM orders WHERE created_at < '${date}'`);
  // ❌ CRITICAL: No backup, no recovery, permanent deletion
}
```

**Severity Justification:** Irreversible data loss without backup or soft-delete mechanism.

**4. Missing Core Features**
```javascript
// Task: Implement password reset with email verification
// Implementation missing email verification step
function resetPassword(userId, newPassword) {
  db.updatePassword(userId, hash(newPassword));
  // ❌ CRITICAL: Security requirement skipped
}
```

**Severity Justification:** Security requirement explicitly specified in task was omitted.

**5. Architecture Violations**
```javascript
// Task: Add caching layer following ARCHITECTURE.md pattern
// Implementation bypasses architecture
function getUser(id) {
  // Direct DB call, ignoring caching layer
  return db.users.findById(id);  // ❌ CRITICAL: Violates documented architecture
}
```

**Severity Justification:** Violates ARCHITECTURE.md contract. Creates inconsistent data access patterns.

### Critical Issue Response Pattern

**When Prodige Reviewer finds Critical issues:**

```markdown
## Critical Issues Found: MERGE BLOCKED

### Issue #1: SQL Injection in getUserByEmail()
**File:** src/auth/db.js:45
**Severity:** Critical
**Impact:** Security vulnerability - arbitrary SQL execution

**Problem:**
Direct string interpolation in SQL query allows SQL injection:
```javascript
db.query(`SELECT * FROM users WHERE email = '${email}'`)
```

**Attack Vector:**
email = "admin@example.com' OR '1'='1" bypasses authentication

**Fix Required:**
Use parameterized queries:
```javascript
db.query('SELECT * FROM users WHERE email = ?', [email])
```

**Blocks:** Merge to main
**Timeline:** Must fix immediately before any merge
```

**Agent Response to Critical Issues:**

1. **Stop all work immediately**
2. **Acknowledge the issue:**
   ```
   Acknowledged. SQL injection vulnerability is Critical.
   Pausing work on next task.
   ```

3. **Fix the issue:**
   - Read affected code
   - Implement fix following reviewer's guidance
   - Add regression test
   - Verify fix works

4. **Request re-review:**
   ```
   Fixed SQL injection by switching to parameterized queries.
   Added test case for SQL injection attempt.
   All tests passing.
   
   Ready for re-review of src/auth/db.js:45
   ```

5. **Wait for approval before proceeding**

**Never:**
- Argue that Critical issues aren't really critical
- Defer Critical fixes to "later"
- Proceed to next task with open Critical issues
- Merge with Critical issues marked "TODO"

---

## Important Severity

### Definition

**Blocks next task.** Issues that:
- Reduce code quality significantly
- Miss non-critical requirements
- Create maintainability problems
- Show poor error handling
- Indicate scope creep or behavioral violations

**Test:** "Can we safely build the next feature on top of this?"

If NO → Important

### Common Examples

**1. Missing Error Handling**
```javascript
// Task: Add file upload endpoint
app.post('/api/upload', async (req, res) => {
  const file = await saveFile(req.file);  // ❌ IMPORTANT: No error handling
  res.json({ url: file.url });
});
```

**Severity Justification:** Not Critical (won't break existing features), but Important because next feature might rely on proper error responses.

**2. Scope Creep**
```javascript
// Task: Add login endpoint
// Implementation also adds password reset (not requested)

app.post('/api/login', loginHandler);           // ✓ Requested
app.post('/api/password-reset', resetHandler);  // ❌ IMPORTANT: Scope creep
```

**Severity Justification:** Not Critical (doesn't break anything), but Important because it violates surgical precision and adds untested scope.

**3. Overcomplication**
```javascript
// Task: Validate email format
// Simple requirement → overcomplicated solution

class EmailValidatorFactory {  // ❌ IMPORTANT: Overengineered
  createValidator(strategy) {
    return new EmailValidator(strategy);
  }
}

// Should be: const isValid = /^[^@]+@[^@]+$/.test(email);
```

**Severity Justification:** Not Critical (works correctly), but Important because it violates simplicity principle and makes maintenance harder.

**4. Incomplete Requirements**
```javascript
// Task: Add pagination to /users endpoint
// Missing: total count and hasMore indicators

app.get('/api/users', (req, res) => {
  const { page = 1, limit = 20 } = req.query;
  const users = db.users.paginate(page, limit);
  res.json({ users });  // ❌ IMPORTANT: Missing pagination metadata
});

// Should include: total, currentPage, totalPages, hasMore
```

**Severity Justification:** Functional but incomplete. Frontend can't build proper pagination UI.

**5. Drive-By Refactoring**
```diff
# Task: Add logging to auth module
# Git diff shows unrelated formatting changes

  src/auth/login.js         | 15 ++++++++----
  src/auth/register.js      | 22 ++++++++--------  # ❌ IMPORTANT: Not in task
  src/utils/validation.js   | 8 +++----              # ❌ IMPORTANT: Not in task
```

**Severity Justification:** Not Critical (doesn't break anything), but Important because it violates surgical precision and makes review harder.

**6. Missing Test Coverage**
```javascript
// Task: Add rate limiting middleware
// Implementation complete but no tests

function rateLimiter(limit) {
  const requests = new Map();
  return (req, res, next) => {
    // ... implementation ...  // ❌ IMPORTANT: No tests for edge cases
  };
}
```

**Severity Justification:** Not Critical (code might work), but Important because untested rate limiting could fail under load.

### Important Issue Response Pattern

**When Prodige Reviewer finds Important issues:**

```markdown
## Important Issues Found: FIX BEFORE NEXT TASK

### Issue #1: Missing Error Handling in File Upload
**File:** src/api/upload.js:23
**Severity:** Important
**Impact:** Next feature (upload progress tracking) will fail without proper error states

**Problem:**
No error handling for file save operation:
```javascript
const file = await saveFile(req.file);  // Throws unhandled exception
```

**Why This Matters:**
1. Upload progress feature (next task) needs error states
2. Frontend can't differentiate between success/failure
3. Server crashes on disk full or permission errors

**Fix Required:**
```javascript
try {
  const file = await saveFile(req.file);
  res.json({ url: file.url });
} catch (error) {
  res.status(500).json({ error: 'Upload failed', message: error.message });
}
```

**Blocks:** Next task (upload progress)
**Timeline:** Fix before proceeding to Task 4
```

**Agent Response to Important Issues:**

1. **Acknowledge and assess:**
   ```
   Acknowledged. Missing error handling is Important.
   This will block upload progress feature (Task 4).
   ```

2. **Fix before next task:**
   - Complete current task properly
   - Don't start next task until fixed
   - Add tests for error scenarios
   - Update relevant documentation

3. **Document the fix:**
   ```
   Added comprehensive error handling to upload endpoint:
   - Disk space errors → 507 response
   - Permission errors → 500 response  
   - Invalid file type → 400 response
   
   Added test coverage:
   - test_upload_disk_full()
   - test_upload_invalid_type()
   - test_upload_success()
   
   All tests passing (12/12).
   Ready to proceed to Task 4.
   ```

4. **Request clearance:**
   ```
   Important issues resolved. Request clearance to proceed to Task 4.
   ```

**Can you proceed without fixing?**
- ❌ No - if next task depends on this functionality
- ⚠️ Maybe - if next task is independent (ask first)
- ✓ Yes - only with explicit approval and tech debt recorded

---

## Minor Severity

### Definition

**Doesn't block work.** Issues that:
- Are optimization opportunities
- Improve code style or readability
- Add nice-to-have features
- Polish documentation
- Represent technical debt worth tracking

**Test:** "Can we ship this and address it later?"

If YES → Minor

### Common Examples

**1. Performance Optimization**
```javascript
// Works correctly but could be faster
function findUsersByRole(role) {
  return users.filter(u => u.role === role);  // ⚠️ MINOR: O(n) scan
}

// Could add index for O(log n), but not blocking if dataset is small
```

**Severity Justification:** Functionally correct. Optimization valuable but not urgent.

**2. Code Duplication**
```javascript
// Same validation logic in 2 places
function validateLogin(data) {
  if (!data.email || !data.password) return false;
  // ... ⚠️ MINOR: Duplicated in validateRegister()
}
```

**Severity Justification:** Works fine. DRY refactor is good hygiene but not blocking.

**3. Magic Numbers**
```javascript
// Hard-coded value that should be configurable
function rateLimit(req) {
  const count = requests.get(req.ip);
  return count > 100;  // ⚠️ MINOR: Magic number
}

// Should be config value, but works fine as-is
```

**Severity Justification:** Functional. Making it configurable is nice to have, not required.

**4. Documentation Polish**
```javascript
// Function works but docs could be better
function processOrder(order) {
  // Process order  // ⚠️ MINOR: Vague comment
  // ... (complex logic)
}

// Better: Explain validation → payment → fulfillment flow
```

**Severity Justification:** Code is understandable. Better docs would help but not blocking.

**5. Missing Edge Case Handling (Non-Critical)**
```javascript
// Task: Add username validation
function validateUsername(name) {
  return name.length >= 3 && name.length <= 20;
  // ⚠️ MINOR: Doesn't handle emoji or unicode edge cases
}

// Works for 99% of cases. Unicode handling is polish.
```

**Severity Justification:** Meets core requirements. Edge cases can be addressed later.

**6. Test Coverage Gaps (Low Priority)**
```javascript
// Core functionality tested, but missing edge cases
test('login with valid credentials', () => { ... });  // ✓ Present
test('login with invalid credentials', () => { ... });  // ✓ Present
// ⚠️ MINOR: Missing test for expired credentials
```

**Severity Justification:** Core paths tested. Additional edge case tests are good but not blocking.

