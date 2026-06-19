# Workflow: Multi-Reviewer (High-Risk Changes)

## Purpose
For changes where a single reviewer is a single point of failure, dispatch multiple
specialized reviewers in parallel and synthesize their findings into one verdict.

**Core principle:** More eyes on high-blast-radius changes — but with a clear
consensus rule so multiple reports don't create decision paralysis.

---

## When to Use

Trigger multi-review when **any** of these are true:

| Trigger | Reviewers to dispatch |
|---------|----------------------|
| Touches auth / payment / crypto / PII | security + backend |
| Changes documented architecture | architect + orchestrator |
| Cross-cutting (backend + frontend) | backend + frontend |
| Public API / contract change | backend + docs |
| Large diff (>25 files) or core module | backend + qa |
| Explicit request: `/review --peers a,b` | the listed agents |

For ordinary single-domain changes, use the standard `.ai/workflows/review.md`.
Multi-review has real cost — reserve it for genuine risk.

> **Note on "security":** There is **no standalone `security` agent**. Where this
> workflow lists "security" as a reviewer, it means the `reviewer` agent running its
> `security-review` skill specialization. Dispatch it like any other reviewer, but
> understand it resolves to `reviewer` + `security-review`, not a separate agent.

---

## Steps

### 1. Pre-Review Gate (shared, once)
Run `.ai/scripts/pre-review-check.sh` and (if applicable) `security-scan.sh` **once**.
A blocking failure stops the whole multi-review — fix first.

### 2. Prepare shared context
Build one review brief (commit range, requirements, focus areas) and a **snapshot**
of context files. All reviewers receive the *same* snapshot — never live-changing
context — so their findings are comparable.

### 3. Dispatch reviewers in parallel
```
Orchestrator:
  ├─ Dispatch Reviewer A (e.g. security = reviewer + security-review)  → saves report A
  ├─ Dispatch Reviewer B (e.g. backend)   → saves report B
  └─ (parallel, isolated contexts)
```
Each reviewer follows the standard review workflow within its specialty and writes
to `.ai/reports/reviews/multi-{branch}-{role}-{timestamp}.md`.

### 4. Synthesize
The Orchestrator merges reports into a single verdict applying the **consensus rule**.

### 5. Resolve conflicts
If reviewers disagree, apply the resolution ladder (below). Escalate to human only
when reviewers conflict on a Critical and cannot be reconciled by evidence.

---

## Consensus Rule (deterministic)

Severity is combined conservatively — the **highest** severity assigned by any
reviewer to a given issue wins, with one escalation rule:

```
FOR each distinct issue across all reports:
  combined_severity = MAX(severity assigned by any reviewer)

ESCALATION:
  IF the SAME issue is flagged Important by 2+ reviewers independently:
      → escalate to Critical (independent corroboration = higher confidence)

FINAL VERDICT:
  IF any combined Critical exists      → 🚫 BLOCKED
  ELSE IF any combined Important exists → ⚠️ APPROVED WITH CHANGES
  ELSE                                  → ✅ APPROVED
```

Deduplicate issues by `file:line + theme` before combining so the same finding from
two reviewers isn't double-counted (except for the escalation rule above).

## Conflict Resolution Ladder

1. **Evidence wins.** A reviewer citing a failing test / query plan / spec line
   overrides one citing opinion.
2. **Specialty wins in-domain.** On a security question, the security reviewer's call
   stands unless another reviewer has concrete contradicting evidence.
3. **Context files win.** If a suggestion conflicts with DECISIONS.md/ARCHITECTURE.md,
   the documented decision stands (or must be explicitly revised).
4. **Escalate to human** only for unresolved Critical disagreements. Present both
   positions with evidence, not a vague "reviewers disagree".

## Synthesized Report Format

```markdown
# Multi-Reviewer Verdict: {branch}
**Date:** {timestamp}
**Reviewers:** {role A}, {role B}
**Verdict:** {✅ Approved / ⚠️ Approved with Changes / 🚫 Blocked}

## Combined Findings
| Severity | Issue | Location | Raised by | Notes |
|----------|-------|----------|-----------|-------|
| 🚫 Critical | ... | file:line | security | escalated (2 reviewers) |
| ⚠️ Important | ... | file:line | backend | |

## Conflicts Resolved
- {issue}: {how resolved, which rule}

## Source Reports
- multi-{branch}-security-{ts}.md
- multi-{branch}-backend-{ts}.md
```

## Integration

- **Command:** `/review --peers <a,b>` or auto when triggers above match
- **Parallel safety:** uses `dispatching-parallel-agents`, `snapshot-manager`,
  `lock-manager` patterns (shared snapshot, isolated reviewer sessions)
- **Feeds:** `generate-review-metrics.js` reads the per-role reports normally
- **Falls back to:** `.ai/workflows/review.md` for single-domain changes
