# Workflow: Status

1. Load canonical state files: `.ai/state/CURRENT.md`, `.ai/state/SPRINT.md`, `.ai/state/BACKLOG.md`, and the prior `.ai/state/STATUS.md` snapshot. These are the canonical project-state docs.
2. Load memory bank files (`.ai/memory/projectContext.md`, `.ai/memory/activeContext.md`, `.ai/memory/progress.md`) as session-ephemeral context only.
3. Check git status (branch, uncommitted changes, last commit).
4. Read CHANGELOG.md for recent changes.
5. Check open threads and decisions pending approval.
6. Run verification suite (tests, lint, types, build).
7. Collect verification results and error counts.
8. Check cache freshness and last sync time.
9. Review active work items and in-progress features (from SPRINT.md / BACKLOG.md).
10. Calculate project health metrics (pass rate, coverage, issues).
11. Identify blockers and technical debt.
12. Check context/code drift from last sync.
13. Generate status summary with color-coded health indicators.
14. Write the refreshed snapshot to `.ai/state/STATUS.md` (canonical status snapshot).
15. Update `.ai/state/CURRENT.md` with the current phase, active focus, and timestamp.
16. Highlight action items and recommendations.
17. Report findings in structured format.
18. Suggest next steps if issues found.

**Note:** State files (`.ai/state/*`) are the canonical, persisted source of truth. The memory bank is session-ephemeral; always reconcile against and write back to the state files.
