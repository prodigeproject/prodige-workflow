#!/usr/bin/env bash
# Prodige Pre-Review Automated Checks
# Runs BEFORE dispatching the Reviewer Agent to filter out trivial issues.
# Exit codes: 0 = pass (proceed to review), 1 = blocking failure, 2 = warnings only
#
# Improvement over manual review: auto-catches lint/test/coverage/secret issues
# so the Reviewer Agent focuses on architecture & behavior, not trivia.

set -uo pipefail

BASE_REF="${1:-origin/main}"
REPORT_DIR=".ai/reports/reviews"
STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT="${REPORT_DIR}/pre-review-${STAMP}.md"
mkdir -p "${REPORT_DIR}"

BLOCKING=0
WARNINGS=0
declare -a RESULTS

# --- stack auto-detection -------------------------------------------------
detect_stack() {
  if [ -f package.json ]; then echo "node"; return; fi
  if [ -f pyproject.toml ] || [ -f requirements.txt ]; then echo "python"; return; fi
  if [ -f go.mod ]; then echo "go"; return; fi
  if [ -f Cargo.toml ]; then echo "rust"; return; fi
  echo "unknown"
}
STACK="$(detect_stack)"

record() { # status, message
  RESULTS+=("$1|$2")
  case "$1" in
    FAIL) BLOCKING=$((BLOCKING+1)); echo "❌ $2" ;;
    WARN) WARNINGS=$((WARNINGS+1)); echo "⚠️  $2" ;;
    PASS) echo "✅ $2" ;;
    SKIP) echo "⏭️  $2" ;;
  esac
}

run() { # description, command...
  local desc="$1"; shift
  if "$@" >/tmp/prodige_check.log 2>&1; then
    record PASS "$desc"
  else
    record FAIL "$desc (see /tmp/prodige_check.log)"
  fi
}

echo "🔍 Prodige Pre-Review Checks (stack: ${STACK}, base: ${BASE_REF})"
echo "================================================================"

# 1. Lint -------------------------------------------------------------------
case "$STACK" in
  node)   [ -n "$(jq -r '.scripts.lint // empty' package.json 2>/dev/null)" ] \
            && run "Lint" npm run lint || record SKIP "Lint (no script)";;
  python) command -v ruff >/dev/null && run "Lint (ruff)" ruff check . || record SKIP "Lint (ruff not found)";;
  go)     run "Vet" go vet ./...;;
  rust)   run "Clippy" cargo clippy -- -D warnings;;
  *)      record SKIP "Lint (unknown stack)";;
esac

# 2. Tests ------------------------------------------------------------------
case "$STACK" in
  node)   [ -n "$(jq -r '.scripts.test // empty' package.json 2>/dev/null)" ] \
            && run "Tests" npm test || record SKIP "Tests (no script)";;
  python) command -v pytest >/dev/null && run "Tests (pytest)" pytest -q || record SKIP "Tests (pytest not found)";;
  go)     run "Tests" go test ./...;;
  rust)   run "Tests" cargo test;;
  *)      record SKIP "Tests (unknown stack)";;
esac

# 3. Secret scan (all stacks) ----------------------------------------------
SECRET_HITS=$(git diff "${BASE_REF}"...HEAD 2>/dev/null | grep -nE '^\+' | \
  grep -iE '(api[_-]?key|secret|password|passwd|token|private[_-]?key)[[:space:]]*[:=][[:space:]]*["'\''][^"'\'']{8,}' | \
  grep -ivE '(process\.env|os\.environ|getenv|example|placeholder|xxxx|<your)' | wc -l | tr -d ' ')
if [ "${SECRET_HITS:-0}" -gt 0 ]; then
  record FAIL "Secret scan: ${SECRET_HITS} possible hardcoded secret(s)"
else
  record PASS "Secret scan: no hardcoded secrets detected"
fi

# 4. Debug statements in production code ------------------------------------
DEBUG_HITS=$(git diff "${BASE_REF}"...HEAD -- '*.js' '*.ts' '*.jsx' '*.tsx' 2>/dev/null | \
  grep -nE '^\+' | grep -E 'console\.(log|debug)|debugger;' | grep -viE '(test|spec|\.md)' | wc -l | tr -d ' ')
if [ "${DEBUG_HITS:-0}" -gt 0 ]; then
  record WARN "Debug statements: ${DEBUG_HITS} console.log/debugger in changed code"
else
  record PASS "Debug statements: clean"
fi

# 5. New TODO/FIXME ---------------------------------------------------------
TODO_HITS=$(git diff "${BASE_REF}"...HEAD 2>/dev/null | grep -nE '^\+' | grep -cE '\b(TODO|FIXME|HACK|XXX)\b')
if [ "${TODO_HITS:-0}" -gt 0 ]; then
  record WARN "TODO/FIXME: ${TODO_HITS} new marker(s) — document in debt register"
else
  record PASS "TODO/FIXME: none added"
fi

# 6. Diff size sanity (surgical precision guard) ----------------------------
FILES_CHANGED=$(git diff --name-only "${BASE_REF}"...HEAD 2>/dev/null | wc -l | tr -d ' ')
if [ "${FILES_CHANGED:-0}" -gt 25 ]; then
  record WARN "Diff size: ${FILES_CHANGED} files changed — verify no scope creep"
else
  record PASS "Diff size: ${FILES_CHANGED} files"
fi

# --- write machine-readable + human report --------------------------------
{
  echo "# Pre-Review Check Report"
  echo "**Date:** ${STAMP}"
  echo "**Stack:** ${STACK}"
  echo "**Base:** ${BASE_REF}"
  echo ""
  echo "| Status | Check |"
  echo "|--------|-------|"
  for r in "${RESULTS[@]}"; do
    s="${r%%|*}"; m="${r#*|}"
    echo "| ${s} | ${m} |"
  done
  echo ""
  echo "**Blocking failures:** ${BLOCKING}"
  echo "**Warnings:** ${WARNINGS}"
} > "${REPORT}"

echo "================================================================"
echo "Report: ${REPORT}"
echo "Blocking: ${BLOCKING} | Warnings: ${WARNINGS}"

if [ "${BLOCKING}" -gt 0 ]; then
  echo "❌ BLOCKED: fix blocking failures before requesting review."
  exit 1
elif [ "${WARNINGS}" -gt 0 ]; then
  echo "⚠️  PASS WITH WARNINGS: review may proceed; note warnings for Reviewer."
  exit 2
else
  echo "✅ ALL CHECKS PASSED: proceed to Reviewer Agent dispatch."
  exit 0
fi
