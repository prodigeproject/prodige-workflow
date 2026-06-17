# Audit Report Template

**How to Use**: This template is auto-filled by the `/audit` workflow. It categorizes findings by severity and tracks technical debt.

**When**: After codebase audit, code review, or architecture review  
**Updated By**: Orchestrator during `/audit` execution  
**Referenced In**: `.ai/governance/debt/` registry

---

## Executive Summary

**What Goes Here**: 2-3 sentence overview of audit scope and key findings

**Format**:
```
Audited: {component/module/feature}
Date: {YYYY-MM-DD}
Scope: {what was audited}
Key Finding: {most critical issue}
Overall Status: {RED/YELLOW/GREEN}
```

**Example**:
```
Audited: Authentication module
Date: 2026-06-17
Scope: JWT implementation, session management, password hashing
Key Finding: JWT tokens not properly invalidated on logout (security risk)
Overall Status: YELLOW (functional but has security gaps)
```

---

## Must Fix

**What Goes Here**: Critical issues that block deployment or create security/data integrity risks

**Criteria**:
- Security vulnerabilities
- Data corruption risks
- System crashes/outages
- Compliance violations
- Breaking production

**Format**:
```
### Issue {N}: {Brief title}
**Severity**: CRITICAL  
**Impact**: {What breaks/who's affected}  
**Location**: {file:line or component}  
**Evidence**: {code snippet or log}  
**Fix**: {What needs to change}  
**Estimated Effort**: {hours/days}  
**Blocker For**: {what this blocks}  
```

**Example**:
```
### Issue 1: JWT tokens not invalidated on logout
**Severity**: CRITICAL  
**Impact**: Users can continue using old tokens after logout (security breach)  
**Location**: `src/auth/jwt.service.ts:45`  
**Evidence**:
\`\`\`typescript
// No token blacklist or expiration on logout
async logout(token: string) {
  // Just clears client-side - token still valid!
  return { success: true };
}
\`\`\`
**Fix**: Implement token blacklist (Redis) or short-lived tokens with refresh  
**Estimated Effort**: 4 hours  
**Blocker For**: Security compliance, production deployment  
```

---

## Should Fix

**What Goes Here**: Important issues that degrade quality but don't block deployment

**Criteria**:
- Performance problems
- Code quality issues
- Missing error handling
- Poor UX
- Technical debt

**Format**: Same as "Must Fix" but Severity: HIGH

**Example**:
```
### Issue 3: N+1 query in user list endpoint
**Severity**: HIGH  
**Impact**: Slow response time (2s for 100 users), poor UX  
**Location**: `src/users/users.controller.ts:23`  
**Evidence**: Loads each user's orders in separate query (100 queries for 100 users)  
**Fix**: Use JOIN or eager loading  
**Estimated Effort**: 2 hours  
**Blocker For**: Performance SLA  
```

---

## Nice To Have

**What Goes Here**: Improvements that enhance maintainability or future-proof code

**Criteria**:
- Code style improvements
- Better naming
- Additional tests
- Refactoring opportunities
- Documentation gaps

**Format**: Same as above but Severity: MEDIUM or LOW

**Example**:
```
### Issue 5: Magic numbers in discount calculation
**Severity**: MEDIUM  
**Impact**: Hard to understand business rules, error-prone to change  
**Location**: `src/billing/discount.service.ts:12-18`  
**Evidence**: Hardcoded 0.1, 0.15, 0.2 (10%, 15%, 20% discounts)  
**Fix**: Extract to constants or config  
**Estimated Effort**: 30 minutes  
**Blocker For**: None  
```

---

## Debt Registry Updates

**What Goes Here**: Which technical debt items to add/update/close

**Format**:
```
**NEW DEBT**:
- {debt-type}/{issue-id}.md - {title}

**UPDATED DEBT**:
- {debt-type}/{issue-id}.md - {update description}

**RESOLVED DEBT**:
- {debt-type}/{issue-id}.md - {resolution summary}
```

**Example**:
```
**NEW DEBT**:
- security-debt/SD-007-jwt-logout.md - JWT tokens not invalidated
- performance-debt/PD-012-n-plus-one-users.md - N+1 query in user list

**UPDATED DEBT**:
- architecture-debt/AD-003-monolith.md - Partial refactor complete (3/5 modules)

**RESOLVED DEBT**:
- test-debt/TD-008-missing-unit-tests.md - All auth tests added
```

---

## Checklist

Before finalizing audit report:

- [ ] All issues categorized (Must/Should/Nice)
- [ ] Each issue has severity, impact, location, fix
- [ ] Effort estimates provided
- [ ] Debt registry updates listed
- [ ] Executive summary reflects key findings
- [ ] Linked to `.ai/governance/debt/` registry

---

## Integration with Workflows

**Created By**: `/audit` workflow  
**Updates**: `.ai/governance/debt/` files  
**Triggers**: Debt remediation tasks  
**Referenced In**: `/review`, `/sync`, `/status`

---

## Related Files

- `.ai/workflows/audit.md` - Audit workflow
- `.ai/governance/debt/` - Debt registry
- `.ai/checklists/audit.md` - Audit checklist

---

**Template Version**: 2.0  
**Last Updated**: 17 Juni 2026
