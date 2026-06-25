#!/usr/bin/env bash
# Git Sentinel Hook untuk Prodige Workflow: Menegakkan TDD, Surgical Changes & Secret Guard
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$AI_DIR/.." && pwd)"

echo "[CHECK] Prodige Git Sentinel memverifikasi kepatuhan komit..."

# Cek apakah git terinstal di PATH
if ! command -v git &> /dev/null; then
    echo "[WARNING] Git tidak ditemukan di PATH. Sentinel dilewati secara aman."
    exit 0
fi

# 1. Dapatkan daftar file yang berubah di staged area
staged_files=($(git diff --cached --name-only || true))
if [ ${#staged_files[@]} -eq 0 ]; then
    echo "[SUCCESS] Tidak ada berkas staged. Sentinel dilewati."
    exit 0
fi

# 2. Ambil rencana aktif dari activeContext.md atau task.md
allowed_files=()
active_context="$AI_DIR/memory/activeContext.md"
task_file="$AI_DIR/task.md"

parse_allowed_files() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        while IFS= read -r line; do
            if [[ "$line" =~ file:\/\/\/([^\s\)]+) ]]; then
                local url_path="${BASH_REMATCH[1]}"
                url_path="${url_path//%20/ }"
                local filename=$(basename "$url_path")
                allowed_files+=("$filename")
            fi
        done < "$file_path"
    fi
}

parse_allowed_files "$active_context"
parse_allowed_files "$task_file"

# Deduplicate allowed_files
allowed_files=($(echo "${allowed_files[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

violations=()

# 3. Validasi Surgical Changes
for file in "${staged_files[@]}"; do
    if [[ "$file" =~ ^\.ai/ ]] || [ "$file" = "AGENTS.md" ] || [ "$file" = ".gitignore" ] || [ "$file" = ".gitattributes" ]; then
        continue
    fi
    
    filename=$(basename "$file")
    if [ ${#allowed_files[@]} -gt 0 ]; then
        found=0
        for allowed in "${allowed_files[@]}"; do
            if [ "$allowed" = "$filename" ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            violations+=("Pelanggaran Surgical Changes: File '$file' tidak terdaftar dalam rencana activeContext.md atau task.md!")
        fi
    fi
done

# 4. Validasi TDD (Test-Driven Development Gate)
source_changes=0
test_changes=0
for file in "${staged_files[@]}"; do
    if [[ "$file" =~ \.(ts|js|py|go|cs|rs)$ ]]; then
        if [[ "$file" =~ (test|spec)\.(ts|js|py|go|cs|rs)$ ]] || [[ "$file" =~ test_ ]]; then
            test_changes=$((test_changes + 1))
        else
            source_changes=$((source_changes + 1))
        fi
    fi
done

if [ $source_changes -gt 0 ] && [ $test_changes -eq 0 ]; then
    violations+=("Pelanggaran TDD Gate: Kode sumber diubah tanpa adanya modifikasi berkas pengujian (test/spec) di staged area!")
fi

# 5. Keamanan: Secret Scanner (Pencegahan Kebocoran Kredensial Enterprise)
# Mencari penambahan (+) baris bermasalah pada komit staged
secret_found=0
# Regex patterns
openai_pat='sk-[A-Za-z0-9]{16,}'
aws_pat='AKIA[0-9A-Z]{16}'
private_key='-----BEGIN [A-Z ]*PRIVATE KEY-----'
generic_secret='(password|passwd|secret|apikey|api_key|token)[[:space:]]*[:=][[:space:]]*['"'"'"][A-Za-z0-9._=-]{16,}['"'"'"]'

# Gunakan git diff untuk memeriksa baris yang ditambahkan (berawalan +)
added_lines=$(git diff --cached | grep -E '^\+[^+]' || true)
if [ -n "$added_lines" ]; then
    if echo "$added_lines" | grep -qE "$openai_pat"; then
        violations+=("Pelanggaran Keamanan: Ditemukan indikasi kebocoran kredensial [OpenAI API Key]!")
    fi
    if echo "$added_lines" | grep -qE "$aws_pat"; then
        violations+=("Pelanggaran Keamanan: Ditemukan indikasi kebocoran kredensial [AWS Access Key ID]!")
    fi
    if echo "$added_lines" | grep -qE "$private_key"; then
        violations+=("Pelanggaran Keamanan: Ditemukan berkas kunci privat [Private Key Block]!")
    fi
    if echo "$added_lines" | grep -iqE "$generic_secret"; then
        violations+=("Pelanggaran Keamanan: Ditemukan indikasi kebocoran kredensial [Kunci Rahasia/Password Terhardcode]!")
    fi
fi

# 6. Keputusan Akhir
if [ ${#violations[@]} -gt 0 ]; then
    echo "[ERROR] Prodige Sentinel memblokir komit karena pelanggaran aturan:"
    for v in "${violations[@]}"; do
        echo "  - $v"
    fi
    echo "[TIP] Silakan perbaiki rencana tugas Anda di activeContext.md, tambahkan uji unit, atau bersihkan berkas rahasia sebelum melakukan komit."
    exit 1
fi

echo "[SUCCESS] Prodige Sentinel: Semua aturan terpenuhi. Komit diizinkan!"
exit 0
