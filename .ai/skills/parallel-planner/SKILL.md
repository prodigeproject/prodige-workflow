---
name: parallel-planner
description: "Analyzes work and splits it into safe, independent parallel agent sessions to maximize throughput without conflicts."
---

# Parallel Planner

Design and orchestrate parallel agent work distribution for maximum efficiency and safety.

## Quick Protocol (your next action)
1. Break the task into atomic subtasks and map their dependencies.
2. Find the critical path and the work that can safely run in parallel.
3. Detect file-overlap conflicts; never parallelize tasks that write the same files.
4. Group subtasks into agent tracks and define merge order + verification points.
5. Keep a serial fallback. Don't parallelize when overhead exceeds the benefit.

## Purpose

Split complex work into safe parallel agent sessions by:
- Analyzing task dependencies and identifying parallelizable work
- Detecting resource conflicts between potential parallel tasks
- Designing optimal work distribution across agents
- Balancing load and minimizing idle time

## When to Use

This skill is automatically selected by the orchestrator when:
- A large task could benefit from parallel execution
- Multiple independent features need implementation
- Work can be split across frontend/backend/testing agents
- Optimizing development velocity for complex projects

## Process

### 1. Work Analysis
- Break down the overall task into atomic subtasks
- Identify dependencies between subtasks (what must happen first)
- Assess resource requirements for each subtask
- Estimate complexity and time for each subtask

### 2. Dependency Mapping
- Create dependency graph of all subtasks
- Identify critical path (longest chain of dependencies)
- Find parallelizable work (tasks with no dependencies)
- Detect potential bottlenecks

### 3. Conflict Detection
- Analyze which files each subtask will modify
- Check for overlapping file access
- Identify shared dependencies (types, utilities, configs)
- Flag high-risk parallel operations

### 4. Work Distribution
- Group subtasks into parallel-safe work packages
- Assign appropriate agent types (frontend, backend, qa, etc.)
- Sequence work to respect dependencies
- Balance load across available agents

### 5. Execution Plan
- Define clear handoff points between agents
- Specify integration and merge strategies
- Plan verification checkpoints
- Create fallback for serial execution if parallel fails

## Output Format

Provide a structured parallel execution plan:

**Work Breakdown:**
```
Critical Path: [Task A] → [Task D] → [Task F]
Estimated time: 45 minutes

Parallel Track 1 (Frontend Agent):
  - Task B: Implement user component [15 min]
  - Task C: Add form validation [10 min]
  Files: src/components/*, src/hooks/*

Parallel Track 2 (Backend Agent):
  - Task A: Create API endpoint [20 min]
  - Task E: Add database migration [10 min]
  Files: src/api/*, prisma/migrations/*

Parallel Track 3 (QA Agent):
  - Task G: Write integration tests [25 min]
  Files: tests/integration/*
  Depends on: Task A, Task B completion
```

**Dependency Graph:**
```
   A (API)
   ├─→ D (Integration)
   └─→ F (Deployment)
   
   B (UI) ──→ D
   C (Validation) ──→ D
   
   G (Tests) depends on [A, B]
```

**Conflict Analysis:**
```
✓ Track 1 & 2: No file overlap - safe
⚠ Track 3 waits for 1 & 2: Tests need completed features
✓ Shared types handled via: Initial type definition in Track 2, then locked
```

**Recommendations:**
- Start Track 1 & 2 immediately in parallel
- Track 3 begins after Track 1 & 2 reach checkpoint
- Merge order: Track 2 → Track 1 → Track 3
- Verification after each merge

## Rules

- **Maximize parallelism:** Find every safe opportunity for parallel work
- **Minimize conflicts:** Never create work that will cause merge conflicts
- **Balance load:** Don't overload one agent while others are idle
- **Respect dependencies:** Critical path tasks must complete in order
- **Plan for integration:** Define clear merge and verification strategy
- **Be realistic:** Consider actual agent capabilities and limitations
- **Have a fallback:** If parallel fails, how do we proceed serially?

## Key Principles

**Safe Parallelism:**
- Tasks are truly independent (no shared file writes)
- Dependencies are explicit and enforced
- Shared resources are accessed through coordination
- Integration points are well-defined

**Efficient Distribution:**
- Work is evenly balanced across agents
- Critical path is kept as short as possible
- No agent is blocked waiting for others unnecessarily
- Handoffs are minimized and clear

**Practical Execution:**
- Each agent has clear, complete instructions
- Success criteria are defined upfront
- Verification happens at integration points
- Rollback is possible if parallel work fails

## Integration Points

- Works with **lock-manager** to coordinate resource access (`.ai/runtime/locks/`)
- Works with **snapshot-manager** to provide stable starting points (`.ai/runtime/snapshots/`)
- Works with **orchestrator** to dispatch actual agent sessions (`.ai/runtime/sessions/`, per [`SESSION_TEMPLATE.json`](../../runtime/sessions/SESSION_TEMPLATE.json))
- Works with **git-guardian** for merge strategy and conflict resolution

All coordination state lives under `.ai/runtime/` (sessions, snapshots, locks,
handoffs, briefs, queue, worktrees) — never top-level `.ai/` equivalents.

## Anti-Patterns

- ❌ Parallelizing dependent tasks (creates race conditions)
- ❌ Ignoring shared file conflicts (causes merge hell)
- ❌ Creating too many small parallel tasks (overhead exceeds benefit)
- ❌ Not planning integration/merge strategy upfront
- ❌ Parallelizing when serial would be faster (small tasks)

## Decision Framework

**When to parallelize:**
- Multiple independent features or modules
- Clear separation of concerns (frontend/backend/tests)
- Substantial work that benefits from concurrency
- Well-defined interfaces between components

**When to stay serial:**
- Strong dependencies between tasks
- Significant file overlap
- Small tasks (overhead > benefit)
- Exploratory work where direction may change

## Example Scenarios

**Good Parallel Split:**
```
Feature: User authentication system
├─ Backend Agent: API endpoints + database
├─ Frontend Agent: Login UI + auth context
└─ QA Agent: E2E tests (waits for both)
```

**Bad Parallel Split:**
```
Feature: Refactor user service
├─ Agent 1: Refactor UserService class
└─ Agent 2: Refactor UserService class methods
❌ Same file, guaranteed conflict
```

**Optimized Parallel Split:**
```
Feature: Dashboard with multiple widgets
├─ Agent 1: Widget A (independent component)
├─ Agent 2: Widget B (independent component)
├─ Agent 3: Widget C (independent component)
└─ Agent 4: Dashboard layout (waits for widgets)
```
