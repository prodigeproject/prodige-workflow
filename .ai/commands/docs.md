# /docs

Generate or update documentation so it matches the current code and context.

Keeps READMEs, API docs, and guides accurate as the project evolves.

---

## What This Does

✅ Generates or updates documentation from code and context
✅ Detects and fixes drift between docs and implementation
✅ Updates README, API references, and guides
✅ Keeps `.ai/context/` docs aligned with reality

---

## Usage

```bash
/docs                   # Update docs for recent changes
/docs generate          # Generate missing documentation
/docs <path>            # Document a specific area
```

---

## Workflow

Runs **`workflows/docs.md`**.

Coordinated by the orchestrator with the **docs** agent.

---

## HITL

**`conditional`** — minor doc updates proceed autonomously; substantial
rewrites or new published documentation require human approval.

---

## Skills Auto-Loaded

Selected automatically from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`, `/docs` entry). Skills are not
hardcoded — the matrix is the single source of truth and stays consistent with
`.ai/skills/manifest.json`.

---

## When to Use

- After a feature, fix, or API change
- When `/sync` or `/audit` reports documentation drift
- Before a release to refresh user-facing docs
- When onboarding material is missing or stale

---

## Integration

- Pairs with `/sync` to detect and resolve doc drift
- Runs in the `/release` workflow to refresh release docs
- Reads canonical context from `.ai/context/`
- Writes generated artifacts under `.ai/context/docs/`

---

**Remember:** Docs that drift from code mislead everyone — keep them in sync. 📝
