# Code Review Template

**How to Use**: This template is used by the `/review` workflow for code review and approval gates.

**When**: Before merging code, after implementation complete  
**Updated By**: Reviewer agent or human reviewer  
**Referenced In**: `.ai/workflows/review.md`, HITL gates

---

## Decision

**What Goes Here**: Final review decision

**Options**:
- ✅ **Approved** - Code is production-ready, merge allowed
- ⚠️ **Approved with Changes** - Minor fixes needed, but can merge
- ❌ **Blocked** - Critical issues, cannot merge

**Format**:
```
Decision: {Approved/Approved with Changes/Blocked}
Reviewer: {agent-name or human-name}
Date: {YYYY-MM-DD HH:MM}
Reason: {brief explanation}
```

**Example**:
```
Decision: Approved with Changes
Reviewer: Backend Agent + Human (John)
Date: 2026-06-17 14:30
Reason: Code quality good, but needs inline comments for complex logic
```

---

## Findings

**What Goes Here**: Categorized review findings with severity and action items

### Format

```
### {Category}: {Title}
**Severity**: {CRITICAL/HIGH/MEDIUM/LOW}  
**Location**: {file:line}  
**Issue**: {What's wrong}  
**Impact**: {Why it matters}  
**Recommendation**: {How to fix}  
**Action**: {MUST FIX / SHOULD FIX / NICE TO HAVE}  
```

### Categories

1. **Security** - Auth, data protection, injection risks
2. **Performance** - N+1 queries, memory leaks, slow algorithms
3. **Correctness** - Logic errors, edge cases, null handling
4. **Code Quality** - Naming, structure, duplication
5. **Testing** - Missing tests, flaky tests, low coverage
6. **Documentation** - Missing docs, outdated comments

---

## Examples

### Security Finding

```
### Security: SQL Injection Risk in Search
**Severity**: CRITICAL  
**Location**: `src/users/search.ts:23`  
**Issue**: User input directly concatenated into SQL query  
**Code**:
\`\`\`typescript
const query = `SELECT * FROM users WHERE name LIKE '%${searchTerm}%'`;
\`\`\`
**Impact**: Attacker can execute arbitrary SQL (data breach, deletion)  
**Recommendation**: Use parameterized queries or ORM  
**Action**: MUST FIX (blocking issue)  
```

### Performance Finding

```
### Performance: N+1 Query in User List
**Severity**: HIGH  
**Location**: `src/users/list.controller.ts:45`  
**Issue**: Loads orders for each user in separate query  
**Impact**: 100 users = 101 queries, response time 2+ seconds  
**Recommendation**: Use JOIN or eager loading  
**Action**: SHOULD FIX (degrades UX)  
```

### Code Quality Finding

```
### Code Quality: Magic Numbers in Discount Logic
**Severity**: MEDIUM  
**Location**: `src/billing/discount.ts:12-18`  
**Issue**: Hardcoded 0.1, 0.15, 0.2 without explanation  
**Impact**: Hard to understand business rules, error-prone updates  
**Recommendation**: Extract to named constants or config  
**Action**: NICE TO HAVE (technical debt)  
```

### Testing Finding

```
### Testing: Missing Unit Tests for Auth
**Severity**: HIGH  
**Location**: `src/auth/jwt.service.ts`  
**Issue**: No tests for token generation/validation  
**Impact**: Changes can break auth without detection  
**Recommendation**: Add unit tests with TDD skill  
**Action**: SHOULD FIX (quality gate)  
```

---

## Review Checklist

**Reviewer should verify**:

### Correctness
- [ ] Logic is correct for all cases
- [ ] Edge cases handled (null, empty, max, negative)
- [ ] Error handling present
- [ ] No race conditions

### Security
- [ ] Input validation (XSS, SQL injection, command injection)
- [ ] Authentication/authorization checked
- [ ] Secrets not hardcoded
- [ ] Sensitive data encrypted

### Performance
- [ ] No N+1 queries
- [ ] Indexes used where needed
- [ ] No unnecessary loops
- [ ] Memory leaks prevented

### Code Quality
- [ ] Clear naming (variables, functions, classes)
- [ ] Single responsibility
- [ ] No duplication
- [ ] Proper abstractions

### Testing
- [ ] Tests exist (TDD followed)
- [ ] Tests pass
- [ ] Coverage adequate
- [ ] Tests are maintainable

### Documentation
- [ ] Code comments for complex logic
- [ ] API docs updated
- [ ] README updated if needed
- [ ] CHANGELOG updated

---

## Decision Matrix

| Severity | Must Fix Count | Should Fix Count | Decision |
|----------|----------------|------------------|----------|
| CRITICAL | 0 | Any | Approved (if Should Fix acceptable) |
| CRITICAL | 1+ | Any | **BLOCKED** |
| HIGH | 0-2 | Any | Approved with Changes |
| HIGH | 3+ | Any | **BLOCKED** |
| MEDIUM | Any | Any | Approved or Approved with Changes |
| LOW | Any | Any | Approved |

---

## Integration with Workflows

**Created By**: `/review` workflow  
**Blocks**: Merge if decision = Blocked  
**Triggers**: Fix tasks for Must Fix items  
**Updates**: `.ai/governance/debt/` for Should Fix/Nice to Have  

---

## Related Files

- `.ai/workflows/review.md` - Review workflow
- `.ai/skills/code-review.md` - Code review skill
- `docs/HITL_REVIEW_GATES.md` - Human approval gates

---

**Template Version**: 2.0  
**Last Updated**: 17 Juni 2026
