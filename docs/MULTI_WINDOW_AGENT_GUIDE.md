# Multi-Window Agent Guide

## Overview

This guide explains how to use **multiple AI coding windows in parallel** to speed up development while avoiding chaos.

**Key Idea**: One AI window is good for focus. Multiple AI windows are good for speed. But parallel AI work needs coordination to prevent conflicts.

---

## Why Use Multiple Windows?

### Benefits
- ✅ **5x faster**: Multiple agents work simultaneously
- ✅ **Specialization**: Each agent focuses on their domain (backend, frontend, QA)
- ✅ **Parallel PRs**: Ship features in smaller, reviewable chunks
- ✅ **Reduced context switching**: Each window maintains focused context

### Challenges Without Coordination
- ❌ Conflicting file edits
- ❌ Inconsistent architecture decisions
- ❌ Duplicate work
- ❌ Breaking changes without notice
- ❌ Merge conflicts

### How This Workflow Solves It
- **Sessions**: Each window has clear scope
- **Snapshots**: Shared starting point for all windows
- **Locks**: Prevent overlapping file edits
- **Handoffs**: Structured completion reports
- **Cache**: Shared project understanding
- **Review gates**: Central approval before merge

---

## Quick Start (Non-Technical Users)

Use only this command in your main AI window:

```bash
/parallel build dashboard
```

The AI will output something like:

```text
✅ Snapshot created: context-v12
✅ Sessions created: 4

Open 4 new AI windows and paste these prompts:

┌─────────────────────────────────────────┐
│ Window A: Backend Agent                 │
│ /agent backend resume dashboard-backend │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Window B: Frontend Agent                │
│ /agent frontend resume dashboard-frontend│
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Window C: QA Agent                      │
│ /agent qa resume dashboard-qa           │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ Window D: Review Agent                  │
│ /agent reviewer resume dashboard-review │
└─────────────────────────────────────────┘

When all windows are done, return here and run:
/parallel merge dashboard
```

**That's it!** Copy each prompt into a new AI chat window, let them work, then merge.

---

## Multi-Window Workflow (Step-by-Step)

### Step 1: Create Plan (Main Window)

In your primary AI window:

```bash
/parallel build checkout-feature
```

AI creates:
- **Snapshot**: Frozen project context (`.ai/runtime/snapshots/context-v12/`)
- **Session files**: Task definitions for each agent (`.ai/runtime/sessions/`)
- **Handoff templates**: Where agents report completion

### Step 2: Open Worker Windows

Open new AI chat windows (one per agent) and paste the generated prompts:

| Window | Role | Prompt |
|--------|------|--------|
| 1 | Backend | `/agent backend resume checkout-backend` |
| 2 | Frontend | `/agent frontend resume checkout-frontend` |
| 3 | QA | `/agent qa resume checkout-qa` |
| 4 | Docs | `/agent docs resume checkout-docs` |
| 5 | Review | `/agent reviewer resume checkout-review` |

### Step 3: Agents Work in Parallel

Each agent:
1. Reads their session file (scope, files, constraints)
2. Loads the shared snapshot
3. Completes their assigned work
4. Writes a handoff report

### Step 4: Review Handoffs

The **Reviewer agent** (Window 5):
1. Reads all handoff reports
2. Checks for conflicts
3. Validates consistency
4. Flags issues for human review

### Step 5: Merge (Main Window)

Back in your main window:

```bash
/parallel merge checkout-feature
```

AI:
1. Inspects all handoffs
2. Identifies overlapping changes
3. Resolves conflicts (or asks for help)
4. Updates context files
5. Creates merge summary

---

## The 5 Critical Rules

### Rule 1: Same Snapshot

**All windows must use the same snapshot.**

✅ Good:
```text
All agents: snapshot context-v12
```

❌ Bad:
```text
Backend: context-v12
Frontend: context-v13  ← Out of sync!
```

**Why**: Prevents agents from working on incompatible codebases.

---

### Rule 2: No Silent Architecture Changes

**Worker agents cannot change architecture without approval.**

✅ Good:
```text
Backend agent: "Need to add Redis cache. Requesting approval in handoff."
```

❌ Bad:
```text
Backend agent: [Replaces PostgreSQL with MongoDB without asking]
```

**Why**: Architecture changes affect all agents. Must be coordinated.

---

### Rule 3: No Overlapping Files Without Lock

**If two agents need to edit the same file, one must wait.**

✅ Good:
```text
Backend agent: Acquired lock on auth.ts
Frontend agent: Waiting for auth.ts lock to release
```

❌ Bad:
```text
Backend and Frontend both edit auth.ts simultaneously → merge conflict
```

**How**: Use lock files in `.ai/runtime/locks/auth.ts.lock`

---

### Rule 4: Every Worker Writes Handoff

**Each agent must complete a handoff report.**

Required sections:
```markdown
## Completed
- List of finished tasks

## Changed Files
- File paths with descriptions

## Blockers
- Issues encountered

## Architecture Decisions
- Any design choices made

## Needs Review
- Items requiring human attention

## Next Steps
- Recommended follow-up work
```

**Why**: Enables coordination and audit trail.

---

### Rule 5: Reviewer Validates Before Merge

**Don't blindly merge all agent output.**

Reviewer checks:
- ✅ No conflicting changes
- ✅ Consistent naming/patterns
- ✅ Tests pass
- ✅ No security regressions
- ✅ Architecture is coherent

**Why**: Catches issues before they hit the main codebase.

---

## Example: Building Checkout (5 Windows)

### Main Window

```bash
/parallel build checkout
```

AI generates:

```text
📸 Snapshot: context-v15
📁 Created sessions:
  - checkout-backend.json
  - checkout-frontend.json
  - checkout-qa.json
  - checkout-docs.json
  - checkout-review.json

🪟 Open 5 windows with these prompts:
```

### Window 1: Backend Agent

```bash
/agent backend resume checkout-backend
```

**Session file** (`.ai/runtime/sessions/checkout-backend.json`):
```json
{
  "agent": "backend",
  "feature": "checkout",
  "snapshot": "context-v15",
  "scope": {
    "create": ["backend/api/checkout.ts", "backend/models/Order.ts"],
    "modify": ["backend/api/payment.ts"],
    "tests": ["backend/tests/checkout.test.ts"]
  },
  "constraints": {
    "no_architecture_changes": true,
    "require_tests": true,
    "lock_files": ["backend/api/payment.ts"]
  }
}
```

**Handoff output** (`.ai/runtime/handoffs/checkout-backend.md`):
```markdown
## Completed
- Created checkout API endpoint
- Added Order model
- Integrated with payment service

## Changed Files
- backend/api/checkout.ts (new) - Main checkout logic
- backend/models/Order.ts (new) - Order data model
- backend/api/payment.ts (modified) - Added checkout callback

## Tests
- 15 unit tests pass
- 3 integration tests pass

## Blockers
- None

## Architecture Decisions
- Used existing payment service (no new dependencies)
- Orders stored in PostgreSQL (consistent with other entities)

## Needs Review
- Payment callback error handling (line 45-60 in payment.ts)

## Next Steps
- Frontend integration needed
- Add order confirmation email
```

### Window 2: Frontend Agent

```bash
/agent frontend resume checkout-frontend
```

Works on:
- Checkout UI components
- Cart integration
- Payment form
- Success/error states

### Window 3: QA Agent

```bash
/agent qa resume checkout-qa
```

Works on:
- E2E tests
- Edge case testing
- Error scenarios
- Performance testing

### Window 4: Docs Agent

```bash
/agent docs resume checkout-docs
```

Works on:
- API documentation
- User guide updates
- Developer notes
- Changelog entry

### Window 5: Review Agent

```bash
/agent reviewer resume checkout-review
```

Validates:
- Cross-agent consistency
- No conflicting changes
- Tests comprehensive
- Docs complete

### Main Window: Merge

```bash
/parallel merge checkout
```

AI:
1. Reads all 5 handoffs
2. Checks for conflicts (none found)
3. Validates test coverage
4. Updates context files
5. Creates summary

```text
✅ Merge complete

Changed: 12 files
Tests: 35 pass, 0 fail
Conflicts: 0
Warnings: 1 (review payment error handling)

Ready for human review and PR.
```

---

## Conflict Handling

If conflicts occur:

```bash
/parallel resolve checkout
```

AI should:
1. Inspect all handoff reports
2. Identify overlapping file edits
3. Show conflicting changes side-by-side
4. Suggest merge order
5. **Ask human approval** if:
   - Architecture changes conflict
   - Behavior differs from spec
   - Security implications exist

**Example conflict**:
```text
Conflict in backend/api/payment.ts:

Backend agent (line 45):
  throw new Error('Payment failed');

QA agent (line 45):
  return { success: false, error: 'Payment failed' };

Recommendation: Use QA's approach (better error handling)
Approve? [y/n]
```

---

## Advanced: Custom Window Setup

For complex features, create custom agent configurations:

```bash
/parallel build ecommerce --agents backend,frontend,qa,db-migration,security,docs
```

This creates 6 specialized windows instead of the default 4.

---

## Troubleshooting

### Problem: Agents Conflict on Same File

**Solution**: Update session files to assign non-overlapping scopes.

```bash
/parallel replan checkout --avoid-conflicts
```

---

### Problem: Snapshot is Outdated

**Solution**: Create a fresh snapshot before starting.

```bash
/sync                    # Update context
/parallel build feature  # Uses fresh snapshot
```

---

### Problem: One Agent is Stuck

**Solution**: Resume that agent with additional context.

In the stuck window:
```bash
/agent backend resume checkout-backend --clarify "focus on X"
```

---

### Problem: Merge Creates Conflicts

**Solution**: Use conflict resolver.

```bash
/parallel resolve checkout --interactive
```

---

## Best Practices

### For Non-Technical Users
1. **Always start from main window**: Let AI coordinate agents
2. **Copy prompts exactly**: Don't modify agent commands
3. **Wait for all windows to finish**: Don't merge prematurely
4. **Review handoffs**: Check for warnings before merging

### For Technical Users
1. **Keep sessions small**: 2-4 hours of work per agent max
2. **Use locks for shared files**: Prevent race conditions
3. **Update snapshots regularly**: After major PRs
4. **Review before merge**: Don't trust blind merges
5. **Commit often**: Easier rollback if multi-window work goes wrong

### Agent Assignments

| Agent | Best For |
|-------|----------|
| **Backend** | APIs, database, business logic |
| **Frontend** | UI, components, state management |
| **QA** | Tests, edge cases, validation |
| **Docs** | Documentation, guides, comments |
| **Reviewer** | Quality checks, consistency, conflicts |
| **Architect** | Design decisions, refactors |
| **Git Guardian** | Branch management, PRs, changelog |

---

## Limitations

### When NOT to Use Multi-Window

- ❌ Small features (<1 hour of work)
- ❌ High coupling (many shared files)
- ❌ Experimental/exploratory work
- ❌ Urgent hotfixes

**Use single window instead**: Simpler, less coordination overhead.

### Known Issues

1. **Context drift**: Long-running sessions may diverge. Mitigation: Keep sessions under 4 hours.
2. **Lock contention**: Multiple agents waiting on same file. Mitigation: Better session planning.
3. **Merge complexity**: Many conflicts. Mitigation: Smaller sessions, clearer boundaries.

---

## Summary

**Simple workflow**:
1. Main window: `/parallel build [feature]`
2. Open suggested windows
3. Paste generated prompts
4. Wait for completion
5. Main window: `/parallel merge [feature]`

**Key benefits**: Speed, specialization, parallel PRs

**Critical rules**: Same snapshot, no silent architecture changes, handoffs required, reviewer validates

**When to use**: Medium-to-large features with clear module boundaries

**When not to use**: Small features, highly coupled changes, hotfixes
