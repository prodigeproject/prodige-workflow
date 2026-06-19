# Prodige Review Automation Scripts

Scripts that power the enhanced code-review pipeline. Cross-platform: `.sh` for
Unix/Git Bash, `.ps1` for Windows PowerShell, `.js` for Node (any OS).

## Review Pipeline

| Script | Purpose | Inputs | Outputs | When it runs |
|--------|---------|--------|---------|--------------|
| `pre-review-check.{sh,ps1}` | Automated gate: lint, tests, secrets, debug, TODOs, diff size | git diff vs base ref; package.json scripts | `.ai/reports/reviews/pre-review-<stamp>.md`; exit 0/1/2 | Step 0 of `/review`, before Reviewer Agent |
| `security-scan.{sh,ps1}` | OWASP-mapped automated security first pass | git diff vs base ref; npm/pip audit | `.ai/reports/reviews/security-scan-<stamp>.md`; exit 0/1 | `/review` (security-sensitive), `/audit` |
| `update-review-patterns.js` | Fold review findings into the learning store | a review report `.md` | `.ai/memory/review-patterns.json` | review-learning post-review step (after each review) |
| `generate-review-metrics.js` | Aggregate review reports into trends & action items | `.ai/reports/reviews/*.md` (skips `pre-review-*`/`security-scan-*`) | `.ai/reports/metrics/review-metrics-<date>.md` | review-learning post-review step + weekly |
| `calibrate-reviewer.js` | Score reviewer accuracy vs labeled cases | `.ai/training/review-cases/cases/<case>/{expected.json,actual.md}` | `.ai/training/review-cases/results/calibration-<date>.json` | manual / on reviewer-skill change |

### Canonical theme taxonomy (shared)

`update-review-patterns.js` owns the canonical theme-bucket taxonomy. The exact same
13-bucket `THEME_MAP` is duplicated verbatim in `generate-review-metrics.js` and
`calibrate-reviewer.js`, so the learning store, the metrics report, and calibration
all bucket findings identically (no collapsing of `accessibility`/`input_validation`):

```
error_handling, scope_creep, overcomplication, test_coverage, injection, xss,
secret_exposure, access_control, input_validation, performance, magic_numbers,
documentation, accessibility
```

If you change a bucket, change it in all three files.

## Lint / Drift Checks

Structural validators for the Prodige `.ai/` workspace itself (not code review).
Each has a `.sh` and `.ps1` form; exit `0` = clean, `1` = problems found.

| Script | Validates |
|--------|-----------|
| `lint-commands.{sh,ps1}` | Command registry: `registry.json` valid + every command key has a matching `.ai/commands/<name>.md` |
| `lint-context.{sh,ps1}` | Context/state dirs: canonical `.ai/context/*.md` files exist and are well-formed |
| `lint-memory.{sh,ps1}` | Memory Bank: index rows resolve, anchor integrity, no secret leaks |
| `lint-runtime.{sh,ps1}` | Runtime templates: template JSON parses and the directory layout matches |
| `lint-skills.{sh,ps1}` | Skills registry: each skill has `SKILL.md` + frontmatter and is in `manifest.json` (no ghosts) |

## Optional Manual Tools

`generate-review-metrics.js` and `calibrate-reviewer.js` can also be run manually
(or on a schedule). `generate-review-metrics.js` is additionally wired as a
review-learning post-review step (see below); `calibrate-reviewer.js` is run on
demand against the training dataset.

### `generate-review-metrics.js`

Aggregates the human/agent review reports in `.ai/reports/reviews/*.md` into a
trends report. It deliberately ignores `pre-review-*.md` gate reports and
`security-scan-*.md` scanner outputs so they are not miscounted as reviews.
With no matching review reports in the window it produces an empty report (no-op).

**When it runs:** as the metrics step of the review-learning post-review flow
(right after `update-review-patterns.js`), and on a weekly/monthly cadence. Output
always lands in `.ai/reports/metrics/`. See `.ai/reports/metrics/README.md` for the
optional scheduled-hook wiring.

```bash
# Default 7-day window, writes .ai/reports/metrics/review-metrics-<date>.md
node .ai/scripts/generate-review-metrics.js

# Custom window / explicit output path
node .ai/scripts/generate-review-metrics.js --days 30 --out .ai/reports/metrics/last-month.md
```

### `calibrate-reviewer.js`

Scores Reviewer Agent output against labeled ground truth. The `--suite` mode reads
`.ai/training/review-cases/cases/<case>/` directories that each contain
`expected.json` + `actual.md`. Two worked sample cases ship under that path, so the
suite runs out of the box. If the cases directory is missing or empty the tool
prints a clear "no cases yet" message and exits cleanly (`0`) - it is data-optional,
never a silent no-op. See `.ai/training/review-cases/README.md` for the case format.

```bash
# Run the whole training suite (uses .ai/training/review-cases/cases/<case>/...)
node .ai/scripts/calibrate-reviewer.js --suite

# Score a single case manually
node .ai/scripts/calibrate-reviewer.js --expected <expected.json> --actual <report.md>
```

## Exit-Code Contracts

**pre-review-check:** `0` clean · `1` blocking (do NOT dispatch reviewer) · `2` warnings only
**security-scan:** `0` no critical · `1` critical finding (merge blocked)

## Quick Usage

```bash
# Gate before review
bash .ai/scripts/pre-review-check.sh origin/main          # or .ps1 on Windows

# Security pass on sensitive diff
bash .ai/scripts/security-scan.sh origin/main

# Weekly metrics
node .ai/scripts/generate-review-metrics.js --days 7

# Learn from a completed review
node .ai/scripts/update-review-patterns.js .ai/reports/reviews/<report>.md

# Calibrate the reviewer against the training suite
node .ai/scripts/calibrate-reviewer.js --suite
```

## Design Notes

- **No heavy dependencies** — Node scripts use only the standard library; shell
  scripts auto-detect stack (node/python/go/rust) and degrade gracefully (SKIP)
  when a tool isn't present. Consistent with the `mainstream-tools-only` and
  `no-magic-abstractions` boundaries.
- **Severity is canonical** — everything emits Prodige's Critical/Important/Minor.
- **Reports are the interface** — scripts read/write `.ai/reports/reviews/*.md`, so
  human and agent reviews flow through the same pipeline.

## Prerequisites

- Node.js (for `.js` scripts)
- `git` on PATH
- Optional, improves coverage: `jq` (shell lint/test detection), `npm`, `pytest`,
  `ruff`, `pip-audit`
