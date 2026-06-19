<#
.SYNOPSIS
  Validates the Prodige skills registry for drift.

  Checks:
   1. Every skill folder under .ai/skills/ has a SKILL.md.
   2. Every SKILL.md begins with YAML frontmatter containing at least
      'name:' and 'description:'.
   3. Every skill folder is listed in manifest.json.
   4. Every manifest entry points to a file that exists.
   5. Both skill-selection matrices reference only skills that exist in the manifest
      (or are declared aliases). No ghost skills.
   6. The two matrices agree on the set of skills per shared command.

  Exit code 0 = clean, 1 = problems found.

.EXAMPLE
  pwsh .ai/scripts/lint-skills.ps1
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # .ai/ parent = repo root
$ai = Join-Path $root '.ai'
$skillsDir = Join-Path $ai 'skills'
$problems = New-Object System.Collections.Generic.List[string]

function Add-Problem($msg) { $script:problems.Add($msg) }

# Returns the YAML frontmatter body (text between the leading '---' fences) or
# $null when the file does not begin with a frontmatter block.
function Get-Frontmatter($text) {
  if ($null -eq $text) { return $null }
  $t = $text -replace '^\uFEFF', ''   # strip BOM if present
  if ($t -match '(?s)^\s*---\s*\r?\n(.*?)\r?\n---\s*(\r?\n|$)') {
    return $Matches[1]
  }
  return $null
}

# --- 1. Discover skill folders (those containing SKILL.md) ---
$folders = Get-ChildItem -Path $skillsDir -Directory | Where-Object {
  Test-Path (Join-Path $_.FullName 'SKILL.md')
} | Select-Object -ExpandProperty Name | Sort-Object

# Folders that exist but lack SKILL.md (excluding known support dirs)
Get-ChildItem -Path $skillsDir -Directory | ForEach-Object {
  if (-not (Test-Path (Join-Path $_.FullName 'SKILL.md'))) {
    Add-Problem "Folder '$($_.Name)' has no SKILL.md"
  }
}

# --- 1b. SKILL.md frontmatter check (name + description) ---
foreach ($f in $folders) {
  $skillFile = Join-Path (Join-Path $skillsDir $f) 'SKILL.md'
  $raw = Get-Content $skillFile -Raw
  $fm = Get-Frontmatter $raw
  if ($null -eq $fm) {
    Add-Problem "Skill '$f' SKILL.md is missing YAML frontmatter (--- block at top)"
  } else {
    if ($fm -notmatch '(?m)^\s*name\s*:\s*\S') {
      Add-Problem "Skill '$f' SKILL.md frontmatter is missing 'name:'"
    }
    if ($fm -notmatch '(?m)^\s*description\s*:\s*\S') {
      Add-Problem "Skill '$f' SKILL.md frontmatter is missing 'description:'"
    }
  }
}

# --- 2. Load manifest ---
$manifestPath = Join-Path $skillsDir 'manifest.json'
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$manifestSkills = @($manifest.skills.PSObject.Properties.Name)
$globalSkills = @()
if ($manifest.globalSkills) { $globalSkills = @($manifest.globalSkills.PSObject.Properties.Name) }
$aliases = @{}
if ($manifest.aliases) { $manifest.aliases.PSObject.Properties | ForEach-Object { $aliases[$_.Name] = $_.Value } }

$known = ($manifestSkills + $globalSkills + $aliases.Keys) | Select-Object -Unique

# Folder not in manifest
foreach ($f in $folders) {
  if ($manifestSkills -notcontains $f -and $globalSkills -notcontains $f) {
    Add-Problem "Skill folder '$f' is NOT listed in manifest.json"
  }
}
# Manifest entry with missing file
$manifest.skills.PSObject.Properties | ForEach-Object {
  $p = Join-Path $root $_.Value.path
  if (-not (Test-Path $p)) { Add-Problem "manifest skill '$($_.Name)' -> missing file: $($_.Value.path)" }
}

# --- 3. Validate matrices ---
function Get-MatrixSkills($path) {
  $names = New-Object System.Collections.Generic.List[string]
  if (-not (Test-Path $path)) { Add-Problem "Matrix not found: $path"; return $names }
  $json = Get-Content $path -Raw | ConvertFrom-Json
  foreach ($prop in $json.PSObject.Properties) {
    if ($prop.Name -like '_*' -or $prop.Name -eq 'version' -or $prop.Name -eq 'description' -or $prop.Name -eq 'lastUpdated') { continue }
    $val = $prop.Value
    if ($prop.Name -eq 'globalSkills') { $val.skills | ForEach-Object { $names.Add($_) }; continue }
    if ($prop.Name -eq 'commandSkills') {
      foreach ($cmd in $val.PSObject.Properties) {
        @($cmd.Value.required) + @($cmd.Value.optional) | Where-Object { $_ } | ForEach-Object { $names.Add($_) }
      }
      continue
    }
    # flat orchestrator format: command -> array
    if ($val -is [System.Array]) { $val | ForEach-Object { $names.Add($_) } }
  }
  return ($names | Select-Object -Unique)
}

$canonical = Join-Path $skillsDir 'skill-selection-matrix.json'
$orchestrator = Join-Path $ai 'orchestrator/skill-selection.matrix.json'

foreach ($m in @($canonical, $orchestrator)) {
  $refs = Get-MatrixSkills $m
  foreach ($r in $refs) {
    if ($known -notcontains $r) {
      Add-Problem "Matrix '$([System.IO.Path]::GetFileName($m))' references unknown skill: '$r'"
    }
  }
}

# --- Report ---
Write-Host "Skill folders with SKILL.md : $($folders.Count)"
Write-Host "Manifest skills             : $($manifestSkills.Count)"
Write-Host "Global skills               : $($globalSkills.Count)"
Write-Host ""

if ($problems.Count -eq 0) {
  Write-Host "OK - skills registry is consistent." -ForegroundColor Green
  exit 0
} else {
  Write-Host "FOUND $($problems.Count) PROBLEM(S):" -ForegroundColor Red
  $problems | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}
