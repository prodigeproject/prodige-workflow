#!/usr/bin/env bash
# Validates the Prodige runtime canonical paths and templates for drift.
#
# FAIL (non-zero exit):
#   1. No .md or .json file under .ai/ references a deprecated top-level
#      '.ai/cache/' or '.ai/handoffs/' path. Runtime paths must live under
#      '.ai/runtime/cache/...' and '.ai/runtime/handoffs/...'. Offenders are
#      reported as file:line.
#   2. No .md or .json file references a non-canonical '.ai/parallel/' path.
#      Parallel artifacts must live under '.ai/runtime/...'; there is no
#      '.ai/parallel/' directory.
#   3. Runtime template JSON files parse as valid JSON:
#      .ai/runtime/sessions/SESSION_TEMPLATE.json
#      .ai/runtime/cache/CACHE_MANIFEST.json
#      .ai/runtime/cache/repomap.json
#
# WARN (advisory, exit code unaffected):
#   - SESSION_TEMPLATE.json should declare 'agent_role' and 'snapshot_id' keys.
#   - Cache/repo-map/snapshot/session/handoff artifacts written under
#     '.ai/context/' (cache belongs in '.ai/runtime/cache/'). Targeted
#     heuristic: only lines pairing '.ai/context/' with cache/repo-map/
#     snapshot wording are flagged, to avoid false positives on legitimate
#     '.ai/context/' documentation references.
#
# Requires: jq. Exit 0 = clean, 1 = problems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required for lint-runtime.sh" >&2
  exit 2
fi

problems=()
warnings=()
add_problem() { problems+=("$1"); }
add_warning() { warnings+=("$1"); }

# --- 1. Scan .ai/**(md+json) for non-canonical runtime paths ---
# (a) Matches '.ai/cache/' or '.ai/handoffs/' but NOT '.ai/runtime/cache/'.
bad_pattern='\.ai/(cache|handoffs)/'
# (b) Matches any '.ai/parallel/' path (no such canonical directory exists).
parallel_pattern='\.ai/parallel/'
# (c) Targeted cache-in-context heuristic (advisory WARNING): a line must
#     reference '.ai/context/' AND mention a cache/repo-map/snapshot/session/
#     handoff artifact, so legitimate '.ai/context/' doc references are safe.
context_path_pattern='\.ai/context/'
context_artifact_pattern='(cache|repo-?map|repomap|snapshot|session|handoff)'
# The runtime layout README is the canonical definition of these rules; it cites
# the deprecated/forbidden forms only to forbid them, so it is not a violation.
# This linter's own scripts are not scanned (only *.md and *.json are).
scan_exclude="runtime/README.md"
files_scanned=0
offenders=0
while IFS= read -r file; do
  rel="${file#"$AI_DIR"/}"
  if [[ "$rel" == "$scan_exclude" ]]; then continue; fi
  files_scanned=$((files_scanned + 1))
  while IFS= read -r match; do
    [[ -z "$match" ]] && continue
    offenders=$((offenders + 1))
    lineno="${match%%:*}"
    add_problem "Deprecated top-level runtime path in .ai/${rel}:${lineno} (use .ai/runtime/...)"
  done < <(grep -nE "$bad_pattern" "$file" 2>/dev/null || true)
  while IFS= read -r match; do
    [[ -z "$match" ]] && continue
    offenders=$((offenders + 1))
    lineno="${match%%:*}"
    add_problem "Non-canonical .ai/parallel/ path in .ai/${rel}:${lineno} (use .ai/runtime/...)"
  done < <(grep -nE "$parallel_pattern" "$file" 2>/dev/null || true)
  while IFS= read -r match; do
    [[ -z "$match" ]] && continue
    lineno="${match%%:*}"
    add_warning "Cache artifact under .ai/context/ in .ai/${rel}:${lineno} (cache belongs in .ai/runtime/cache/)"
  done < <(grep -nE "$context_path_pattern" "$file" 2>/dev/null | grep -E "$context_artifact_pattern" | grep -vE '\.ai/runtime/' || true)
done < <(find "$AI_DIR" -type f \( -name '*.md' -o -name '*.json' \) | sort)

# --- 2. Runtime template JSONs parse ---
json_templates=(
  "runtime/sessions/SESSION_TEMPLATE.json"
  "runtime/cache/CACHE_MANIFEST.json"
  "runtime/cache/repomap.json"
)
json_checked=0
session_template="$AI_DIR/runtime/sessions/SESSION_TEMPLATE.json"
for rel in "${json_templates[@]}"; do
  p="$AI_DIR/$rel"
  if [[ ! -f "$p" ]]; then
    add_problem "Missing runtime template: .ai/$rel"
    continue
  fi
  json_checked=$((json_checked + 1))
  if ! jq -e . "$p" >/dev/null 2>&1; then
    add_problem ".ai/$rel is not valid JSON"
  fi
done

# --- Advisory: SESSION_TEMPLATE.json key presence ---
if [[ -f "$session_template" ]] && jq -e . "$session_template" >/dev/null 2>&1; then
  for k in agent_role snapshot_id; do
    if ! jq -e --arg k "$k" 'has($k)' "$session_template" >/dev/null; then
      add_warning "SESSION_TEMPLATE.json is missing recommended key: '$k'"
    fi
  done
fi

echo "Files scanned (md+json) : $files_scanned"
echo "JSON templates checked  : $json_checked / ${#json_templates[@]}"
echo "Deprecated path hits    : $offenders"
echo

if [[ ${#warnings[@]} -gt 0 ]]; then
  echo "WARNINGS (${#warnings[@]}) - advisory, exit code unaffected:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
  echo
fi

if [[ ${#problems[@]} -eq 0 ]]; then
  echo "OK - runtime canonical paths and templates are consistent."
  exit 0
else
  echo "FOUND ${#problems[@]} PROBLEM(S):"
  for p in "${problems[@]}"; do echo "  - $p"; done
  exit 1
fi
