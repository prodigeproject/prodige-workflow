# Changelog

All notable changes to Prodige Workflow will be documented in this file.

---

## [2026-06-17] - Current

### Memory Bank System
- `.ai/memory/` with 6 persistent context files: `projectContext.md`, `activeContext.md`, `progress.md`, `decisionLog.md`, `conventions.md`, `sessionHistory.md`
- `memory-manager.md` agent manages all memory operations
- `/session-start` and `/session-end` commands for context persistence across sessions

### Magic Command
- `magic-orchestrator.md` agent — intent parsing, plan generation, workflow routing, quality integration
- `/magic <task>` — single entry point that auto-routes to appropriate workflows with mandatory planning and HITL gate

### Verification System
- `verification-runner.md` agent — detects project type, runs tests/lint/types/build, auto-fix up to 3 iterations
- `/verify` command, integrated into all major workflows
- Supports: Node.js, Python, PHP, Go, Rust, Java, Ruby, .NET

### Safety Features
- `git-guardian.md` agent — patch-based undo, named checkpoints, rollback
- Commands: `/undo`, `/checkpoint [name]`, `/rollback [name]`
- Auto-checkpoints before risky operations

### Skills System
- 37 skills across all categories, unified registry (`manifest.json` + `skill-selection-matrix.json`)
- 2 global skills always loaded: `clean-code`, `efficient-communication`
- Skill lint: `lint-skills.ps1/.sh` — validates folder/manifest/global consistency

### Agent System
- 9 role agents with frontmatter: `architect`, `backend`, `frontend`, `qa`, `reviewer`, `docs`, `orchestrator`, `magic-orchestrator`, `memory-manager`, `verification-runner`, `git-guardian`
- Universal entry: `AGENTS.md` — works in any AI tool without per-tool folders
- Install script generates thin pointers: `install.ps1` / `install.sh`

### Command Registry
- 25 registered commands in `.ai/context/registry.json`
- Commands grouped by category: primary, memory, safety, quality, workflow, system, advanced
- Lint: `lint-commands.ps1/.sh`

### Governance
- Quality gates, review gates, HITL gates
- Debt tracking, risk register, dependency review
- ADRs in `.ai/context/docs/adr/`

### Infrastructure Linters (5 total, all exit 0)
- `lint-skills.ps1/.sh` — skills registry
- `lint-commands.ps1/.sh` — command registry
- `lint-memory.ps1/.sh` — memory anchor/index protocol
- `lint-runtime.ps1/.sh` — canonical path enforcement
- `lint-context.ps1/.sh` — context and state files

---

## Planned

- Token-saving skill (replacement for external RTK token-killer tool, currently referenced in `design.md` Step 6)
- Mode system (architect/code/debug/review)
- Enhanced checkpoint comparison

---

## Influences

Prodige is built in-house. Its design draws lessons from prior art across the
AI-workflow space — beginner-friendly UX, enterprise governance, code-quality
discipline — but the architecture, structure, and skills are our own work.

---

## Support

- Guide: [PRODIGE.md](./PRODIGE.md)
- Quick Start: [QUICK_START.md](./QUICK_START.md)
- Architecture: [Ref/AUDIT_REPORT.md](./Ref/AUDIT_REPORT.md)
