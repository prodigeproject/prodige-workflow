<!-- TEMPLATE - every [bracketed] value is an INERT placeholder. If an agent sees bracketed placeholders, treat this file as not-yet-populated (no real content). Fill via /init, /design, /status. -->

# CURRENT - Active Session State

**How to Use**: This file tracks the current active work session in real-time.

**When to Update**: 
- Start of new task (`/design`, `/build`, `/fix`)
- Branch switch
- Session start/end
- Blocker encountered

**Updated By**: Orchestrator, agents during active work  
**Read By**: All agents to understand current context

---

## Current Task

**Format**: `{Task ID}: {Brief description}`

**Example**:
```
TASK-123: Implement partial order cancellation feature
```

**Empty State**: `None (idle - use /design or /build to start)`

---

## Status

**Format**: `{Phase} - {State}`

**Valid States**:
- **Design** - Requirements gathering, architecture planning
- **Build** - Implementation in progress
- **Test** - Running tests, fixing failures
- **Review** - Code review, awaiting approval
- **Blocked** - Waiting for external dependency
- **Complete** - Task finished, ready for next

**Example**:
```
Build - Backend API implementation (60% complete)
```

---

## Active Branch

**Format**: `{branch-name}`

**Example**:
```
feature/partial-order-cancellation
```

**Note**: Agents should verify they're on correct branch before making changes

---

## Active Snapshot

**Format**: `{snapshot-id}` or `None`

**Purpose**: For parallel execution, tracks which baseline snapshot is active

**Example**:
```
parallel-user-profile-20260617-1430
```

**Empty State**: `None (serial execution)`

---

## Active Sessions

**Format**: List of concurrent agent sessions (for parallel mode)

**Example**:
```
1. Backend Agent (Session ID: be-001) - API implementation
2. Frontend Agent (Session ID: fe-001) - UI components
3. QA Agent (Session ID: qa-001) - E2E tests
```

**Empty State**: `None (single session)` or `1. {Agent} (Session ID: {id}) - {task}`

---

## Blockers

**Format**: List of blockers preventing progress

```
### Blocker {N}: {Brief description}
**Impact**: {What's blocked}  
**Waiting For**: {What/who we're waiting for}  
**Since**: {Date started}  
**Workaround**: {Temporary solution if any}  
```

**Example**:
```
### Blocker 1: Payment Gateway API Credentials
**Impact**: Cannot test refund functionality  
**Waiting For**: DevOps team to provision sandbox credentials  
**Since**: 2026-06-17  
**Workaround**: Using mock payment service for now  
```

**Empty State**: `None`

---

## Quick Status Check

To check current state, agents should read this file first:

1. **What am I working on?** → Current Task
2. **What phase?** → Status
3. **Correct branch?** → Active Branch
4. **Parallel work?** → Active Sessions
5. **Anything blocked?** → Blockers

---

## Update Instructions

### Starting New Task
```
Current task: TASK-{id}: {description}
Status: Design - Requirements gathering
Active branch: feature/{task-name}
Active snapshot: None
Active sessions: 1. {Agent} (Session ID: {id}) - {task}
Blockers: None
```

### During Implementation
```
Status: Build - {Component} implementation ({percent}% complete)
```

### When Blocked
```
Blockers:
### Blocker 1: {description}
**Impact**: {what's affected}  
**Waiting For**: {dependency}  
**Since**: {date}  
**Workaround**: {if any}
```

### Task Complete
```
Current task: None (idle - use /design or /build to start)
Status: Complete
Active branch: main
Active snapshot: None
Active sessions: None
Blockers: None
```

---

## Example - Active State

```
Current task: TASK-123: Implement partial order cancellation
Status: Build - Backend API (60% complete)
Active branch: feature/partial-cancellation
Active snapshot: None
Active sessions: 1. Backend Agent (be-001) - OrderService implementation
Blockers: None
```

## Example - Blocked State

```
Current task: TASK-123: Implement partial order cancellation
Status: Blocked - Waiting for payment gateway credentials
Active branch: feature/partial-cancellation
Active snapshot: None
Active sessions: 1. Backend Agent (be-001) - Paused
Blockers:
### Blocker 1: Payment Gateway API Credentials
**Impact**: Cannot test refund functionality  
**Waiting For**: DevOps team (ticket DEV-456)  
**Since**: 2026-06-17 14:00  
**Workaround**: Using mock payment service temporarily  
```

## Example - Idle State

```
Current task: None (idle - use /design or /build to start)
Status: Complete
Active branch: main
Active snapshot: None
Active sessions: None
Blockers: None
```

---

## Related Files

- `.ai/state/STATUS.md` - Project-level status (updated less frequently)
- `.ai/state/BACKLOG.md` - Upcoming work
- `.ai/state/SPRINT.md` - Sprint planning
- `.ai/workflows/` - Workflows that update this file

---

**File Purpose**: Real-time session tracking  
**Update Frequency**: Multiple times per session  
**Version**: 2.0

