<#
.SYNOPSIS
  Validates the Prodige runtime canonical paths and templates for drift.

  Checks (FAIL = non-zero exit):
   1. No .md or .json file under .ai/ references a deprecated top-level
      '.ai/cache/' or '.ai/handoffs/' path. Runtime paths must live under
      '.ai/runtime/cache/...' and '.ai/runtime/handoffs/...'. Offenders are
      reported as file:line. (The canonical layout doc
      .ai/runtime/README.md is exempt: it cites the deprecated forms to
      forbid them.)
   2. No .md or .json file references a non-canonical '.ai/parallel/' path.
      Parallel artifacts must live under '.ai/runtime/...'; there is no
      '.ai/parallel/' directory.
   3. Runtime template JSON files parse as valid JSON:
      .ai/runtime/sessions/SESSION_TEMPLATE.json
      .ai/runtime/cache/CACHE_MANIFEST.json
      .ai/runtime/cache/repomap.json

  Advisory (WARNING only, does NOT affect exit code):
   - SESSION_TEMPLATE.json should declare 'agent_role' and 'snapshot_id' keys.
   - Cache/repo-map/snapshot/session/handoff artifacts written under
     '.ai/context/' (cache belongs in '.ai/runtime/cache/'). This is a
     targeted heuristic: only lines that pair '.ai/context/' with
     cache/repo-map/snapshot wording are flagged, to avoid false positives
     on legitimate '.ai/context/' documentation references.

  Exit code 0 = clean, 1 = problems found.

.EXAMPLE
  powershell -File .ai/scripts/lint-runtime.ps1
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # .ai/ parent = repo root
$ai = Join-Path $root '.ai'

$problems = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
function Add-Problem($msg) { $script:problems.Add($msg) }
function Add-Warning($msg) { $script:warnings.Add($msg) }

# --- 1. Scan .ai/**(md+json) for non-canonical runtime paths ---
# (a) Matches '.ai/cache/' or '.ai/handoffs/' (either slash) but NOT
#     '.ai/runtime/cache/' (since 'runtime' sits between '.ai' and 'cache').
$badPathPattern = '\.ai[\\/](cache|handoffs)[\\/]'
# (b) Matches any '.ai/parallel/' path; parallel artifacts must live under
#     '.ai/runtime/...' and there is no '.ai/parallel/' directory.
$parallelPattern = '\.ai[\\/]parallel[\\/]'
# (c) Targeted cache-in-context heuristic (advisory WARNING). Only flag lines
#     that reference '.ai/context/' AND mention a cache/repo-map/snapshot/
#     session/handoff artifact, so legitimate '.ai/context/' doc references
#     are not falsely flagged.
$contextPathPattern = '\.ai[\\/]context[\\/]'
$contextArtifactPattern = '(cache|repo-?map|repomap|snapshot|session|handoff)'
# The runtime layout README is the canonical definition of these rules; it cites
# the deprecated/forbidden forms only to forbid them, so it is not a violation.
# This linter's own scripts are not scanned (only *.md and *.json are).
$scanExclude = @('runtime/README.md')
$filesScanned = 0
$offenders = 0
Get-ChildItem -Path $ai -Recurse -File -Include '*.md', '*.json' | ForEach-Object {
  $rel = $_.FullName.Substring($ai.Length).TrimStart('\', '/')
  $relNorm = $rel -replace '\\', '/'
  if ($scanExclude -contains $relNorm) { return }
  $filesScanned++
  $n = 0
  foreach ($ln in (Get-Content $_.FullName)) {
    $n++
    if ($ln -match $badPathPattern) {
      $offenders++
      Add-Problem "Deprecated top-level runtime path in .ai/${rel}:$n (use .ai/runtime/...)"
    }
    if ($ln -match $parallelPattern) {
      $offenders++
      Add-Problem "Non-canonical .ai/parallel/ path in .ai/${rel}:$n (use .ai/runtime/...)"
    }
    if (($ln -match $contextPathPattern) -and ($ln -match $contextArtifactPattern) -and ($ln -notmatch '\.ai[\\/]runtime[\\/]')) {
      # A line that already references the canonical .ai/runtime/ path is doing the
      # right thing (e.g. copying context docs INTO a snapshot, or git-adding both) -
      # not a violation.
      Add-Warning "Cache artifact under .ai/context/ in .ai/${rel}:$n (cache belongs in .ai/runtime/cache/)"
    }
  }
}

# --- 2. Runtime template JSONs parse ---
$jsonTemplates = @(
  'runtime/sessions/SESSION_TEMPLATE.json',
  'runtime/cache/CACHE_MANIFEST.json',
  'runtime/cache/repomap.json'
)
$jsonChecked = 0
$sessionTemplate = $null
foreach ($rel in $jsonTemplates) {
  $p = Join-Path $ai $rel
  if (-not (Test-Path $p)) {
    Add-Problem "Missing runtime template: .ai/$rel"
    continue
  }
  $jsonChecked++
  try {
    $parsed = Get-Content $p -Raw | ConvertFrom-Json
    if ($rel -eq 'runtime/sessions/SESSION_TEMPLATE.json') { $sessionTemplate = $parsed }
  } catch {
    Add-Problem ".ai/$rel is not valid JSON: $($_.Exception.Message)"
  }
}

# --- Advisory: SESSION_TEMPLATE.json key presence ---
if ($null -ne $sessionTemplate) {
  $keys = @($sessionTemplate.PSObject.Properties.Name)
  foreach ($k in @('agent_role', 'snapshot_id')) {
    if ($keys -notcontains $k) {
      Add-Warning "SESSION_TEMPLATE.json is missing recommended key: '$k'"
    }
  }
}

# --- Report ---
Write-Host "Files scanned (md+json) : $filesScanned"
Write-Host "JSON templates checked  : $jsonChecked / $($jsonTemplates.Count)"
Write-Host "Deprecated path hits    : $offenders"
Write-Host ""

if ($warnings.Count -gt 0) {
  Write-Host "WARNINGS ($($warnings.Count)) - advisory, exit code unaffected:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  Write-Host ""
}

if ($problems.Count -eq 0) {
  Write-Host "OK - runtime canonical paths and templates are consistent." -ForegroundColor Green
  exit 0
} else {
  Write-Host "FOUND $($problems.Count) PROBLEM(S):" -ForegroundColor Red
  $problems | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}
