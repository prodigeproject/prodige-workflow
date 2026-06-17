# Workflow: Code Review

## Purpose
Systematic evaluation of code changes for correctness, quality, security, and merge readiness. Validate adherence to Karpathy principles and Prodige standards.

**Core principle:** Thorough but surgical. Catch issues before merge, ensure simplicity and correctness.

---

## Steps

### 1. Load Full Context

**Gather necessary context:**
- Read PRD or feature requirements
- Review ARCHITECTURE.md for system design
- Check implementation plan if available
- Review DECISIONS.md for past tradeoffs
- Load relevant existing code for comparison

**Understand:**
- What is the feature/fix trying to achieve?
- What are success criteria?
- What are architectural constraints?

**Skill:** Context loading (baseline understanding)

### 2. Inspect Diff and Changed Files

**Get complete diff:**
```bash
git diff main --stat
git diff main
```

**First-pass scan:**
- How many files changed?
- Which files changed?
- Size of changes (lines added/removed)
- Any unexpected files in diff?

**Create mental map:** What parts of system were touched?

### 3. Verify Feature Completeness

**Cross-check implementation against requirements:**

Load PRD/requirements and create checklist:
```
Requirements from PRD:
- [ ] Requirement 1: [description] → Code: [file:line]
- [ ] Requirement 2: [description] → Code: [file:line]
- [ ] Requirement 3: [description] → Code: [file:line]
```

**For each requirement:**
- Is it implemented?
- Where is it implemented?
- Is implementation complete?

**Check for:**
- Missing requirements
- Partial implementations
- Scope creep (unrequested features)

**Karpathy principle:** Goal-driven - verify all success criteria met.

### 4. Check Correctness and Logic

**Review core logic:**

For each changed function/method:
- Does logic correctly implement requirement?
- Are edge cases handled?
- Are error paths covered?
- Any off-by-one errors, null checks, boundary conditions?

**Common logic issues:**
- Incorrect conditionals (&&, ||, !)
- Missing null/undefined checks
- Wrong default values
- Incorrect loop boundaries
- Race conditions in async code

**Test:** Can you trace execution paths? Do they all make sense?

### 5. Evaluate Code Quality and Readability

**Check for clarity:**
- Are names descriptive? (no `data`, `temp`, `x`)
- Is code self-documenting?
- Are functions focused (single responsibility)?
- Is complexity reasonable?

**Calculate rough complexity:**
- Functions >50 lines → Flag for simplification
- Nested conditionals >3 levels → Flag for refactoring
- Duplicated logic → Flag for extraction

**Karpathy principle:** Simplicity first - minimum code that solves problem.

**Red flags:**
- Cryptic variable names
- Functions doing multiple things
- Complex nested logic
- Magic numbers without explanation

### 6. Run Karpathy Simplicity Check

**Ask the critical question:** "Would a senior engineer say this is overcomplicated?"

**Check for overcomplication signals:**

**Unnecessary abstractions:**
- Strategy pattern with 1 implementation?
- Abstract base class with 1 subclass?
- Factory for single object type?
- Middleware for single use?

**Premature optimization:**
- Caching without measurement?
- Async where sync is fine?
- Microservices for small system?

**Speculative features:**
- Configuration for hardcoded value?
- Flexibility nobody requested?
- Error handling for impossible scenarios?

**The test:** If implementation is 200 lines and could be 50, flag it.

**Skill:** `karpathy-behavioral` (Simplicity principle)

### 7. Verify Surgical Precision

**Check git diff for non-surgical changes:**

**For each changed file:**
- Is file mentioned in implementation plan? → Should be YES
- Are changes limited to task scope? → Should be YES
- Any style/format changes (quotes, spacing, tabs)? → Should be NO
- Any comment-only changes? → Should be NO
- Any drive-by refactoring? → Should be NO

**Acceptable changes:**
- Code directly implementing feature
- Imports needed for new code
- Removing imports/variables YOUR changes made unused

**Unacceptable changes:**
- Reformatting existing code
- Changing quote style
- Rewriting comments
- Refactoring unrelated functions
- Cleaning up pre-existing dead code

**The test:** Every changed line should trace directly to the request.

**Skill:** `karpathy-behavioral` (Surgical changes)

### 8. Review Test Coverage and Quality

**Verify tests exist and are meaningful:**

**Check:**
- Does every new function have a test?
- Do tests cover edge cases?
- Do tests cover error paths?
- Are tests clear and focused?

**Test quality criteria:**
- [ ] Tests written BEFORE implementation (TDD compliance)
- [ ] Tests failed first (RED), then passed (GREEN)
- [ ] Test names describe behavior
- [ ] Tests use real code (not just mocks)
- [ ] Coverage ≥90% for new code

**Run tests and verify output:**
```bash
npm test -- --coverage
```

**Verify:**
- X/X tests passing
- Coverage percentage
- No skipped/pending tests

**Skill:** `test-driven-development` (verify TDD compliance)

### 9. Check Security Considerations

**Scan for common vulnerabilities:**

**Input validation:**
- User input sanitized?
- SQL injection risk? (use parameterized queries)
- XSS risk? (escape output)
- Path traversal risk? (validate file paths)

**Authentication/Authorization:**
- Are protected endpoints actually protected?
- Are permissions checked?
- Is sensitive data exposed in logs/errors?

**Data handling:**
- Secrets hardcoded? (should be in env vars)
- Sensitive data logged?
- PII handled appropriately?

**Dependencies:**
- New dependencies reviewed?
- Known vulnerabilities? (check npm audit)

**Flag any security issues as MUST FIX.**

**Skill:** Security review checklist

### 10. Assess Performance Implications

**Check for performance issues:**

**Database queries:**
- N+1 query problems?
- Missing indexes?
- Fetching unnecessary data?

**Algorithms:**
- Time complexity reasonable? (avoid O(n²) for large n)
- Unnecessary loops?
- Inefficient data structures?

**Resource usage:**
- Memory leaks (event listeners, intervals)?
- File handles not closed?
- Connections not cleaned up?

**For most changes:** Performance is fine.

**Flag concerns, but don't require premature optimization.**

### 11. Verify Documentation Completeness

**Check documentation updates:**

**Code-level:**
- [ ] Complex logic has comments explaining WHY
- [ ] Public APIs have JSDoc/docstrings
- [ ] Edge cases documented

**Project-level:**
- [ ] ARCHITECTURE.md updated if structure changed
- [ ] DECISIONS.md updated if tradeoffs made
- [ ] README updated if user-facing changes
- [ ] CHANGELOG.md has entry

**Not every change needs docs:**
- Simple bug fixes → No docs needed
- Internal refactoring → No docs needed
- New features or architecture changes → Docs required

### 12. Run RoastMe Questions (Karpathy Deep Check)

**Execute mental RoastMe critique:**

**Ask yourself:**

**1. Hidden assumptions?**
- Did implementer state assumptions explicitly?
- Were multiple interpretations considered?
- Were clarifying questions asked?

**2. Overcomplication?**
- Is code simpler than expected? (GOOD)
- Is code more complex than expected? (BAD)
- Are abstractions justified by 2+ use cases?

**3. Surgical precision?**
- Only task-related files changed?
- No "improvements" to unrelated code?
- No style/format changes mixed in?

**4. Clear success criteria?**
- Can success be verified automatically?
- Are verification steps documented?
- Was verification actually run?

**Rate each dimension:** PASS / NEEDS WORK / FAIL

**Skill:** `roastme` mental framework

### 13. Run Pre-Merge Checklist

**Execute systematic pre-merge check:**

From `checklists/pre-merge.md`:

**Structural checks:**
- [ ] Tests run and output verified (fresh run)
- [ ] Code review completed (this workflow)
- [ ] Context files updated
- [ ] Debt recorded if applicable

**Behavioral checks:**
- [ ] TDD compliance (tests before implementation)
- [ ] Verification evidence provided
- [ ] Simplicity verified (not overcomplicated)
- [ ] Surgical precision verified (clean diff)

**If using pre-merge checklist:** Follow it line-by-line.

### 14. Classify Findings and Prioritize

**Organize all findings into categories:**

**MUST FIX (blocking issues):**
- Incorrect logic or behavior
- Security vulnerabilities
- Missing critical requirements
- Failing tests
- Major overcomplication (6+ violations)

**SHOULD FIX (important but not blocking):**
- Code quality issues
- Minor complexity problems
- Missing edge case tests
- Unclear naming
- Minor security hardening

**NICE TO HAVE (suggestions):**
- Performance optimizations
- Additional documentation
- Refactoring opportunities
- Code style preferences

**Format findings:**
```markdown
## Review Findings

### 🚨 MUST FIX (Blocking)
1. [File:Line] - [Issue description]
   - Problem: [what's wrong]
   - Fix: [specific action needed]

### ⚠️ SHOULD FIX (Important)
1. [File:Line] - [Issue description]
   - Suggestion: [recommended fix]

### 💡 NICE TO HAVE (Optional)
1. [File:Line] - [Enhancement idea]
```

### 15. Make Merge Decision and Deliver Verdict

**Synthesize review into clear decision:**

**✅ APPROVE - Merge Ready:**
- All MUST FIX items: 0
- All requirements implemented
- Tests passing with good coverage
- No security issues
- Clean, surgical diff
- Follows Karpathy principles

**🔄 REQUEST CHANGES - Needs Revision:**
- MUST FIX items: 1-3
- Issues can be fixed quickly (<1 hour)
- Overall approach is sound
- Most requirements met

**❌ REJECT - Major Revision Required:**
- MUST FIX items: 4+
- Fundamental design issues
- Major overcomplication
- Extensive non-surgical changes
- Missing core requirements

**Deliver verdict with structure:**
```markdown
## Code Review Verdict: [APPROVE / REQUEST CHANGES / REJECT]

**Summary:** [1-2 sentence overview]

**Strengths:**
- [What was done well]

**Issues Found:**
- MUST FIX: [count]
- SHOULD FIX: [count]
- NICE TO HAVE: [count]

**Decision Rationale:**
[Why this decision]

**Next Steps:**
[What should happen next]

**Estimated fix time:** [X hours] (if changes requested)
```

---

## Review Output Format

```markdown
# Code Review: [Feature/PR Name]

**Reviewer:** [Reviewer agent/name]
**Date:** [timestamp]
**Branch:** [branch-name]
**Files Changed:** [count]
**Lines Changed:** +[added] -[removed]

---

## Executive Summary

[2-3 sentence overview of changes and verdict]

---

## Requirements Verification

| Requirement | Status | Location | Notes |
|-------------|--------|----------|-------|
| [Req 1] | ✅ Complete | file.js:L20 | [comment] |
| [Req 2] | ⚠️ Partial | file.js:L45 | Missing edge case |
| [Req 3] | ❌ Missing | N/A | Not implemented |

---

## Code Quality Assessment

**Simplicity Score:** [0-100] (higher is better)
**Surgical Precision:** [Clean / Minor issues / Significant violations]
**Test Coverage:** [X%]
**Complexity:** [Acceptable / Needs reduction]

---

## Detailed Findings

### 🚨 MUST FIX (Blocking)
[List with file:line references]

### ⚠️ SHOULD FIX (Important)
[List with file:line references]

### 💡 NICE TO HAVE (Optional)
[List with suggestions]

---

## Karpathy Behavioral Check

| Principle | Status | Notes |
|-----------|--------|-------|
| Think Before Coding | ✅ PASS | Assumptions stated clearly |
| Simplicity First | ⚠️ NEEDS WORK | 2 overcomplications found |
| Surgical Changes | ✅ PASS | Clean diff |
| Goal-Driven | ✅ PASS | All criteria verified |

---

## Security Review

- [ ] Input validation: [status]
- [ ] Authentication/Authorization: [status]
- [ ] Sensitive data handling: [status]
- [ ] Dependency security: [status]

**Issues:** [None / List issues]

---

## Test Review

**Tests written:** [count]
**Tests passing:** [X/X]
**Coverage:** [X%]
**TDD compliance:** [Yes / No / Partial]

**Test quality issues:** [None / List issues]

---

## Documentation Review

- [x] Code comments adequate
- [x] ARCHITECTURE.md updated
- [ ] DECISIONS.md needs update
- [x] CHANGELOG.md updated

---

## Final Verdict

**Decision:** [✅ APPROVE / 🔄 REQUEST CHANGES / ❌ REJECT]

**Rationale:**
[Clear explanation of decision]

**Next Steps:**
[Specific actions needed]

**Estimated fix time:** [if changes needed]

---

**Reviewer Signature:** [Reviewer agent]
**Review Complete:** [timestamp]
```

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Thorough** | Check all dimensions systematically | Used full checklist |
| **Fair** | Judge by standards, not preferences | Applied Karpathy principles |
| **Clear** | Findings are specific and actionable | Each issue has file:line |
| **Goal-focused** | Verify requirements met | Requirements checklist complete |

---

## Red Flags - Dig Deeper

- Large changes without tests
- Tests passing immediately (no TDD)
- Files changed unrelated to task
- Security-sensitive code without validation
- Complexity spikes in specific areas
- Vague commit messages
- No documentation for major changes

**If you see these:** Investigate thoroughly before approving.

---

## Integration Points

**Skills:**
- `karpathy-behavioral` - Simplicity, surgical, assumptions (Steps 6, 7, 12)
- `test-driven-development` - Verify TDD compliance (Step 8)
- `verification-before-completion` - Evidence required (Step 8)
- `requesting-code-review` - Context for reviewer role

**Commands:**
- `/roastme build` - Automated Karpathy check (can run as supplement)

**Checklists:**
- `pre-merge.md` - Comprehensive checklist (Step 13)

**Agents:**
- `reviewer` - This workflow is reviewer agent's primary function

---

**Remember:** Review is the last gate before merge. Be thorough, be fair, be clear. Catch issues here, prevent production bugs.
