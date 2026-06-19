# Runtime System

> **File**: `.ai/runtime/README.md`  
> **Purpose**: Parallel AI agent coordination infrastructure  
> **Related**: [ORCHESTRATOR](../orchestrator/ORCHESTRATOR.md), [SOUL](../SOUL.md)

---

## Overview

The runtime system provides the infrastructure to support parallel AI agent work. It manages sessions, prevents conflicts, coordinates handoffs, and optimizes token usage through caching.

---

## Canonical Layout

All runtime state lives **under** `.ai/runtime/`. There is no top-level `.ai/cache/`
or `.ai/handoffs/` - those paths are deprecated. Consumers (skills, workflows, commands)
must reference the runtime paths below:

```
.ai/runtime/
├── cache/        # token-saving summaries (snapshot.json, dependencies.json,
│                 #   repo-map.md, repomap.json, architecture-summary.md,
│                 #   module-summaries/)
├── handoffs/     # worker-to-reviewer handoff documents
├── sessions/     # active agent session configs (SESSION_TEMPLATE.json schema)
├── snapshots/    # stable point-in-time context copies
├── locks/        # file-level locks to prevent conflicting edits
├── briefs/       # per-agent task briefs
├── queue/        # pending task queue
└── worktrees/    # isolated git worktrees, one per parallel agent
```

The five core coordination directories are `cache`, `handoffs`, `sessions`,
`snapshots`, and `locks`. Use `.ai/runtime/cache/...` (never `.ai/cache/...`) and
`.ai/runtime/handoffs/...` (never `.ai/handoffs/...`).

---

## Directory Structure

### `sessions/`
**Purpose**: Track active AI agent windows

Each file represents one active agent session with:
- Session ID
- Agent role
- Current task
- Start time
- Status

### `snapshots/`
**Purpose**: Stable context copies for consistency

Snapshots provide:
- Point-in-time codebase state
- Consistent context across parallel agents
- Rollback capability if needed

### `locks/`
**Purpose**: Prevent conflicting edits

Lock files ensure:
- Only one agent edits a file at a time
- Changes are serialized when needed
- Race conditions are prevented

### `handoffs/`
**Purpose**: Worker-to-reviewer communication

Handoff documents contain:
- Work completed
- Files changed
- Decisions made
- Risks identified
- Review requirements

See: [HANDOFF_TEMPLATE.md](./handoffs/HANDOFF_TEMPLATE.md)

### `queue/`
**Purpose**: Task queue for work distribution

Queue manages:
- Pending tasks
- Task priority
- Task dependencies
- Agent assignment

### `cache/`
**Purpose**: Token-saving summaries

Cache stores (canonical filenames consumers read):
- `snapshot.json` - last snapshot state and file hashes
- `dependencies.json` - dependency snapshot for change detection
- `repo-map.md` - repository structure (markdown view)
- `repomap.json` - repository structure (structured view)
- `architecture-summary.md` - system overview
- `module-summaries/` - per-module summaries

Cache contents are tracked in [CACHE_MANIFEST.json](./cache/CACHE_MANIFEST.json).

See: [architecture-summary.md](./cache/architecture-summary.md)

---

## Template Schemas

Each runtime template defines a canonical schema. Consumers (the skills) and the
template files must use these exact field/key names so they always agree.

### `sessions/SESSION_TEMPLATE.json`
Consumed by **dispatching-parallel-agents** and **snapshot-manager** (via `snapshot_id`).

| Field | Type | Notes |
|---|---|---|
| `session_id` | string | `session-<role>-<task>-<timestamp>` |
| `agent_role` | string | orchestrator/architect/backend/frontend/qa |
| `snapshot_id` | string | matches the snapshot-manager `snapshot_id` baseline |
| `task` | string | task description |
| `status` | string | pending/active/completed/failed |
| `priority` | string | low/normal/high |
| `created_at` | iso8601 \| null | |
| `timeout_at` | iso8601 \| null | |
| `worktree` | string | `.ai/runtime/worktrees/<agent>` |
| `assigned_files` | string[] | globs the agent owns |
| `locked_files` | string[] | files locked under `.ai/runtime/locks/` |
| `expected_tests` | string[] | tests the agent must make pass |
| `handoff_file` | string | `.ai/runtime/handoffs/<session>.md` |

### `cache/CACHE_MANIFEST.json`
Consumed by **cache-manager**. Shape: `{ cache_version:int, last_updated:iso8601|null,
entries:{ <key>:{ path:string, status:"fresh"|"stale"|"missing" } } }`. Canonical keys
and the files they track: `snapshot`→`snapshot.json`, `dependencies`→`dependencies.json`,
`repo_map`→`repo-map.md`, `repomap_json`→`repomap.json`,
`architecture_summary`→`architecture-summary.md`, `module_summaries`→`module-summaries/`.

### `cache/repomap.json`
Consumed by **repomap**. Keys: `schema_version`, `generated_at`, `project`
(`type`/`framework`/`language`/`database`/`deployment`), `entry_points`
(`path`/`purpose`), `modules` (`path`/`purpose`/`children`), `critical_files`
(`path`/`category`/`purpose`), `relationships` (`from`/`to`/`kind`),
`architecture_patterns` (string[]), `notes`.

### `handoffs/HANDOFF_TEMPLATE.md`
Consumed by **handoff-manager** (and reviewer/finishing flows). Sections map 1:1 to the
handoff-manager standard format: Handoff Metadata (session id, agent role, snapshot
reference), Session Summary, Current State, Context, Files Affected, Tests Run, Next
Steps, Blockers, Open Questions, Risks/Known Issues, Verification, and Handoff Quality.

---

## Workflow Integration

The runtime system is used by:
1. **Orchestrator**: Routes commands and manages workflows
2. **Agents**: Execute tasks with consistent context
3. **Skills**: Access cached knowledge
4. **Reviews**: Handoffs trigger review processes

---

## Usage

Runtime operations are managed automatically by the [orchestrator](../orchestrator/ORCHESTRATOR.md). Direct manipulation is not recommended.

**Common commands**:
- `/sync` - Update runtime context
- `/cache update` - Refresh cache
- `/status` - Check runtime state
- `/parallel` - Coordinate parallel work
