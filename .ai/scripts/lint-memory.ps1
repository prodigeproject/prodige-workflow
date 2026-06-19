<#
.SYNOPSIS
  Validates the Prodige Memory Bank for drift, anchor integrity, and secret leaks.

  Checks (FAIL = non-zero exit):
   1. Parse every row of the Index table in .ai/memory/index.md
      (id, date, type, topic, source_file).
   2. For each row: open source_file (relative to .ai/memory/, may include an
      archive/ subpath) and verify a heading '### M-NNNN ...' exists (accepts
      ASCII hyphen or em dash in the data file; matched on the M-NNNN token).
   3. Reverse check: any '### M-NNNN' anchor in an indexed memory file with no
      matching index row is an orphan.
   4. IDs are unique and monotonically increasing; the footer 'Next ID' must be
      greater than the max existing id.
   5. review-patterns.json must parse as valid JSON if present.

  Advisory (WARNING only, does NOT affect exit code):
   - Files directly in .ai/memory/ that are not known indexed files.
   - Unknown entry types.
   - Secret / PII patterns found anywhere under .ai/memory/ (file:line, no value).

  Exit code 0 = clean, 1 = problems found.

.EXAMPLE
  pwsh .ai/scripts/lint-memory.ps1
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # .ai/ parent = repo root
$ai = Join-Path $root '.ai'
$memDir = Join-Path $ai 'memory'
$indexPath = Join-Path $memDir 'index.md'

$problems = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Problem($msg) { $script:problems.Add($msg) }
function Add-Warning($msg) { $script:warnings.Add($msg) }

# Known indexed source files (live directly under .ai/memory/).
$indexedFiles = @('sessionHistory.md', 'decisionLog.md', 'conventions.md', 'progress.md')
# Files directly in .ai/memory/ that are NOT indexed entry stores.
$nonIndexedFiles = @('index.md', 'activeContext.md', 'projectContext.md', 'review-patterns.json', 'README.md')
# Valid entry types.
$validTypes = @('session', 'decision', 'pattern', 'bugfix', 'feature', 'discovery')

if (-not (Test-Path $indexPath)) {
  Write-Host "FOUND 1 PROBLEM(S):" -ForegroundColor Red
  Write-Host "  - Memory index not found: $indexPath" -ForegroundColor Red
  exit 1
}

# --- 1. Parse the Index table ---
$rows = New-Object System.Collections.Generic.List[object]
$indexLines = Get-Content $indexPath
foreach ($line in $indexLines) {
  if ($line -match '^\|\s*(M-\d+)\s*\|\s*([^|]*)\|\s*([^|]*)\|\s*([^|]*)\|\s*([^|]*)\|') {
    $rows.Add([pscustomobject]@{
      Id     = $Matches[1].Trim()
      Date   = $Matches[2].Trim()
      Type   = $Matches[3].Trim()
      Topic  = $Matches[4].Trim()
      Source = $Matches[5].Trim()
    })
  }
}

# Map id (numeric) -> id text, and the set of indexed ids.
$indexIds = @{}            # numeric -> idText
$indexIdSet = @{}          # idText -> $true
$prevNum = $null
foreach ($r in $rows) {
  $num = [int]($r.Id -replace '^M-0*', '')
  if ($num -eq 0 -and $r.Id -notmatch '0+$') { $num = [int]($r.Id -replace '\D', '') }

  # --- 4a. Unique ---
  if ($indexIds.ContainsKey($num)) {
    Add-Problem "Duplicate index id: $($r.Id)"
  } else {
    $indexIds[$num] = $r.Id
    $indexIdSet[$r.Id] = $true
  }

  # --- 4b. Monotonic (strictly increasing in table order) ---
  if ($null -ne $prevNum -and $num -le $prevNum) {
    Add-Problem "Index id not monotonic: $($r.Id) follows M-$('{0:0000}' -f $prevNum)"
  }
  $prevNum = $num

  # --- 7. Type check (advisory) ---
  if ($validTypes -notcontains $r.Type) {
    Add-Warning "Row $($r.Id): unknown type '$($r.Type)'"
  }

  # --- 2. Anchor exists in source file ---
  if ([string]::IsNullOrWhiteSpace($r.Source)) {
    Add-Problem "Row $($r.Id): empty source_file"
    continue
  }
  $srcPath = Join-Path $memDir $r.Source
  if (-not (Test-Path $srcPath)) {
    Add-Problem "Row $($r.Id): source file not found: $($r.Source)"
    continue
  }
  $srcRaw = Get-Content $srcPath -Raw
  $anchorPattern = "(?m)^###\s+$([regex]::Escape($r.Id))(\b|\s|$)"
  if ($srcRaw -notmatch $anchorPattern) {
    Add-Problem "Row $($r.Id): missing anchor '### $($r.Id) ...' in $($r.Source)"
  }
}

$maxNum = if ($indexIds.Count -gt 0) { ($indexIds.Keys | Measure-Object -Maximum).Maximum } else { 0 }

# --- 4c. Next ID footer must be greater than the max existing id ---
$indexRaw = Get-Content $indexPath -Raw
if ($indexRaw -match 'Next ID:\s*M-(\d+)') {
  $nextNum = [int]$Matches[1]
  if ($nextNum -le $maxNum) {
    Add-Problem "Footer 'Next ID: M-$('{0:0000}' -f $nextNum)' must be greater than max id M-$('{0:0000}' -f $maxNum)"
  }
} else {
  Add-Problem "Footer 'Next ID: M-NNNN' not found in index.md"
}

# --- 3. Reverse check: anchors with no matching index row ---
# Scan the union of known indexed files and any source files referenced in rows.
$scanSet = New-Object System.Collections.Generic.List[string]
foreach ($f in $indexedFiles) {
  $p = Join-Path $memDir $f
  if (Test-Path $p) { $scanSet.Add($p) }
}
foreach ($r in $rows) {
  if (-not [string]::IsNullOrWhiteSpace($r.Source)) {
    $p = Join-Path $memDir $r.Source
    if ((Test-Path $p) -and ($scanSet -notcontains $p)) { $scanSet.Add($p) }
  }
}

$anchorsFound = 0
foreach ($p in $scanSet) {
  $raw = Get-Content $p -Raw
  $rel = $p.Substring($memDir.Length).TrimStart('\', '/')
  foreach ($m in [regex]::Matches($raw, '(?m)^###\s+(M-\d+)(\b|\s|$)')) {
    $anchorsFound++
    $aid = $m.Groups[1].Value
    if (-not $indexIdSet.ContainsKey($aid)) {
      Add-Problem "Orphan anchor '$aid' in $rel (no matching index row)"
    }
  }
}

# --- 5. Unknown / orphan files directly in .ai/memory/ (advisory) ---
$known = $indexedFiles + $nonIndexedFiles
Get-ChildItem -Path $memDir -File | ForEach-Object {
  if ($known -notcontains $_.Name) {
    Add-Warning "Unknown file in .ai/memory/: $($_.Name) (not an indexed entry store)"
  }
}

# --- 6. review-patterns.json must be valid JSON if present ---
$rpPath = Join-Path $memDir 'review-patterns.json'
if (Test-Path $rpPath) {
  try {
    Get-Content $rpPath -Raw | ConvertFrom-Json | Out-Null
  } catch {
    Add-Problem "review-patterns.json is not valid JSON: $($_.Exception.Message)"
  }
}

# --- F8. Secret / PII guard (advisory; reports file:line, never the value) ---
$secretPatterns = @(
  @{ Name = 'OpenAI-style key (sk-)';      Pattern = 'sk-[A-Za-z0-9]{16,}' }
  @{ Name = 'AWS access key id (AKIA)';    Pattern = 'AKIA[0-9A-Z]{16}' }
  @{ Name = 'Private key block';           Pattern = '-----BEGIN [A-Z ]*PRIVATE KEY-----' }
  @{ Name = 'password assignment';         Pattern = 'password\s*[:=]\s*\S' }
  @{ Name = 'token assignment';            Pattern = 'token\s*[:=]\s*\S' }
  @{ Name = 'secret assignment';           Pattern = 'secret\s*[:=]\s*\S' }
  @{ Name = 'Bearer token';                Pattern = 'Bearer\s+[A-Za-z0-9\-_\.=]{16,}' }
  @{ Name = 'long hex/base64 value';       Pattern = '[:=]\s*["'']?[A-Za-z0-9+/]{40,}={0,2}["'']?\s*$' }
)
$scanFiles = Get-ChildItem -Path $memDir -Recurse -File |
  Where-Object { $_.Extension -in '.md', '.json', '.txt', '.yml', '.yaml' }
foreach ($f in $scanFiles) {
  $rel = $f.FullName.Substring($memDir.Length).TrimStart('\', '/')
  $n = 0
  foreach ($ln in (Get-Content $f.FullName)) {
    $n++
    foreach ($sp in $secretPatterns) {
      if ($ln -match $sp.Pattern) {
        Add-Warning "Possible secret [$($sp.Name)] at ${rel}:$n"
      }
    }
  }
}

# --- Report ---
Write-Host "Index rows        : $($rows.Count)"
Write-Host "Anchors found     : $anchorsFound"
Write-Host "Files scanned     : $($scanSet.Count)"
Write-Host "Next ID           : $(if ($indexRaw -match 'Next ID:\s*(M-\d+)') { $Matches[1] } else { 'n/a' })"
Write-Host ""

if ($warnings.Count -gt 0) {
  Write-Host "WARNINGS ($($warnings.Count)) - advisory, exit code unaffected:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  Write-Host ""
}

if ($problems.Count -eq 0) {
  Write-Host "OK - Memory Bank is consistent." -ForegroundColor Green
  exit 0
} else {
  Write-Host "FOUND $($problems.Count) PROBLEM(S):" -ForegroundColor Red
  $problems | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}
