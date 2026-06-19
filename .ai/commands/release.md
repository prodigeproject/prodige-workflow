# /release

Prepare and execute a release: verify, document, version, and finish the branch.

Brings a change set to a shippable state with all gates satisfied.

---

## What This Does

✅ Runs final verification (tests, lint, types, build)
✅ Updates changelog, version, and release docs
✅ Confirms quality and review gates are satisfied
✅ Finishes the development branch and tags the release

---

## Usage

```bash
/release                # Prepare a release from the current branch
/release <version>      # Prepare a specific version (e.g. 1.2.0)
```

---

## Workflow

Runs **`workflows/release.md`**.

Coordinated by the orchestrator with the **git-guardian**,
**verification-runner**, and **docs** agents.

---

## HITL

**`true`** — releases are high-impact. The release plan and final cut require
explicit human approval. Production deploys remain gated by
`.ai/boundaries/no-production-deploys`.

---

## Skills Auto-Loaded

Selected automatically from the **skill-selection matrix**
(`.ai/skills/skill-selection-matrix.json`, `/release` entry). Skills are not
hardcoded — the matrix is the single source of truth and stays consistent with
`.ai/skills/manifest.json`.

---

## When to Use

- A milestone or feature set is complete and verified
- A versioned cut needs to be tagged and documented
- Closing out a development branch for shipping

---

## Integration

- Runs `/verify` as a hard gate before cutting the release
- Runs `/docs` to refresh changelog and release notes
- Uses the `finishing-a-development-branch` skill to wrap the branch
- Honors human-approval gates and no-production-deploy boundaries

---

**Remember:** Nothing ships until verification and approval gates pass. 🚀
