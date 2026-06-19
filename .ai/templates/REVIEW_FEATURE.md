# Feature Review Template

**Use for:** PRs on `feature/*` / `feat/*` branches or labeled `feature`.
**Severity scale:** Critical (🚫) / Important (⚠️) / Minor (💡).

> Feature reviews check the full engineering-discipline stack: did we build the *right* thing,
> *simply*, *surgically*, and is it *proven*?

---

## Decision
```
Decision: {Approved / Approved with Changes / Blocked}
Reviewer: {agent/human}
Date: {YYYY-MM-DD HH:MM}
Reason: {brief}
```

## Feature Specific Gates

### 1. Requirement compliance
- [ ] Every acceptance criterion in PRD/spec is met (list them, check each)
- [ ] No required behavior missing
- [ ] 🚫 **Critical** if a core requirement is unmet or wrong

### 2. Scope discipline (YAGNI)
- [ ] Only requested functionality built — nothing speculative
- [ ] No unrequested endpoints/options/config
- [ ] ⚠️ **Important** for each unrequested addition

### 3. Simplicity (behavioral)
- [ ] No abstraction with a single use site
- [ ] No design pattern where a function would do
- [ ] ⚠️ **Important** if a senior would call it overengineered

### 4. Test coverage
- [ ] Happy path tested
- [ ] Edge cases tested (null, empty, max, boundary, error)
- [ ] 🚫 **Critical** if core business logic untested
- [ ] ⚠️ **Important** if error paths untested

### 5. Integration & docs
- [ ] Context files updated (ARCHITECTURE.md / DECISIONS.md if design choices made)
- [ ] API docs / README updated if surface changed
- [ ] Migration plan documented if schema/data changes
- [ ] 💡 **Minor** for doc polish

### 6. Security & performance (delegate if heavy)
- [ ] If touches auth/payment/data → run `security-scan` + security-review checklist
- [ ] If hot path / large dataset → see `performance-review` skill

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
| Core requirement unmet | 🚫 Critical |
| Core logic untested | 🚫 Critical |
| Unrequested feature added | ⚠️ Important |
| Overengineered solution | ⚠️ Important |
| Error paths untested | ⚠️ Important |
| Doc gaps / magic numbers | 💡 Minor |

**Related:** `.ai/skills/requesting-code-review/SKILL.md`, `.ai/skills/clean-code/SKILL.md`
