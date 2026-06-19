#!/usr/bin/env bash
# Validates the Prodige command registry for drift.
#
# FAIL checks (non-zero exit):
#   1. registry.json must be valid JSON.
#   2. Every command key in registry.json has a matching .ai/commands/<name>.md
#      spec (leading slash stripped). FAIL on missing spec.
#   3. Every .ai/commands/*.md (except README.md) is registered in registry.json.
#      FAIL on ghost spec.
#   4. Every registry "workflow" value resolves to nothing -> FAIL.
#
# Advisory (WARNING only, exit code unaffected):
#   - A workflow value that resolves to a known agent .ai/agents/<value>.md.
#   - A workflow value that is an allowlisted spec-only handler.
#
# Requires: jq. Exit 0 = clean, 1 = problems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$AI_DIR/.." && pwd)"
COMMANDS_DIR="$AI_DIR/commands"
WORKFLOWS_DIR="$AI_DIR/workflows"
AGENTS_DIR="$AI_DIR/agents"
REGISTRY="$COMMANDS_DIR/registry.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required for lint-commands.sh" >&2
  exit 2
fi

# Spec-only / agent handlers that legitimately have NO workflow file (allowlist).
SPEC_ONLY=(session-start session-end memory-init verification git-undo git-checkpoint git-rollback magic-orchestrator agent-session test roastme diagnose-health)

problems=()
warnings=()
add_problem() { problems+=("$1"); }
add_warning() { warnings+=("$1"); }

contains() { local n="$1"; shift; for x in "$@"; do [[ "$x" == "$n" ]] && return 0; done; return 1; }

# --- 0. registry.json must exist and be valid JSON ---
if [[ ! -f "$REGISTRY" ]]; then
  echo "FOUND 1 PROBLEM(S):"
  echo "  - registry.json not found: $REGISTRY"
  exit 1
fi
if ! jq empty "$REGISTRY" >/dev/null 2>&1; then
  echo "FOUND 1 PROBLEM(S):"
  echo "  - registry.json is not valid JSON"
  exit 1
fi
if [[ "$(jq -r 'has("commands")' "$REGISTRY")" != "true" ]]; then
  echo "FOUND 1 PROBLEM(S):"
  echo "  - registry.json has no 'commands' object"
  exit 1
fi

# Command keys and registered spec names (leading slash stripped).
mapfile -t cmd_keys < <(jq -r '.commands | keys[]' "$REGISTRY")
registered_names=()
for k in "${cmd_keys[@]}"; do registered_names+=("${k#/}"); done

command_count=${#cmd_keys[@]}

# --- 1. Every command key has a matching spec .md ---
for k in "${cmd_keys[@]}"; do
  name="${k#/}"
  if [[ ! -f "$COMMANDS_DIR/$name.md" ]]; then
    add_problem "Command '$k' has no spec file: .ai/commands/$name.md"
  fi
done

# --- 2. Every spec .md (except README.md) is registered ---
spec_count=0
while IFS= read -r f; do
  base="$(basename "$f" .md)"
  [[ "$base" == "README" ]] && continue
  spec_count=$((spec_count + 1))
  contains "$base" "${registered_names[@]}" \
    || add_problem "Ghost spec '.ai/commands/$base.md' is not registered in registry.json"
done < <(find "$COMMANDS_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.md' | sort)

# --- 3. Every workflow value resolves to a workflow, agent, or allowlisted handler ---
while IFS= read -r line; do
  key="${line%%$'\t'*}"
  wf="${line#*$'\t'}"
  if [[ -z "$wf" || "$wf" == "null" ]]; then
    add_problem "Command '$key' has no 'workflow' value"
    continue
  fi
  if [[ -f "$WORKFLOWS_DIR/$wf.md" ]]; then
    : # resolves to a real workflow file - OK
  elif [[ -f "$AGENTS_DIR/$wf.md" ]]; then
    add_warning "Command '$key' workflow '$wf' resolves to agent .ai/agents/$wf.md (no workflow file)"
  elif contains "$wf" "${SPEC_ONLY[@]}"; then
    add_warning "Command '$key' workflow '$wf' is a spec-only handler (allowlisted, no workflow file)"
  else
    add_problem "Command '$key' workflow '$wf' resolves to nothing (no .ai/workflows/$wf.md, no .ai/agents/$wf.md, not allowlisted)"
  fi
done < <(jq -r '.commands | to_entries[] | "\(.key)\t\(.value.workflow)"' "$REGISTRY")

# --- Report ---
echo "Registry commands : $command_count"
echo "Command specs     : $spec_count"
echo

if [[ ${#warnings[@]} -gt 0 ]]; then
  echo "WARNINGS (${#warnings[@]}) - advisory, exit code unaffected:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
  echo
fi

if [[ ${#problems[@]} -eq 0 ]]; then
  echo "OK - command registry is consistent."
  exit 0
else
  echo "FOUND ${#problems[@]} PROBLEM(S):"
  for p in "${problems[@]}"; do echo "  - $p"; done
  exit 1
fi
