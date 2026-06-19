---
name: lock-manager
description: "Prevents parallel agents from editing conflicting resources through intelligent lock coordination and conflict detection."
---

# Lock Manager

Coordinate resource access across parallel agent sessions to prevent edit conflicts, data races, and merge collisions.

## Quick Protocol (your next action)
1. Identify the resources/files the task needs and check the lock registry.
2. Detect conflicts via dependency/import analysis before acquiring (flag risk level).
3. Acquire file-level locks (not directories); record agent ID + timestamp.
4. If a resource is contested, suggest work reordering rather than just blocking.
5. Release locks as soon as work completes. Watch for deadlocks and stale locks.

## Purpose

Prevent parallel agents from editing conflicting resources by:
- Tracking which files/resources are being modified by which agent
- Detecting potential conflicts before they occur
- Coordinating lock acquisition and release
- Resolving lock contention gracefully

## When to Use

This skill is automatically selected by the orchestrator when:
- Multiple agents are working in parallel
- Dispatching new parallel work that might touch shared resources
- An agent requests access to a potentially locked resource
- Detecting or resolving merge conflicts

## Process

### 1. Lock Acquisition
- Identify resources needed for current task
- Check existing locks held by other agents
- Request locks for required resources
- Wait or negotiate if resources are already locked

### 2. Conflict Detection
- Analyze file dependencies and import graphs
- Identify overlapping edit scopes between agents
- Detect potential race conditions
- Flag risky parallel operations

### 3. Lock Management
- Maintain lock registry with agent ID, resource, and timestamp
- Implement lock timeout mechanisms
- Handle lock release on agent completion/failure
- Support lock escalation for urgent work

### 4. Conflict Resolution
- Provide recommendations when conflicts are detected
- Suggest alternative work ordering
- Propose resource splitting strategies
- Coordinate merge conflict resolution

## Output Format

Provide structured findings with:

**Lock Status:**
- Currently locked resources and by which agents
- Available resources for new work
- Pending lock requests

**Conflict Analysis:**
- Detected conflicts (actual or potential)
- Risk level (low/medium/high/critical)
- Affected files and line ranges if relevant

**Recommendations:**
- Whether to proceed, wait, or reorganize work
- Alternative task ordering to avoid conflicts
- Lock acquisition strategy

**Example:**
```
Lock Status:
  ✓ src/api/users.ts - locked by agent-2 (backend)
  ✓ src/components/UserList.tsx - locked by agent-3 (frontend)
  ○ src/types/user.ts - available

Conflict Analysis:
  ⚠ Medium risk: Both agents may need to modify src/types/user.ts
  ○ Low risk: No direct file overlap detected

Recommendation:
  → Wait for agent-2 to complete user API changes
  → Then acquire lock on src/types/user.ts
  → Estimated wait: 5-10 minutes based on task scope
```

## Rules

- **Be proactive:** Detect conflicts before they occur, not after
- **Be granular:** Lock at file level, not directory level when possible
- **Be fair:** Don't let one agent monopolize resources
- **Be timely:** Release locks as soon as work completes
- **Be evidence-based:** Base conflict detection on actual code analysis
- **Prefer coordination over blocking:** Suggest work reordering rather than just saying "no"

## Integration Points

- Works with **parallel-planner** to design conflict-free work distribution
- Works with **snapshot-manager** to provide stable views of locked resources
- Works with **git-guardian** to detect and resolve merge conflicts
- Reports to **orchestrator** for work scheduling decisions

## Anti-Patterns

- ❌ Locking entire directories when only one file is needed
- ❌ Holding locks longer than necessary
- ❌ Not detecting transitive dependencies (A imports B, B imports C)
- ❌ Allowing deadlocks (agent-1 waits for agent-2, agent-2 waits for agent-1)

## Edge Cases

- **Stale locks:** Agents that crash without releasing locks
- **Lock timeout:** How long to wait before forcing lock release
- **Read vs write locks:** Multiple readers OK, exclusive writers
- **Lock escalation:** Upgrading from read to write lock
