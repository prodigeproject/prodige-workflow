# Reviewer Calibration & Training

Systematic way to measure and improve the Reviewer Agent's accuracy — so review
quality is engineered, not assumed.

## Why

A reviewer that misses Critical issues is worse than no reviewer (false confidence).
This program measures **detection rate** (did it catch known issues?) and **false
positive rate** (did it invent issues?) against a labeled dataset, then closes gaps.

## Dataset Layout

```
.ai/training/review-cases/
├── README.md                 (this file)
├── cases/
│   ├── case-001/
│   │   ├── diff.patch         (the change under review - INPUT, optional)
│   │   ├── context.md         (task/PRD/requirements - INPUT, optional)
│   │   ├── expected.json      (ground-truth labeled findings - REQUIRED)
│   │   └── actual.md          (Reviewer Agent output to score - REQUIRED for --suite)
│   ├── case-002/
│   └── ...
└── results/                  (calibration run outputs - written by the scorer)
```

`calibrate-reviewer.js --suite` scores every case dir under `cases/` that contains
**both** `expected.json` and `actual.md`. `diff.patch` and `context.md` are the
inputs you give the reviewer to produce `actual.md`; the scorer does not read them.
If `cases/` is missing or empty the scorer prints a "no cases yet" message and exits
cleanly (0) - it is data-optional, never a silent no-op.

### Shipped sample cases

Two worked examples ship with this repo so calibration runs out of the box:

- **case-001** - SQL injection (Critical) + scope creep (Important). The reviewer
  output catches both -> 100% detection, 0% false positives.
- **case-002** - missing input validation (Important) + accessibility gap (Minor).
  The reviewer output catches the validation issue, misses the a11y issue, and
  raises a false magic-number flag on a `must_not_flag` constant -> demonstrates
  a false negative and a false positive (50% detection, 50% FP rate for that case).

These exercise the `injection`, `scope_creep`, `input_validation`, `accessibility`,
and `magic_numbers` buckets from the canonical taxonomy (see below). Replace or
extend them with your own cases as you build a real dataset.

### `expected.json` schema
```json
{
  "case": "case-001",
  "description": "Login endpoint with SQL injection + scope creep",
  "expected_findings": [
    { "severity": "Critical", "theme": "injection", "location": "src/auth/login.js:23" },
    { "severity": "Important", "theme": "scope_creep", "location": "src/auth/reset.js" }
  ],
  "must_not_flag": [
    { "location": "src/auth/login.js:10", "reason": "input already validated by zod upstream" }
  ]
}
```

`must_not_flag` is as important as `expected_findings` — it measures false positives,
which erode trust and waste implementer time.

### `theme` values (canonical taxonomy)

`theme` MUST be one of the canonical buckets owned by the review-learning loop
(`update-review-patterns.js` is the source of truth; `generate-review-metrics.js`
and `calibrate-reviewer.js` use the identical set):

`error_handling`, `scope_creep`, `overcomplication`, `test_coverage`, `injection`,
`xss`, `secret_exposure`, `access_control`, `input_validation`, `performance`,
`magic_numbers`, `documentation`, `accessibility`.

### `actual.md` format

Plain review report. The scorer reads severity headings (`## Critical`, `### Important`,
`Minor`) or `Severity:` lines, then the `Issue:`/`Problem:`/`Title:` and `Location:`
lines beneath them. The issue text is mapped to a canonical theme using the same
taxonomy. Example:

```markdown
## Critical
**Issue:** SQL injection via interpolated query
**Location:** src/auth/login.js:24
```

## Three-Phase Program

### Phase 1 — Baseline (Week 1)
1. Assemble 10+ cases with known issues (mix: security, complexity, scope creep,
   missing tests, performance, a11y, and at least 2 *clean* PRs).
2. Run the reviewer on each case (no peeking at `expected.json`).
3. Score with `calibrate-reviewer.js`. Record detection & false-positive rates.

### Phase 2 — Calibration (Week 2)
1. Review misses and false positives from Phase 1.
2. For each miss: add an example to the relevant skill's examples, tighten a checklist
   item, or add a detection pattern.
3. For each false positive: add a `must_not_flag`-style note / false-positive guidance.
4. Re-run. Confirm improvement.

### Phase 3 — Production Monitoring (Weeks 3-4+)
1. Shadow real reviews; periodically sample and label them as new cases.
2. Track **bug escape rate** (issues found post-merge that review should have caught).
3. Feed escaped bugs back as new training cases (they're the highest-value cases).

## Success Criteria

| Metric | Target |
|--------|--------|
| Critical detection rate | ≥ 95% |
| Important detection rate | ≥ 85% |
| False positive rate | ≤ 10% |
| Clean-PR pass rate (no false flags) | ≥ 90% |
| Avg review time | ≤ 5 min (simple), ≤ 30 min (complex) |

## Running Calibration

```bash
# Score reviewer output for a single case
node .ai/scripts/calibrate-reviewer.js \
  --expected .ai/training/review-cases/cases/case-001/expected.json \
  --actual   .ai/reports/reviews/<reviewer-output>.md

# Aggregate score across all cases (after running the reviewer on each)
node .ai/scripts/calibrate-reviewer.js --suite
```

## Scoring Method

For each case, findings are matched by `theme + location` (location matched loosely
by file, line within ±3):

- **True Positive (TP):** expected finding the reviewer caught
- **False Negative (FN):** expected finding the reviewer missed
- **False Positive (FP):** reviewer finding not in expected AND matching `must_not_flag`
  or simply absent from ground truth

```
detection_rate = TP / (TP + FN)
false_positive_rate = FP / (TP + FP)
```

Severity-weighted: a missed Critical counts more heavily than a missed Minor.

## Maintaining the Dataset

- Add a new case whenever a bug escapes review (root-cause the miss).
- Keep cases small and focused — one or two issues each, plus clean controls.
- Version the dataset in git; calibration is reproducible and reviewable.
- Re-run the suite after any change to review skills/checklists to catch regressions
  in the reviewer itself.

## Integration

- **Scorer:** `.ai/scripts/calibrate-reviewer.js`
- **Feeds:** skill examples, checklist items, `review-patterns.json` focus areas
- **Tied to:** `generate-review-metrics.js` bug-escape tracking
