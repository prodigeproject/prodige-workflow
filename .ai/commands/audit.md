# /audit

Audit the repository for security, dependency, debt, and quality issues.

A broad, read-only sweep that surfaces risks across the whole codebase rather
than a single change.

---

## What This Does

✅ Scans for security vulnerabilities and risky patterns
✅ Reviews dependencies for CVEs, deprecation, and version drift
✅ Detects technical debt (TODO/FIXME/HACK, dead code, duplication)
✅ Checks performance and accessibility hotspots
✅ Produces a prioritized audit report

---

## Usage

```bash
/audit                  # Full repository audit
/audit <path>           # Audit a specific area
/audit --category deps  # Focus on a single dimension (deps, security, debt)
```

---

## Workflow

Runs **`workflows/audit.md`**.

Coordinated by the orchestrator, drawing on the **reviewer**, **qa**, and
**git-guardian** agents as needed.

---

## HITL

**`false`** — audit is read-only and reports findings autonomously. Any
remediation (updates, refactors, deploys) runs under its own command and gate.

---

## Skills Auto-Loaded

Selected automatically from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`, `/audit` entry). Skills are not
hardcoded here — the matrix is the single source of truth and is kept
consistent with `.ai/skills/manifest.json`.

---

## When to Use

- Periodic health and security checks
- Before a release or major milestone
- When inheriting or onboarding to a codebase
- After a dependency or framework upgrade

---

## Integration

- Complements `/diagnose` (environment health) with code-level analysis
- Findings route to `/fix`, `/refactor`, `/docs`, or the debt registry
- Reports saved under `.ai/reports/audits/`
- Uses the audit checklist (`.ai/checklists/audit.md`)

---

**Remember:** Audit surfaces risk; remediation happens through targeted commands. 🔎
