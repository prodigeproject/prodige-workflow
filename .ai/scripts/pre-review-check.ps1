<#
.SYNOPSIS
  Prodige Pre-Review Automated Checks (Windows/PowerShell).
.DESCRIPTION
  Runs BEFORE dispatching the Reviewer Agent to filter out trivial issues.
  Exit codes: 0 = pass, 1 = blocking failure, 2 = warnings only.
#>
param([string]$BaseRef = "origin/main")

$ErrorActionPreference = "Continue"
$reportDir = ".ai/reports/reviews"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$report = Join-Path $reportDir "pre-review-$stamp.md"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$blocking = 0; $warnings = 0
$results = @()

function Detect-Stack {
  if (Test-Path package.json) { return "node" }
  if ((Test-Path pyproject.toml) -or (Test-Path requirements.txt)) { return "python" }
  if (Test-Path go.mod) { return "go" }
  if (Test-Path Cargo.toml) { return "rust" }
  return "unknown"
}
$stack = Detect-Stack

# Mirror the .sh guard: only run npm scripts that actually exist in package.json
# (no `jq` on Windows, so parse with ConvertFrom-Json). Returns the script body
# string or $null when absent, so the verdict matches the bash script (SKIP).
function Get-PkgScript($name) {
  if (-not (Test-Path package.json)) { return $null }
  try {
    $pkg = Get-Content package.json -Raw | ConvertFrom-Json
    if ($pkg.scripts) { return $pkg.scripts.$name }
    return $null
  } catch { return $null }
}

function Record($status, $msg) {
  $script:results += [pscustomobject]@{ Status = $status; Message = $msg }
  switch ($status) {
    "FAIL" { $script:blocking++; Write-Host "[X] $msg" -ForegroundColor Red }
    "WARN" { $script:warnings++; Write-Host "[!] $msg" -ForegroundColor Yellow }
    "PASS" { Write-Host "[OK] $msg" -ForegroundColor Green }
    "SKIP" { Write-Host "[-] $msg" -ForegroundColor DarkGray }
  }
}

function Run-Check($desc, $scriptblock) {
  try {
    & $scriptblock *> "$env:TEMP\prodige_check.log"
    if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) { Record "PASS" $desc }
    else { Record "FAIL" "$desc (see $env:TEMP\prodige_check.log)" }
  } catch { Record "FAIL" "$desc ($_)" }
}

Write-Host "Prodige Pre-Review Checks (stack: $stack, base: $BaseRef)"
Write-Host "================================================================"

# 1. Lint
switch ($stack) {
  "node"   { if (Get-PkgScript "lint") { Run-Check "Lint" { npm run lint } } else { Record "SKIP" "Lint (no script)" } }
  "python" { if (Get-Command ruff -EA SilentlyContinue) { Run-Check "Lint (ruff)" { ruff check . } } else { Record "SKIP" "Lint (ruff not found)" } }
  "go"     { Run-Check "Vet" { go vet ./... } }
  "rust"   { Run-Check "Clippy" { cargo clippy -- -D warnings } }
  default  { Record "SKIP" "Lint (unknown stack)" }
}

# 2. Tests
switch ($stack) {
  "node"   { if (Get-PkgScript "test") { Run-Check "Tests" { npm test } } else { Record "SKIP" "Tests (no script)" } }
  "python" { if (Get-Command pytest -EA SilentlyContinue) { Run-Check "Tests (pytest)" { pytest -q } } else { Record "SKIP" "Tests (pytest not found)" } }
  "go"     { Run-Check "Tests" { go test ./... } }
  "rust"   { Run-Check "Tests" { cargo test } }
  default  { Record "SKIP" "Tests (unknown stack)" }
}

# 3. Secret scan
$diff = git diff "$BaseRef...HEAD" 2>$null
$added = $diff | Where-Object { $_ -match '^\+' }
$secretPattern = '(?i)(api[_-]?key|secret|password|passwd|token|private[_-]?key)\s*[:=]\s*["''][^"'']{8,}'
$secretHits = ($added | Where-Object { $_ -match $secretPattern -and $_ -notmatch '(?i)(process\.env|os\.environ|getenv|example|placeholder|xxxx|<your)' }).Count
if ($secretHits -gt 0) { Record "FAIL" "Secret scan: $secretHits possible hardcoded secret(s)" }
else { Record "PASS" "Secret scan: no hardcoded secrets detected" }

# 4. Debug statements
$debugHits = ($added | Where-Object { $_ -match 'console\.(log|debug)|debugger;' -and $_ -notmatch '(?i)(test|spec|\.md)' }).Count
if ($debugHits -gt 0) { Record "WARN" "Debug statements: $debugHits console.log/debugger in changed code" }
else { Record "PASS" "Debug statements: clean" }

# 5. TODO/FIXME
$todoHits = ($added | Where-Object { $_ -match '\b(TODO|FIXME|HACK|XXX)\b' }).Count
if ($todoHits -gt 0) { Record "WARN" "TODO/FIXME: $todoHits new marker(s) - document in debt register" }
else { Record "PASS" "TODO/FIXME: none added" }

# 6. Diff size
$filesChanged = (git diff --name-only "$BaseRef...HEAD" 2>$null | Measure-Object).Count
if ($filesChanged -gt 25) { Record "WARN" "Diff size: $filesChanged files changed - verify no scope creep" }
else { Record "PASS" "Diff size: $filesChanged files" }

# --- Report ---
$md = @("# Pre-Review Check Report", "**Date:** $stamp", "**Stack:** $stack", "**Base:** $BaseRef", "", "| Status | Check |", "|--------|-------|")
foreach ($r in $results) { $md += "| $($r.Status) | $($r.Message) |" }
$md += @("", "**Blocking failures:** $blocking", "**Warnings:** $warnings")
$md -join "`n" | Set-Content -Path $report -Encoding UTF8

Write-Host "================================================================"
Write-Host "Report: $report"
Write-Host "Blocking: $blocking | Warnings: $warnings"
if ($blocking -gt 0) { Write-Host "BLOCKED: fix blocking failures before review." -ForegroundColor Red; exit 1 }
elseif ($warnings -gt 0) { Write-Host "PASS WITH WARNINGS." -ForegroundColor Yellow; exit 2 }
else { Write-Host "ALL CHECKS PASSED." -ForegroundColor Green; exit 0 }
