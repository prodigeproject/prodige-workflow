# .ai/scripts/prodige-sentinel.ps1
# Git Sentinel Hook untuk Prodige Workflow: Menegakkan TDD, Surgical Changes & Secret Guard

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # Repo root
$ai = Join-Path $root '.ai'

Write-Host "[CHECK] Prodige Git Sentinel memverifikasi kepatuhan komit..." -ForegroundColor Cyan

# Cek apakah git terinstal di PATH
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[WARNING] Git tidak ditemukan di PATH. Sentinel dilewati secara aman." -ForegroundColor Yellow
    exit 0
}

# 1. Dapatkan daftar file yang berubah di staged area (git diff --cached)
$stagedFiles = git diff --cached --name-only
if ($stagedFiles.Count -eq 0) {
    Write-Host "[SUCCESS] Tidak ada berkas staged. Sentinel dilewati." -ForegroundColor Green
    exit 0
}

# 2. Ambil rencana implementasi aktif dari task.md atau activeContext.md
# Menentukan file mana saja yang diizinkan untuk dimodifikasi (Surgical Changes)
$activeContextPath = Join-Path $ai "memory/activeContext.md"
$taskPath = Join-Path $ai "task.md"
$allowedFiles = @()

# Membaca dari activeContext.md jika ada
if (Test-Path $activeContextPath) {
    $content = Get-Content $activeContextPath
    $allowedFiles += foreach ($line in $content) {
        if ($line -match 'file:\/\/\/([^\s\)]+)') {
            $path = $Matches[1] -replace '%20', ' '
            [System.IO.Path]::GetFileName($path)
        }
    }
}

# Membaca dari task.md jika ada
if (Test-Path $taskPath) {
    $content = Get-Content $taskPath
    $allowedFiles += foreach ($line in $content) {
        if ($line -match 'file:\/\/\/([^\s\)]+)') {
            $path = $Matches[1] -replace '%20', ' '
            [System.IO.Path]::GetFileName($path)
        }
    }
}

$allowedFiles = $allowedFiles | Select-Object -Unique

$violations = @()

# 3. Validasi Surgical Changes
foreach ($file in $stagedFiles) {
    $filename = [System.IO.Path]::GetFileName($file)
    # Abaikan file di dalam folder .ai/ karena itu adalah manajemen status internal
    if ($file -like '.ai/*' -or $file -eq 'AGENTS.md' -or $file -eq '.gitignore' -or $file -eq '.gitattributes') { continue }
    
    if ($allowedFiles.Count -gt 0 -and $allowedFiles -notcontains $filename) {
        $violations += "Pelanggaran Surgical Changes: File '$file' tidak terdaftar dalam rencana activeContext.md atau task.md!"
    }
}

# 4. Validasi TDD (Test-Driven Development Gate)
$sourceChanges = 0
$testChanges = 0
foreach ($file in $stagedFiles) {
    if ($file -match '\.(ts|js|py|go|cs|rs)$') {
        if ($file -match '(test|spec)\.(ts|js|py|go|cs|rs)$' -or $file -match 'test_') {
            $testChanges++
        } else {
            $sourceChanges++
        }
    }
}

if ($sourceChanges -gt 0 -and $testChanges -eq 0) {
    $violations += "Pelanggaran TDD Gate: Kode sumber diubah tanpa adanya modifikasi berkas pengujian (test/spec) di staged area!"
}

# 5. Keamanan: Secret Scanner (Pencegahan Kebocoran Kredensial Enterprise)
# Scan semua baris tambahan (+) dalam komit saat ini
$diffAdditions = git diff --cached | Where-Object { $_ -match '^\+[^+]' }
$secretPatterns = @(
    @{ Name = "OpenAI API Key"; Pattern = "sk-[A-Za-z0-9]{16,}" }
    @{ Name = "AWS Access Key ID"; Pattern = "AKIA[0-9A-Z]{16}" }
    @{ Name = "Private Key Block"; Pattern = "-----BEGIN [A-Z ]*PRIVATE KEY-----" }
    @{ Name = "Kunci Rahasia (Password/API Key) Terhardcode"; Pattern = "(password|passwd|secret|apikey|api_key|token)\s*[:=]\s*['""\s][A-Za-z0-9-_\.=]{16,}['""\s]" }
)

foreach ($line in $diffAdditions) {
    foreach ($sp in $secretPatterns) {
        if ($line -match $sp.Pattern) {
            $violations += "Pelanggaran Keamanan: Ditemukan indikasi kebocoran kredensial [$($sp.Name)] pada baris komit staged!"
        }
    }
}

# 6. Keputusan Akhir Sentinel
if ($violations.Count -gt 0) {
    Write-Host "[ERROR] Prodige Sentinel memblokir komit karena pelanggaran aturan:" -ForegroundColor Red
    foreach ($v in $violations) {
        Write-Host "  - $v" -ForegroundColor Yellow
    }
    Write-Host "[TIP] Silakan perbaiki rencana tugas Anda di activeContext.md, tambahkan uji unit, atau bersihkan berkas rahasia sebelum melakukan komit." -ForegroundColor LightCyan
    exit 1
}

Write-Host "[SUCCESS] Prodige Sentinel: Semua aturan terpenuhi. Komit diizinkan!" -ForegroundColor Green
exit 0
