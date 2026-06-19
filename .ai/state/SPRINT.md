<!-- TEMPLATE - every [bracketed] value is an INERT placeholder. If an agent sees bracketed placeholders, treat this file as not-yet-populated (no real content). Fill via /init, /design, /status. -->

# SPRINT - Sprint Planning & Execution Tracker

**How to Use**: This is a manually-maintained DOCUMENT that tracks the current sprint's execution from planning through retrospective. It is not driven by any dedicated slash command — keep it current by hand, or let `/design` (planning), `/status` (progress), and `/sync` (reconcile with context) update it as a side effect.

**When to Update**: 
- Sprint Planning (start of sprint)
- Daily standup (daily updates)
- Task completion or status changes
- When risks or blockers emerge
- Sprint Review (end of sprint)
- Sprint Retrospective (end of sprint)

**Updated By**: Orchestrator, Scrum Master, Team Members, Agents  
**Read By**: All team members, stakeholders, Scrum Master, Product Owner

---

## Sprint Overview

**Format**: Current sprint metadata

```
**Sprint**: {Sprint number or name}  
**Sprint Goal**: {One sentence - what value this sprint delivers}  
**Start Date**: {YYYY-MM-DD}  
**End Date**: {YYYY-MM-DD}  
**Duration**: {X weeks}  
**Team Capacity**: {Story points or hours}  
**Committed Work**: {Story points or hours}  
**Status**: {Planning/Active/Review/Complete}  
```

**Example**:
```
**Sprint**: Sprint 5 - Order Management Redesign  
**Sprint Goal**: Enable customers to cancel and modify orders with automated refunds  
**Start Date**: 2026-06-17  
**End Date**: 2026-07-01  
**Duration**: 2 weeks  
**Team Capacity**: 40 story points  
**Committed Work**: 38 story points (95% capacity)  
**Status**: Active  
```

---

## Sprint Goal

**Format**: Clear, measurable sprint objective

```
### Primary Goal
{One sentence describing the main value delivered this sprint}

### Success Criteria
- {Measurable outcome 1}
- {Measurable outcome 2}
- {Measurable outcome 3}

### Why This Sprint?
{Brief context on why this work is prioritized now}

### Dependencies
{External dependencies or prerequisites}

### Out of Scope
{What's explicitly NOT included to prevent scope creep}
```

**Example**:
```
### Primary Goal
Enable customers to cancel full or partial orders with automated refund processing.

### Success Criteria
- API supports full and partial order cancellation
- UI allows item selection for partial cancellation
- Refunds are processed automatically via payment gateway
- Order status updates correctly (cancelled, partially cancelled)
- E2E tests cover all cancellation scenarios
- Documentation updated for support team

### Why This Sprint?
Customer support receives 200+ cancellation requests per week (manual process). This automation reduces support load by 60% and improves customer satisfaction with self-service.

### Dependencies
- Payment gateway API access (RESOLVED - credentials obtained)
- Shipping integration for cancellation cutoff (RESOLVED - API ready)

### Out of Scope
- Returns and exchanges (separate workflow - Sprint 7)
- Subscription cancellations (different system - Q3)
- Refund to store credit option (future enhancement)
```

---
## Sprint Tasks

**Format**: Detailed task tracking with status

```
### {Task ID}: {Title}
**Priority**: {P0/P1/P2}  
**Status**: {Not Started/In Progress/Testing/Review/Blocked/Complete}  
**Assigned To**: {Agent or Person}  
**Estimate**: {Story points}  
**Actual**: {Story points or hours spent}  
**Progress**: {0-100%}  

**Description**: {Brief summary}

**Acceptance Criteria**:
- [ ] {Criteria 1}
- [ ] {Criteria 2}
- [ ] {Criteria 3}

**Dependencies**: {Task IDs or "None"}  
**Blockers**: {Active blockers or "None"}  
**Notes**: {Updates, decisions, or important information}  
```

**Status Definitions**:
- **Not Started**: Task hasn't begun
- **In Progress**: Actively being worked on
- **Testing**: Implementation complete, in testing phase
- **Review**: Code review or QA review
- **Blocked**: Cannot proceed due to blocker
- **Complete**: All acceptance criteria met, merged, deployed (if applicable)

**Example**:
```
### TASK-145: Implement order cancellation API endpoint
**Priority**: P0  
**Status**: Complete  
**Assigned To**: Backend Agent  
**Estimate**: 5 story points  
**Actual**: 6 story points  
**Progress**: 100%  

**Description**: Create POST /api/orders/:id/cancel endpoint with partial cancellation support and refund calculation.

**Acceptance Criteria**:
- [x] Accept order ID and list of items to cancel
- [x] Calculate partial refund amount based on items
- [x] Update order status (fully cancelled / partially cancelled)
- [x] Trigger refund via payment gateway
- [x] Return updated order with cancellation details
- [x] Handle edge cases (already shipped items, refund failures)

**Dependencies**: None  
**Blockers**: None  
**Notes**: Added extra validation for shipped items (prevents cancellation if shipped). Implemented retry logic for payment gateway timeouts.

---

### TASK-146: Create order cancellation UI flow
**Priority**: P1  
**Status**: In Progress  
**Assigned To**: Frontend Agent  
**Estimate**: 8 story points  
**Actual**: 5 story points (ongoing)  
**Progress**: 70%  

**Description**: Build user-facing UI for cancelling full or partial orders with refund preview.

**Acceptance Criteria**:
- [x] Display list of cancellable items with prices
- [x] Allow selection of specific items to cancel
- [x] Show refund amount calculation in real-time
- [ ] Confirm cancellation with modal dialog
- [ ] Display success/error messages
- [ ] Update order display after cancellation

**Dependencies**: TASK-145 (Complete)  
**Blockers**: None  
**Notes**: Real-time refund calculation working. Modal dialog in progress. ETA: Tomorrow.

---

### TASK-147: E2E tests for order cancellation flow
**Priority**: P1  
**Status**: Not Started  
**Assigned To**: QA Agent  
**Estimate**: 3 story points  
**Actual**: 0 story points  
**Progress**: 0%  

**Description**: Automated E2E tests covering full and partial order cancellation scenarios.

**Acceptance Criteria**:
- [ ] Test full order cancellation
- [ ] Test partial order cancellation (select specific items)
- [ ] Test refund calculation accuracy
- [ ] Test cancellation of already-shipped orders (should fail)
- [ ] Test concurrent cancellation attempts
- [ ] Test payment gateway timeout handling

**Dependencies**: TASK-145 (Complete), TASK-146 (In Progress)  
**Blockers**: Waiting for TASK-146 to complete  
**Notes**: Will start testing as soon as UI is ready. Payment gateway sandbox account configured.
```

---

## Sprint Burndown

**Format**: Daily tracking of remaining work

```
| Date | Completed Points | Remaining Points | Notes |
|------|------------------|------------------|-------|
| {date} | {points} | {points} | {note} |
```

**Example**:
```
| Date | Completed Points | Remaining Points | Notes |
|------|------------------|------------------|-------|
| 2026-06-17 | 0 | 38 | Sprint started, planning complete |
| 2026-06-18 | 3 | 35 | TASK-148 complete (3 pts) |
| 2026-06-19 | 8 | 30 | TASK-145 complete (5 pts) |
| 2026-06-20 | 8 | 30 | No tasks completed (design work) |
| 2026-06-21 | 13 | 25 | TASK-149 complete (5 pts) |
| 2026-06-24 | 20 | 18 | TASK-150, TASK-151 complete (7 pts) |
| 2026-06-25 | 27 | 11 | TASK-146 nearing completion (7 pts) |
| 2026-06-26 | 35 | 3 | TASK-146, TASK-147 complete (11 pts) |
| 2026-06-27 | 38 | 0 | TASK-152 complete - Sprint Goal achieved! |
```

**Burndown Chart** (conceptual):
```
38 |●
   |  ●
30 |    ● ●
   |        ●
20 |          ●
   |            ●
10 |              ●
   |                ●
 0 |__________________●____
   17 18 19 20 21 24 25 26 27
```

---

## Risks & Issues

**Format**: Active risks and mitigation strategies

```
### Risk/Issue {N}: {Title}
**Type**: {Risk/Issue/Blocker}  
**Severity**: {CRITICAL/HIGH/MEDIUM/LOW}  
**Probability**: {HIGH/MEDIUM/LOW} (for risks)  
**Impact**: {Description of potential impact}  
**Status**: {Active/Monitoring/Mitigated/Resolved}  

**Mitigation Strategy**: {How we're addressing this}  
**Owner**: {Who's responsible}  
**Raised**: {Date}  
**Last Updated**: {Date}  
```

**Type Definitions**:
- **Risk**: Potential future problem
- **Issue**: Current problem affecting progress
- **Blocker**: Prevents task completion

**Example**:
```
### Risk 1: Payment Gateway Rate Limiting
**Type**: Risk  
**Severity**: MEDIUM  
**Probability**: MEDIUM  
**Impact**: E2E tests may fail or timeout during test runs, affecting sprint completion confidence.  
**Status**: Mitigated  

**Mitigation Strategy**: 
- Implemented retry logic with exponential backoff
- Using mock payment service for 80% of tests
- Reserved real gateway tests for critical paths only
- Coordinated with payment provider for increased test limits

**Owner**: QA Agent  
**Raised**: 2026-06-18  
**Last Updated**: 2026-06-20  

---

### Issue 2: Frontend Agent Context Switch
**Type**: Issue  
**Severity**: LOW  
**Probability**: N/A (current issue)  
**Impact**: Frontend Agent was pulled to fix production bug (2 hours lost), delaying TASK-146 by half day.  
**Status**: Resolved  

**Mitigation Strategy**: 
- Bug fixed and deployed
- Frontend Agent back on sprint work
- Adjusted task estimates (added buffer)
- No impact to sprint goal

**Owner**: Scrum Master  
**Raised**: 2026-06-23  
**Last Updated**: 2026-06-23  

---

### Risk 3: Scope Creep - Subscription Cancellations
**Type**: Risk  
**Severity**: HIGH  
**Probability**: LOW  
**Impact**: Product Owner mentioned subscription cancellations during demo; if added to sprint, would jeopardize sprint goal.  
**Status**: Monitoring  

**Mitigation Strategy**: 
- Clarified out-of-scope during sprint planning
- Documented in "Out of Scope" section
- Product Owner agreed to defer to Q3
- Will revisit in backlog grooming

**Owner**: Scrum Master  
**Raised**: 2026-06-20  
**Last Updated**: 2026-06-24  
```

---

## Sprint Metrics

**Format**: Quantitative sprint health indicators

```
### Velocity
**Planned**: {story points}  
**Completed**: {story points}  
**Completion Rate**: {percent}%  
**Historical Average**: {story points per sprint}  
**Trend**: {↑ Increasing / → Stable / ↓ Decreasing}  

### Burndown
**Days Elapsed**: {X} / {Total}  
**Work Completed**: {percent}%  
**On Track**: {Yes/No - based on ideal burndown}  
**Projected Completion**: {Date or "On time"}  

### Quality
**Test Coverage**: {percent}% ({trend} from last sprint)  
**Bugs Found**: {count} (in sprint work)  
**Code Review Pass Rate**: {percent}% (first-time approval)  
**Technical Debt Added**: {count} items  

### Team Performance
**Tasks Completed**: {count}  
**Tasks In Progress**: {count}  
**Tasks Blocked**: {count}  
**Average Cycle Time**: {days} days (from start to done)  
**Scope Changes**: {count} (tasks added/removed mid-sprint)  
```

**Example**:
```
### Velocity
**Planned**: 38 story points  
**Completed**: 35 story points (as of day 8/10)  
**Completion Rate**: 92% (projected)  
**Historical Average**: 36 story points per sprint  
**Trend**: → Stable  

### Burndown
**Days Elapsed**: 8 / 10  
**Work Completed**: 92% (35/38 points)  
**On Track**: Yes (ahead of ideal burndown)  
**Projected Completion**: 2026-06-27 (on time)  

### Quality
**Test Coverage**: 89% (↑ 2% from last sprint)  
**Bugs Found**: 3 (all fixed within sprint)  
**Code Review Pass Rate**: 94% (first-time approval)  
**Technical Debt Added**: 1 item (payment retry logic - LOW priority)  

### Team Performance
**Tasks Completed**: 8 / 11  
**Tasks In Progress**: 2  
**Tasks Blocked**: 0  
**Average Cycle Time**: 2.3 days (from start to done)  
**Scope Changes**: 0 (no scope creep)  
```

---

## Daily Standup

**Format**: Daily team sync (15 minutes max)

```
### Standup - {YYYY-MM-DD}

#### {Agent/Team Member Name}
**Yesterday**:
- {What was accomplished}
- {What was accomplished}

**Today**:
- {What will be worked on}
- {What will be worked on}

**Blockers**:
- {Blocker or "None"}

---

#### {Next Team Member}
...
```

**Standup Guidelines**:
- **Keep it brief**: 2-3 minutes per person max
- **Focus on sprint goal**: How does your work contribute?
- **Raise blockers immediately**: Don't wait for resolution
- **Update task status**: Mark progress in Sprint Tasks section
- **Be specific**: "Completed TASK-145" not "worked on backend"

**Example**:
```
### Standup - 2026-06-24

#### Backend Agent
**Yesterday**:
- Completed TASK-145 (order cancellation API endpoint)
- Fixed edge case with shipped items validation
- Reviewed TASK-146 (frontend integration)

**Today**:
- Support QA Agent with E2E test setup
- Begin TASK-152 (refund notification emails)

**Blockers**:
- None

---

#### Frontend Agent
**Yesterday**:
- Implemented item selection UI (TASK-146)
- Added real-time refund calculation
- Started confirmation modal dialog

**Today**:
- Complete confirmation modal (TASK-146)
- Add success/error messaging
- Test integration with backend API

**Blockers**:
- None

---

#### QA Agent
**Yesterday**:
- Configured payment gateway sandbox
- Reviewed TASK-145 acceptance criteria
- Planned E2E test scenarios

**Today**:
- Wait for TASK-146 completion
- Begin E2E test implementation (TASK-147)
- Test full cancellation flow first

**Blockers**:
- Waiting for TASK-146 (Frontend Agent estimates completion today)

---

#### Scrum Master Notes
- Sprint 70% complete (day 6/10)
- On track to meet sprint goal
- No active blockers
- Frontend Agent pulled for prod bug fix yesterday (2 hours) - back on track now
```

---
## Sprint Planning Checklist

**Use this checklist at sprint start to ensure proper planning**

```
### Pre-Planning (1 day before)
- [ ] Review backlog (ensure "Next" section has enough refined work)
- [ ] Review previous sprint retrospective action items
- [ ] Confirm team capacity (time off, holidays, known commitments)
- [ ] Prepare sprint goal options (discuss with Product Owner)
- [ ] Estimate or re-estimate top backlog items

### Sprint Planning Meeting (Part 1: What - 1-2 hours)
- [ ] Review previous sprint outcomes
- [ ] Define sprint goal (one clear sentence)
- [ ] Define success criteria (3-5 measurable outcomes)
- [ ] Select backlog items supporting sprint goal
- [ ] Verify team capacity vs. committed work (aim for 80-90%)
- [ ] Identify dependencies and risks
- [ ] Clarify out-of-scope to prevent scope creep
- [ ] Get team commitment on sprint goal

### Sprint Planning Meeting (Part 2: How - 1-2 hours)
- [ ] Break down selected items into tasks
- [ ] Assign tasks to team members/agents
- [ ] Identify technical approach for each task
- [ ] Define acceptance criteria (if not already detailed)
- [ ] Estimate each task (story points or hours)
- [ ] Identify task dependencies
- [ ] Create initial task board (Not Started/In Progress/Done)
- [ ] Schedule daily standups

### Post-Planning (same day)
- [ ] Update SPRINT.md with sprint overview
- [ ] Move selected tasks from BACKLOG.md to SPRINT.md
- [ ] Update STATUS.md with new sprint info
- [ ] Create burndown tracking table
- [ ] Document known risks and mitigation strategies
- [ ] Share sprint plan with stakeholders
- [ ] Set up monitoring and alerts (if applicable)
```

---

## Sprint Review

**Format**: Demo and sprint outcome review (end of sprint)

```
### Sprint Review - {Sprint Name} - {Date}

#### Sprint Goal
{Restate the sprint goal}

#### Goal Achievement
**Status**: {Achieved / Partially Achieved / Not Achieved}  
**Completion**: {percent}%  
**Summary**: {Brief explanation of outcome}

#### Completed Work
**Tasks Completed**: {count} / {total}  
**Story Points Completed**: {points} / {planned}  

**Key Deliverables**:
- {Deliverable 1 with link or reference}
- {Deliverable 2 with link or reference}
- {Deliverable 3 with link or reference}

#### Incomplete Work
**Tasks Not Completed**: {count}  
**Reason**: {Why - scope, blockers, estimation errors}  
**Next Steps**: {Moved to next sprint / deprioritized / cancelled}

**Incomplete Items**:
- {Task ID}: {Title} - {Reason}
- {Task ID}: {Title} - {Reason}

#### Stakeholder Feedback
**Attendees**: {Names}  
**Demo Notes**: {What was demonstrated}  
**Feedback**:
- {Positive feedback or approval}
- {Concerns or change requests}
- {Questions raised}

#### Metrics
- **Velocity**: {completed points}
- **Completion Rate**: {percent}%
- **Burndown**: {On track / Behind / Ahead}
- **Test Coverage**: {percent}%
- **Bugs Found**: {count}
```

**Example**:
```
### Sprint Review - Sprint 5: Order Management Redesign - 2026-06-28

#### Sprint Goal
Enable customers to cancel full or partial orders with automated refund processing.

#### Goal Achievement
**Status**: Achieved  
**Completion**: 92% (35/38 story points)  
**Summary**: Successfully delivered order cancellation API, UI, and E2E tests. All success criteria met. Remaining 3 points (email notifications) moved to next sprint as nice-to-have enhancement.

#### Completed Work
**Tasks Completed**: 10 / 11  
**Story Points Completed**: 35 / 38  

**Key Deliverables**:
- POST /api/orders/:id/cancel endpoint with partial cancellation support
- Order cancellation UI with item selection and refund preview
- E2E test suite covering all cancellation scenarios
- Updated API documentation
- Support team runbook for cancellation edge cases

#### Incomplete Work
**Tasks Not Completed**: 1  
**Reason**: De-prioritized as non-critical enhancement  
**Next Steps**: Moved to Sprint 6 backlog  

**Incomplete Items**:
- TASK-152: Refund notification emails (3 pts) - Not critical for launch, existing order update emails sufficient

#### Stakeholder Feedback
**Attendees**: Product Owner, CTO, Support Team Lead, Dev Team  
**Demo Notes**: Demonstrated full and partial cancellation flows, including edge cases (shipped items, payment failures)  
**Feedback**:
- ✅ Product Owner: "Exactly what we needed - clean UI, handles all cases"
- ✅ Support Lead: "This will reduce our ticket load significantly"
- 💡 CTO: "Consider adding cancellation reason tracking for analytics" (added to backlog as TASK-160)
- ❓ Question: "What about subscription cancellations?" (Out of scope - Q3 roadmap)

#### Metrics
- **Velocity**: 35 story points
- **Completion Rate**: 92%
- **Burndown**: Ahead of schedule (finished day 9/10)
- **Test Coverage**: 89% (↑ 2% from Sprint 4)
- **Bugs Found**: 3 (all fixed within sprint)
```

---
## Sprint Retrospective

**Format**: Team reflection and continuous improvement (end of sprint)

```
### Retrospective - {Sprint Name} - {Date}

#### What Went Well 🟢
{Things the team should continue doing}
- {Item 1}
- {Item 2}
- {Item 3}

#### What Didn't Go Well 🔴
{Things that caused problems or friction}
- {Item 1}
- {Item 2}
- {Item 3}

#### What We Learned 💡
{New insights or knowledge gained}
- {Item 1}
- {Item 2}
- {Item 3}

#### Action Items for Next Sprint 🎯
**Format per item**: {Action} - Owner: {Name} - Due: {Date or "Next Sprint"}
- [ ] {Action item 1} - Owner: {Name}
- [ ] {Action item 2} - Owner: {Name}
- [ ] {Action item 3} - Owner: {Name}

#### Experiment Ideas 🧪
{Things to try in next sprint}
- {Experiment 1}
- {Experiment 2}
```

**Retrospective Guidelines**:
- **Safe space**: No blame, focus on process not people
- **Data-driven**: Use metrics and examples
- **Actionable**: Each "didn't go well" should have an action item
- **Specific**: Avoid vague statements like "better communication"
- **Follow through**: Review previous retrospective action items
- **Time-boxed**: 60-90 minutes max

**Example**:
```
### Retrospective - Sprint 5: Order Management Redesign - 2026-06-28

#### What Went Well 🟢
- **Early API completion** (TASK-145) allowed frontend to start integration sooner
- **Payment gateway sandbox** setup went smoothly; no test environment issues
- **Clear acceptance criteria** prevented scope ambiguity and rework
- **Backend/Frontend collaboration** on refund calculation logic worked well (paired on design)
- **Finished ahead of schedule** (day 9/10) - good capacity planning

#### What Didn't Go Well 🔴
- **Production bug interrupted sprint** - Frontend Agent lost 2 hours on day 7 (scope creep from prod support)
- **TASK-146 estimate was low** - 8 pts took 11 pts actual; UI complexity underestimated
- **Late dependency discovery** - Realized we needed shipping integration for cancellation cutoff on day 3
- **Limited testing on mobile** - E2E tests focused on desktop; mobile UI not validated
- **Documentation created at end** - Should have been incremental; rushed at sprint end

#### What We Learned 💡
- **Payment gateway retry logic** is critical; failures are more common than expected (10% failure rate in sandbox)
- **Partial cancellation UX** is complex; users need clearer guidance on item selection
- **Shipping integration** has data lag (15 minutes); affects real-time cancellation cutoff accuracy
- **Team velocity** stabilizing around 35-38 points per sprint (3 sprints consistent)

#### Action Items for Next Sprint 🎯
- [ ] **Add production support rotation** to prevent sprint interruptions - Owner: Scrum Master - Due: Before Sprint 6
- [ ] **Improve estimation** for UI tasks (add 20% buffer for UX complexity) - Owner: Frontend Agent - Due: Next planning
- [ ] **Dependency checklist** during sprint planning (API integrations, data sources) - Owner: Scrum Master - Due: Sprint 6 planning
- [ ] **Mobile testing protocol** for all UI tasks - Owner: QA Agent - Due: Sprint 6 start
- [ ] **Incremental documentation** (update docs as features complete, not at end) - Owner: All agents - Due: Ongoing

#### Experiment Ideas 🧪
- **Pair programming** for complex estimation (Frontend + Backend) - Try on TASK-160 (cancellation analytics)
- **Mid-sprint checkpoint** (day 5) to catch scope/estimate issues earlier
- **Definition of Done** includes mobile validation (add to acceptance criteria template)
```

---

## Sprint Retrospective Template

**Use this template to run retrospectives efficiently**

### Preparation (15 minutes before meeting)
```
1. Review sprint metrics (velocity, burndown, quality)
2. Review daily standup notes for recurring themes
3. Review previous retrospective action items (completed?)
4. Prepare examples for discussion (specific incidents)
```

### Meeting Structure (60-90 minutes)

#### 1. Set the Stage (5 minutes)
```
- Welcome and purpose reminder
- Review retrospective norms (safe space, respect, actionable)
- Set time boxes for each section
```

#### 2. Gather Data (15 minutes)
```
- Each person adds items to:
  * What Went Well (green sticky notes)
  * What Didn't Go Well (red sticky notes)
  * What We Learned (blue sticky notes)
- Silent writing (5 minutes)
- Read aloud and group similar items (10 minutes)
```

#### 3. Generate Insights (20 minutes)
```
- Vote on top 3 items to discuss (dot voting)
- Deep dive on each top item:
  * What happened?
  * Why did it happen? (5 Whys technique)
  * What can we control?
- Document insights and patterns
```

#### 4. Decide What to Do (20 minutes)
```
- For each "What Didn't Go Well":
  * Propose action items
  * Assign owner
  * Set target completion
- Prioritize action items (max 3-5)
- Define success criteria for each action
```

#### 5. Close the Retrospective (10 minutes)
```
- Summarize action items
- Review previous action item completion
- Appreciate team members (shout-outs)
- Retrospective feedback (how was the meeting itself?)
```

---
## Maintaining This Document

**SPRINT.md is a manually-maintained document.** No slash command drives it directly — the sprint sections below are structures you fill in by hand. The registered commands touch this file only as a side effect:

### Planning a sprint (use `/design` or edit by hand)
```
1. Review BACKLOG.md "Next" section
2. Decide sprint goal and duration
3. Select tasks for the sprint (based on capacity)
4. Fill in the Sprint Overview and Sprint Tasks sections below
5. Start the burndown table
6. Reflect the new sprint in STATUS.md
```

### Tracking progress (use `/status` or edit by hand)
```
1. Update task status and progress in Sprint Tasks
2. Add a row to the Sprint Burndown table
3. Record new risks or blockers in Risks & Issues
4. Update the daily standup notes section
```

### Reconciling with context (use `/sync`)
```
1. Cross-check sprint work against .ai/context/ documents
2. Surface drift between planned work and current task state
3. Update STATUS.md / CURRENT.md as needed
```

### Review & retrospective (edit by hand)
```
1. Fill in the Sprint Review section (outcomes, metrics, feedback)
2. Fill in the Sprint Retrospective section (what went well / didn't / learned)
3. Keep the completed sprint inline here for history (no separate report archive)
```

---
## Sprint Anti-Patterns to Avoid

### 🚫 Common Mistakes

**1. Vague Sprint Goal**
```
❌ Bad: "Work on order management"
✅ Good: "Enable customers to cancel orders with automated refunds"
```

**2. Over-Commitment**
```
❌ Bad: Committing 50 story points when historical velocity is 35
✅ Good: Commit 32 points (90% of capacity) with 3 point buffer
```

**3. No Acceptance Criteria**
```
❌ Bad: "Implement cancellation feature"
✅ Good: 
- Accept order ID and items to cancel
- Calculate refund based on items
- Update order status
- Trigger payment gateway refund
- Return updated order
```

**4. Scope Creep Mid-Sprint**
```
❌ Bad: Adding new features when stakeholder requests during sprint
✅ Good: Document new requests in BACKLOG.md, discuss in next planning
```

**5. No Daily Updates**
```
❌ Bad: Standup every 2-3 days or skipped
✅ Good: Daily 15-minute standup, even if "no updates"
```

**6. Ignoring Blockers**
```
❌ Bad: Waiting days to escalate blocker
✅ Good: Raise blocker immediately in standup, escalate same day
```

**7. Moving Goalposts**
```
❌ Bad: Changing sprint goal mid-sprint
✅ Good: Commit to goal, adjust next sprint if priorities shift
```

**8. No Retrospective Action Items**
```
❌ Bad: "Good sprint, no changes needed" every retrospective
✅ Good: Always identify 2-3 improvement actions
```

**9. Carrying Over Incomplete Work Repeatedly**
```
❌ Bad: Same task incomplete for 3 sprints
✅ Good: Re-evaluate priority, break down, or remove from backlog
```

**10. No Celebration**
```
❌ Bad: Sprint ends, immediately start next sprint
✅ Good: Celebrate achievements, recognize contributions
```

---

## Sprint Health Indicators

### 🟢 Healthy Sprint

- Sprint goal is clear and measurable
- Team committed to realistic capacity (80-90%)
- All tasks have acceptance criteria
- Burndown tracking ideal line
- No blockers older than 2 days
- Daily standups happening consistently
- Test coverage increasing or stable
- Velocity within 10% of historical average
- Team morale positive
- Stakeholder feedback incorporated

### 🟡 At-Risk Sprint

- Sprint goal ambiguous or too broad
- Committed work >95% capacity
- Some tasks missing acceptance criteria
- Burndown slightly behind ideal line
- 1-2 blockers with mitigation in place
- Standups occasionally skipped
- Test coverage flat or slightly decreasing
- Velocity 10-20% below historical average
- Some team friction or low morale
- Scope creep pressure (resisted)

### 🔴 Unhealthy Sprint

- No clear sprint goal or constantly changing
- Committed work >100% capacity
- Many tasks vague or missing criteria
- Burndown significantly behind ideal line
- Multiple blockers without mitigation
- Standups irregular or not happening
- Test coverage decreasing significantly
- Velocity >20% below historical average
- High team turnover or conflict
- Scope creep accepted without adjustment

**Actions for At-Risk or Unhealthy Sprints**:
1. Emergency retrospective (don't wait for sprint end)
2. Reduce scope (remove lowest priority tasks)
3. Escalate blockers to leadership
4. Pair programming to unblock stuck work
5. Daily check-ins with Scrum Master
6. Simplify acceptance criteria (MVP approach)
7. Consider sprint cancellation if goal unachievable

---
## Sprint Ceremonies Schedule

**Recommended schedule for 2-week sprints**

```
### Week 1
**Monday**
- 09:00-11:00: Sprint Planning (4 hours for 2-week sprint)
  * Part 1: What (define goal, select work)
  * Part 2: How (break down, estimate, assign)
- 15:00-15:15: Daily Standup

**Tuesday-Friday**
- 09:00-09:15: Daily Standup

### Week 2
**Monday-Thursday**
- 09:00-09:15: Daily Standup

**Friday**
- 09:00-09:15: Daily Standup
- 14:00-15:00: Sprint Review (demo and feedback)
- 15:15-16:45: Sprint Retrospective (reflection and improvement)
```

**Ceremony Time Allocations**:
- **Sprint Planning**: 2 hours per week of sprint (4 hours for 2-week)
- **Daily Standup**: 15 minutes (max)
- **Sprint Review**: 1 hour per week of sprint (2 hours for 2-week)
- **Sprint Retrospective**: 1.5 hours per week of sprint (3 hours for 2-week, but 90 minutes usually sufficient)

**Total Time Investment**: ~8-10 hours per 2-week sprint (~10-12% of sprint time)

---

## Related Files

- `.ai/state/STATUS.md` - Project-level health and current status
- `.ai/state/BACKLOG.md` - Work prioritization and backlog management
- `.ai/state/CURRENT.md` - Real-time session state
- `.ai/context/` - Canonical context documents (`/sync` reconciles against these)

> Note: Sprint history lives inline in this document — there is no separate sprint report archive and no dedicated sprint-ceremony workflow files. Use `/status` to record progress and `/sync` to reconcile against `.ai/context/`.

---

## Quick Reference

**Starting a sprint?** → Use Sprint Planning Checklist  
**Daily update?** → Use Daily Standup format  
**Track progress?** → Update Sprint Burndown table  
**New risk?** → Add to Risks & Issues section  
**Sprint ending?** → Run Sprint Review and Retrospective  
**Check sprint health?** → Review Sprint Metrics and Health Indicators  
**Task complete?** → Update task status and burndown  
**Blocker?** → Add to Risks & Issues, escalate in standup  

---

## Update Instructions

### Sprint Start (Day 1)
```
1. Complete Sprint Planning Checklist
2. Populate Sprint Overview section
3. Add all sprint tasks with acceptance criteria
4. Initialize Sprint Burndown table
5. Document known risks
6. Update STATUS.md with new sprint
7. Move tasks from BACKLOG.md
```

### Daily Updates (Every Day)
```
1. Run daily standup (15 minutes)
2. Update Daily Standup section
3. Update task status and progress
4. Add row to Sprint Burndown table
5. Update or add risks/blockers
6. Update Sprint Metrics (if significant change)
7. Quick sync to STATUS.md
```

### Weekly Updates (Mid-Sprint)
```
1. Review sprint progress vs. goal
2. Update Sprint Metrics
3. Review and update risks
4. Check velocity projection
5. Adjust scope if necessary (rare)
6. Stakeholder communication if needed
```

### Sprint End (Last Day)
```
1. Finalize Sprint Burndown
2. Calculate final Sprint Metrics
3. Conduct Sprint Review
4. Document Sprint Review section
5. Conduct Sprint Retrospective
6. Document Sprint Retrospective section
7. Keep the completed sprint inline here for history
8. Update STATUS.md with sprint outcome
9. Move incomplete work to BACKLOG.md
10. Prepare for next sprint planning
```

---

## Sprint Report Template (for Stakeholders)

```markdown
# Sprint {Number} Report - {Sprint Name}

**Sprint Goal**: {One sentence goal}  
**Duration**: {Start Date} to {End Date}  
**Status**: {Achieved / Partially Achieved / Not Achieved}  

## Summary
{2-3 sentence sprint outcome summary}

## Key Deliverables
- ✅ {Deliverable 1}
- ✅ {Deliverable 2}
- ✅ {Deliverable 3}

## Metrics
- **Velocity**: {completed} / {planned} story points ({percent}%)
- **Tasks Completed**: {count} / {total}
- **Test Coverage**: {percent}%
- **Bugs Found**: {count}

## Challenges & Resolutions
- **Challenge**: {Issue description}  
  **Resolution**: {How it was handled}

## Next Sprint Focus
{Brief preview of next sprint goal}

## Team Feedback
{Optional: Key stakeholder or team feedback}
```

---

**File Purpose**: Sprint planning, execution, and retrospective tracker  
**Update Frequency**: Daily (standup, burndown), End of Sprint (review, retrospective)  
**Maintained**: Manually (this is a document, not a command). `/design` plans, `/status` tracks, `/sync` reconciles.  
**Version**: 2.0
