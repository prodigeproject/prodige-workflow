#!/usr/bin/env bash
# .ai/scripts/release-locks.sh
# Prodige Lock Manager Cleanup: Otomatis melepaskan stale locks (kunci usang) berdasarkan PID atau waktu.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCKS_DIR="$AI_DIR/runtime/locks"

if [ ! -d "$LOCKS_DIR" ]; then
    echo "[INFO] Direktori kunci tidak ditemukan: $LOCKS_DIR"
    exit 0
fi

echo "[CHECK] Memeriksa berkas kunci (locks)..."

lock_files=($(find "$LOCKS_DIR" -name "*.lock" -type f || true))
released_count=0

for file_path in "${lock_files[@]}"; do
    filename=$(basename "$file_path")
    stale=0
    reason=""
    
    # Membaca isi JSON (memerlukan grep/sed jika jq tidak ada, tetapi jq adalah standar di Prodige)
    if command -v jq &> /dev/null; then
        pid=$(jq -r '.pid // empty' "$file_path" 2>/dev/null || echo "")
        timestamp=$(jq -r '.timestamp // empty' "$file_path" 2>/dev/null || echo "")
    else
        # Fallback parsing regex sederhana jika jq tidak terinstal
        pid=$(grep -oE '"pid"[[:space:]]*:[[:space:]]*[0-9]+' "$file_path" | grep -oE '[0-9]+' || echo "")
        timestamp=$(grep -oE '"timestamp"[[:space:]]*:[[:space:]]*"[^"]+"' "$file_path" | cut -d'"' -f4 || echo "")
    fi
    
    # 1. Validasi PID
    if [ -n "$pid" ]; then
        if ! kill -0 "$pid" 2>/dev/null; then
            stale=1
            reason="Proses PID $pid tidak aktif."
        fi
    fi
    
    # 2. Validasi usia kunci (menggunakan date stat jika timestamp tersedia)
    if [ $stale -eq 0 ] && [ -n "$timestamp" ]; then
        # Menggunakan file modification time sebagai fallback/komparasi
        if command -v stat &> /dev/null; then
            file_mtime=$(stat -c %Y "$file_path" 2>/dev/null || stat -f %m "$file_path" 2>/dev/null || echo "0")
            current_time=$(date +%s)
            age_seconds=$((current_time - file_mtime))
            # 7200 detik = 2 jam
            if [ $age_seconds -gt 7200 ]; then
                stale=1
                reason="Usia berkas kunci telah melebihi 2 jam ($((age_seconds / 3600)) jam)."
            fi
        fi
    fi
    
    # Jika file rusak
    if [ -s "$file_path" ] && [ -z "$pid" ] && [ -z "$timestamp" ]; then
        stale=1
        reason="Berkas kunci tidak valid atau kosong."
    fi
    
    if [ $stale -eq 1 ]; then
        rm -f "$file_path"
        echo "[CLEANUP] Menghapus kunci usang '$filename': $reason"
        released_count=$((released_count + 1))
    fi
done

if [ $released_count -gt 0 ]; then
    echo "[SUCCESS] Berhasil membersihkan $released_count kunci usang!"
else
    echo "[SUCCESS] Tidak ada kunci usang yang ditemukan."
fi

exit 0
