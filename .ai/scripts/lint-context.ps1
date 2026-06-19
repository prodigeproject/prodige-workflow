<#
.SYNOPSIS
  Validates the Prodige context and state directories for drift.

  Checks (FAIL = non-zero exit):
   1. .ai/context/manifest.json exists, parses as valid JSON, and has an
      integer 'context_version' plus a 'last_sync' key.
   2. Every context file BOOT loads exists under .ai/context/:
      PROJECT.md, PRD.md, ARCHITECTURE.md, IMPLEMENTATION.md, CONTEXT.md,
      DECISIONS.md, CHANGELOG.md
   3. Every state file exists under .ai/state/:
      CURRENT.md, SPRINT.md, BACKLOG.md, STATUS.md

  Advisory (WARNING only, does NOT affect exit code):
   - The ADR directory should be .ai/context/docs/adr/. If a misplaced
     .ai/docs/adr/ exists instead, that is flagged.
   - Any context or state file that still contains an unfilled [TBD] or
     [placeholder] bracket marker (template state).

  Exit code 0 = clean, 1 = problems found.

.EXAMPLE
  powershell -File .ai/scripts/lint-context.ps1
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # .ai/ parent = repo root
$ai = Join-Path $root '.ai'
$contextDir = Join-Path $ai 'context'
$stateDir = Join-Path $ai 'state'

$problems = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Problem($msg) { $script:problems.Add($msg) }
function Add-Warning($msg) { $script:warnings.Add($msg) }

# Files scanned for unfilled placeholder/TBD markers.
$placeholderTargets = New-Object System.Collections.Generic.List[string]

# --- 1. manifest.json: exists, valid JSON, integer context_version, last_sync key ---
$manifestPath = Join-Path $contextDir 'manifest.json'
if (-not (Test-Path $manifestPath)) {
  Add-Problem "Missing manifest: .ai/context/manifest.json"
} else {
  $manifest = $null
  try {
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
  } catch {
    Add-Problem "context/manifest.json is not valid JSON: $($_.Exception.Message)"
  }
  if ($null -ne $manifest) {
    $names = @($manifest.PSObject.Properties.Name)
    if ($names -notcontains 'context_version') {
      Add-Problem "context/manifest.json is missing field: 'context_version'"
    } else {
      $cv = $manifest.context_version
      if (-not (($cv -is [int]) -or ($cv -is [long]) -or ($cv -is [int16]) -or ($cv -is [byte]))) {
        Add-Problem "context/manifest.json 'context_version' must be an integer (got: '$cv')"
      }
    }
    if ($names -notcontains 'last_sync') {
      Add-Problem "context/manifest.json is missing field: 'last_sync'"
    }
  }
}

# --- 2. Context files BOOT loads ---
$contextFiles = @(
  'PROJECT.md', 'PRD.md', 'ARCHITECTURE.md', 'IMPLEMENTATION.md',
  'CONTEXT.md', 'DECISIONS.md', 'CHANGELOG.md'
)
$contextFound = 0
foreach ($f in $contextFiles) {
  $p = Join-Path $contextDir $f
  if (Test-Path $p) {
    $contextFound++
    $placeholderTargets.Add($p)
  } else {
    Add-Problem "Missing context file: .ai/context/$f"
  }
}

# --- 3. State files ---
$stateFiles = @('CURRENT.md', 'SPRINT.md', 'BACKLOG.md', 'STATUS.md')
$stateFound = 0
foreach ($f in $stateFiles) {
  $p = Join-Path $stateDir $f
  if (Test-Path $p) {
    $stateFound++
    $placeholderTargets.Add($p)
  } else {
    Add-Problem "Missing state file: .ai/state/$f"
  }
}

# --- Advisory: ADR directory location ---
$canonicalAdr = Join-Path $contextDir 'docs/adr'
$misplacedAdr = Join-Path $ai 'docs/adr'
if (Test-Path $misplacedAdr -PathType Container) {
  Add-Warning "Misplaced ADR directory .ai/docs/adr/ found - canonical location is .ai/context/docs/adr/"
}
if (-not (Test-Path $canonicalAdr -PathType Container)) {
  Add-Warning "Canonical ADR directory .ai/context/docs/adr/ is missing"
}

# --- Advisory: unfilled [TBD] / [placeholder] markers ---
foreach ($p in $placeholderTargets) {
  $raw = Get-Content $p -Raw
  if ($raw -match '(?i)\[(TBD|placeholder)\]') {
    $rel = $p.Substring($ai.Length).TrimStart('\', '/')
    Add-Warning "Unfilled template marker ([TBD]/[placeholder]) found in .ai/$rel"
  }
}

# --- Report ---
Write-Host "Context files found : $contextFound / $($contextFiles.Count)"
Write-Host "State files found   : $stateFound / $($stateFiles.Count)"
Write-Host ""

if ($warnings.Count -gt 0) {
  Write-Host "WARNINGS ($($warnings.Count)) - advisory, exit code unaffected:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  Write-Host ""
}

if ($problems.Count -eq 0) {
  Write-Host "OK - context and state are consistent." -ForegroundColor Green
  exit 0
} else {
  Write-Host "FOUND $($problems.Count) PROBLEM(S):" -ForegroundColor Red
  $problems | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}
