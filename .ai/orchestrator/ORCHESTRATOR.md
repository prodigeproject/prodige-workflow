# Orchestrator

> **File**: `.ai/orchestrator/ORCHESTRATOR.md`  
> **Purpose**: Command routing and workflow coordination  
> **Related**: [SOUL](../SOUL.md), [Runtime](../runtime/README.md), [Skills](../skills/), [Agents](../agents/)

---

## Overview

The orchestrator maps simple user commands to workflows, skills, agents, cache, and review gates.

**Key Principle**: Users should not manually invoke skills. The orchestrator handles all skill selection automatically based on command intent.

---

## Responsibilities

- Interpret command intent
- Select workflow
- Select skills
- Select agent roles
- Decide whether HITL is required
- Decide whether task can run in parallel
- Manage snapshots
- Manage cache
- Manage locks
- Require handoffs
- Enforce quality gates
- Trigger context sync

## Command Routing

The orchestrator recognizes the full command set defined in
`.ai/commands/registry.json`. Every command maps to a workflow and an HITL policy:

| Command | Category | Workflow | Purpose |
|---------|----------|----------|---------|
| `/magic` | primary | Magic Orchestrator | Main entry point; auto-routes to the right workflow |
| `/session-start` | memory | Session Start | Load Memory Bank and orient to the project |
| `/session-end` | memory | Session End | Save session context to the Memory Bank |
| `/memory-init` | memory | Memory Init | Scaffold the Memory Bank for a new project |
| `/undo` | safety | Git Undo | Revert the last AI change |
| `/checkpoint` | safety | Git Checkpoint | Create a named save point |
| `/rollback` | safety | Git Rollback | Restore to a previous checkpoint |
| `/verify` | quality | Verification | Run tests, lint, types, and build |
| `/test` | quality | Test | TDD RED-GREEN-REFACTOR cycle |
| `/roastme` | quality | RoastMe | Self-critique for overcomplication and scope creep |
| `/init` | workflow | Initialization | Set up project context and structure |
| `/design` | workflow | Design | Create PRD, architecture, implementation plan |
| `/build` | workflow | Build | Implement approved design |
| `/fix` | workflow | Bugfix | Diagnose and fix issues |
| `/review` | workflow | Code Review | Review code quality and standards |
| `/audit` | workflow | Audit | Security, dependency, and technical-debt analysis |
| `/refactor` | workflow | Refactor | Improve structure without changing behavior |
| `/docs` | workflow | Documentation | Generate or update documentation |
| `/release` | workflow | Release | Prepare and execute releases |
| `/sync` | system | Context Sync | Detect and fix context drift |
| `/status` | system | Status Check | Report current project state |
| `/cache` | system | Cache Management | Manage token-saving summaries |
| `/diagnose` | system | Diagnose Health | Project environment health check |
| `/parallel` | advanced | Multi-Agent Planning | Coordinate parallel work across agents |
| `/agent` | advanced | Worker Session | Single-worker, focused task session |

> **Boundaries:** HITL gates consult `.ai/boundaries/` — notably
> `human-approval-gates` and `no-production-deploys` — before any high-impact
> action proceeds.

---

## Automatic Skill Selection

The orchestrator automatically loads appropriate skills based on command context. This ensures consistency and reduces cognitive overhead.

### Example: `/build login`

**Auto-loaded skills:**
- `test-driven-development` - RED-GREEN-REFACTOR discipline (mandatory)
- `verification-before-completion` - Evidence before completion claims (mandatory)
- `repomap` - Navigate codebase structure
- `ripgrep` - Search existing code before writing new
- `reuse-rebuild` - Check for reusable components
- `clean-code` - Code quality standards
- `context-sync` - Keep context current

### Example: `/audit repo`

**Auto-loaded skills:**
- `repomap` - Map repository structure
- `ripgrep` - Search for patterns
- `roastme` - Critical analysis
- `security-review` - Security vulnerability detection
- `dependency-review` - Dependency audit
- `debt-detection` - Technical debt identification
- `context-sync` - Context synchronization

### Example: `/parallel build checkout`

**Auto-loaded skills:**
- `parallel-planner` - Plan parallel work
- `snapshot-manager` - Create stable snapshots
- `cache-manager` - Manage shared cache
- `lock-manager` - Prevent conflicts
- `handoff-manager` - Coordinate handoffs
- `repomap` - Repository navigation
- `clean-code` - Quality standards
- `verification-before-completion` - Evidence-based merge gate

---

## Integration

The orchestrator integrates with:
- **Runtime**: Uses [runtime system](../runtime/README.md) for sessions, locks, and handoffs
- **Cache**: Leverages [cached summaries](../runtime/cache/) to save tokens
- **Agents**: Coordinates [specialized agents](../agents/) for different roles
- **Skills**: Dynamically loads [skills](../skills/) based on task needs

---

## Quality Gates

Before completing workflows, the orchestrator enforces:
1. **Code quality checks**: Linting, formatting, standards compliance
2. **Test coverage**: Required tests pass
3. **Review requirements**: Human-in-the-loop (HITL) for critical changes
4. **Context sync**: Runtime state is up-to-date
5. **Handoff completion**: All worker notes are captured
