# .ai/scripts/release-locks.ps1
# Prodige Lock Manager Cleanup: Otomatis melepaskan stale locks (kunci usang) berdasarkan PID atau waktu.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # Repo root
$locksDir = Join-Path $root ".ai/runtime/locks"

if (-not (Test-Path $locksDir)) {
    Write-Host "[INFO] Direktori kunci tidak ditemukan: $locksDir"
    exit 0
}

Write-Host "[CHECK] Memeriksa berkas kunci (locks)..." -ForegroundColor Cyan

$lockFiles = Get-ChildItem -Path $locksDir -Filter "*.lock" -File
$releasedCount = 0

foreach ($file in $lockFiles) {
    $filePath = $file.FullName
    $stale = $false
    $reason = ""
    
    try {
        $lockData = Get-Content $filePath -Raw | ConvertFrom-Json
        
        # 1. Cek berdasarkan PID (Process ID) jika tersedia
        if ($lockData.pid) {
            $pid = [int]$lockData.pid
            $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
            if ($null -eq $process) {
                $stale = $true
                $reason = "Proses PID $pid tidak ditemukan sedang berjalan."
            }
        }
        
        # 2. Cek berdasarkan usia kunci (misal > 2 jam) jika tidak ada PID atau proses masih dianggap berjalan tapi terlalu lama
        if (-not $stale -and $lockData.timestamp) {
            $timestamp = [DateTime]$lockData.timestamp
            $age = (Get-Date) - $timestamp
            if ($age.TotalHours -gt 2) {
                $stale = $true
                $reason = "Kunci telah berusia lebih dari 2 jam ($($age.TotalHours) jam)."
            }
        }
    } catch {
        # Jika file JSON rusak, anggap stale dan hapus
        $stale = $true
        $reason = "Berkas kunci rusak atau tidak valid JSON: $($_.Exception.Message)"
    }
    
    if ($stale) {
        Remove-Item -Path $filePath -Force
        Write-Host "[CLEANUP] Menghapus kunci usang '$($file.Name)': $reason" -ForegroundColor Yellow
        $releasedCount++
    }
}

if ($releasedCount -gt 0) {
    Write-Host "[SUCCESS] Berhasil membersihkan $releasedCount kunci usang!" -ForegroundColor Green
} else {
    Write-Host "[SUCCESS] Tidak ada kunci usang yang ditemukan." -ForegroundColor Green
}

exit 0
