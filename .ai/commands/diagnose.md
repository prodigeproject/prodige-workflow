# Command: /diagnose

## Purpose
Perform comprehensive health check of project environment with automatic fix recommendations. Inspired by RTK's parallel diagnostic system.

## Usage
```bash
/diagnose              # Run all checks
/diagnose --fix        # Interactive repair mode
/diagnose --category [name]  # Run specific check category
```

## Check Categories

### 1. Project Structure
Verify `.ai` folder completeness and organization.

**Checks:**
- [ ] `.ai/` folder exists
- [ ] `.ai/SOUL.md` exists
- [ ] `.ai/boot/BOOT.md` exists
- [ ] `.ai/orchestrator/ORCHESTRATOR.md` exists
- [ ] `.ai/context/` folder complete (PROJECT, PRD, ARCHITECTURE, IMPLEMENTATION)
- [ ] `.ai/context/manifest.json` valid
- [ ] `.ai/governance/` folder complete (rules, quality-gates, review-gates)
- [ ] `.ai/agents/` folder has all 11 agents (architect, backend, docs, frontend, git-guardian, magic-orchestrator, memory-manager, orchestrator, qa, reviewer, verification-runner)
- [ ] `.ai/commands/` folder has command registry

**Possible Issues:**
- Missing required files
- Invalid JSON in manifest
- Outdated folder structure

**Auto-Fix Options:**
- Scaffold missing files from templates
- Upgrade to latest folder structure
- Repair corrupted manifest.json

---

### 2. Context Integrity
Validate context files and approval status.

**Checks:**
- [ ] PROJECT.md has required sections (identity, vision, scope, users)
- [ ] PRD.md has features and acceptance criteria
- [ ] ARCHITECTURE.md has system design
- [ ] IMPLEMENTATION.md has technical plan
- [ ] manifest.json versions match file timestamps
- [ ] No `[TODO]` or `[UNKNOWN]` placeholders in approved docs
- [ ] DECISIONS.md records exist for major choices

**Possible Issues:**
- Unapproved changes in context
- Stale context (code changed, docs didn't)
- Missing required sections
- Unapproved drafts marked as approved

**Auto-Fix Options:**
- Run `/sync` to detect and fix drift
- Generate missing sections from code
- Reset approval status on changed files

---

### 3. Runtime State
Check active sessions, snapshots, locks, and cache status.

**Checks:**
- [ ] No zombie sessions (planned but never started)
- [ ] No stale locks (>24h old)
- [ ] Snapshot references valid
- [ ] Cache not corrupted
- [ ] No conflicting sessions on same files
- [ ] Handoff files exist for completed sessions

**Possible Issues:**
- Abandoned parallel sessions
- Deadlocked file access
- Corrupted cache entries
- Missing handoffs

**Auto-Fix Options:**
- Clean up zombie sessions
- Release stale locks
- Invalidate corrupted cache
- Generate missing handoffs from git history

---

### 4. Quality Gates
Verify pre-commit hooks and quality tooling setup.

**Checks:**
- [ ] Pre-commit hook installed (`.git/hooks/pre-commit`)
- [ ] Git hooks executable
- [ ] Format tool installed (prettier/black/rustfmt)
- [ ] Linter installed (eslint/ruff/clippy)
- [ ] Test runner installed (jest/pytest/cargo)
- [ ] Type checker installed (tsc/mypy) if applicable
- [ ] Hook configuration matches stack

**Possible Issues:**
- Hooks not executable
- Tools not in PATH
- Version mismatches
- Configuration files missing

**Auto-Fix Options:**
- Install pre-commit hook
- Install missing tools via package manager
- Generate configuration files
- Set file permissions (chmod +x)

---

### 5. Dependencies
Check project dependencies health.

**Checks:**
- [ ] Package manager lockfile exists (package-lock.json/poetry.lock/Cargo.lock)
- [ ] No dependency conflicts
- [ ] No security vulnerabilities (npm audit/pip-audit/cargo audit)
- [ ] No deprecated packages
- [ ] Dependencies match package.json/requirements.txt/Cargo.toml

**Possible Issues:**
- Outdated dependencies
- Known CVEs in dependencies
- Missing dependencies
- Version conflicts

**Auto-Fix Options:**
- Run `npm install` / `pip install -r requirements.txt` / `cargo build`
- Update vulnerable packages
- Resolve version conflicts
- Add missing dependencies

---

### 6. Debt Status
Analyze tracked technical debt.

**Checks:**
- [ ] Debt files exist (technical, architecture, documentation, knowledge)
- [ ] High-priority debt addressed
- [ ] Debt items have owners and due dates
- [ ] No debt items >90 days old without plan
- [ ] Debt trend (increasing/stable/decreasing)

**Possible Issues:**
- Growing debt backlog
- Untracked debt
- Abandoned debt items
- Missing mitigation plans

**Auto-Fix Options:**
- Scan code for TODO/FIXME/HACK comments → add to debt registry
- Generate debt mitigation plans
- Archive resolved debt items
- Assign owners to orphaned debt

---

### 7. Sync Status
Detect context drift between code and documentation.

**Checks:**
- [ ] README accurate (reflects current features)
- [ ] ARCHITECTURE.md matches code structure
- [ ] IMPLEMENTATION.md matches actual implementation
- [ ] API docs match endpoints
- [ ] Database schema docs match migrations

**Possible Issues:**
- Code evolved, docs didn't
- Deprecated features still documented
- New features undocumented
- Architecture decisions undocumented

**Auto-Fix Options:**
- Run `/sync` command
- Generate missing documentation from code
- Update outdated sections
- Remove deprecated content

---

## Output Format

### Success (All Green)
```
🔍 Running Diagnostics...

✅ Project Structure: OK
✅ Context Integrity: OK  
✅ Runtime State: OK
✅ Quality Gates: OK
✅ Dependencies: OK
✅ Debt Status: 3 items tracked (1 high, 2 medium)
✅ Sync Status: OK

🎉 All systems healthy!
```

### Issues Found
```
🔍 Running Diagnostics...

✅ Project Structure: OK
✅ Context Integrity: OK
⚠️  Runtime State: 1 stale lock found
   └─ auth.ts locked 26h ago by session backend-api
❌ Quality Gates: Pre-commit hook not installed
```
   └─ .git/hooks/pre-commit missing
❌ Dependencies: 2 vulnerabilities found (npm audit)
   └─ lodash@4.17.19 (High severity)
   └─ axios@0.21.0 (Moderate severity)
⚠️  Debt Status: 5 items (2 high priority overdue)
✅ Sync Status: OK

📋 Issues Summary:
- 2 critical (🚨)
- 2 warnings (⚠️)
- 5 passed (✅)

💡 Run `/diagnose --fix` for interactive repair options.
```

---

## Interactive Fix Mode

When running `/diagnose --fix`, present multi-select repair options:

```
🔧 Available Fixes:

Runtime State:
[ ] Release stale lock on auth.ts

Quality Gates:
[ ] Install pre-commit hook
[ ] Install eslint (npm i -D eslint)
[ ] Generate .eslintrc.json

Dependencies:
[ ] Update lodash to 4.17.21
[ ] Update axios to 0.21.4
[ ] Run npm audit fix

Debt:
[ ] Review 2 overdue high-priority items
[ ] Scan code for new TODO/FIXME comments

Select fixes to apply (Space to toggle, Enter to confirm):
```

**After Selection:**
```
Applying 4 selected fixes...

✅ Released lock on auth.ts
✅ Installed pre-commit hook
✅ Updated lodash to 4.17.21
✅ Updated axios to 0.21.4

Remaining issues: 2 (require manual action)
```

---

## Category-Specific Diagnostics

### `/diagnose --category structure`
Run only project structure checks.

### `/diagnose --category context`
Run only context integrity checks.

### `/diagnose --category gates`
Run only quality gate checks.

### `/diagnose --category deps`
Run only dependency checks.

### `/diagnose --category debt`
Run only debt analysis.

### `/diagnose --category sync`
Run only context sync checks.

---

## Stack-Specific Checks

### JavaScript/TypeScript
- `package.json` valid
- `node_modules/` exists
- `tsconfig.json` valid (if TypeScript)
- ESLint config exists
- Prettier config exists

### Python
- `requirements.txt` or `pyproject.toml` exists
- Virtual environment active
- `pytest.ini` or `pyproject.toml` [tool.pytest] exists
- Linter config (ruff.toml or .ruff.toml) exists

### Rust
- `Cargo.toml` valid
- `Cargo.lock` exists
- `rustfmt.toml` exists
- Clippy configured

### Go
- `go.mod` exists
- `go.sum` exists
- `.golangci.yml` exists

---

## Agent Behavior Rules

When executing `/diagnose`, agent MUST:
1. **Run checks in parallel** (for speed)
2. **Show progress indicators** (checking...)
3. **Prioritize issues** (critical > warning > info)
4. **Suggest fixes** (actionable, specific)
5. **Never auto-fix without permission** (unless `--fix` flag)
6. **Log diagnostic results** to `.ai/reports/diagnostics/`
7. **Update context if major issues found**

---

## Integration with Workflows

### Auto-Trigger Conditions
Run `/diagnose` automatically when:
- First time loading project in new window
- After `git pull` with conflicts
- After failed build/test
- When user reports "something broken"
- Weekly scheduled health check

### In `/init` Workflow
After scaffolding context, run diagnostics to verify setup.

### In `/build` Workflow
Before implementing, verify quality gates installed.

### In `/review` Workflow
Before merge, run diagnostics to ensure no hidden issues.

---

## Diagnostic Report Format

Save results to `.ai/reports/diagnostics/YYYY-MM-DD-HHmmss.md`:

```markdown
# Diagnostic Report
**Date:** 2026-06-17 14:32:15
**Duration:** 3.2s
**Status:** Issues Found

## Results
- Project Structure: ✅ PASS
- Context Integrity: ✅ PASS
- Runtime State: ⚠️ WARNING (1 stale lock)
- Quality Gates: ❌ FAIL (hook missing)
- Dependencies: ❌ FAIL (2 vulnerabilities)
- Debt Status: ⚠️ WARNING (2 overdue)
- Sync Status: ✅ PASS

## Critical Issues
1. Pre-commit hook not installed
   - Impact: Quality gates not enforced
   - Fix: Run `npm run prepare` or manually install hook
   - Priority: HIGH

2. Security vulnerabilities in dependencies
   - lodash@4.17.19 (High CVE-2020-8203)
   - axios@0.21.0 (Moderate CVE-2021-3749)
   - Fix: Run `npm audit fix`
   - Priority: HIGH

## Warnings
1. Stale lock on auth.ts (26h old)
   - Session: backend-api
   - Fix: Release lock manually or wait for timeout

2. High-priority debt overdue
   - 2 items past due date
   - Fix: Review and reschedule or resolve

## Recommendations
- Install pre-commit hook immediately
- Update vulnerable dependencies
- Review debt backlog
- Consider running `/sync` to refresh context

## Next Steps
1. Run `/diagnose --fix` for interactive repair
2. Address critical issues before next build
3. Schedule debt review meeting
```

---

## Success Metrics
- Diagnostics run time <5s (parallel checks)
- 90%+ issues auto-fixable
- Zero false positives
- Used weekly by 70% of developers

---

## Troubleshooting

### Issue: Diagnostic checks timeout
**Solution:** Run category-specific checks instead of full diagnostic.

### Issue: False positives on context integrity
**Solution:** Update manifest.json timestamps after legitimate edits.

### Issue: Auto-fix broke something
**Solution:** All fixes are git-tracked, run `git restore [file]` to revert.

---

## References
- RTK `/diagnose` command (inspiration)
- `.ai/governance/quality-gates.md`
- `.ai/governance/rules.md`
- `.ai/commands/sync.md`

---

## Version History
- v1.0: Initial implementation (inspired by RTK parallel diagnostics)
- Future: Add custom check plugins, CI/CD integration
