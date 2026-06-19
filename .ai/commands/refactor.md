# /refactor

Improve code structure and quality without changing observable behavior.

Reduces complexity, removes duplication, and pays down debt while keeping all
tests green.

---

## What This Does

✅ Restructures code while preserving behavior
✅ Removes duplication and improves naming
✅ Reduces complexity and pays down tracked debt
✅ Keeps the test suite green at every step

---

## Usage

```bash
/refactor <path>        # Refactor a file, module, or area
/refactor               # Refactor current working scope
```

---

## Workflow

Runs **`workflows/refactor.md`**.

Coordinated by the orchestrator with the **backend**/**frontend** and
**verification-runner** agents.

---

## HITL

**`true`** — refactors change code structure, so the plan and resulting diff
require human approval before merge.

---

## Skills Auto-Loaded

Selected automatically from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`, `/refactor` entry). Skills are not
hardcoded — the matrix is the single source of truth and stays consistent with
`.ai/skills/manifest.json`.

---

## When to Use

- Code is hard to read, test, or extend
- Duplication or complexity is slowing development
- After `/audit` or `/review` flags debt
- Before building a feature on top of fragile code

---

## Integration

- Behavior is locked by tests via `test-driven-development`
- Every change verified with `verification-before-completion`
- Pairs with `/test` (keep green) and `/review` (validate result)
- Debt resolved here is closed out in the debt registry

---

**Remember:** Refactoring changes structure, never behavior — tests stay green. ♻️
