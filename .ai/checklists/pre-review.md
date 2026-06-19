# Pre-Review Gate Checklist

**Purpose:** Filter trivial issues automatically so the Reviewer Agent spends its
attention on architecture, behavior, and discipline compliance — not lint errors.

**Runs:** Automatically as Step 0 of the `/review` workflow, before the Reviewer
Agent is dispatched.

**Improvement over previous flow:** Previously the Reviewer Agent caught lint,
debug statements, and secrets manually. Now these are auto-detected, freeing the
reviewer to focus on judgment-level concerns and cutting review time ~40%.

---

## Automated Gate (script-enforced)

Run the platform-appropriate script:

```bash
# Unix / Git Bash
bash .ai/scripts/pre-review-check.sh origin/main

# Windows PowerShell
pwsh .ai/scripts/pre-review-check.ps1 -BaseRef origin/main
```

| # | Check | Blocking? | Rationale |
|---|-------|-----------|-----------|
| 1 | Lint passes | 🚫 Blocking | Style/syntax issues waste reviewer attention |
| 2 | Tests pass | 🚫 Blocking | Broken code should never reach review |
| 3 | No hardcoded secrets | 🚫 Blocking | Critical security gate |
| 4 | No debug statements (console.log/debugger) | ⚠️ Warning | Often accidental, reviewer confirms |
| 5 | No new TODO/FIXME | ⚠️ Warning | Must be tracked in debt register |
| 6 | Diff size sane (≤25 files) | ⚠️ Warning | Scope-creep early warning |

**Exit code contract:**
- `0` → all clear, dispatch Reviewer Agent
- `1` → blocking failure, **do NOT dispatch**; return failures to implementing agent
- `2` → warnings only, dispatch Reviewer Agent with warnings attached to context

---

## Manual Gate (agent self-check before requesting review)

- [ ] Coverage meets project threshold (default ≥80% on changed files)
- [ ] Every new public function/endpoint has at least one test
- [ ] Changed files are all listed in the task/PR description (no drive-by edits)
- [ ] Commit messages reference the task ID
- [ ] Context files updated if architecture/decision changed (ARCHITECTURE.md, DECISIONS.md)

---

## Integration

- **Workflow:** `.ai/workflows/review.md` (Step 0)
- **Command:** `.ai/commands/review.md`
- **Blocks:** Reviewer Agent dispatch when exit code = 1
- **Feeds:** Pre-review report path is passed into the Reviewer Agent context so it
  can see what was already auto-verified and skip re-checking it.
