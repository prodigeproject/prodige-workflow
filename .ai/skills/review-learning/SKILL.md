---
name: review-learning
description: Use at the start of a review to load codebase-specific recurring-issue patterns, and after a review to record new findings - makes the reviewer get smarter about THIS codebase over time.
auto_load: ["/review"]
applies_to: [reviewer, orchestrator]
---

# Review Learning System

A static reviewer makes the same discoveries forever. This skill gives the reviewer
a memory of **what tends to go wrong in specific parts of this codebase**, so it
allocates extra attention where history says it matters.

## How It Works

```
BEFORE review (Step 0):
  Read .ai/memory/review-patterns.json
  Find entries whose path-glob matches the changed files
  → Inject their focus_areas into the reviewer's attention list

AFTER review:
  Run .ai/scripts/update-review-patterns.js with the new report
  → Issues are bucketed by theme and counted per directory
  → Recurring themes (≥ threshold) become focus_areas automatically
```

This is deliberately **simple and transparent** (a JSON store + theme buckets), not
opaque ML — consistent with Prodige's "no magic abstractions" boundary.

## Pattern Store Format

`.ai/memory/review-patterns.json`:
```json
{
  "version": 1,
  "updated": "2026-06-18",
  "config": { "focus_threshold": 3, "monthly_decay": 0.9 },
  "paths": {
    "src/auth/**": {
      "review_count": 14,
      "common_issues": {
        "input_validation": 12,
        "access_control": 5
      },
      "focus_areas": ["input_validation", "access_control"]
    },
    "src/api/**": {
      "review_count": 22,
      "common_issues": {
        "error_handling": 18,
        "performance": 8
      },
      "focus_areas": ["error_handling", "performance"]
    }
  }
}
```

`common_issues` keys are **canonical theme buckets** (see the taxonomy in
Integration below), not free-text - the updater buckets every finding before
counting it. `focus_areas` is just the subset of those buckets at or above the
recurrence threshold.

## Using Patterns in a Review

When changed files match a stored path, the reviewer adds an explicit focus note:

```markdown
**Historical Focus (from review-learning):**
This change touches `src/auth/**`, which has a history of:
- Missing input validation (12 prior occurrences)
- Token expiry not checked (5 prior occurrences)

→ Verifying these specifically:
✅ Input validated (zod schema on request body)
✅ Token expiry checked before use
```

This turns institutional knowledge into a concrete checklist instead of relying on
the reviewer to "remember".

## Threshold & Decay

- A theme becomes a `focus_area` after recurring **≥ 3 times** in a directory.
- Counts **decay** over time (configurable) so fixed/old patterns fade and don't
  haunt the reviewer forever. Default: multiply counts by 0.9 each month with no
  new occurrence; drop below 1 → removed.
- `focus_areas` are advisory — they raise attention, they do **not** auto-fail code.

## Commands

```bash
# After a review report is written, fold its findings into the store
node .ai/scripts/update-review-patterns.js .ai/reports/reviews/<report>.md

# Inspect current focus for a path (dry run, prints matched patterns)
node .ai/scripts/update-review-patterns.js --query src/auth/login.ts
```

## Guardrails

- Never let a historical pattern **lower** scrutiny ("usually fine here" is how bugs
  ship). Patterns only ever *add* focus.
- Keep the store in version control so the learning is shared and auditable.
- If a pattern is wrong/noisy, edit the JSON directly — it's meant to be human-readable.

## Integration

- **Auto-loaded:** `/review` Step 0 (read), post-review (write)
- **Store:** `.ai/memory/review-patterns.json` (owned by this skill)
- **Updater:** `.ai/scripts/update-review-patterns.js` - this script's `THEME_MAP` is
  the **canonical theme-bucket taxonomy** (source of truth) for the whole pipeline.
- **Canonical buckets (13):** `error_handling`, `scope_creep`, `overcomplication`,
  `test_coverage`, `injection`, `xss`, `secret_exposure`, `access_control`,
  `input_validation`, `performance`, `magic_numbers`, `documentation`, `accessibility`.
- **Works with:** `generate-review-metrics.js` and `calibrate-reviewer.js` - both
  embed the *identical* `THEME_MAP`, so the learning store, the metrics report, and
  reviewer calibration all bucket findings the same way (e.g. `accessibility` and
  `input_validation` are never collapsed into a catch-all `security` bucket). This
  is what "themes use the same buckets" means - it is enforced by keeping the three
  `THEME_MAP` arrays byte-identical.

## Post-Review Flow

After a review report is written, the review-learning post-review step runs two
scripts in order:

```bash
# 1. Fold this review's findings into the per-path learning store
node .ai/scripts/update-review-patterns.js .ai/reports/reviews/<report>.md
# 2. Refresh the aggregated trends/metrics report (skips pre-review-*/security-scan-*)
node .ai/scripts/generate-review-metrics.js --days 7
```

Both consume the same review reports and the same canonical buckets, so Step 0
focus areas and the metrics trends always agree.
