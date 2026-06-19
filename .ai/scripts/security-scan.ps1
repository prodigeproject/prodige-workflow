<#
.SYNOPSIS  Prodige Security Scanner (Windows/PowerShell) - automated first pass.
.DESCRIPTION
  Catches mechanically-detectable OWASP issues. Severity maps to Prodige:
  Critical (blocks merge) / Important / Minor.
#>
param([string]$BaseRef = "origin/main")
$ErrorActionPreference = "Continue"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportDir = ".ai/reports/reviews"
$report = Join-Path $reportDir "security-scan-$stamp.md"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$crit = 0; $imp = 0; $min = 0
$findings = @()
function Add-Finding($sev, $title, $detail) {
  $script:findings += [pscustomobject]@{ Sev=$sev; Title=$title; Detail=$detail }
  switch ($sev) {
    "CRITICAL"  { $script:crit++;  Write-Host "[CRITICAL] $title" -ForegroundColor Red }
    "IMPORTANT" { $script:imp++;   Write-Host "[IMPORTANT] $title" -ForegroundColor Yellow }
    "MINOR"     { $script:min++;   Write-Host "[MINOR] $title" -ForegroundColor Cyan }
  }
}

if (git rev-parse $BaseRef 2>$null) { $diff = git diff "$BaseRef...HEAD" 2>$null }
else { $diff = git diff "HEAD~1...HEAD" 2>$null }
$added = $diff | Where-Object { $_ -match '^\+' }
function Match-Added($pattern, $exclude) {
  $m = $added | Where-Object { $_ -match $pattern }
  if ($exclude) { $m = $m | Where-Object { $_ -notmatch $exclude } }
  return ($m -join "`n")
}

Write-Host "Prodige Security Scan (base: $BaseRef)"
Write-Host "============================================"

$h = Match-Added '(?i)(api[_-]?key|secret|password|token|private[_-]?key)\s*[:=]\s*["''][^"'']{8,}' '(?i)(process\.env|os\.environ|getenv|example|placeholder|<your|xxxx)'
if ($h) { Add-Finding "CRITICAL" "Hardcoded secret(s) detected" $h }

# SQL injection: same two-stage match as security-scan.sh -- a query/exec call
# with string interpolation AND a SQL keyword anywhere on the line (keyword need
# not follow the interpolation), so both scripts flag identical patterns.
$h = ($added | Where-Object {
  $_ -match '(?i)(query|execute|exec)\(.*(\$\{|\+\s*[a-zA-Z_])' -and $_ -match '(?i)(select|insert|update|delete)'
}) -join "`n"
if ($h) { Add-Finding "CRITICAL" "Possible SQL injection (interpolated query)" $h }

$h = Match-Added '(?i)(exec|spawn|system|popen)\(.*(\$\{|\+\s*req|user)' $null
if ($h) { Add-Finding "CRITICAL" "Possible command injection" $h }

$h = Match-Added '(?:^|[^a-zA-Z])eval\(|new Function\(' $null
if ($h) { Add-Finding "CRITICAL" "Dynamic code execution (eval/Function)" $h }

$h = Match-Added 'dangerouslySetInnerHTML|\.innerHTML\s*=' $null
if ($h) { Add-Finding "IMPORTANT" "Potential XSS sink (innerHTML)" $h }

$h = Match-Added '(?i)(md5|sha1)\(' $null
if ($h) { Add-Finding "IMPORTANT" "Weak hash algorithm (md5/sha1)" $h }

$h = Match-Added 'Math\.random\(\)' $null
if ($h) { Add-Finding "MINOR" "Math.random() not safe for security tokens" $h }

if ((Test-Path package.json) -and (Get-Command npm -EA SilentlyContinue)) {
  $audit = npm audit --audit-level=high --json 2>$null | Out-String
  if ($audit -match '"critical":\s*(\d+)' -and [int]$Matches[1] -gt 0) { Add-Finding "CRITICAL" "npm audit: $($Matches[1]) critical vuln(s)" "run: npm audit" }
  if ($audit -match '"high":\s*(\d+)' -and [int]$Matches[1] -gt 0) { Add-Finding "IMPORTANT" "npm audit: $($Matches[1]) high vuln(s)" "run: npm audit" }
}

# A06 - vulnerable Python dependencies (parity with security-scan.sh pip-audit branch)
if ((Test-Path requirements.txt) -and (Get-Command pip-audit -EA SilentlyContinue)) {
  $pa = pip-audit 2>$null | Out-String
  if ($pa -match '(?i)vulnerab') { Add-Finding "IMPORTANT" "pip-audit found vulnerabilities" "run: pip-audit" }
}

$md = @("# Security Scan Report", "**Date:** $stamp", "**Base:** $BaseRef", "", "**Critical:** $crit | **Important:** $imp | **Minor:** $min", "")
if ($findings.Count -eq 0) { $md += "No mechanically-detectable issues. Proceed to manual logic review." }
else { foreach ($f in $findings) { $md += @("## [$($f.Sev)] $($f.Title)", '```', $f.Detail, '```', "") } }
$md += @("---", "_Automated pass only. Manual review still required for OWASP A01/A04/A09._")
$md -join "`n" | Set-Content -Path $report -Encoding UTF8

Write-Host "============================================"
Write-Host "Report: $report"
Write-Host "Critical: $crit | Important: $imp | Minor: $min"
if ($crit -gt 0) { Write-Host "MERGE BLOCKED - critical security findings." -ForegroundColor Red; exit 1 }
exit 0
