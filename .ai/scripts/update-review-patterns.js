#!/usr/bin/env node
/**
 * Prodige Review Pattern Updater (review-learning skill).
 *
 * Usage:
 *   node .ai/scripts/update-review-patterns.js <review-report.md>
 *   node .ai/scripts/update-review-patterns.js --query <changed-file-path>
 *
 * Folds findings from a review report into .ai/memory/review-patterns.json,
 * bucketed by theme and grouped by top-level source directory. Themes recurring
 * >= focus_threshold become focus_areas. Transparent JSON, no ML.
 */
'use strict';
const fs = require('fs');
const path = require('path');

const STORE = path.join('.ai', 'memory', 'review-patterns.json');

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

function bucket(text) {
  for (const [re, label] of THEME_MAP) if (re.test(text)) return label;
  return null;
}

function loadStore() {
  if (!fs.existsSync(STORE)) {
    return { version: 1, updated: today(), config: { focus_threshold: 3, monthly_decay: 0.9 }, paths: {} };
  }
  return JSON.parse(fs.readFileSync(STORE, 'utf8'));
}

function today() { return new Date().toISOString().slice(0, 10); }

// Map a file path to a grouping glob: top two segments + /**
function pathGlob(filePath) {
  const parts = filePath.split(/[\\/]/).filter(Boolean);
  if (parts.length <= 1) return parts[0] ? `${parts[0]}/**` : '**';
  return `${parts[0]}/${parts[1]}/**`;
}

// Extract (location, issueText) pairs from a review report.
// Strip markdown bold markers first so "**Issue:**" / "- **Location:**" both parse.
function extractFindings(content) {
  const lines = content.split(/\r?\n/).map((l) =>
    l.replace(/\*\*/g, '').replace(/^[\s>\-*]+/, ''));
  const locations = [];
  const issues = [];
  for (const l of lines) {
    let m;
    if ((m = /^Location:?\s*`?([^\s`,]+)/i.exec(l))) locations.push(m[1]);
    if ((m = /^(?:Issue|Problem|Title):?\s*(.+)/i.exec(l))) issues.push(m[1].trim());
  }
  const findings = [];
  const n = Math.max(locations.length, issues.length);
  for (let i = 0; i < n; i++) {
    findings.push({ location: locations[i] || '', text: issues[i] || '' });
  }
  return findings;
}

function recomputeFocus(entry, threshold) {
  entry.focus_areas = Object.entries(entry.common_issues || {})
    .filter(([, n]) => n >= threshold)
    .sort((a, b) => b[1] - a[1])
    .map(([k]) => k);
}

function ingest(reportPath) {
  if (!fs.existsSync(reportPath)) {
    console.error(`Report not found: ${reportPath}`);
    process.exit(1);
  }
  const store = loadStore();
  const threshold = store.config?.focus_threshold ?? 3;
  const content = fs.readFileSync(reportPath, 'utf8');
  const findings = extractFindings(content);

  let added = 0;
  for (const f of findings) {
    const theme = bucket(`${f.text} ${f.location}`);
    if (!theme || !f.location) continue;
    const glob = pathGlob(f.location);
    store.paths[glob] = store.paths[glob] || { review_count: 0, common_issues: {}, focus_areas: [] };
    const entry = store.paths[glob];
    entry.common_issues[theme] = (entry.common_issues[theme] || 0) + 1;
    added++;
  }
  // Bump review_count per touched glob once.
  const touched = new Set(findings.map((f) => f.location && pathGlob(f.location)).filter(Boolean));
  for (const g of touched) store.paths[g].review_count++;
  for (const g of Object.keys(store.paths)) recomputeFocus(store.paths[g], threshold);

  store.updated = today();
  fs.writeFileSync(STORE, JSON.stringify(store, null, 2) + '\n', 'utf8');
  console.log(`Ingested ${added} themed finding(s) across ${touched.size} path group(s).`);
  console.log(`Store updated: ${STORE}`);
}

function query(filePath) {
  const store = loadStore();
  const glob = pathGlob(filePath);
  const entry = store.paths[glob];
  if (!entry || !entry.focus_areas.length) {
    console.log(`No historical focus for ${glob}.`);
    return;
  }
  console.log(`Historical focus for ${glob} (from ${entry.review_count} reviews):`);
  for (const fa of entry.focus_areas) {
    console.log(`  - ${fa} (${entry.common_issues[fa]}x)`);
  }
}

function main() {
  const args = process.argv.slice(2);
  if (args[0] === '--query') return query(args[1]);
  if (!args[0]) {
    console.error('Usage: update-review-patterns.js <report.md> | --query <path>');
    process.exit(1);
  }
  ingest(args[0]);
}
main();
