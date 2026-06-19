#!/usr/bin/env node
/**
 * Prodige Review Metrics Generator
 * Parses .ai/reports/reviews/*.md and produces an aggregated metrics report.
 *
 * Usage:
 *   node .ai/scripts/generate-review-metrics.js [--days 7] [--out <path>]
 *
 * Improvement: previously reviews were stored but never aggregated. This turns
 * the report archive into actionable trends (severity counts, agent performance,
 * recurring issue themes) so quality can be managed, not just hoped for.
 */
'use strict';
const fs = require('fs');
const path = require('path');

const REVIEW_DIR = path.join('.ai', 'reports', 'reviews');
const METRICS_DIR = path.join('.ai', 'reports', 'metrics');

function parseArgs() {
  const args = process.argv.slice(2);
  const opts = { days: 7, out: null };
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--days') opts.days = parseInt(args[++i], 10);
    else if (args[i] === '--out') opts.out = args[++i];
  }
  return opts;
}

function listReports() {
  if (!fs.existsSync(REVIEW_DIR)) return [];
  return fs.readdirSync(REVIEW_DIR)
    .filter((f) => f.endsWith('.md'))
    .map((f) => path.join(REVIEW_DIR, f));
}

// Count severity markers in a report. Prefers explicit "Severity:" labels
// (most reliable in Prodige reports); falls back to emoji markers. Avoids
// double-counting section headings + labels.
function analyze(content) {
  const clean = content.replace(/\*\*/g, '');
  const lower = clean.toLowerCase();
  const labeled = (sev) =>
    (clean.match(new RegExp(`^\\s*Severity:?\\s*${sev}\\b`, 'gim')) || []).length;
  const emoji = { critical: /🚫/g, important: /⚠️/g, minor: /💡/g };
  const emojiCount = (k) => (content.match(emoji[k]) || []).length;
  const pick = (sev, key) => {
    const l = labeled(sev);
    return l > 0 ? l : emojiCount(key);
  };
  return {
    critical: pick('Critical', 'critical'),
    important: pick('Important', 'important'),
    minor: pick('Minor', 'minor'),
    approved: /approved(?!_with| with)/i.test(clean) && !/approved_with_changes|approved with changes/i.test(clean),
    approvedWithChanges: /approved_with_changes|approved with changes/i.test(clean),
    rejected: /\brejected\b|merge blocked/i.test(clean),
    agent: (clean.match(/Agent:?\s*([A-Za-z ]+)/i) || [])[1]?.trim() || 'Unknown',
    type: (clean.match(/Type:?\s*([A-Za-z \-]+)/i) || [])[1]?.trim() || 'Unknown',
    isSecurity: /security scan|owasp|injection|secret/i.test(lower),
  };
}

// Extract recurring issue themes from "Issue:" / "Problem:" lines.
function extractThemes(content) {
  const themes = [];
  const lines = content.split(/\r?\n/).map((l) => l.replace(/\*\*/g, '').replace(/^[\s>\-*]+/, ''));
  for (const l of lines) {
    const m = /^(?:Issue|Problem):?\s*(.+)/i.exec(l);
    if (m) themes.push(m[1].trim().slice(0, 80).toLowerCase());
  }
  return themes;
}

function withinDays(filePath, days) {
  const stat = fs.statSync(filePath);
  const ageMs = Date.now() - stat.mtimeMs;
  return ageMs <= days * 24 * 60 * 60 * 1000;
}

// Bucket a free-text theme into the canonical taxonomy. This MUST stay
// identical to THEME_MAP in update-review-patterns.js so the metrics report
// and the learning store speak the same language (e.g. 'hardcode' -> secret_exposure,
// 'magic number' -> magic_numbers, never a single catch-all 'Security' bucket).
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

function bucketTheme(theme) {
  for (const [re, label] of THEME_MAP) if (re.test(theme)) return label;
  return 'other';
}

function main() {
  const opts = parseArgs();
  const reports = listReports().filter((f) => withinDays(f, opts.days));

  const totals = { critical: 0, important: 0, minor: 0, reviews: 0,
                   approved: 0, approvedWithChanges: 0, rejected: 0, security: 0 };
  const byAgent = {};
  const byType = {};
  const themeCounts = {};

  for (const file of reports) {
    const base = path.basename(file);
    // Skip non-review artifacts that live in the same dir: pre-review gate
    // reports and security-scan outputs (scanner output, not a human/agent review).
    if (base.startsWith('pre-review-') || base.startsWith('security-scan-')) continue;
    const content = fs.readFileSync(file, 'utf8');
    const a = analyze(content);
    totals.reviews++;
    totals.critical += a.critical;
    totals.important += a.important;
    totals.minor += a.minor;
    if (a.approved) totals.approved++;
    if (a.approvedWithChanges) totals.approvedWithChanges++;
    if (a.rejected) totals.rejected++;
    if (a.isSecurity) totals.security++;

    byAgent[a.agent] = byAgent[a.agent] || { reviews: 0, critical: 0, important: 0, minor: 0 };
    byAgent[a.agent].reviews++;
    byAgent[a.agent].critical += a.critical;
    byAgent[a.agent].important += a.important;
    byAgent[a.agent].minor += a.minor;

    byType[a.type] = (byType[a.type] || 0) + 1;

    for (const t of extractThemes(content)) {
      const b = bucketTheme(t);
      themeCounts[b] = (themeCounts[b] || 0) + 1;
    }
  }
  render(totals, byAgent, byType, themeCounts, opts);
}

function render(totals, byAgent, byType, themeCounts, opts) {
  const stamp = new Date().toISOString().slice(0, 10);
  const avgIssues = totals.reviews
    ? ((totals.critical + totals.important) / totals.reviews).toFixed(2) : '0.00';

  const lines = [];
  lines.push(`# Code Review Metrics`);
  lines.push(`**Generated:** ${stamp}  `);
  lines.push(`**Window:** last ${opts.days} day(s)  `);
  lines.push(`**Reviews analyzed:** ${totals.reviews}`);
  lines.push('');
  lines.push('## Severity Distribution');
  lines.push('| Severity | Count | Per Review |');
  lines.push('|----------|-------|------------|');
  lines.push(`| 🚫 Critical | ${totals.critical} | ${rate(totals.critical, totals.reviews)} |`);
  lines.push(`| ⚠️ Important | ${totals.important} | ${rate(totals.important, totals.reviews)} |`);
  lines.push(`| 💡 Minor | ${totals.minor} | ${rate(totals.minor, totals.reviews)} |`);
  lines.push('');
  lines.push('## Outcomes');
  lines.push(`- ✅ Approved clean: ${totals.approved}`);
  lines.push(`- ⚠️ Approved with changes: ${totals.approvedWithChanges}`);
  lines.push(`- 🚫 Rejected / blocked: ${totals.rejected}`);
  lines.push(`- 🔐 Security-focused reviews: ${totals.security}`);
  lines.push('');
  lines.push(`**Avg blocking issues (Critical+Important) per review:** ${avgIssues} (target: <1.00)`);
  lines.push('');

  lines.push('## Agent Performance');
  lines.push('| Agent | Reviews | Critical | Important | Issues/Review |');
  lines.push('|-------|---------|----------|-----------|---------------|');
  for (const [agent, s] of Object.entries(byAgent).sort((a, b) => b[1].reviews - a[1].reviews)) {
    const ipr = s.reviews ? ((s.critical + s.important) / s.reviews).toFixed(2) : '0.00';
    const flag = ipr > 1 ? ' ⚠️' : ' ✅';
    lines.push(`| ${agent} | ${s.reviews} | ${s.critical} | ${s.important} | ${ipr}${flag} |`);
  }
  lines.push('');

  lines.push('## Review Types');
  for (const [type, n] of Object.entries(byType).sort((a, b) => b[1] - a[1])) {
    lines.push(`- ${type}: ${n}`);
  }
  lines.push('');

  lines.push('## Top Recurring Issue Themes');
  const sorted = Object.entries(themeCounts).sort((a, b) => b[1] - a[1]);
  if (sorted.length === 0) lines.push('_No themes extracted._');
  for (const [theme, n] of sorted) lines.push(`- ${theme}: ${n}`);
  lines.push('');

  lines.push('## Action Items (auto-suggested)');
  for (const [theme, n] of sorted.slice(0, 3)) {
    if (n >= 3) lines.push(`- Recurring "${theme}" (${n}×): add to focus list / schedule training.`);
  }
  lines.push('');
  lines.push('---');
  lines.push('_Generated by .ai/scripts/generate-review-metrics.js_');

  const out = opts.out || path.join(METRICS_DIR, `review-metrics-${stamp}.md`);
  fs.mkdirSync(path.dirname(out), { recursive: true });
  fs.writeFileSync(out, lines.join('\n'), 'utf8');
  console.log(`Metrics written to ${out}`);
  console.log(`Reviews: ${totals.reviews} | Critical: ${totals.critical} | Important: ${totals.important} | Minor: ${totals.minor}`);
}

function rate(n, total) { return total ? (n / total).toFixed(2) : '0.00'; }

main();
