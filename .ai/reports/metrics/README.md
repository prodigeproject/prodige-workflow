# Review Metrics

Aggregated, trend-level view of code review activity. Turns the raw review archive
in `.ai/reports/reviews/` into actionable signals.

## Generate

```bash
# Last 7 days (default)
node .ai/scripts/generate-review-metrics.js

# Custom window
node .ai/scripts/generate-review-metrics.js --days 30

# Custom output path
node .ai/scripts/generate-review-metrics.js --days 7 --out .ai/reports/metrics/weekly.md
```

Output: `.ai/reports/metrics/review-metrics-YYYY-MM-DD.md`

## What it measures

- **Severity distribution** — Critical / Important / Minor counts and per-review rates
- **Outcomes** — approved clean, approved-with-changes, rejected/blocked
- **Agent performance** — issues/review per agent (target <1.00, flagged ⚠️ when over)
- **Review types** — task / feature / pre-merge / bugfix breakdown
- **Recurring themes** — bucketed into the canonical 13-theme taxonomy shared with
  `update-review-patterns.js` / `calibrate-reviewer.js`: `error_handling`,
  `scope_creep`, `overcomplication`, `test_coverage`, `injection`, `xss`,
  `secret_exposure`, `access_control`, `input_validation`, `performance`,
  `magic_numbers`, `documentation`, `accessibility` (anything unmatched -> `other`)
- **Auto-suggested action items** — themes recurring ≥3× get flagged for training/focus

> Only actual review reports are counted. `pre-review-*.md` gate reports and
> `security-scan-*.md` scanner outputs in `.ai/reports/reviews/` are skipped so they
> do not inflate the stats.

## When it runs

`generate-review-metrics.js` runs in two places:

1. **Post-review step** of the review-learning loop — right after
   `update-review-patterns.js` folds a new report into the learning store, the
   metrics report is regenerated so trends stay current.
2. **Scheduled cadence** — weekly/monthly (see below).

Output always lands in `.ai/reports/metrics/review-metrics-YYYY-MM-DD.md` (or the
`--out` path).

## Recommended cadence

- **Weekly:** run with `--days 7`, review in team sync
- **Monthly:** run with `--days 30` for trend comparison
- **Automate:** wire to a Prodige `agentStop` or scheduled hook (see below)

## Hook integration (optional)

```json
{
  "name": "Weekly Review Metrics",
  "version": "1.0.0",
  "when": { "type": "userTriggered" },
  "then": { "type": "runCommand", "command": "node .ai/scripts/generate-review-metrics.js --days 7" }
}
```

## Targets

| Metric | Target |
|--------|--------|
| Avg blocking issues / review | < 1.00 |
| Critical issues reaching main | 0 |
| Bug escape rate | ≤ 5% |
| Agent issues/review | < 1.00 each |
