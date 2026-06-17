# Parallel Execution Plan Template

**How to Use**: This template is used by `/parallel` command to plan concurrent agent work with proper isolation and merge strategies.

**When**: When feature can be split into independent work streams  
**Updated By**: Orchestrator during `/parallel` planning  
**Referenced In**: `.ai/workflows/parallel.md`, session management

---

## Goal

**What Goes Here**: What feature/task is being parallelized and why

**Format**:
```
**Feature**: {Name of feature being built}  
**Reason for Parallel**: {Why split the work}  
**Expected Speedup**: {Estimated time savings}  
**Complexity**: {Simple/Medium/Complex}  
```

**Example**:
```
**Feature**: User Profile Management (CRUD + Avatar Upload)  
**Reason for Parallel**: Frontend and Backend can work independently  
**Expected Speedup**: 6 hours → 3 hours (50% reduction)  
**Complexity**: Medium (shared data models, needs integration)  
```

---

## Snapshot

**What Goes Here**: Baseline state before parallel work starts

**Format**:
```
**Snapshot ID**: {unique-id}  
**Created**: {YYYY-MM-DD HH:MM}  
**Branch**: {git-branch-name}  
**Commit**: {git-commit-hash}  
**Files**:
- {file-path} - {purpose}
- {file-path} - {purpose}
```

**Example**:
```
**Snapshot ID**: parallel-user-profile-20260617-1430  
**Created**: 2026-06-17 14:30  
**Branch**: feature/user-profile  
**Commit**: a3f9b2c  
**Files**:
- src/users/user.model.ts - Base user model
- src/users/users.module.ts - Module definition
- docs/api/users.md - API spec
```

**Purpose**: Ensures all sessions start from same known-good state

---

## Sessions

**What Goes Here**: Independent work streams with isolation rules

**Format**:
```
### Session {N}: {Name}
**Agent**: {agent-role}  
**Goal**: {What this session delivers}  
**Scope**: {What files/components}  
**Duration**: {Estimated time}  
**Dependencies**: {What must exist first}  
**Isolated Files**: {Files only this session touches}  
**Shared Files**: {Files multiple sessions touch}  
```

**Example**:
```
### Session 1: Backend API Implementation
**Agent**: Backend  
**Goal**: Implement user CRUD endpoints + avatar upload  
**Scope**: 
- src/users/users.controller.ts
- src/users/users.service.ts
- src/users/dto/update-user.dto.ts
- src/upload/avatar.service.ts
**Duration**: 3 hours  
**Dependencies**: User model (already exists)  
**Isolated Files**: All backend src/ files (no conflict)  
**Shared Files**: 
- src/users/user.model.ts (READ only - no modification)
- docs/api/users.md (may UPDATE - lock needed)

### Session 2: Frontend Components
**Agent**: Frontend  
**Goal**: Build ProfilePage, EditProfileForm, AvatarUpload components  
**Scope**:
- src/components/Profile/ProfilePage.tsx
- src/components/Profile/EditProfileForm.tsx
- src/components/Profile/AvatarUpload.tsx
- src/api/users.ts (API client)
**Duration**: 3 hours  
**Dependencies**: API spec (from snapshot)  
**Isolated Files**: All frontend src/components/Profile/ (no conflict)  
**Shared Files**:
- src/types/user.ts (READ only - no modification)
- docs/api/users.md (may UPDATE - lock needed)

### Session 3: Tests
**Agent**: QA  
**Goal**: E2E tests for profile management flow  
**Scope**:
- tests/e2e/profile.spec.ts
- tests/fixtures/users.json
**Duration**: 2 hours  
**Dependencies**: Backend + Frontend complete  
**Isolated Files**: All tests/ files (no conflict)  
**Shared Files**: None
```

---

## Locks

**What Goes Here**: File access coordination to prevent conflicts

**Format**:
```
### Lock: {file-path}
**Access**: {READ-ONLY / EXCLUSIVE / COORDINATED}  
**Held By**: {Session N, Session M}  
**Reason**: {Why lock needed}  
**Resolution**: {How conflicts resolved}  
```

**Example**:
```
### Lock: docs/api/users.md
**Access**: COORDINATED  
**Held By**: Session 1 (Backend), Session 2 (Frontend)  
**Reason**: Both may update API spec during implementation  
**Resolution**: 
- Backend updates endpoints section first (hour 0-1)
- Frontend reads spec, updates examples (hour 1-2)
- If conflict: Backend has priority, Frontend adapts

### Lock: src/users/user.model.ts
**Access**: READ-ONLY  
**Held By**: All sessions  
**Reason**: Shared data contract, no modifications allowed  
**Resolution**: If model change needed, STOP parallel and update baseline

### Lock: tests/e2e/profile.spec.ts
**Access**: EXCLUSIVE  
**Held By**: Session 3 (QA)  
**Reason**: Only QA writes E2E tests  
**Resolution**: No conflict possible
```

---

## Handoffs

**What Goes Here**: Coordination points between sessions

**Format**:
```
### Handoff {N}: {From Session} → {To Session}
**What**: {What's being handed off}  
**When**: {Timing/trigger}  
**Format**: {How it's delivered}  
**Validation**: {How recipient verifies}  
```

**Example**:
```
### Handoff 1: Backend → Frontend
**What**: API endpoints deployed to dev server + OpenAPI spec  
**When**: After Backend Session 1 hour mark  
**Format**: 
- API base URL: http://localhost:3000/api
- OpenAPI spec: docs/api/users.json (generated)
**Validation**: Frontend runs `curl` health check, validates spec

### Handoff 2: Backend + Frontend → QA
**What**: Integrated feature ready for testing  
**When**: Both Session 1 and Session 2 complete  
**Format**: 
- Dev environment: http://localhost:3000
- Test account: test@example.com / password123
**Validation**: QA confirms login and profile page loads
```

---

## Merge Plan

**What Goes Here**: How independent work gets merged back together

**Format**:
```
### Merge Strategy
**Order**: {Which session merges first}  
**Method**: {Git strategy}  
**Verification**: {How to validate merge}  
**Rollback**: {What if merge breaks}  
```

**Example**:
```
### Merge Strategy
**Order**:
1. Backend (Session 1) - Merges first (has API contract)
2. Frontend (Session 2) - Merges after Backend (depends on API)
3. QA (Session 3) - Merges last (tests integrated feature)

**Method**:
1. Merge Backend:
   - Create PR: feature/user-profile-backend → feature/user-profile
   - Run backend tests
   - Deploy to dev
   - Merge if green

2. Merge Frontend:
   - Pull latest feature/user-profile (includes backend)
   - Create PR: feature/user-profile-frontend → feature/user-profile
   - Run frontend + integration tests
   - Merge if green

3. Merge QA:
   - Pull latest feature/user-profile (includes backend + frontend)
   - Create PR: feature/user-profile-tests → feature/user-profile
   - Run full E2E suite
   - Merge if green

**Verification**:
- All tests pass (unit + integration + E2E)
- No merge conflicts
- Dev environment fully functional
- Code review approved

**Rollback**:
- If merge breaks: `git revert {merge-commit}`
- If conflict: Pause, resolve manually, re-test
- If showstopper: Abandon merge, debug in isolation
```

---

## Parallel Execution Checklist

Before starting parallel work:

### Planning
- [ ] Goal clearly defined
- [ ] Snapshot created
- [ ] Sessions scoped (no overlap)
- [ ] Locks identified
- [ ] Handoffs planned

### Isolation
- [ ] Each session has isolated files
- [ ] Shared files have access rules
- [ ] No hidden dependencies
- [ ] Merge strategy defined

### Coordination
- [ ] Handoff points clear
- [ ] Timing coordinated
- [ ] Validation methods defined
- [ ] Rollback plan exists

### Verification
- [ ] Merge order logical
- [ ] Tests cover integration
- [ ] Dev environment ready
- [ ] Team aware of parallel work

---

## Anti-Patterns to Avoid

### ❌ Sessions with Overlapping Files

```
Session 1: Edit src/users/user.controller.ts
Session 2: Edit src/users/user.controller.ts
→ Guaranteed merge conflict
```

**Fix**: Split file or make one session wait for other

### ❌ Hidden Dependencies

```
Session 1: Changes User model
Session 2: Depends on old User model structure
→ Session 2 breaks when merged
```

**Fix**: Make model change in baseline, THEN parallelize

### ❌ No Handoff Validation

```
Backend: "API is done"
Frontend: (starts calling API, gets 404)
→ Wasted time debugging
```

**Fix**: Add validation step in handoff (health check, spec check)

---

## Integration with Workflows

**Created By**: `/parallel` command  
**Manages**: Session isolation, lock coordination  
**Triggers**: Merge workflow when sessions complete  
**Updates**: `.ai/state/CURRENT.md` with session status  

---

## Related Files

- `.ai/workflows/parallel.md` - Parallel execution workflow
- `.ai/commands/parallel.md` - Parallel command
- `.ai/state/CURRENT.md` - Session tracking

---

**Template Version**: 2.0  
**Last Updated**: 17 Juni 2026
