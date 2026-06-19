# Hotfix Review Template

**Use for:** PRs on `hotfix/*` branches or labeled `hotfix` — urgent production fixes.
**Severity scale:** Critical (🚫) / Important (⚠️) / Minor (💡).

> A hotfix review is fast but NOT lax. Speed comes from a *narrow* scope, not from
> skipping verification. The bar: smallest possible change, proven, with a path back.

---

## Decision
```
Decision: {Approved / Approved with Changes / Blocked}
Reviewer: {agent/human}
Date: {YYYY-MM-DD HH:MM}
Severity of incident: {SEV1 / SEV2 / SEV3}
Reason: {brief}
```

## Hotfix Specific Gates

### 1. Urgency justified
- [ ] Production impact documented (who/what is broken, since when)
- [ ] Hotfix path justified vs normal flow (genuine urgency)
- [ ] ⚠️ **Important** if this could have gone through normal review

### 2. Minimal change
- [ ] Change is the smallest possible to stop the bleeding
- [ ] No refactoring, no cleanup, no extras
- [ ] 🚫 **Critical** if scope exceeds the incident

### 3. Verification (not skipped)
- [ ] Fix verified in staging/repro of the production condition
- [ ] At least a smoke test or targeted regression test added
- [ ] 🚫 **Critical** if shipped with zero verification evidence

### 4. Rollback plan
- [ ] Rollback/revert procedure documented
- [ ] Feature flag or quick disable available if applicable
- [ ] 🚫 **Critical** if no way to undo

### 5. Follow-up debt
- [ ] Permanent fix / root-cause work logged as a follow-up task
- [ ] Tech debt from shortcuts recorded in `.ai/governance/debt/`
- [ ] 💡 **Minor**: tidy-ups deferred to follow-up

---

## Findings
```
### {Category}: {Title}
**Severity:** {Critical/Important/Minor}
**Location:** {file:line}
**Problem:** {what}  **Impact:** {why}  **Fix:** {how}
```

## Quick Reference
| Situation | Severity |
|-----------|----------|
| Scope exceeds incident | 🚫 Critical |
| No verification evidence | 🚫 Critical |
| No rollback plan | 🚫 Critical |
| Could have been normal flow | ⚠️ Important |
| No follow-up task logged | ⚠️ Important |
| Deferred cleanup | 💡 Minor |

**Related:** `.ai/commands/rollback.md`, `.ai/skills/verification-before-completion/SKILL.md`
