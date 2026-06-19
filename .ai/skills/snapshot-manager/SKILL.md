---
name: snapshot-manager
description: "Creates and manages stable context snapshots for parallel agent work, ensuring consistent starting points and preventing race conditions."
---

# Snapshot Manager

Create stable, consistent snapshots of project state to enable safe parallel agent execution.

## Quick Protocol (your next action)
1. Define snapshot scope (full repo / partial / dependency) and capture state + git ref.
2. Generate a unique snapshot ID with metadata (timestamp, purpose, expiration).
3. Assign the same snapshot to all parallel agents so they share one baseline.
4. Update snapshots only at integration/merge points, then notify dependent agents.
5. Clean up snapshots once agents complete. Never let agents work off a moving target.

## Canonical Storage

Snapshot state and metadata live **only** under `.ai/runtime/snapshots/` (never a
top-level `.ai/snapshots/`). Each snapshot is identified by a `snapshot_id` of the
form `snapshot-<timestamp>` (e.g. `snapshot-20240115-143022`). That same
`snapshot_id` is the field session configs carry in
[`SESSION_TEMPLATE.json`](../../runtime/sessions/SESSION_TEMPLATE.json) — the
`snapshot_id` written here MUST match the `snapshot_id` each dispatched session
references, so agents and the snapshot registry always agree on the baseline.

## Purpose

Provide stable context for parallel work by:
- Creating point-in-time snapshots of codebase state
- Ensuring all parallel agents work from same baseline
- Preventing race conditions from shifting context
- Managing snapshot lifecycle (creation, usage, cleanup)
- Coordinating snapshot updates as work progresses

## When to Use

This skill is automatically selected by the orchestrator when:
- Starting parallel agent sessions
- Need consistent view across multiple agents
- Coordinating work that spans multiple sessions
- Creating stable reference points for complex work
- Managing context for long-running parallel operations

## Process

### 1. Snapshot Creation
Create stable reference point:
- Identify scope of snapshot (full repo, specific modules)
- Capture current state (files, git ref, dependencies)
- Record metadata (timestamp, agent context, purpose)
- Generate unique snapshot identifier
- Store snapshot reference for agent use

### 2. Snapshot Distribution
Provide snapshots to agents:
- Assign snapshot to each parallel agent
- Ensure agents see consistent starting state
- Provide snapshot metadata and context
- Track which agents use which snapshots

### 3. Snapshot Coordination
Manage snapshot updates:
- Determine when snapshot needs updating
- Coordinate merge of agent work back to main
- Create new snapshot after integration
- Notify dependent agents of snapshot changes

### 4. Snapshot Cleanup
Manage snapshot lifecycle:
- Track snapshot usage by agents
- Clean up unused snapshots
- Maintain active snapshot registry
- Archive historical snapshots if needed

## Snapshot Types

### Full Repository Snapshot
Complete codebase state at specific point in time:
- Git commit SHA
- All source files
- Dependencies and lock files
- Configuration files
- Build artifacts if relevant

**Use when:**
- Major parallel work across many modules
- Need complete isolation between agents
- Work spans days/weeks

### Partial Snapshot
Focused subset of codebase:
- Specific modules or directories
- Relevant type definitions
- Key configuration files
- Related test files

**Use when:**
- Work is modular and isolated
- Quick parallel tasks
- Clear boundaries between agent scopes

### Dependency Snapshot
Package and dependency state:
- package.json / package-lock.json
- node_modules state
- Global type definitions
- External API schemas

**Use when:**
- Dependency changes expected
- Need consistent external interfaces
- Multiple agents depend on same libraries

## Output Format

**Snapshot Created:**
```
📸 Snapshot: parallel-work-2024-01-15-a3f9c2

Type: Full repository
Git Ref: main@a3f9c2e
Created: 2024-01-15 10:30:00
Purpose: Parallel feature development

Contents:
  ✓ Source code: src/ (234 files)
  ✓ Tests: tests/ (89 files)
  ✓ Types: src/types/ (12 files)
  ✓ Config: package.json, tsconfig.json, etc.
  ✓ Dependencies: node_modules (locked)

Metadata:
  - Session ID: session-123
  - Orchestrator context: feature-user-dashboard
  - Expiration: 24 hours
```

**Snapshot Assignment:**
```
📋 Agent Snapshot Assignments:

Agent 1 (Frontend):
  Snapshot: parallel-work-2024-01-15-a3f9c2
  Scope: src/components/*, src/hooks/*
  Lock acquired: ✓

Agent 2 (Backend):
  Snapshot: parallel-work-2024-01-15-a3f9c2
  Scope: src/api/*, prisma/*
  Lock acquired: ✓

Agent 3 (Tests):
  Snapshot: parallel-work-2024-01-15-a3f9c2
  Scope: tests/*
  Lock acquired: ✓
  Dependencies: [Agent 1, Agent 2] must complete first
```

**Snapshot Status:**
```
🔍 Active Snapshots:

parallel-work-2024-01-15-a3f9c2
  ├─ Used by: 3 agents
  ├─ Status: Active
  ├─ Age: 2 hours
  └─ Cleanup: On agent completion

feature-auth-2024-01-14-b7e4a1
  ├─ Used by: 1 agent
  ├─ Status: Stale (>24h)
  ├─ Age: 28 hours
  └─ Cleanup: Scheduled
```

**Snapshot Update:**
```
🔄 Snapshot Update Required

Reason: Agent 2 (Backend) completed work and merged
Old snapshot: parallel-work-2024-01-15-a3f9c2 (main@a3f9c2e)
New snapshot: parallel-work-2024-01-15-d8f3b5 (main@d8f3b5a)

Changes:
  + src/api/users/route.ts (new API endpoint)
  + prisma/schema.prisma (user model updated)
  + prisma/migrations/20240115_add_user_fields/

Affected agents:
  → Agent 3 (Tests): Update to new snapshot before testing
  
Action: Agent 3 will pull latest changes and rebase on new snapshot
```

## Rules

- **Consistency first:** All agents in a session use same snapshot initially
- **Update strategically:** Only update snapshots at integration points
- **Clean up proactively:** Remove unused snapshots to save resources
- **Track dependencies:** Know which agents depend on which snapshots
- **Coordinate updates:** When snapshot updates, notify affected agents
- **Be explicit:** Make snapshot boundaries and scope clear

## Key Principles

**Stable Baseline:**
- Parallel agents need consistent starting point
- Prevents "the code changed under me" problems
- Enables reproducible work

**Isolation:**
- Each agent works in isolation from others
- Changes don't affect other agents until integrated
- Reduces coordination overhead

**Coordination:**
- Define clear integration points
- Update snapshots at merge boundaries
- Notify agents when context changes

**Lifecycle Management:**
- Create snapshots when needed
- Clean up when no longer used
- Don't accumulate stale snapshots

## Integration Points

- Works with **parallel-planner** to design work distribution
- Works with **lock-manager** to coordinate resource access
- Works with **orchestrator** to manage agent sessions
- Works with **git-guardian** for merge and integration

## Implementation Approaches

### Git-Based Snapshots
Use git references as snapshots:
```bash
# Create snapshot branch
git branch snapshot/parallel-work-a3f9c2 main

# Agents work from snapshot
git checkout snapshot/parallel-work-a3f9c2

# Cleanup after integration
git branch -d snapshot/parallel-work-a3f9c2
```

**Pros:** Simple, uses existing tooling, efficient
**Cons:** Requires git discipline, branch management overhead

### Context Capture
Capture relevant context without full checkout:
```json
{
  "snapshot_id": "parallel-work-a3f9c2",
  "git_ref": "main@a3f9c2e",
  "files": {
    "src/api/users.ts": "hash-abc123",
    "src/types/user.ts": "hash-def456"
  },
  "dependencies": {
    "package.json": "hash-ghi789",
    "node_modules_hash": "hash-jkl012"
  }
}
```

**Pros:** Lightweight, fast, selective
**Cons:** Custom implementation, needs tracking system

### Work Tree Approach
Use git worktrees for isolation:
```bash
# Create separate working directory
git worktree add ../parallel-agent-1 main

# Agent works in isolated directory
cd ../parallel-agent-1

# Cleanup
git worktree remove ../parallel-agent-1
```

**Pros:** Complete isolation, no branch pollution
**Cons:** Disk space usage, complexity

## Common Scenarios

### Scenario 1: Clean Parallel Split
```
State: Fresh work, no dependencies
Action: Create snapshot, assign to all agents
Result: All agents work from same baseline
Update: Merge agents sequentially, update snapshot after each
```

### Scenario 2: Dependent Work
```
State: Agent 2 depends on Agent 1 output
Action: Create initial snapshot for Agent 1
Result: Agent 1 completes, merges, creates new snapshot
Update: Agent 2 starts from new snapshot including Agent 1 changes
```

### Scenario 3: Long-Running Work
```
State: Parallel work takes multiple days, main branch evolving
Action: Create initial snapshot, agents work isolated
Decision point: Do agents need main branch updates?
  - Yes: Periodically update snapshot, agents rebase
  - No: Stay isolated, deal with conflicts at final merge
```

## Snapshot Metadata

Track essential information:
```json
{
  "snapshot_id": "parallel-work-2024-01-15-a3f9c2",
  "created_at": "2024-01-15T10:30:00Z",
  "created_by": "orchestrator-session-123",
  "git_ref": "main@a3f9c2e",
  "purpose": "Feature: User Dashboard",
  "scope": "full-repository",
  "agents": [
    {
      "agent_role": "frontend",
      "scope": "src/components/*, src/hooks/*",
      "status": "active"
    },
    {
      "agent_role": "backend",
      "scope": "src/api/*, prisma/*",
      "status": "completed"
    }
  ],
  "expiration": "2024-01-16T10:30:00Z",
  "cleanup_policy": "on-agent-completion"
}
```

## Anti-Patterns

- ❌ **No snapshot:** Agents work from moving target (main branch)
- ❌ **Stale snapshots:** Agents work from outdated baseline
- ❌ **Unclear scope:** Agents don't know what's stable vs changing
- ❌ **No cleanup:** Accumulating snapshots waste resources
- ❌ **Over-updating:** Constantly updating snapshot disrupts work
- ❌ **No coordination:** Agents don't know when snapshot changes

## Success Criteria

**Effective snapshots provide:**
- ✅ Consistent baseline for all parallel agents
- ✅ Clear scope of what's included
- ✅ Stable context throughout parallel work
- ✅ Coordinated updates at integration points
- ✅ Clean lifecycle (create → use → cleanup)

## Example Workflow

**Phase 1: Create Snapshot**
```
Orchestrator: Starting parallel work on user dashboard
→ snapshot-manager: Create snapshot of current main branch
← Snapshot created: parallel-work-a3f9c2 (main@a3f9c2e)
```

**Phase 2: Assign Snapshot**
```
→ Agent 1 (Frontend): Use snapshot parallel-work-a3f9c2
→ Agent 2 (Backend): Use snapshot parallel-work-a3f9c2
→ Agent 3 (Tests): Use snapshot parallel-work-a3f9c2
```

**Phase 3: Agent Completes**
```
Agent 2 (Backend): Work complete, ready to merge
→ Merge Agent 2 changes to main
→ snapshot-manager: Create new snapshot parallel-work-d8f3b5
← Snapshot created: parallel-work-d8f3b5 (main@d8f3b5a)
```

**Phase 4: Update Dependent Agents**
```
→ Agent 3 (Tests): Update to snapshot parallel-work-d8f3b5
   (includes Agent 2 backend changes for testing)
```

**Phase 5: Cleanup**
```
All agents complete
→ snapshot-manager: Clean up snapshots
← Removed: parallel-work-a3f9c2, parallel-work-d8f3b5
```
