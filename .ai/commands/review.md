# /review

Review code quality, correctness, and standards compliance before merge.

Catches bugs, security issues, and style drift while the change is still cheap to fix.

---

## What This Does

✅ Reviews a diff, branch, or set of files against quality gates
✅ Flags correctness, security, performance, and accessibility concerns
✅ Checks tests exist and pass for the change
✅ Produces an actionable report with severity-tagged findings

---

## Usage

```bash
/review                 # Review current changes / working diff
/review <branch>        # Review a specific branch
/review <path>          # Review specific files or a directory
```

---

## Workflow

Runs **`workflows/review.md`** (interactive and multi-reviewer variants in
`workflows/review-interactive.md` and `workflows/review-multi.md`).

Invokes the **reviewer** agent, coordinated by the orchestrator.

---

## HITL

**`false`** — review runs autonomously and reports findings. Acting on
findings (edits, reverts) follows the normal gates for those commands.

---

## Skills Auto-Loaded

Skills are selected automatically by the orchestrator from the
**skill-selection matrix** (`.ai/skills/skill-selection-matrix.json`,
`/review` entry). Do not load skills manually — the matrix is the single
source of truth and stays consistent with `.ai/skills/manifest.json`.

---

## When to Use

- Before opening or merging a pull request
- After completing a `/build` or `/fix` task
- When onboarding to unfamiliar code you intend to change

---

## Integration

- Runs inside the `/magic` workflow before merge
- Feeds the pre-merge checklist (`.ai/checklists/pre-merge.md`)
- Findings can route to `/fix`, `/refactor`, or `/docs`
- Review learnings are captured for `review-learning`

---

**Remember:** Review early — findings are cheapest before merge. 👀
