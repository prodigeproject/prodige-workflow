#!/usr/bin/env node
/**
 * Prodige Reviewer Calibration Scorer.
 *
 * Scores a Reviewer Agent's output against labeled ground truth to measure
 * detection rate and false-positive rate.
 *
 * Usage:
 *   node .ai/scripts/calibrate-reviewer.js --expected <expected.json> --actual <report.md>
 *   node .ai/scripts/calibrate-reviewer.js --suite
 */
'use strict';
const fs = require('fs');
const path = require('path');

const CASES_DIR = path.join('.ai', 'training', 'review-cases', 'cases');
const RESULTS_DIR = path.join('.ai', 'training', 'review-cases', 'results');

const SEV_WEIGHT = { Critical: 3, Important: 2, Minor: 1 };

// CANONICAL theme-bucket taxonomy. Source of truth lives in
// update-review-patterns.js (review-learning owns it). This MUST stay identical
// to that THEME_MAP and to generate-review-metrics.js so all three tools speak
// the same language (e.g. 'magic number' -> magic_numbers, 'a11y' -> accessibility,
// 'input' -> input_validation). Do NOT collapse buckets here.
const THEME_MAP = [
  [/error handling|catch|exception|unhandled/i, 'error_handling'],
  [/scope creep|not requested|unrelated|drive-by/i, 'scope_creep'],
  [/complex|overengineer|abstraction|factory|pattern/i, 'overcomplication'],
  [/test|coverage|untested/i, 'test_coverage'],
  [/sql|inject/i, 'injection'],
  [/xss|innerhtml|sanitiz/i, 'xss'],
  [/secret|hardcode|api[_ -]?key|token/i, 'secret_exposure'],
  [/auth|authoriz|idor|access control/i, 'access_control'],
  [/validation|validate|input/i, 'input_validation'],
  [/performance|slow|n\+1|memory|latency/i, 'performance'],
  [/magic number|constant/i, 'magic_numbers'],
  [/document|comment|jsdoc|docstring/i, 'documentation'],
  [/accessib|a11y|aria|contrast|keyboard/i, 'accessibility'],
];

function theme(text) {
  for (const [re, label] of THEME_MAP) if (re.test(text)) return label;
  return 'other';
}

function fileOf(loc) { return (loc || '').split(':')[0]; }
function lineOf(loc) { const p = (loc || '').split(':'); return p[1] ? parseInt(p[1], 10) : null; }

// Loose location match: same file, line within +-3 (or no line given).
function locMatch(a, b) {
  if (fileOf(a) !== fileOf(b)) return false;
  const la = lineOf(a), lb = lineOf(b);
  if (la == null || lb == null) return true;
  return Math.abs(la - lb) <= 3;
}

// Parse reviewer findings from a report. Line-based with running context so a
// section heading like "### Critical" or a "Severity:" line applies to the
// Issue/Location lines beneath it. Strips bold markers first.
function parseActual(content) {
  const clean = content.replace(/\*\*/g, '');
  const lines = clean.split(/\r?\n/).map((l) => l.replace(/^[\s>\-*]+/, ''));
  const findings = [];
  let curSev = null;
  let curIssue = '';
  const sevHeading = /^#{1,6}\s*.*?\b(Critical|Important|Minor)\b/i;
  for (const l of lines) {
    let m;
    if ((m = sevHeading.exec(l))) { curSev = cap(m[1]); continue; }
    if ((m = /^Severity:?\s*(Critical|Important|Minor)\b/i.exec(l))) { curSev = cap(m[1]); continue; }
    if ((m = /^(?:Issue|Problem|Title):?\s*(.+)/i.exec(l))) { curIssue = m[1]; continue; }
    if ((m = /^Location:?\s*`?([^\s`,]+)/i.exec(l))) {
      findings.push({ severity: curSev || 'Minor', location: m[1], theme: theme(`${curIssue} ${m[1]}`) });
    }
  }
  return findings;
}

function cap(s) { return s.charAt(0).toUpperCase() + s.slice(1).toLowerCase(); }

function scoreCase(expected, actual) {
  const expFindings = expected.expected_findings || [];
  const mustNot = expected.must_not_flag || [];
  const matchedActual = new Set();
  let tp = 0, fn = 0, weightedTp = 0, weightedFn = 0;

  for (const e of expFindings) {
    const w = SEV_WEIGHT[e.severity] || 1;
    const idx = actual.findIndex((a, i) =>
      !matchedActual.has(i) && a.theme === e.theme && locMatch(a.location, e.location));
    if (idx >= 0) { tp++; weightedTp += w; matchedActual.add(idx); }
    else { fn++; weightedFn += w; }
  }

  // False positives: actual findings not matched to expected.
  let fp = 0;
  actual.forEach((a, i) => {
    if (matchedActual.has(i)) return;
    // Ignore Minor noise unless it hits a must_not_flag location.
    const violatesMustNot = mustNot.some((m) => locMatch(a.location, m.location));
    if (violatesMustNot || a.severity !== 'Minor') fp++;
  });

  const detection = tp + fn ? tp / (tp + fn) : 1;
  const weightedDetection = weightedTp + weightedFn ? weightedTp / (weightedTp + weightedFn) : 1;
  const fpRate = tp + fp ? fp / (tp + fp) : 0;
  return { case: expected.case, tp, fn, fp, detection, weightedDetection, fpRate };
}

function pct(n) { return (n * 100).toFixed(1) + '%'; }

function printResult(r) {
  console.log(`Case ${r.case}: TP=${r.tp} FN=${r.fn} FP=${r.fp} | ` +
    `detection=${pct(r.detection)} (weighted ${pct(r.weightedDetection)}) | FP rate=${pct(r.fpRate)}`);
}

function runOne(expectedPath, actualPath) {
  const expected = JSON.parse(fs.readFileSync(expectedPath, 'utf8'));
  const actual = parseActual(fs.readFileSync(actualPath, 'utf8'));
  const r = scoreCase(expected, actual);
  printResult(r);
  return r;
}

function runSuite() {
  if (!fs.existsSync(CASES_DIR)) {
    console.log(`No calibration cases yet: ${CASES_DIR} does not exist.`);
    console.log('Add case dirs (each with expected.json + actual.md) to enable scoring.');
    console.log('See .ai/training/review-cases/README.md for the case format.');
    return; // clean exit (0) - not an error, just nothing to score yet
  }
  const cases = fs.readdirSync(CASES_DIR).filter((d) =>
    fs.existsSync(path.join(CASES_DIR, d, 'expected.json')) &&
    fs.existsSync(path.join(CASES_DIR, d, 'actual.md')));
  if (!cases.length) {
    console.log(`No scored cases in ${CASES_DIR} (each case needs expected.json + actual.md).`);
    console.log('See .ai/training/review-cases/README.md for the case format.');
    return; // clean exit (0) - data-optional, never a silent failure
  }

  const results = cases.map((c) =>
    runOne(path.join(CASES_DIR, c, 'expected.json'), path.join(CASES_DIR, c, 'actual.md')));

  const agg = results.reduce((a, r) => ({
    tp: a.tp + r.tp, fn: a.fn + r.fn, fp: a.fp + r.fp,
  }), { tp: 0, fn: 0, fp: 0 });
  const detection = agg.tp + agg.fn ? agg.tp / (agg.tp + agg.fn) : 1;
  const fpRate = agg.tp + agg.fp ? agg.fp / (agg.tp + agg.fp) : 0;

  console.log('\n=== Suite Summary ===');
  console.log(`Cases: ${results.length}`);
  console.log(`Overall detection rate: ${pct(detection)} (target >= 90%)`);
  console.log(`Overall false-positive rate: ${pct(fpRate)} (target <= 10%)`);

  fs.mkdirSync(RESULTS_DIR, { recursive: true });
  const out = path.join(RESULTS_DIR, `calibration-${new Date().toISOString().slice(0,10)}.json`);
  fs.writeFileSync(out, JSON.stringify({ results, detection, fpRate }, null, 2));
  console.log(`Saved: ${out}`);
}

function main() {
  const args = process.argv.slice(2);
  if (args.includes('--suite')) return runSuite();
  const exp = args[args.indexOf('--expected') + 1];
  const act = args[args.indexOf('--actual') + 1];
  if (!exp || !act) {
    console.error('Usage: --expected <expected.json> --actual <report.md> | --suite');
    process.exit(1);
  }
  runOne(exp, act);
}
main();
