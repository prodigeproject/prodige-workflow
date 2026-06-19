#!/usr/bin/env bash
# Validates the Prodige context and state directories for drift.
#
# FAIL (non-zero exit):
#   1. .ai/context/manifest.json exists, is valid JSON, has an integer
#      'context_version' and a 'last_sync' key.
#   2. Every context file BOOT loads exists under .ai/context/:
#      PROJECT.md PRD.md ARCHITECTURE.md IMPLEMENTATION.md CONTEXT.md
#      DECISIONS.md CHANGELOG.md
#   3. Every state file exists under .ai/state/:
#      CURRENT.md SPRINT.md BACKLOG.md STATUS.md
#
# WARN (advisory, exit code unaffected):
#   - ADR dir should be .ai/context/docs/adr/; flags a misplaced .ai/docs/adr/.
#   - Any context/state file still containing [TBD] or [placeholder] markers.
#
# Requires: jq. Exit 0 = clean, 1 = problems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONTEXT_DIR="$AI_DIR/context"
STATE_DIR="$AI_DIR/state"
MANIFEST="$CONTEXT_DIR/manifest.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required for lint-context.sh" >&2
  exit 2
fi

problems=()
warnings=()
add_problem() { problems+=("$1"); }
add_warning() { warnings+=("$1"); }

placeholder_targets=()

# --- 1. manifest.json: exists, valid JSON, integer context_version, last_sync ---
if [[ ! -f "$MANIFEST" ]]; then
  add_problem "Missing manifest: .ai/context/manifest.json"
elif ! jq -e . "$MANIFEST" >/dev/null 2>&1; then
  add_problem "context/manifest.json is not valid JSON"
else
  cv_type="$(jq -r '.context_version | type' "$MANIFEST" 2>/dev/null || echo "null")"
  if [[ "$cv_type" == "null" ]] && ! jq -e 'has("context_version")' "$MANIFEST" >/dev/null; then
    add_problem "context/manifest.json is missing field: 'context_version'"
  else
    # JSON has no integer type; require a number with no fractional part.
    if [[ "$cv_type" != "number" ]]; then
      add_problem "context/manifest.json 'context_version' must be an integer (got type: $cv_type)"
    elif ! jq -e '.context_version == (.context_version | floor)' "$MANIFEST" >/dev/null; then
      cv_val="$(jq -r '.context_version' "$MANIFEST")"
      add_problem "context/manifest.json 'context_version' must be an integer (got: $cv_val)"
    fi
  fi
  if ! jq -e 'has("last_sync")' "$MANIFEST" >/dev/null; then
    add_problem "context/manifest.json is missing field: 'last_sync'"
  fi
fi

# --- 2. Context files BOOT loads ---
context_files=(PROJECT.md PRD.md ARCHITECTURE.md IMPLEMENTATION.md CONTEXT.md DECISIONS.md CHANGELOG.md)
context_found=0
for f in "${context_files[@]}"; do
  if [[ -f "$CONTEXT_DIR/$f" ]]; then
    context_found=$((context_found + 1))
    placeholder_targets+=("$CONTEXT_DIR/$f")
  else
    add_problem "Missing context file: .ai/context/$f"
  fi
done

# --- 3. State files ---
state_files=(CURRENT.md SPRINT.md BACKLOG.md STATUS.md)
state_found=0
for f in "${state_files[@]}"; do
  if [[ -f "$STATE_DIR/$f" ]]; then
    state_found=$((state_found + 1))
    placeholder_targets+=("$STATE_DIR/$f")
  else
    add_problem "Missing state file: .ai/state/$f"
  fi
done

# --- Advisory: ADR directory location ---
if [[ -d "$AI_DIR/docs/adr" ]]; then
  add_warning "Misplaced ADR directory .ai/docs/adr/ found - canonical location is .ai/context/docs/adr/"
fi
if [[ ! -d "$CONTEXT_DIR/docs/adr" ]]; then
  add_warning "Canonical ADR directory .ai/context/docs/adr/ is missing"
fi

# --- Advisory: unfilled [TBD] / [placeholder] markers ---
for p in "${placeholder_targets[@]}"; do
  if grep -Eiq '\[(TBD|placeholder)\]' "$p"; then
    rel="${p#"$AI_DIR"/}"
    add_warning "Unfilled template marker ([TBD]/[placeholder]) found in .ai/$rel"
  fi
done

echo "Context files found : $context_found / ${#context_files[@]}"
echo "State files found   : $state_found / ${#state_files[@]}"
echo

if [[ ${#warnings[@]} -gt 0 ]]; then
  echo "WARNINGS (${#warnings[@]}) - advisory, exit code unaffected:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
  echo
fi

if [[ ${#problems[@]} -eq 0 ]]; then
  echo "OK - context and state are consistent."
  exit 0
else
  echo "FOUND ${#problems[@]} PROBLEM(S):"
  for p in "${problems[@]}"; do echo "  - $p"; done
  exit 1
fi
