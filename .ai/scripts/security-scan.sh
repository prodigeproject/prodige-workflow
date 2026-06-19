#!/usr/bin/env bash
# Prodige Security Scanner — automated first pass for security-review skill.
# Catches the mechanically-detectable subset of OWASP Top 10.
# Output severity maps to Prodige: Critical (blocks merge) / Important / Minor.

set -uo pipefail
BASE_REF="${1:-origin/main}"
STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT_DIR=".ai/reports/reviews"
REPORT="${REPORT_DIR}/security-scan-${STAMP}.md"
mkdir -p "${REPORT_DIR}"

CRIT=0; IMP=0; MIN=0
declare -a FINDINGS

add() { # severity, title, detail
  FINDINGS+=("$1|$2|$3")
  case "$1" in
    CRITICAL) CRIT=$((CRIT+1)); echo "🚫 CRITICAL: $2";;
    IMPORTANT) IMP=$((IMP+1)); echo "⚠️  IMPORTANT: $2";;
    MINOR) MIN=$((MIN+1)); echo "💡 MINOR: $2";;
  esac
}

# Scan changed lines only (faster, focused). Fall back to full tree if no base.
if git rev-parse "$BASE_REF" >/dev/null 2>&1; then
  SCAN="git diff ${BASE_REF}...HEAD"
else
  SCAN="git diff HEAD~1...HEAD"
fi

grep_added() { eval "$SCAN" 2>/dev/null | grep -nE '^\+' | grep -iE "$1"; }

echo "🔐 Prodige Security Scan (base: ${BASE_REF})"
echo "============================================"

# A02 — Hardcoded secrets
HITS=$(grep_added '(api[_-]?key|secret|password|token|private[_-]?key)[[:space:]]*[:=][[:space:]]*["'\''][^"'\'']{8,}' \
  | grep -ivE '(process\.env|os\.environ|getenv|example|placeholder|<your|xxxx)' || true)
[ -n "$HITS" ] && add CRITICAL "Hardcoded secret(s) detected" "$HITS"

# A03 — SQL injection (string interpolation in queries)
HITS=$(grep_added '(query|execute|exec)\(.*(\$\{|\+[[:space:]]*[a-zA-Z_])' | grep -iE 'select|insert|update|delete' || true)
[ -n "$HITS" ] && add CRITICAL "Possible SQL injection (interpolated query)" "$HITS"

# A03 — Command injection
HITS=$(grep_added '(exec|spawn|system|popen)\(' | grep -iE '\$\{|\+[[:space:]]*req|user' || true)
[ -n "$HITS" ] && add CRITICAL "Possible command injection" "$HITS"

# A03 — eval / dynamic code
HITS=$(grep_added '(^|[^a-zA-Z])eval\(|new Function\(' || true)
[ -n "$HITS" ] && add CRITICAL "Dynamic code execution (eval/Function)" "$HITS"

# A03 — XSS via dangerouslySetInnerHTML / innerHTML
HITS=$(grep_added 'dangerouslySetInnerHTML|\.innerHTML[[:space:]]*=' || true)
[ -n "$HITS" ] && add IMPORTANT "Potential XSS sink (innerHTML)" "$HITS"

# A02 — Weak hashing
HITS=$(grep_added '(md5|sha1)\(' || true)
[ -n "$HITS" ] && add IMPORTANT "Weak hash algorithm (md5/sha1)" "$HITS"

# Insecure randomness for security
HITS=$(grep_added 'Math\.random\(\)' || true)
[ -n "$HITS" ] && add MINOR "Math.random() — not safe for security tokens" "$HITS"

# A06 — Vulnerable dependencies
if [ -f package.json ] && command -v npm >/dev/null; then
  AUDIT=$(npm audit --audit-level=high --json 2>/dev/null || true)
  HIGH=$(echo "$AUDIT" | grep -oE '"high":[0-9]+' | head -1 | grep -oE '[0-9]+' || echo 0)
  CRITN=$(echo "$AUDIT" | grep -oE '"critical":[0-9]+' | head -1 | grep -oE '[0-9]+' || echo 0)
  [ "${CRITN:-0}" -gt 0 ] && add CRITICAL "npm audit: ${CRITN} critical vuln(s)" "run: npm audit"
  [ "${HIGH:-0}" -gt 0 ] && add IMPORTANT "npm audit: ${HIGH} high vuln(s)" "run: npm audit"
fi
if [ -f requirements.txt ] && command -v pip-audit >/dev/null; then
  PA=$(pip-audit 2>/dev/null | grep -c -iE 'vulnerab' || echo 0)
  [ "${PA:-0}" -gt 0 ] && add IMPORTANT "pip-audit found vulnerabilities" "run: pip-audit"
fi

# --- report ---
{
  echo "# Security Scan Report"
  echo "**Date:** ${STAMP}"
  echo "**Base:** ${BASE_REF}"
  echo ""
  echo "**Critical:** ${CRIT} | **Important:** ${IMP} | **Minor:** ${MIN}"
  echo ""
  if [ "${#FINDINGS[@]}" -eq 0 ]; then
    echo "✅ No mechanically-detectable issues. Proceed to manual logic review (IDOR, access control, business logic)."
  else
    for f in "${FINDINGS[@]}"; do
      sev="${f%%|*}"; rest="${f#*|}"; title="${rest%%|*}"; detail="${rest#*|}"
      echo "## [${sev}] ${title}"
      echo '```'
      echo "${detail}"
      echo '```'
      echo ""
    done
  fi
  echo "---"
  echo "_Automated pass only. Manual review still required for OWASP A01/A04/A09._"
} > "${REPORT}"

echo "============================================"
echo "Report: ${REPORT}"
echo "Critical: ${CRIT} | Important: ${IMP} | Minor: ${MIN}"
[ "${CRIT}" -gt 0 ] && { echo "🚫 MERGE BLOCKED — critical security findings."; exit 1; }
exit 0
