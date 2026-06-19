# Refactoring Review Template

**Use for:** PRs on `refactor/*` branches or labeled `refactor`.
**Severity scale:** Critical (🚫) / Important (⚠️) / Minor (💡).

> The defining rule of a refactor review: **behavior must not change.** If behavior
> changed, it is not a refactor — it is a feature or a fix, and needs that review.

---

## Decision
```
Decision: {Approved / Approved with Changes / Blocked}
Reviewer: {agent/human}
Date: {YYYY-MM-DD HH:MM}
Reason: {brief}
```

## Refactoring Specific Gates

### 1. Behavior preservation (the core gate)
- [ ] No functional/behavioral change (same inputs → same outputs)
- [ ] **No new tests needed** — existing tests still pass unchanged
- [ ] 🚫 **Critical** if existing tests were *modified* to pass (hidden behavior change)
- [ ] 🚫 **Critical** if public API/contract changed without being declared

### 2. Net improvement (justification)
- [ ] Code is measurably simpler/clearer after (fewer lines, lower nesting, less duplication)
- [ ] The refactor has a stated reason (readability, perf, prep for feature X)
- [ ] ⚠️ **Important** if change is lateral (different, not better)

### 3. No scope creep
- [ ] Only structural changes — no new features snuck in
- [ ] No "while I was here" unrelated edits
- [ ] ⚠️ **Important** for any feature/behavior addition mixed in

### 4. Safety
- [ ] Full suite green before AND after (paste both)
- [ ] No performance regression (benchmark if perf-sensitive)
- [ ] Git diff reviewed file-by-file for accidental logic changes

---

## Findings
```
### {Category}: {Title}
**Severity:** {Critical/Important/Minor}
**Location:** {file:line}
**Problem:** {what}
**Recommendation:** {how}
```

## Quick Reference
| Situation | Severity |
|-----------|----------|
| Behavior changed under "refactor" label | 🚫 Critical |
| Tests modified to pass | 🚫 Critical |
| Public contract changed silently | 🚫 Critical |
| Lateral change (not actually cleaner) | ⚠️ Important |
| Feature mixed into refactor | ⚠️ Important |
| Could simplify further | 💡 Minor |

**Related:** `.ai/skills/clean-code/SKILL.md`, `.ai/skills/test-driven-development/SKILL.md`
