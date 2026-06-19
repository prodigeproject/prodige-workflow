# Bug Fix Review Template

**Use for:** PRs on `fix/*` branches or labeled `bugfix`.
**Auto-selected by:** `.ai/workflows/review.md` based on branch prefix.
**Severity scale:** Critical (🚫 blocks merge) / Important (⚠️ blocks next task) / Minor (💡 debt).

> Focus of a bug-fix review is different from a feature review: the question is
> not "is this well designed?" but **"is the root cause actually fixed, and is it
> proven not to regress?"**

---

## Decision
```
Decision: {Approved / Approved with Changes / Blocked}
Reviewer: {agent/human}
Date: {YYYY-MM-DD HH:MM}
Reason: {brief}
```

## Bug-Fix Specific Gates

### 1. Root cause (not symptom)
- [ ] Root cause documented in PR/commit (links to systematic-debugging output)
- [ ] Fix addresses the cause, not just the visible symptom
- [ ] 🚫 **Critical** if fix only masks the symptom (e.g., try/catch swallowing the real error)

### 2. Regression test (mandatory)
- [ ] A test exists that **fails before** the fix and **passes after**
- [ ] Test added in same PR as fix
- [ ] 🚫 **Critical** if no regression test — the bug can silently return

### 3. Blast radius
- [ ] Fix is minimal and surgical (no unrelated refactoring)
- [ ] Related code paths with the same bug pattern checked (`grep` for the anti-pattern)
- [ ] ⚠️ **Important** if the same bug class exists elsewhere unfixed

### 4. Verification evidence
- [ ] Reproduction steps from the original bug now pass
- [ ] Full test suite green (paste command + result)
- [ ] No new warnings/errors introduced

---

## Findings
```
### {Category}: {Title}
**Severity:** {Critical/Important/Minor}
**Location:** {file:line}
**Problem:** {what}
**Impact:** {why it matters}
**Fix:** {how}
```

## Quick Reference
| Situation | Severity |
|-----------|----------|
| No regression test | 🚫 Critical |
| Symptom masked, cause remains | 🚫 Critical |
| Same bug pattern unfixed elsewhere | ⚠️ Important |
| Fix mixed with unrelated changes | ⚠️ Important |
| Could add defensive logging | 💡 Minor |

**Related:** `.ai/skills/systematic-debugging/SKILL.md`, `.ai/skills/test-driven-development/SKILL.md`
