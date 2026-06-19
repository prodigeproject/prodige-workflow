#!/usr/bin/env bash
# Validates the Prodige skills registry for drift.
# Checks: every skill folder has SKILL.md and is in manifest.json; every SKILL.md
# begins with YAML frontmatter containing 'name:' and 'description:'; manifest paths
# exist; both matrices reference only known skills (no ghosts).
# Requires: jq. Exit 0 = clean, 1 = problems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$AI_DIR/.." && pwd)"
SKILLS_DIR="$AI_DIR/skills"
MANIFEST="$SKILLS_DIR/manifest.json"
CANON="$SKILLS_DIR/skill-selection-matrix.json"
ORCH="$AI_DIR/orchestrator/skill-selection.matrix.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required for lint-skills.sh" >&2
  exit 2
fi

problems=()
add_problem() { problems+=("$1"); }

# Verify a SKILL.md begins with YAML frontmatter containing name: and description:
# Sets globals: fm_found, fm_has_name, fm_has_desc
check_frontmatter() {
  local file="$1"
  fm_found=0; fm_has_name=0; fm_has_desc=0
  local first=1 in_fm=0 ln
  while IFS= read -r ln || [[ -n "$ln" ]]; do
    if [[ $first -eq 1 ]]; then
      first=0
      if [[ "$ln" =~ ^---[[:space:]]*$ ]]; then
        in_fm=1; fm_found=1; continue
      else
        return
      fi
    fi
    if [[ $in_fm -eq 1 ]]; then
      if [[ "$ln" =~ ^---[[:space:]]*$ ]]; then in_fm=0; break; fi
      [[ "$ln" =~ ^[[:space:]]*name[[:space:]]*:[[:space:]]*[^[:space:]] ]] && fm_has_name=1
      [[ "$ln" =~ ^[[:space:]]*description[[:space:]]*:[[:space:]]*[^[:space:]] ]] && fm_has_desc=1
    fi
  done < "$file"
}

# Skill folders containing SKILL.md
folders=()
while IFS= read -r d; do
  name="$(basename "$d")"
  if [[ -f "$d/SKILL.md" ]]; then
    folders+=("$name")
  else
    add_problem "Folder '$name' has no SKILL.md"
  fi
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

# SKILL.md frontmatter check (name + description)
for f in "${folders[@]}"; do
  skill_file="$SKILLS_DIR/$f/SKILL.md"
  [[ -f "$skill_file" ]] || continue
  check_frontmatter "$skill_file"
  if [[ "$fm_found" -eq 0 ]]; then
    add_problem "Skill '$f' SKILL.md is missing YAML frontmatter (--- block at top)"
  else
    [[ "$fm_has_name" -eq 1 ]] || add_problem "Skill '$f' SKILL.md frontmatter is missing 'name:'"
    [[ "$fm_has_desc" -eq 1 ]] || add_problem "Skill '$f' SKILL.md frontmatter is missing 'description:'"
  fi
done

# Manifest skill names + globals + aliases
mapfile -t manifest_skills < <(jq -r '.skills | keys[]' "$MANIFEST")
mapfile -t global_skills < <(jq -r '(.globalSkills // {}) | keys[]' "$MANIFEST")
mapfile -t alias_keys < <(jq -r '(.aliases // {}) | keys[]' "$MANIFEST")
known=("${manifest_skills[@]}" "${global_skills[@]}" "${alias_keys[@]}")

contains() { local n="$1"; shift; for x in "$@"; do [[ "$x" == "$n" ]] && return 0; done; return 1; }

# Folder not in manifest
for f in "${folders[@]}"; do
  if ! contains "$f" "${manifest_skills[@]}" && ! contains "$f" "${global_skills[@]}"; then
    add_problem "Skill folder '$f' is NOT listed in manifest.json"
  fi
done

# Manifest paths exist
while IFS= read -r line; do
  name="${line%%$'\t'*}"; path="${line#*$'\t'}"
  [[ -f "$ROOT_DIR/$path" ]] || add_problem "manifest skill '$name' -> missing file: $path"
done < <(jq -r '.skills | to_entries[] | "\(.key)\t\(.value.path)"' "$MANIFEST")

# Collect referenced skills from a matrix file
matrix_refs() {
  local file="$1"
  jq -r '
    if has("commandSkills") then
      ((.globalSkills.skills // [])[]),
      (.commandSkills[] | ((.required // [])[]), ((.optional // [])[]))
    else
      to_entries[] | select(.key|startswith("_")|not)
                   | select(.value|type=="array") | .value[]
    end
  ' "$file" 2>/dev/null | sort -u
}

for m in "$CANON" "$ORCH"; do
  [[ -f "$m" ]] || { add_problem "Matrix not found: $m"; continue; }
  while IFS= read -r r; do
    [[ -z "$r" ]] && continue
    contains "$r" "${known[@]}" || add_problem "Matrix '$(basename "$m")' references unknown skill: '$r'"
  done < <(matrix_refs "$m")
done

echo "Skill folders with SKILL.md : ${#folders[@]}"
echo "Manifest skills             : ${#manifest_skills[@]}"
echo "Global skills               : ${#global_skills[@]}"
echo

if [[ ${#problems[@]} -eq 0 ]]; then
  echo "OK - skills registry is consistent."
  exit 0
else
  echo "FOUND ${#problems[@]} PROBLEM(S):"
  for p in "${problems[@]}"; do echo "  - $p"; done
  exit 1
fi
