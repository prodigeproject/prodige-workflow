# STATUS - Project Health Dashboard

**How to Use**: This file provides project-level health status, updated by `/status` command.

**When to Update**: 
- Daily standup (automated)
- After major milestone
- When requested via `/status`
- Weekly team sync

**Updated By**: `/status` command, Orchestrator  
**Read By**: Team, stakeholders, project managers

---

## Quick Status

**Format**: One-line project state

```
Status: {GREEN/YELLOW/RED} - {Brief summary}
Last Updated: {YYYY-MM-DD HH:MM}
```

**Status Codes**:
- 🟢 **GREEN** - On track, no blockers
- 🟡 **YELLOW** - Minor issues, on track with mitigation
- 🔴 **RED** - Critical issues, timeline at risk

**Example**:
```
Status: 🟢 GREEN - Sprint 3 on track, 80% complete
Last Updated: 2026-06-17 16:00
```

---

## Current Sprint

**Format**: Sprint details

```
**Sprint**: {Sprint number or name}  
**Goal**: {What this sprint delivers}  
**Start**: {YYYY-MM-DD}  
**End**: {YYYY-MM-DD}  
**Progress**: {X}/{Y} tasks complete ({percent}%)  
**Status**: {On Track / At Risk / Off Track}  
```

**Example**:
```
**Sprint**: Sprint 3 - User Profile Management  
**Goal**: Complete user profile CRUD + avatar upload  
**Start**: 2026-06-10  
**End**: 2026-06-24  
**Progress**: 8/10 tasks complete (80%)  
**Status**: On Track  
```

---

## Tasks Status

**Format**: Task breakdown by status

```
**Completed**: {count} tasks
- {Task ID}: {Title}
- {Task ID}: {Title}

**In Progress**: {count} tasks
- {Task ID}: {Title} - {Agent} - {percent}% complete
- {Task ID}: {Title} - {Agent} - {percent}% complete

**Blocked**: {count} tasks
- {Task ID}: {Title} - Blocked by {reason}

**Not Started**: {count} tasks
- {Task ID}: {Title}
```

**Example**:
```
**Completed**: 8 tasks
- TASK-120: Design user profile schema
- TASK-121: Implement GET /users/:id endpoint
- TASK-122: Implement PUT /users/:id endpoint
- TASK-123: Implement DELETE /users/:id endpoint
- TASK-124: Add user avatar upload
- TASK-125: Create ProfilePage component
- TASK-126: Create EditProfileForm component
- TASK-127: Create AvatarUpload component

**In Progress**: 1 task
- TASK-128: E2E tests for profile flow - QA Agent - 60% complete

**Blocked**: 1 task
- TASK-129: Deploy to staging - Blocked by DevOps (server provisioning)

**Not Started**: 0 tasks
```

---

## Health Metrics

**Format**: Key project health indicators

```
### Code Quality
**Test Coverage**: {percent}% ({trend} from last week)  
**Code Review Pass Rate**: {percent}%  
**Technical Debt Items**: {count} ({HIGH}/{MEDIUM}/{LOW})  

### Velocity
**Story Points Completed**: {count} / {planned}  
**Average Cycle Time**: {days} days  
**Deployment Frequency**: {count} per week  

### Risks
**Active Risks**: {count}  
**Mitigated Risks**: {count}  
**New Risks**: {count} (since last update)  
```

**Example**:
```
### Code Quality
**Test Coverage**: 87% (↑ 3% from last week)  
**Code Review Pass Rate**: 92% (first-time approval)  
**Technical Debt Items**: 12 (2 HIGH, 6 MEDIUM, 4 LOW)  

### Velocity
**Story Points Completed**: 34 / 40 (85%)  
**Average Cycle Time**: 2.5 days  
**Deployment Frequency**: 3 per week  

### Risks
**Active Risks**: 2  
**Mitigated Risks**: 1  
**New Risks**: 1 (since last update)  
```

---

## Active Blockers

**Format**: List of all blockers affecting progress

```
### Blocker {N}: {Title}
**Severity**: {CRITICAL/HIGH/MEDIUM/LOW}  
**Affects**: {Task IDs or teams}  
**Waiting For**: {What/who}  
**Since**: {Date}  
**Expected Resolution**: {Date or "Unknown"}  
**Workaround**: {If any}  
```

**Example**:
```
### Blocker 1: Staging Server Not Provisioned
**Severity**: HIGH  
**Affects**: TASK-129 (deployment), QA testing  
**Waiting For**: DevOps team (ticket DEV-456)  
**Since**: 2026-06-15  
**Expected Resolution**: 2026-06-18  
**Workaround**: Testing on local dev environment (limited)  

### Blocker 2: Payment Gateway API Rate Limit
**Severity**: MEDIUM  
**Affects**: TASK-128 (E2E tests with payments)  
**Waiting For**: Payment provider to increase limit  
**Since**: 2026-06-16  
**Expected Resolution**: Unknown (ticket open with provider)  
**Workaround**: Using mock payment service for most tests  
```

---

## Recent Achievements

**Format**: Completed this week/sprint

```
**This Week**:
- ✅ {Achievement}
- ✅ {Achievement}
- ✅ {Achievement}
```

**Example**:
```
**This Week**:
- ✅ Completed all backend API endpoints for user profile
- ✅ Deployed avatar upload to production (handling 1000+ uploads/day)
- ✅ Fixed critical security vulnerability (JWT validation)
- ✅ Achieved 87% test coverage (up from 84%)
- ✅ Resolved 3 technical debt items (reduced from 15 to 12)
```

---

## Upcoming Next Week

**Format**: Planned work

```
**Next Week**:
- 📋 {Planned item}
- 📋 {Planned item}
- 📋 {Planned item}
```

**Example**:
```
**Next Week**:
- 📋 Complete E2E test suite for profile management
- 📋 Deploy to staging (pending server provisioning)
- 📋 Begin Sprint 4 - Order Management redesign
- 📋 Address 2 HIGH priority technical debt items
- 📋 Security audit of authentication flow
```

---

## Team Status

**Format**: Agent/team member status

```
**Agent/Member**: {Name}  
**Current Task**: {Task ID or "Idle"}  
**Status**: {Active/Blocked/Review}  
**Utilization**: {percent}%  
```

**Example**:
```
**Backend Agent**: 
Current Task: TASK-128 (supporting QA)  
Status: Active  
Utilization: 90%  

**Frontend Agent**:
Current Task: Idle (Sprint 3 tasks complete)  
Status: Available for Sprint 4  
Utilization: 0%  

**QA Agent**:
Current Task: TASK-128 (E2E tests)  
Status: Active  
Utilization: 85%  
```

---

## Status History

**Format**: Status changes over time

```
| Date | Status | Note |
|------|--------|------|
| {date} | {status} | {what changed} |
```

**Example**:
```
| Date | Status | Note |
|------|--------|------|
| 2026-06-17 | 🟢 GREEN | Sprint 3 80% complete, on track |
| 2026-06-15 | 🟡 YELLOW | Staging server blocker, workaround in place |
| 2026-06-12 | 🟢 GREEN | Sprint 3 progressing well, no issues |
| 2026-06-10 | 🟢 GREEN | Sprint 3 started, all tasks assigned |
```

---

## Update Instructions

### Daily Update (Automated by /status)
```
1. Update Quick Status (GREEN/YELLOW/RED)
2. Update Tasks Status (count completed/in-progress/blocked)
3. Update Health Metrics (if changed)
4. Add new blockers (if any)
5. Update team status
6. Add to status history
```

### Weekly Update (Manual Review)
```
1. Review and update sprint progress
2. Document recent achievements
3. Plan upcoming week
4. Review and update risks
5. Update health metrics trends
6. Archive completed blockers
```

### Milestone Update
```
1. Update sprint information
2. Document major achievements
3. Update long-term metrics
4. Review technical debt
5. Plan next sprint
```

---

## Status Report Template (for Stakeholders)

```markdown
# Project Status Report - {Date}

## Executive Summary
Status: {GREEN/YELLOW/RED} - {One sentence summary}

## This Week's Achievements
- {Achievement 1}
- {Achievement 2}
- {Achievement 3}

## Next Week's Plan
- {Plan 1}
- {Plan 2}
- {Plan 3}

## Risks & Blockers
- {Risk/Blocker 1} - {Mitigation}
- {Risk/Blocker 2} - {Mitigation}

## Metrics
- Sprint Progress: {X}/{Y} tasks ({percent}%)
- Test Coverage: {percent}%
- Velocity: {points} story points

## Help Needed
- {Request 1}
- {Request 2}
```

---

## Related Files

- `.ai/state/CURRENT.md` - Real-time session state
- `.ai/state/BACKLOG.md` - Upcoming work
- `.ai/state/SPRINT.md` - Current sprint plan
- `.ai/reports/` - Historical status reports

---

**File Purpose**: Project health dashboard  
**Update Frequency**: Daily (automated), Weekly (reviewed)  
**Command**: Use `/status` to generate/update  
**Version**: 2.0

