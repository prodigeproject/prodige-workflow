# Usage Guide

## Overview

This comprehensive guide explains how to use **Prodige Workflow** from initial setup through production deployment. Whether you're building a new project or improving an existing one, this guide covers the complete workflow.

---

## Table of Contents

1. [For Existing Projects](#1-for-existing-projects)
2. [For New Projects](#2-for-new-projects)
3. [Designing Features](#3-designing-features)
4. [Building Features](#4-building-features)
5. [Multi-Window Development](#5-multi-window-development)
6. [Keeping Context Fresh](#6-keeping-context-fresh)
7. [Common Workflows](#7-common-workflows)
8. [Best Practices](#8-best-practices)

---

## 1. For Existing Projects

### Initialize from Repository

When adding Prodige Workflow to an existing codebase:

```bash
/init from repo
```

**What AI does**:

1. **Scans repository structure**
   - Identifies languages and frameworks
   - Maps directory organization
   - Detects configuration files

2. **Analyzes dependencies**
   - Reads `package.json` / `pyproject.toml` / `requirements.txt` / `composer.json` / `Cargo.toml`
   - Identifies third-party libraries
   - Checks for security vulnerabilities

3. **Maps source code**
   - Finds source directories (`src/`, `app/`, `lib/`)
   - Identifies main entry points
   - Discovers module structure

4. **Discovers routes/APIs**
   - HTTP endpoints
   - GraphQL schemas
   - RPC interfaces

5. **Analyzes database**
   - Schema definitions
   - Migrations
   - ORM models

6. **Discovers tests**
   - Test files location
   - Test frameworks used
   - Coverage reports

7. **Reads documentation**
   - README
   - API docs
   - Architecture diagrams
   - Contributing guides

8. **Creates context files**
   - Generates `.ai/context/` files
   - Creates agent definitions
   - Sets up workflow templates

**Important**: AI must **not invent details**. If information is unclear, it should ask.

---

### Example: Existing Next.js App

```bash
/init from repo
```

**AI output**:
```text
Repository Analysis Complete

Detected Stack:
- Framework: Next.js 14.0
- Language: TypeScript 5.3
- Database: PostgreSQL (via Prisma ORM)
- Auth: NextAuth.js v4
- Styling: Tailwind CSS
- Testing: Jest + React Testing Library
- Package Manager: pnpm

Structure:
- Pages: /app (App Router)
- Components: /components
- API Routes: /app/api
- Database: /prisma
- Tests: /__tests__
- Config: next.config.js, tsconfig.json, tailwind.config.js

Dependencies (24 total):
- Production: 18
- Dev: 6
- Outdated: 2 (react-icons, axios)

Routes Found: 12 pages, 8 API endpoints

Database Schema:
- Tables: users, posts, comments, sessions
- Relations: users → posts, posts → comments

Tests: 45 files, ~70% coverage

Context files created in .ai/context/:
✅ architecture.md
✅ codebase.md
✅ dependencies.md
✅ routes.md
✅ database.md
✅ conventions.md

Ready to use! Run /status to verify.
```

---

### Verify AI Understanding

After initialization, check if AI understood your project:

```bash
/show context architecture
```

**Should display**:
- High-level architecture
- Key modules
- Data flow
- External dependencies

**If incorrect or incomplete**:
```bash
/fix context architecture
```

AI will ask clarifying questions to correct its understanding.

---

## 2. For New Projects

### Initialize from Idea

When starting a project from scratch:

```bash
/init from idea: [describe your project]
```

**Example**:
```bash
/init from idea: A fitness tracking app where users can log workouts, track progress, set goals, and compete with friends on leaderboards
```

**What AI does**:

1. **Asks clarifying questions**:
   ```text
   Great! I'll help you build a fitness tracking app. A few questions:

   1. User Authentication:
      - Email/password signup?
      - Social login (Google, Apple)?
      - Both?

   2. Platform:
      - Web application only?
      - Mobile app (iOS/Android)?
      - Both web and mobile?

   3. Data Complexity:
      - Simple workout types (cardio, strength)?
      - Detailed exercise library with instructions?
      - Custom workout builder?

   4. Social Features:
      - Public leaderboards?
      - Friend-only competitions?
      - Privacy levels?

   5. Tech Preferences:
      - Any preferred technologies?
      - Hosting preferences (cloud, simple)?

   Please answer, and I'll create the project structure.
   ```

2. **Creates draft context documents**:
   - PRD (Product Requirements Document)
   - Architecture plan
   - Module structure
   - Database schema
   - API design

3. **Generates initial project files**:
   - Configuration files
   - Directory structure
   - Boilerplate code
   - README

4. **Asks for human review**:
   ```text
   Project Structure Created

   I've created a fitness tracking app with:

   Tech Stack:
   - Frontend: React Native (cross-platform mobile)
   - Backend: Node.js + Express
   - Database: PostgreSQL
   - Auth: JWT tokens
   - Hosting: AWS (Amplify for mobile, EC2 for backend)

   Core Features:
   1. User authentication (email + social login)
   2. Workout logging (predefined + custom exercises)
   3. Progress tracking (charts, analytics)
   4. Goal setting (weight, reps, distance targets)
   5. Leaderboards (friend-only by default, opt-in public)

   Database Tables:
   - users
   - workouts
   - exercises
   - goals
   - friendships
   - leaderboard_entries

   Review the files in .ai/context/ and let me know if anything should change.

   Approve to generate code? [yes/modify/explain more]
   ```

**Your job**: Review and approve or request changes.

---

## 3. Designing Features

Before writing code, design features through the HITL (Human-in-the-Loop) gates.

### Command

```bash
/design [feature-name]
```

### Example

```bash
/design workout history with filters
```

**AI workflow**:

#### Gate 1: PRD (Product Requirements)

AI creates a PRD document:

```text
PRD: Workout History with Filters

Problem:
Users currently cannot view their past workouts in a meaningful way.
The current workout log shows all workouts chronologically with no
filtering or search capabilities.

User Story:
As a user, I want to filter my workout history by date range, exercise
type, and body part, so I can track specific aspects of my progress.

User Flow:
1. User navigates to "History" tab
2. User sees list of all past workouts (newest first)
3. User taps "Filter" button
4. User selects filters:
   - Date range (last 7 days, 30 days, 90 days, custom)
   - Exercise type (cardio, strength, flexibility, custom)
   - Body part (legs, arms, core, full body)
5. User applies filters
6. List updates to show only matching workouts
7. User can clear filters to see all workouts again

Acceptance Criteria:
✅ History shows all workouts by default (newest first)
✅ Date range filter works correctly
✅ Exercise type filter works correctly
✅ Body part filter works correctly
✅ Multiple filters combine (AND logic)
✅ Filter state persists during session
✅ Clear filters button resets to default view
✅ Performance: Filter results appear within 500ms

Scope:
- Workout history view
- Filter UI (modal or sidebar)
- Filter logic (date, type, body part)
- Filter state management

Non-Goals:
- Advanced search (text search by exercise name)
- Export filtered results
- Share filtered views
- Saved filter presets

Success Metrics:
- 50%+ users use filters within first week
- Average 3+ filter actions per user per week
- <5% filter-related bug reports

Approve PRD? [yes/no/modify]
```

**Your job**: Review and approve or request changes.

---

#### Gate 2: Architecture

AI creates architecture plan:

```text
Architecture: Workout History with Filters

Data Flow:
Frontend (Filter UI) → API Request → Backend (Filter Logic) → Database Query → Return Results → Frontend (Display)

Components Affected:

Frontend:
- WorkoutHistoryScreen (modify)
- FilterModal (new)
- WorkoutListItem (no changes)

Backend:
- GET /api/workouts endpoint (modify - add query params)
- Workout service (modify - add filtering logic)

Database:
- workouts table (read only - no schema changes)

API Changes:

GET /api/workouts?startDate=2025-01-01&endDate=2025-01-15&type=strength&bodyPart=legs

Query Parameters:
- startDate (ISO 8601 date, optional)
- endDate (ISO 8601 date, optional)
- type (enum: cardio|strength|flexibility|custom, optional)
- bodyPart (enum: legs|arms|core|fullBody, optional)

Response: (same format as current GET /api/workouts)

Dependencies:
Internal:
- Workout service (modify)
- WorkoutHistoryScreen (modify)

External:
- No new external dependencies
- Uses existing date library (date-fns)

Database Impact:
- Add composite index: (userId, workoutDate, type, bodyPart) for faster queries
- No schema changes

Performance:
- Current: All workouts loaded (~100ms for 100 workouts)
- With filters: ~50-150ms depending on filter complexity
- Index will keep queries under 100ms even with 1000+ workouts

Risks & Mitigations:
1. Risk: Complex filters may slow down database
   Mitigation: Add composite index, test with 10k workouts

2. Risk: Filter UI might be confusing
   Mitigation: Use standard filter patterns, add "Clear" button

3. Risk: Filter state lost on navigation
   Mitigation: Store filter state in React Context or Redux

Alternatives Considered:
1. Client-side filtering (filter after loading all workouts)
   ❌ Rejected: Won't scale as workout count grows

2. Full-text search
   ❌ Rejected: Overkill for current needs, adds complexity

3. Saved filter presets
   ❌ Rejected: Nice-to-have but not MVP (can add later)

Security:
- Filter params validated server-side
- SQL injection prevented (using ORM parameterized queries)
- Users can only filter their own workouts (userId in query)

Approve Architecture? [yes/no/modify]
```

**Your job**: Review technical approach and approve.

---

#### Gate 3: Implementation Plan

AI creates implementation plan:

```text
Implementation Plan: Workout History with Filters

Files to Create:
1. frontend/src/components/FilterModal.tsx (new)
   - Filter UI component
   - Date range picker
   - Type and body part selectors
   - Apply/Clear buttons

2. frontend/src/hooks/useWorkoutFilters.ts (new)
   - Filter state management
   - Apply filter logic
   - Clear filter logic

Files to Modify:
1. frontend/src/screens/WorkoutHistoryScreen.tsx
   - Add filter button
   - Integrate FilterModal
   - Pass filters to API call
   - Show active filter badges

2. backend/src/routes/workouts.ts
   - Add query param parsing
   - Validate filter params
   - Pass to workout service

3. backend/src/services/workoutService.ts
   - Add buildFilterQuery method
   - Modify getWorkouts to accept filters
   - Apply filters to database query

4. backend/src/database/migrations/
   - 20250115_add_workout_filters_index.sql (new)
   - Add composite index for filtering

Work Split (3 PRs):

PR 1: Backend Filter Logic (3 hours)
- Modify API endpoint to accept query params
- Add filter logic to service
- Add database migration
- Write unit tests for filter logic
- Write integration tests for API

PR 2: Frontend Filter UI (4 hours)
- Create FilterModal component
- Create useWorkoutFilters hook
- Add Storybook stories for FilterModal
- Write component tests

PR 3: Integration (2 hours)
- Integrate FilterModal into WorkoutHistoryScreen
- Connect frontend filters to backend API
- Add loading states
- Write E2E tests for full filter flow
- Update documentation

Tests Planned:

Unit Tests (12 tests):
- Filter query builder (6 tests)
  - Date range only
  - Type only
  - Body part only
  - Multiple filters
  - No filters
  - Invalid params
- Filter state hook (6 tests)
  - Apply filters
  - Clear filters
  - Persist filters
  - Multiple updates
  - Reset on unmount
  - Invalid filter values

Integration Tests (5 tests):
- GET /api/workouts with date filter
- GET /api/workouts with type filter
- GET /api/workouts with body part filter
- GET /api/workouts with multiple filters
- GET /api/workouts with invalid filters (should return 400)

E2E Tests (3 tests):
- User opens filter modal, applies date filter, sees filtered results
- User applies multiple filters, results update correctly
- User clears filters, sees all workouts again

Rollback Plan:
- Feature flag: ENABLE_WORKOUT_FILTERS (default: false in production)
- If issues occur: set flag to false, filters hidden from UI
- Database index is additive (safe to leave), but can be dropped if needed
- No data migration required (no schema changes)

Migration Plan:
1. Deploy PR 1 (backend) - feature flag off
2. Run database migration (adds index)
3. Verify backend tests pass in production
4. Deploy PR 2 (frontend) - feature flag off
5. Deploy PR 3 (integration) - feature flag on for 10% users
6. Monitor for 24 hours
7. Increase to 50%, then 100%

Estimated Effort:
- Development: 9 hours
- Testing: 3 hours
- Code review: 2 hours
- Deployment: 1 hour
- Total: ~15 hours (~2 days)

Approve Implementation Plan? [yes/no/modify]
```

**Your job**: Approve the plan or request changes.

---

### After All 3 Gates Pass

AI will show:

```text
✅ All gates passed

PRD: Approved
Architecture: Approved
Implementation Plan: Approved

Ready to build! Use:
/build approved workout history with filters

Or start multi-window development:
/parallel build workout history with filters
```

---

## 4. Building Features

After design approval, build the feature:

```bash
/build approved [feature-name]
```

### Example

```bash
/build approved workout history with filters
```

**What AI does**:

1. **Follows implementation plan** (from Gate 3)
2. **Creates/modifies files** as specified
3. **Writes tests** (unit, integration, e2e)
4. **Updates documentation**
5. **Shows progress** in real-time

**AI output**:
```text
Building: Workout History with Filters

PR 1/3: Backend Filter Logic
├─ ✅ Modified backend/src/routes/workouts.ts
├─ ✅ Modified backend/src/services/workoutService.ts
├─ ✅ Created backend/src/database/migrations/20250115_add_workout_filters_index.sql
├─ ✅ Wrote 6 unit tests (workoutService.test.ts)
├─ ✅ Wrote 5 integration tests (workouts.api.test.ts)
└─ ✅ All tests pass (11/11)

PR 2/3: Frontend Filter UI
├─ ✅ Created frontend/src/components/FilterModal.tsx
├─ ✅ Created frontend/src/hooks/useWorkoutFilters.ts
├─ ✅ Added Storybook stories
├─ ✅ Wrote 6 component tests
└─ ✅ All tests pass (6/6)

PR 3/3: Integration
├─ ✅ Modified frontend/src/screens/WorkoutHistoryScreen.tsx
├─ ✅ Connected filter UI to API
├─ ✅ Added loading states
├─ ✅ Wrote 3 E2E tests
├─ ✅ Updated USER_GUIDE.md
└─ ✅ All tests pass (3/3)

Build Complete! 🎉

Summary:
- Files created: 4
- Files modified: 4
- Tests written: 20
- Tests passing: 20/20
- Documentation: Updated

Next steps:
1. Review the code
2. Test manually
3. Create PRs (or use /pr create)
4. Deploy (or use /release)

Review now? [yes/later]
```

---

### Manual Review

Always review AI-generated code:

```bash
/review
```

AI shows:
- Changed files
- Test results
- Security analysis
- Performance impact
- Potential issues

**You approve or request fixes.**

---

## 5. Multi-Window Development

For complex features, use multiple AI windows working in parallel.

### Command

```bash
/parallel build [feature-name]
```

### Example

```bash
/parallel build workout history with filters
```

**What AI does**:

1. **Creates snapshot** of current project state
2. **Splits work** into parallel tasks
3. **Creates session files** for each agent
4. **Generates window prompts**

**AI output**:
```text
Multi-Window Setup: Workout History with Filters

Snapshot: context-v18 (created)
Sessions: 4 agents assigned

Open 4 new AI windows and paste these prompts:

┌────────────────────────────────────────────────┐
│ Window 1: Backend Agent                        │
│ /agent backend resume workout-filters-backend  │
│                                                │
│ Tasks:                                         │
│ - Modify API endpoint (add query params)       │
│ - Add filter logic to service                  │
│ - Write unit + integration tests               │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│ Window 2: Frontend Agent                       │
│ /agent frontend resume workout-filters-frontend│
│                                                │
│ Tasks:                                         │
│ - Create FilterModal component                 │
│ - Create useWorkoutFilters hook                │
│ - Write component tests                        │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│ Window 3: QA Agent                             │
│ /agent qa resume workout-filters-qa            │
│                                                │
│ Tasks:                                         │
│ - Write E2E tests                              │
│ - Test edge cases                              │
│ - Verify filter combinations                   │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│ Window 4: Review Agent                         │
│ /agent reviewer resume workout-filters-review  │
│                                                │
│ Tasks:                                         │
│ - Wait for other agents to complete            │
│ - Review all changes                           │
│ - Check for conflicts                          │
│ - Validate consistency                         │
└────────────────────────────────────────────────┘

When all windows report completion, return here and run:
/parallel merge workout-filters
```

**Your job**: Copy each prompt into a new AI chat window, let them work, then merge.

---

### Merge Results

After all windows finish:

```bash
/parallel merge workout-filters
```

**AI output**:
```text
Merging: Workout History with Filters

Reading handoffs:
✅ Backend agent (completed)
✅ Frontend agent (completed)
✅ QA agent (completed)
✅ Review agent (completed)

Checking for conflicts:
✅ No overlapping file edits
✅ API contract matches between backend and frontend
✅ All tests pass (20/20)
✅ No architecture conflicts

Merging changes:
✅ Integrated 8 files
✅ Updated context files
✅ Refreshed cache

Merge complete! 🎉

Summary:
- Agents: 4
- Files changed: 8
- Tests: 20/20 passing
- Conflicts: 0
- Warnings: 0

Ready for PR or deployment.
```

---

## 6. Keeping Context Fresh

AI needs up-to-date understanding of your codebase. Sync regularly.

### When to Sync

Run `/sync` after:
- ✅ Major code changes
- ✅ Architecture refactoring
- ✅ Database schema changes
- ✅ Dependency updates
- ✅ New features merged
- ✅ Releases/deployments
- ✅ Manual file edits
- ✅ Pull requests merged

### Command

```bash
/sync
```

**What AI does**:
1. Rescans codebase
2. Updates context files
3. Refreshes cache
4. Reports changes detected

**AI output**:
```text
Syncing project context...

Scanning changes:
- 15 files modified
- 3 files added
- 1 file deleted
- 2 dependencies updated

Updating context:
✅ architecture.md (updated)
✅ routes.md (updated)
✅ dependencies.md (updated)
✅ modules.md (updated)

Refreshing cache:
✅ repomap.json
✅ architecture-summary.md
✅ routes.md

Detected changes:
- New API endpoint: GET /api/workouts (with filters)
- New component: FilterModal
- New hook: useWorkoutFilters
- Updated dependencies: date-fns@2.30.0 → 3.0.0

Sync complete! ✅

I'm now up to date with the codebase.
```

---

## 7. Common Workflows

### Workflow A: Bug Fix

```bash
/fix [bug description]
```

**Example**:
```bash
/fix login button doesn't work on iOS Safari
```

AI:
1. Investigates issue
2. Identifies root cause
3. Proposes fix
4. Implements fix
5. Tests fix
6. Reports result

---

### Workflow B: Code Audit

```bash
/audit
```

AI checks:
- Code quality
- Security vulnerabilities
- Performance issues
- Technical debt
- Test coverage
- Documentation gaps

---

### Workflow C: Refactoring

```bash
/refactor [module]
```

**Example**:
```bash
/refactor auth module to use OAuth2
```

AI:
1. Analyzes current implementation
2. Proposes refactoring plan
3. Identifies risks
4. Asks for approval
5. Implements changes
6. Ensures tests pass

---

### Workflow D: Add Tests

```bash
/test [module]
```

**Example**:
```bash
/test workout service
```

AI writes:
- Unit tests
- Integration tests
- E2E tests (if applicable)

---

### Workflow E: Update Documentation

```bash
/docs update
```

AI:
1. Scans code
2. Identifies undocumented features
3. Generates documentation
4. Updates README, API docs, guides

---

### Workflow F: Deployment

```bash
/release prepare [feature]
```

AI:
1. Runs all gates
2. Generates changelog
3. Creates deployment notes
4. Identifies risks
5. Waits for approval

Then:
```bash
/release deploy [feature]
```

---

## 8. Best Practices

### For Non-Technical Users

1. **Always use `/design` before `/build`**
   - Prevents unnecessary rework
   - Clarifies requirements upfront

2. **Run `/sync` regularly**
   - After major changes
   - Weekly for active projects

3. **Use `/status` to stay informed**
   - Check project health
   - See what's in progress

4. **Ask questions**
   - "Explain this in simple terms"
   - "What are the risks?"
   - "Is there a simpler way?"

5. **Test before deploying**
   - Use staging environment
   - Test manually
   - Get feedback

---

### For Technical Users

1. **Review context files**
   - Ensure AI understands your architecture
   - Update manually if AI gets it wrong

2. **Customize agents**
   - Define agent roles clearly
   - Set constraints (what agents can/cannot do)

3. **Use version control**
   - Commit `.ai/context/` to Git
   - Add `.ai/runtime/` to `.gitignore`

4. **Write custom commands**
   - Automate repetitive workflows
   - Create shortcuts for your team

5. **Monitor AI output**
   - Review all AI-generated code
   - Run linters and tests
   - Use CI/CD to catch issues

---

### For Teams

1. **Shared context**
   - Commit `.ai/` to Git (except runtime/)
   - Keep context files updated
   - Document team conventions

2. **Code review AI changes**
   - Treat AI as junior developer
   - Review PRs thoroughly
   - Test in staging

3. **Consistent workflows**
   - Use same commands across team
   - Document team-specific processes
   - Create shared agent definitions

4. **Regular syncs**
   - After merging PRs
   - Weekly context updates
   - Post-release syncs

---

## Summary

**Core Commands**:
- `/init from repo` - Add AI Workflow to existing project
- `/init from idea: ...` - Start new project
- `/design [feature]` - Plan feature (goes through 3 gates)
- `/build approved [feature]` - Build after approval
- `/parallel build [feature]` - Multi-window development
- `/sync` - Keep context fresh
- `/fix [bug]` - Fix bugs
- `/audit` - Check code quality
- `/review` - Review changes
- `/release` - Deploy to production

**Workflow**:
1. Initialize → 2. Design (3 gates) → 3. Build → 4. Review → 5. Release

**Key Principles**:
- AI asks before changing architecture
- All features go through HITL gates
- Sync regularly to keep AI informed
- Review all AI-generated code
- Test before deploying

🚀 **Ready to build with AI!**
