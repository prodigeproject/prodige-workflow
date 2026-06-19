#!/usr/bin/env bash
# Validates the Prodige Memory Bank for drift, anchor integrity, and secret leaks.
#
# FAIL checks (non-zero exit):
#   1. Parse every row of the Index table in .ai/memory/index.md.
#   2. Each row's source_file (relative to .ai/memory/, may include archive/)
#      must contain a heading '### M-NNNN ...' (ASCII hyphen or em dash accepted;
#      matched on the M-NNNN token).
#   3. Reverse check: any '### M-NNNN' anchor with no matching index row is an orphan.
#   4. IDs unique and monotonically increasing; footer 'Next ID' > max id.
#   5. review-patterns.json must be valid JSON if present (requires jq).
#
# Advisory (WARNING only, exit code unaffected):
#   - Unknown files directly in .ai/memory/.
#   - Unknown entry types.
#   - Secret / PII patterns under .ai/memory/ (file:line, never the value).
#
# Exit 0 = clean, 1 = problems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MEM_DIR="$AI_DIR/memory"
INDEX="$MEM_DIR/index.md"

INDEXED_FILES=(sessionHistory.md decisionLog.md conventions.md progress.md)
NON_INDEXED_FILES=(index.md activeContext.md projectContext.md review-patterns.json README.md)
VALID_TYPES=(session decision pattern bugfix feature discovery)

problems=()
warnings=()
add_problem() { problems+=("$1"); }
add_warning() { warnings+=("$1"); }

contains() { local n="$1"; shift; for x in "$@"; do [[ "$x" == "$n" ]] && return 0; done; return 1; }

if [[ ! -f "$INDEX" ]]; then
  echo "FOUND 1 PROBLEM(S):"
  echo "  - Memory index not found: $INDEX"
  exit 1
fi

# --- 1. Parse the Index table ---
ids=()          # numeric ids in table order
declare -A id_seen=()
row_count=0
prev_num=""

# Read table rows: | M-NNNN | date | type | topic | source |
while IFS= read -r line; do
  [[ "$line" =~ ^\|[[:space:]]*M-[0-9]+[[:space:]]*\| ]] || continue
  # Strip leading/trailing pipe, split on '|'
  body="${line#|}"
  IFS='|' read -r c_id c_date c_type c_topic c_src _rest <<< "$body"
  id="$(echo "$c_id" | xargs)"
  type="$(echo "$c_type" | xargs)"
  src="$(echo "$c_src" | xargs)"
  row_count=$((row_count + 1))

  num=$((10#$(echo "$id" | sed 's/[^0-9]//g')))

  # 4a. unique
  if [[ -n "${id_seen[$num]:-}" ]]; then
    add_problem "Duplicate index id: $id"
  else
    id_seen[$num]=1
    ids+=("$id")
  fi

  # 4b. monotonic
  if [[ -n "$prev_num" && "$num" -le "$prev_num" ]]; then
    add_problem "Index id not monotonic: $id follows M-$(printf '%04d' "$prev_num")"
  fi
  prev_num="$num"

  # 7. type (advisory)
  if ! contains "$type" "${VALID_TYPES[@]}"; then
    add_warning "Row $id: unknown type '$type'"
  fi

  # 2. anchor exists in source file
  if [[ -z "$src" ]]; then
    add_problem "Row $id: empty source_file"
    continue
  fi
  src_path="$MEM_DIR/$src"
  if [[ ! -f "$src_path" ]]; then
    add_problem "Row $id: source file not found: $src"
    continue
  fi
  if ! grep -Eq "^###[[:space:]]+$id([^0-9]|$)" "$src_path"; then
    add_problem "Row $id: missing anchor '### $id ...' in $src"
  fi
done < "$INDEX"

# Max numeric id
max_num=0
for k in "${!id_seen[@]}"; do
  [[ "$k" -gt "$max_num" ]] && max_num="$k"
done

# --- 4c. Next ID footer must exceed max id ---
next_id_text="$(grep -oE 'Next ID:[[:space:]]*M-[0-9]+' "$INDEX" | head -n1 | grep -oE 'M-[0-9]+' || true)"
if [[ -z "$next_id_text" ]]; then
  add_problem "Footer 'Next ID: M-NNNN' not found in index.md"
else
  next_num=$((10#$(echo "$next_id_text" | sed 's/[^0-9]//g')))
  if [[ "$next_num" -le "$max_num" ]]; then
    add_problem "Footer '$next_id_text' must be greater than max id M-$(printf '%04d' "$max_num")"
  fi
fi

# --- 3. Reverse check: anchors with no matching index row ---
scan_files=()
for f in "${INDEXED_FILES[@]}"; do
  [[ -f "$MEM_DIR/$f" ]] && scan_files+=("$MEM_DIR/$f")
done
# add any referenced source files (incl. archive/) not already present
while IFS= read -r line; do
  [[ "$line" =~ ^\|[[:space:]]*M-[0-9]+[[:space:]]*\| ]] || continue
  body="${line#|}"
  IFS='|' read -r _c_id _c_date _c_type _c_topic c_src _rest <<< "$body"
  src="$(echo "$c_src" | xargs)"
  [[ -z "$src" ]] && continue
  p="$MEM_DIR/$src"
  [[ -f "$p" ]] || continue
  contains "$p" "${scan_files[@]}" || scan_files+=("$p")
done < "$INDEX"

anchors_found=0
for p in "${scan_files[@]}"; do
  rel="${p#"$MEM_DIR"/}"
  while IFS= read -r aid; do
    [[ -z "$aid" ]] && continue
    anchors_found=$((anchors_found + 1))
    if [[ -z "${id_seen[$((10#$(echo "$aid" | sed 's/[^0-9]//g')))]:-}" ]]; then
      add_problem "Orphan anchor '$aid' in $rel (no matching index row)"
    fi
  done < <(grep -oE "^###[[:space:]]+M-[0-9]+" "$p" | grep -oE 'M-[0-9]+')
done

# --- 5. Unknown files directly in .ai/memory/ (advisory) ---
while IFS= read -r entry; do
  name="$(basename "$entry")"
  if ! contains "$name" "${INDEXED_FILES[@]}" && ! contains "$name" "${NON_INDEXED_FILES[@]}"; then
    add_warning "Unknown file in .ai/memory/: $name (not an indexed entry store)"
  fi
done < <(find "$MEM_DIR" -mindepth 1 -maxdepth 1 -type f | sort)

# --- 6. review-patterns.json valid JSON if present ---
RP="$MEM_DIR/review-patterns.json"
if [[ -f "$RP" ]]; then
  if command -v jq >/dev/null 2>&1; then
    jq empty "$RP" >/dev/null 2>&1 || add_problem "review-patterns.json is not valid JSON"
  else
    python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$RP" >/dev/null 2>&1 \
      || add_problem "review-patterns.json is not valid JSON"
  fi
fi

# --- F8. Secret / PII guard (advisory; file:line, never the value) ---
declare -a SECRET_NAMES=(
  "OpenAI-style key (sk-)"
  "AWS access key id (AKIA)"
  "Private key block"
  "password assignment"
  "token assignment"
  "secret assignment"
  "Bearer token"
  "long hex/base64 value"
)
declare -a SECRET_PATS=(
  'sk-[A-Za-z0-9]{16,}'
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  'password[[:space:]]*[:=][[:space:]]*[^[:space:]]'
  'token[[:space:]]*[:=][[:space:]]*[^[:space:]]'
  'secret[[:space:]]*[:=][[:space:]]*[^[:space:]]'
  'Bearer[[:space:]]+[A-Za-z0-9._=-]{16,}'
  '[:=][[:space:]]*["'"'"']?[A-Za-z0-9+/]{40,}={0,2}["'"'"']?[[:space:]]*$'
)
while IFS= read -r f; do
  rel="${f#"$MEM_DIR"/}"
  for idx in "${!SECRET_PATS[@]}"; do
    pat="${SECRET_PATS[$idx]}"
    while IFS= read -r lineno; do
      [[ -z "$lineno" ]] && continue
      add_warning "Possible secret [${SECRET_NAMES[$idx]}] at ${rel}:${lineno}"
    done < <(grep -nE "$pat" "$f" 2>/dev/null | cut -d: -f1 || true)
  done
done < <(find "$MEM_DIR" -type f \( -name '*.md' -o -name '*.json' -o -name '*.txt' -o -name '*.yml' -o -name '*.yaml' \))

# --- Report ---
echo "Index rows        : $row_count"
echo "Anchors found     : $anchors_found"
echo "Files scanned     : ${#scan_files[@]}"
echo "Next ID           : ${next_id_text:-n/a}"
echo

if [[ ${#warnings[@]} -gt 0 ]]; then
  echo "WARNINGS (${#warnings[@]}) - advisory, exit code unaffected:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
  echo
fi

if [[ ${#problems[@]} -eq 0 ]]; then
  echo "OK - Memory Bank is consistent."
  exit 0
else
  echo "FOUND ${#problems[@]} PROBLEM(S):"
  for p in "${problems[@]}"; do echo "  - $p"; done
  exit 1
fi
