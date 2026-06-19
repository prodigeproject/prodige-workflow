<#
.SYNOPSIS
  Validates the Prodige command registry for drift.

  Checks:
   1. registry.json is valid JSON.
   2. Every command key in registry.json has a matching .ai/commands/<name>.md
      spec (leading slash stripped). FAIL on missing spec.
   3. Every .ai/commands/*.md (except README.md) is registered in registry.json.
      FAIL on ghost spec.
   4. Every registry "workflow" value resolves to EITHER .ai/workflows/<value>.md
      OR a known agent .ai/agents/<value>.md OR a spec-only handler (allowlist).
      WARN (advisory) for allowlisted spec/agent handlers; FAIL only when a value
      resolves to nothing at all.

  Exit code 0 = clean, 1 = problems found. Warnings do not affect the exit code.

.EXAMPLE
  pwsh .ai/scripts/lint-commands.ps1
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)  # .ai/ parent = repo root
$ai = Join-Path $root '.ai'
$commandsDir = Join-Path $ai 'commands'
$workflowsDir = Join-Path $ai 'workflows'
$agentsDir = Join-Path $ai 'agents'
$registryPath = Join-Path $commandsDir 'registry.json'

$problems = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
function Add-Problem($msg) { $script:problems.Add($msg) }
function Add-Warning($msg) { $script:warnings.Add($msg) }

# Spec-only / agent handlers that legitimately have NO workflow file (allowlist).
$specOnlyHandlers = @(
  'session-start', 'session-end', 'memory-init', 'verification',
  'git-undo', 'git-checkpoint', 'git-rollback', 'magic-orchestrator', 'agent-session',
  'test', 'roastme', 'diagnose-health'
)

# --- 0. registry.json must exist and be valid JSON ---
if (-not (Test-Path $registryPath)) {
  Write-Host "FOUND 1 PROBLEM(S):" -ForegroundColor Red
  Write-Host "  - registry.json not found: $registryPath" -ForegroundColor Red
  exit 1
}
try {
  $registry = Get-Content $registryPath -Raw | ConvertFrom-Json
} catch {
  Write-Host "FOUND 1 PROBLEM(S):" -ForegroundColor Red
  Write-Host "  - registry.json is not valid JSON: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}

if ($null -eq $registry.commands) {
  Write-Host "FOUND 1 PROBLEM(S):" -ForegroundColor Red
  Write-Host "  - registry.json has no 'commands' object" -ForegroundColor Red
  exit 1
}

$commandProps = @($registry.commands.PSObject.Properties)
$commandCount = $commandProps.Count

# Set of registered spec names (leading slash stripped).
$registeredSpecs = @{}
foreach ($c in $commandProps) {
  $name = $c.Name -replace '^/', ''
  $registeredSpecs[$name] = $true
}

# --- 1. Every command key has a matching spec .md ---
foreach ($c in $commandProps) {
  $name = $c.Name -replace '^/', ''
  $specPath = Join-Path $commandsDir ($name + '.md')
  if (-not (Test-Path $specPath)) {
    Add-Problem "Command '$($c.Name)' has no spec file: .ai/commands/$name.md"
  }
}

# --- 2. Every spec .md (except README.md) is registered ---
Get-ChildItem -Path $commandsDir -Filter '*.md' -File | ForEach-Object {
  if ($_.Name -eq 'README.md') { return }
  $base = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
  if (-not $registeredSpecs.ContainsKey($base)) {
    Add-Problem "Ghost spec '.ai/commands/$($_.Name)' is not registered in registry.json"
  }
}

# --- 3. Every workflow value resolves to a workflow, an agent, or an allowlisted handler ---
foreach ($c in $commandProps) {
  $wf = $c.Value.workflow
  if ([string]::IsNullOrWhiteSpace($wf)) {
    Add-Problem "Command '$($c.Name)' has no 'workflow' value"
    continue
  }
  $wfPath = Join-Path $workflowsDir ($wf + '.md')
  $agentPath = Join-Path $agentsDir ($wf + '.md')
  if (Test-Path $wfPath) {
    # Resolves to a real workflow file - OK, nothing to report.
  } elseif (Test-Path $agentPath) {
    Add-Warning "Command '$($c.Name)' workflow '$wf' resolves to agent .ai/agents/$wf.md (no workflow file)"
  } elseif ($specOnlyHandlers -contains $wf) {
    Add-Warning "Command '$($c.Name)' workflow '$wf' is a spec-only handler (allowlisted, no workflow file)"
  } else {
    Add-Problem "Command '$($c.Name)' workflow '$wf' resolves to nothing (no .ai/workflows/$wf.md, no .ai/agents/$wf.md, not allowlisted)"
  }
}

# --- Report ---
$specFiles = @(Get-ChildItem -Path $commandsDir -Filter '*.md' -File | Where-Object { $_.Name -ne 'README.md' })
Write-Host "Registry commands : $commandCount"
Write-Host "Command specs     : $($specFiles.Count)"
Write-Host ""

if ($warnings.Count -gt 0) {
  Write-Host "WARNINGS ($($warnings.Count)) - advisory, exit code unaffected:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  Write-Host ""
}

if ($problems.Count -eq 0) {
  Write-Host "OK - command registry is consistent." -ForegroundColor Green
  exit 0
} else {
  Write-Host "FOUND $($problems.Count) PROBLEM(S):" -ForegroundColor Red
  $problems | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}
