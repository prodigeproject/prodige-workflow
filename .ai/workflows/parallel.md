# Workflow: Parallel Execution

## Purpose
Execute large features across multiple independent work streams simultaneously. Split approved implementation into parallel tasks while maintaining consistency and preventing conflicts.

**Core principle:** Divide and conquer with coordination. Work in parallel where possible, merge systematically.

---

## Steps

### 1. Verify Approved Design

**Confirm prerequisites before parallel work begins:**

**Check design approval:**
- Read `.ai/context/PRD.md` - Status must be "Approved"
- Read `.ai/context/ARCHITECTURE.md` - Design must be finalized
- Read `.ai/context/IMPLEMENTATION.md` - Implementation plan must exist
- Verify human sign-off received (HITL gate passed)

**Verify scope is large enough for parallel execution:**
- Multiple independent modules/components
- Estimated effort >8 hours of serial work
- Clear boundaries between work streams

**If not approved or too small:**
- STOP. Complete `/design` workflow first, or
- Use standard `/build` workflow instead (no parallel needed)

**Checklist:** Work through `.ai/checklists/parallel.md` before splitting work into parallel streams.

**Skill:** `clean-code` (Think before coding - verify foundation)

### 2. Create Context Snapshot

**Capture current state for all parallel workers:**

**Create snapshot file:**
```bash
mkdir -p .ai/runtime/snapshots
```

Create `.ai/runtime/snapshots/[feature-name]-[timestamp].md`:

```markdown
# Parallel Execution Snapshot: [Feature Name]

**Created:** [timestamp]
**Feature:** [feature name]
**Branch:** [base branch]

## Context Files
- PRD: `.ai/context/PRD.md`
- Architecture: `.ai/context/ARCHITECTURE.md`
- Implementation: `.ai/context/IMPLEMENTATION.md`
- Decisions: `.ai/context/DECISIONS.md`

## Current State
- Git commit: [commit hash]
- Tests passing: [X/X]
- Build status: [passing/failing]

## Key Decisions
1. [Decision 1] - [rationale]
2. [Decision 2] - [rationale]

## Dependencies
[List external dependencies or blockers]

## Success Criteria
[How to verify feature complete]
```

**Purpose:** All workers start with identical context.

### 3. Update Cache

**Ensure cache is current for efficient context loading:**

Run cache update workflow:
```bash
# Update context cache
/cache refresh
```

**Cache should include:**
- Current file structure (repo map)
- Recent changes
- Test baselines
- Build artifacts

**Verify cache timestamp is recent (<5 minutes).**

**Purpose:** Workers can load context efficiently without re-reading entire codebase.

**Skill:** Cache management

### 4. Split Work by Module/Concern

**Analyze implementation plan and create parallel work streams:**

**Read IMPLEMENTATION.md phases:**
- Identify independent modules
- Map dependencies between components
- Find parallelizable work

**Split criteria:**
- Each stream touches DIFFERENT files (no overlaps)
- Minimal cross-stream dependencies
- Each stream completable in 2-4 hours
- Clear acceptance criteria per stream

**Example split:**
```
Stream A: Backend API endpoints
- Files: src/api/*.ts
- Depends on: None
- Estimated: 3 hours

Stream B: Frontend components  
- Files: src/components/*.tsx
- Depends on: None (mocked API initially)
- Estimated: 3 hours

Stream C: Database schema & migrations
- Files: db/migrations/*.sql, src/models/*.ts
- Depends on: None
- Estimated: 2 hours

Stream D: Integration & tests
- Files: tests/integration/*.test.ts
- Depends on: A, B, C complete
- Estimated: 2 hours
```

**Dependency graph:**
```
A ──┐
    ├──> D (integration)
B ──┤
    │
C ──┘
```

**Skill:** `systematic-debugging` (Analyze dependencies)

### 5. Create Session Files

**For each parallel work stream, create dedicated session file:**

Create `.ai/runtime/sessions/[stream-name].md`:

```markdown
# Parallel Session: [Stream Name]

**Parent Feature:** [feature name]
**Stream ID:** [A/B/C]
**Worker:** [agent/human identifier]
**Status:** NOT_STARTED

---

## Scope

**Responsibility:** [What this stream builds]

**Files to create:**
- [file 1]
- [file 2]

**Files to modify:**
- [file 3]: [specific changes]
- [file 4]: [specific changes]

**Files to NOT touch:** [out of scope files]

---

## Context

**Snapshot:** `.ai/runtime/snapshots/[snapshot-file].md`

**Dependencies:**
- Depends on: [other streams, or "None"]
- Required by: [other streams, or "None"]

**Interfaces:**
- API contracts: [what other streams expect]
- Data formats: [shared data structures]

---

## Implementation Plan

1. [Step 1]
2. [Step 2]
3. [Step 3]

---

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

---

## Tests Required

- [ ] Test 1: [description]
- [ ] Test 2: [description]

---

## Handoff Checklist

- [ ] All files created/modified
- [ ] Tests written and passing
- [ ] No conflicts with locked files
- [ ] Handoff template completed
- [ ] Branch pushed

---

## Notes

[Space for worker to add notes during execution]
```

**Create one session file per stream.**

**Skill:** Modular task decomposition

### 6. Create Locks for Risky Files

**Prevent conflicts on shared/critical files:**

Create `.ai/runtime/locks/locks.md`:

```markdown
# Parallel Execution Locks

**Feature:** [feature name]
**Created:** [timestamp]

---

## Locked Files (Do Not Modify)

### Critical Configuration
- `package.json` - LOCKED (main window only)
- `tsconfig.json` - LOCKED (main window only)
- `.env.example` - LOCKED (main window only)

### Shared Utilities
- `src/utils/config.ts` - LOCKED (conflicts likely)
- `src/types/index.ts` - LOCKED (merge conflicts)

### Database Core
- `db/schema.sql` - LOCKED (migration conflicts)

---

## Lock Rules

**If you need to modify a locked file:**
1. STOP work in your stream
2. Document required change in handoff
3. Request main window make change
4. Wait for change to be merged
5. Rebase and continue

**Never commit changes to locked files from parallel streams.**

---

## Lock Release

Locks released after streams merge to main window.
```

**Purpose:** Prevent merge conflicts and lost work.

**Skill:** Coordination and conflict prevention

### 7. Create Handoff Templates

**Prepare structured handoff for each stream:**

Create `.ai/runtime/handoffs/[stream-name]-handoff.md`:

```markdown
# Handoff: [Stream Name]

**Worker:** [identifier]
**Completed:** [timestamp]
**Branch:** [branch name]
**Status:** [IN_PROGRESS / COMPLETE / BLOCKED]

---

## Work Completed

**Files Created:**
- [file 1] - [purpose]
- [file 2] - [purpose]

**Files Modified:**
- [file 3] - [what changed]
- [file 4] - [what changed]

---

## Tests

**Tests Written:** [count]
**Tests Passing:** [X/X]
**Coverage:** [X%]

**Test commands:**
```bash
npm test [test-files]
```

---

## Verification

**Build Status:** [passing/failing]
**Lint Status:** [passing/failing]

**Verification commands:**
```bash
npm run build
npm run lint
```

---

## Acceptance Criteria

- [x] Criterion 1 - COMPLETE
- [x] Criterion 2 - COMPLETE
- [ ] Criterion 3 - BLOCKED: [reason]

---

## Integration Notes

**API contracts delivered:**
- [API 1]: [endpoint/interface]
- [API 2]: [endpoint/interface]

**Dependencies resolved:**
- [Dependency 1]: [how resolved]

**Known issues:**
- [Issue 1]: [description and workaround]

---

## Merge Instructions

**Branch to merge:** `[branch-name]`

**Merge order:** Merge AFTER [stream X, Y] complete

**Conflicts expected:**
- [File]: [reason] - [resolution strategy]

**Post-merge steps:**
1. [Step 1]
2. [Step 2]

---

## Blocked Items

**Blockers:** [None / List blockers]

**Requires:**
- [What's needed to unblock]

---

## Reviewer Notes

[Space for reviewer to add comments]

---

**Handoff complete:** [Yes/No]
**Ready for merge:** [Yes/No]
```

**Create template for each stream.**

**Skill:** Structured communication

### 8. Give Copy-Paste Prompts for Each Window

**Generate ready-to-use prompts for parallel workers:**

**For each stream, create prompt:**

```markdown
# Prompt for Stream [A/B/C]: [Stream Name]

**Copy this prompt into a new Kiro window:**

---

You are working on a parallel execution stream.

**Context:**
- Feature: [feature name]
- Stream: [stream name]
- Session file: `.ai/runtime/sessions/[stream-name].md`
- Snapshot: `.ai/runtime/snapshots/[snapshot].md`
- Locks: `.ai/runtime/locks/locks.md`

**Your task:**
1. Read session file for complete scope
2. Read snapshot for current state
3. Check locks file - do NOT modify locked files
4. Implement according to session plan
5. Write tests (TDD)
6. Verify tests passing
7. Complete handoff template
8. Push branch: `parallel/[stream-name]`

**Important:**
- Work ONLY on files in your session scope
- Do NOT modify locked files
- Follow surgical precision (no scope creep)
- Run tests after each change
- Complete handoff checklist

**When complete:**
- Fill handoff template: `.ai/runtime/handoffs/[stream-name]-handoff.md`
- Notify main window: "Stream [X] complete, ready for review"

**Start now:**
/build --session .ai/runtime/sessions/[stream-name].md
```

**Create one prompt per stream.**

**Share prompts with workers (humans or agents).**

**Skill:** Clear delegation

### 9. Workers Execute

**Each worker executes their stream independently:**

**Worker responsibilities:**
- Open new window/session
- Load assigned context (session + snapshot)
- Follow implementation plan
- Write tests (TDD)
- Stay within scope (surgical)
- Check locks file before modifying any file
- Complete work incrementally
- Push branch regularly
- Fill handoff template when done

**Main window monitors progress:**
- Check stream status periodically
- Unblock workers if needed
- Handle locked file changes
- Coordinate dependencies

**Worker execution follows `/build` workflow:**
- Load context
- Implement incrementally
- Test continuously
- Verify before handoff

**Skill:** `clean-code` (Surgical, focused execution)

### 10. Reviewer Reviews Handoffs and Diffs

**As each stream completes, systematic review required:**

**For each completed stream:**

**Read handoff template:**
- Verify all acceptance criteria met
- Check test results
- Review integration notes
- Note any blockers

**Review code diff:**
```bash
git fetch origin parallel/[stream-name]
git diff main origin/parallel/[stream-name]
```

**Execute `/review` workflow:**
- Check correctness
- Verify surgical precision (only session files touched)
- Ensure no locked files modified
- Validate test coverage
- Check for conflicts with other streams

**Review verdict per stream:**
- ✅ APPROVE - Ready for merge
- 🔄 NEEDS WORK - Issues found, worker fixes
- ⚠️ BLOCKED - Dependencies not ready

**Document review in handoff template:**
```markdown
## Review Complete

**Reviewer:** [identifier]
**Verdict:** [APPROVE/NEEDS WORK/BLOCKED]
**Issues:** [count]

[Details]
```

**Skill:** Systematic code review

**Agent:** Delegate to `reviewer` agent if configured.

### 11. Main Window Merges

**Merge approved streams in dependency order:**

**Merge strategy:**

**Order:** Follow dependency graph from Step 4
```
1. Merge Stream C (no dependencies)
2. Merge Stream A (no dependencies)
3. Merge Stream B (no dependencies)
4. Merge Stream D (depends on A, B, C)
```

**For each stream merge:**

**Prepare:**
```bash
git checkout main
git pull origin main
git fetch origin parallel/[stream-name]
```

**Merge:**
```bash
git merge origin/parallel/[stream-name] --no-ff
```

**Resolve conflicts (if any):**
- Read handoff notes for conflict guidance
- Resolve systematically
- Test after resolution

**Verify after each merge:**
```bash
npm test
npm run build
npm run lint
```

**If verification fails:**
- STOP merging
- Fix issue
- Re-verify
- Continue

**Commit merge:**
```bash
git commit -m "merge: parallel stream [name]

- Feature: [feature name]
- Stream: [stream name]
- Files: [count]
- Tests: passing [X/X]

Reviewed-by: [reviewer]"
```

**Skill:** Systematic integration

### 12. Run Sync

**After all streams merged, synchronize and verify:**

**Run sync workflow:**
```bash
/sync
```

**Sync actions:**
- Update all context files
- Refresh cache
- Update CHANGELOG.md
- Update ARCHITECTURE.md if needed
- Record integration in DECISIONS.md

**Final verification:**
```bash
# Complete test suite
npm test

# Build verification
npm run build

# Lint check
npm run lint

# Integration tests
npm run test:integration
```

**Verify feature completeness:**
- Review PRD acceptance criteria
- Test all user stories
- Verify success metrics

**Clean up parallel artifacts:**
```bash
# Archive session files
mv .ai/runtime/sessions .ai/runtime/archive/[feature]-sessions

# Archive handoffs
mv .ai/runtime/handoffs .ai/runtime/archive/[feature]-handoffs

# Keep snapshot for reference
```

**Update feature status:**
```markdown
Feature: [name]
Status: COMPLETE
Parallel streams: [A, B, C, D]
Merged: [timestamp]
Tests: [X/X passing]
```

**Skill:** `verification-before-completion` (Complete validation)

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Divide & Conquer** | Split large work into independent streams | Each stream has clear boundaries |
| **No Overlap** | Streams modify different files | File locks prevent conflicts |
| **Systematic Integration** | Merge in dependency order with verification | Tests pass after each merge |
| **Coordination** | Main window coordinates, workers execute | Clear handoff communication |

---

## Red Flags - STOP

- Streams modifying same files (conflict risk)
- No clear dependency order
- Locked files modified by workers
- Merging without review
- Tests failing after merge
- Workers expanding scope beyond session
- Skipping verification between merges
- Feature too small for parallel work (<8 hours serial)

**If you see these:** STOP. Re-assess approach or switch to serial `/build`.

---

## Integration Points

**Context Files:**
- Reads: `PRD.md`, `ARCHITECTURE.md`, `IMPLEMENTATION.md`, `DECISIONS.md`
- Updates: `CHANGELOG.md`, `ARCHITECTURE.md` (if needed)
- Creates: Session files, handoffs, locks, snapshots

**Skills:**
- `clean-code` - Think before coding, surgical execution (Steps 1, 9)
- `systematic-debugging` - Dependency analysis (Step 4)
- `verification-before-completion` - Verify each merge (Steps 11, 12)
- `test-driven-development` - TDD in each stream (Step 9)

**Commands:**
- `/design` - Must be complete before parallel work (Step 1)
- `/build` - Each worker uses build workflow (Step 9)
- `/review` - Review each stream (Step 10)
- `/sync` - Final synchronization (Step 12)
- `/cache` - Update cache before splitting work (Step 3)

**Agents:**
- `reviewer` - Reviews handoffs and diffs (Step 10)
- `orchestrator` - Coordinates streams (main window)
- Worker agents - Execute streams (Step 9)

**Workflows:**
- Previous: `/design` - Design must be approved
- Next: `/sync` - Synchronize after merge complete

---

## When to Use Parallel Execution

**Use parallel when:**
- Feature has 3+ independent modules
- Estimated serial work >8 hours
- Clear boundaries between components
- Multiple workers available
- Time pressure (need speed)

**Do NOT use parallel when:**
- Feature is small (<8 hours)
- Components tightly coupled
- Unclear boundaries
- Single worker only
- Experimental/exploratory work

**Tradeoff:** Coordination overhead vs. time savings

---

## Output Format

Parallel execution produces:

**1. Snapshot** - Context at start
**2. Session files** - Work definitions per stream
**3. Locks** - File conflict prevention
**4. Handoffs** - Completion reports per stream
**5. Integrated feature** - Merged, tested, complete

Plus updated:
**6. CHANGELOG.md** - Feature changes
**7. Cache** - Updated context

**Output format:** see `.ai/templates/PARALLEL_PLAN.md`

---

**Remember:** Parallel execution is coordination-heavy. Only use when time savings justify overhead. Clear boundaries and systematic integration are critical for success.
