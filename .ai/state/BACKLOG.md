<!-- TEMPLATE - every [bracketed] value is an INERT placeholder. If an agent sees bracketed placeholders, treat this file as not-yet-populated (no real content). Fill via /init, /design, /status. -->

# BACKLOG - Work Prioritization & Planning

**How to Use**: This is a manually-maintained DOCUMENT that organizes and prioritizes upcoming work across three time horizons (Now/Next/Later). It is not driven by any dedicated slash command — keep it current by hand, or let `/design` (planning) and `/status` (progress) update it as a side effect.

**When to Update**: 
- During sprint planning
- When new work is identified
- After completing "Now" tasks
- Weekly backlog grooming
- When priorities shift

**Updated By**: Orchestrator, Product Owner, Tech Lead, Team during planning  
**Read By**: All team members, stakeholders, agents planning work

---

## Understanding the Three Horizons

### Now (Current Sprint - Next 1-2 Weeks)
**Purpose**: Work committed for the current sprint  
**Criteria**: 
- Clearly defined with acceptance criteria
- Ready to implement (no open questions)
- Dependencies resolved or have workarounds
- Assigned to specific agent/person
- Sprint capacity available

**Capacity**: Should represent ~80% of sprint capacity (buffer for unknowns)

### Next (Next Sprint - 2-4 Weeks)
**Purpose**: Refined work ready for upcoming sprint  
**Criteria**:
- Well-defined but may need minor refinement
- Dependencies identified
- Technical approach understood
- Fits strategic roadmap
- Not yet assigned

**Refinement**: Review and detail during sprint planning

### Later (Future - 1+ Months)
**Purpose**: Ideas, requests, and future work  
**Criteria**:
- High-level concepts or user needs
- May need significant discovery
- Lower priority or longer-term value
- Dependencies may not be clear
- Awaiting strategic alignment

**Review**: Groom monthly, promote to "Next" as priorities clarify

---

## Now

**Format**: Tasks committed for current sprint

```
### {Task ID}: {Title}
**Priority**: {P0/P1/P2}  
**Status**: {Not Started/In Progress/Blocked/Testing/Review}  
**Assigned To**: {Agent or Person}  
**Estimate**: {Story points or time}  
**Sprint Goal**: {Which goal this supports}  

**Description**: {1-2 sentence summary}

**Acceptance Criteria**:
- {Criteria 1}
- {Criteria 2}
- {Criteria 3}

**Dependencies**: {None or list dependencies}  
**Risks**: {Known risks if any}  
```

**Example**:
```
### TASK-145: Implement order cancellation API endpoint
**Priority**: P0  
**Status**: In Progress  
**Assigned To**: Backend Agent  
**Estimate**: 5 story points  
**Sprint Goal**: Order Management v2  

**Description**: Create POST /api/orders/:id/cancel endpoint with partial cancellation support and refund calculation.

**Acceptance Criteria**:
- Accept order ID and list of items to cancel
- Calculate partial refund amount based on items
- Update order status (fully cancelled / partially cancelled)
- Trigger refund via payment gateway
- Return updated order with cancellation details
- Handle edge cases (already shipped items, refund failures)

**Dependencies**: Payment gateway API access (resolved)  
**Risks**: Payment gateway rate limiting during testing  

---

### TASK-146: Create order cancellation UI flow
**Priority**: P1  
**Status**: Not Started  
**Assigned To**: Frontend Agent  
**Estimate**: 8 story points  
**Sprint Goal**: Order Management v2  

**Description**: Build user-facing UI for cancelling full or partial orders with refund preview.

**Acceptance Criteria**:
- Display list of cancellable items with prices
- Allow selection of specific items to cancel
- Show refund amount calculation in real-time
- Confirm cancellation with modal dialog
- Display success/error messages
- Update order display after cancellation

**Dependencies**: TASK-145 (API endpoint)  
**Risks**: None  

---

### TASK-147: E2E tests for order cancellation flow
**Priority**: P1  
**Status**: Not Started  
**Assigned To**: QA Agent  
**Estimate**: 3 story points  
**Sprint Goal**: Order Management v2  

**Description**: Automated E2E tests covering full and partial order cancellation scenarios.

**Acceptance Criteria**:
- Test full order cancellation
- Test partial order cancellation (select specific items)
- Test refund calculation accuracy
- Test cancellation of already-shipped orders (should fail)
- Test concurrent cancellation attempts
- Test payment gateway timeout handling

**Dependencies**: TASK-145, TASK-146  
**Risks**: Payment gateway sandbox stability  
```

---

## Next

**Format**: Work refined for upcoming sprint

```
### {Task ID}: {Title}
**Priority**: {P0/P1/P2/P3}  
**Estimate**: {Story points or "TBD"}  
**Target Sprint**: {Sprint number or "Next"}  

**Description**: {Brief summary}

**Why Now**: {Business value or urgency}

**Key Requirements**:
- {Requirement 1}
- {Requirement 2}
- {Requirement 3}

**Technical Notes**: {Approach, concerns, or unknowns}  
**Dependencies**: {None or list dependencies}  
```

**Example**:
```
### TASK-150: Multi-tier discount system
**Priority**: P1  
**Estimate**: 13 story points  
**Target Sprint**: Sprint 6  

**Description**: Allow configurable discount tiers based on order volume, user loyalty, and seasonal promotions with rule engine.

**Why Now**: Marketing team needs this for Q3 promotion campaigns (due in 6 weeks)

**Key Requirements**:
- Support volume discounts (10+ items = 10%, 50+ = 15%)
- Support loyalty tiers (bronze/silver/gold)
- Support promotional codes with expiration
- Stack multiple discounts (with configurable limits)
- Admin UI for managing discount rules
- Real-time discount calculation in checkout

**Technical Notes**: Consider rule engine (Drools?) vs. custom logic. Need to handle discount stacking edge cases. May need discount audit log for accounting.  
**Dependencies**: None (current order system supports discount field)  

---

### TASK-151: Customer review and rating system
**Priority**: P2  
**Estimate**: 21 story points  
**Target Sprint**: Sprint 7-8 (2 sprint epic)  

**Description**: Full product review system with ratings, photos, helpful votes, and moderation queue.

**Why Now**: Customer feedback indicates reviews increase conversion by ~20%; competitor analysis shows we're behind

**Key Requirements**:
- 5-star rating system
- Text reviews (min 50 chars, max 5000 chars)
- Photo upload (up to 5 photos per review)
- "Helpful" voting on reviews
- Verified purchase badge
- Moderation queue for review approval
- Email notifications for review responses

**Technical Notes**: Large scope - may split into: (1) basic ratings, (2) reviews + photos, (3) moderation. Consider using existing image upload service. Need spam detection strategy.  
**Dependencies**: Image upload service enhancement (TASK-155)  

---

### TASK-152: Order tracking with live updates
**Priority**: P2  
**Estimate**: 8 story points  
**Target Sprint**: Sprint 6  

**Description**: Real-time order status tracking integrated with shipping carrier APIs (FedEx, UPS, USPS).

**Why Now**: Top 3 customer support request category; reduces "where's my order" inquiries

**Key Requirements**:
- Integrate with FedEx, UPS, USPS tracking APIs
- Display order status timeline (ordered → processing → shipped → delivered)
- Real-time updates via webhook from carriers
- Email notifications on status changes
- Estimated delivery date
- Handle carrier API failures gracefully

**Technical Notes**: Need webhook infrastructure for carrier callbacks. Consider polling as fallback. May need carrier sandbox accounts.  
**Dependencies**: Webhook service (TASK-156 or use existing?)  
```

---

## Later

**Format**: Future ideas and low-priority work

```
### {Idea ID or Task ID}: {Title}
**Priority**: {P3/P4/Idea}  
**Value**: {HIGH/MEDIUM/LOW}  
**Effort**: {HIGH/MEDIUM/LOW/Unknown}  

**Description**: {What is this and why might we want it}

**Potential Benefits**: {Expected value or outcome}  
**Open Questions**: {What we don't know yet}  
```

**Example**:
```
### IDEA-201: AI-powered product recommendations
**Priority**: Idea  
**Value**: HIGH  
**Effort**: HIGH  

**Description**: Use machine learning to recommend products based on browsing history, purchase patterns, and similar customer behavior.

**Potential Benefits**: 
- Increased average order value (estimated 15-25%)
- Improved customer satisfaction (personalized experience)
- Competitive advantage (few competitors have this)

**Open Questions**: 
- Build in-house vs. use 3rd party service (AWS Personalize, Google Recommendations AI)?
- Data privacy considerations (GDPR compliance)?
- Minimum data needed for accurate recommendations?
- How to handle cold-start problem (new users)?
- Integration points (homepage, product page, cart, email)?

---

### TASK-202: Mobile app (iOS and Android)
**Priority**: P3  
**Value**: HIGH  
**Effort**: HIGH (multi-quarter project)  

**Description**: Native mobile apps for iOS and Android with core shopping features (browse, search, cart, checkout, order tracking).

**Potential Benefits**: 
- Capture mobile-first users (60% of traffic is mobile web)
- Push notifications for order updates and promotions
- Better performance than mobile web
- App store presence for brand awareness

**Open Questions**: 
- React Native vs. native development?
- Feature parity with web or MVP first?
- Timeline and resource requirements (need mobile developers)?
- Backend API ready for mobile (authentication, performance)?

---

### TASK-203: Wishlist and save-for-later features
**Priority**: P3  
**Value**: MEDIUM  
**Effort**: MEDIUM  

**Description**: Allow users to save products to wishlist or move cart items to "save for later" section for future purchase.

**Potential Benefits**: 
- Reduce cart abandonment (save vs. delete)
- Re-engagement opportunity (wishlist reminder emails)
- Better user experience (planning future purchases)

**Open Questions**: 
- Share wishlist publicly (registry-style)?
- Wishlist analytics for inventory planning?
- Price drop notifications?

---

### IDEA-204: Subscription service for recurring orders
**Priority**: Idea  
**Value**: MEDIUM  
**Effort**: MEDIUM  

**Description**: Auto-reorder consumable products on a schedule (weekly, monthly, quarterly) with subscription discount.

**Potential Benefits**: 
- Predictable recurring revenue
- Increased customer lifetime value
- Reduced churn (convenience)

**Open Questions**: 
- Which product categories qualify?
- Discount model (10% off subscriptions)?
- Subscription management UI (skip, pause, cancel)?
- Payment handling (failed payments, retries)?
- Integration with inventory system?

---

### TASK-205: Advanced search with filters and facets
**Priority**: P4  
**Value**: MEDIUM  
**Effort**: MEDIUM  

**Description**: Enhance search with faceted navigation (filter by price, brand, rating, features) and advanced query support (autocomplete, spell correction).

**Potential Benefits**: 
- Easier product discovery
- Reduced search abandonment
- Better conversion on high-intent searches

**Open Questions**: 
- Upgrade to Elasticsearch or similar?
- Performance at scale (millions of products)?
- Filter options per category (dynamic facets)?
```

---

## Prioritization Framework

### Priority Levels

**P0 - Critical**
- System down or major functionality broken
- Security vulnerability
- Legal/compliance requirement
- Revenue-blocking issue

**P1 - High**
- Important feature for current sprint/quarter
- High customer impact
- Strategic initiative
- Dependency for other work

**P2 - Medium**
- Valuable but not urgent
- Quality of life improvement
- Moderate customer impact
- Can wait 1-2 sprints

**P3 - Low**
- Nice to have
- Low customer impact
- Can wait 3+ months
- Opportunistic (if capacity available)

**P4 - Backlog**
- Ideas for consideration
- Very low priority
- May never be built

### Prioritization Criteria

When deciding priority, consider:

1. **Value**: What's the business/user value?
   - Revenue impact
   - Customer satisfaction
   - Strategic alignment
   - Competitive advantage

2. **Urgency**: What's the timeline pressure?
   - External deadlines (legal, contractual)
   - Market opportunity window
   - Dependency for other work
   - Customer commitment

3. **Effort**: What's the implementation cost?
   - Story points or time estimate
   - Team capacity
   - Technical complexity
   - Dependencies and risks

4. **Risk**: What could go wrong?
   - Technical uncertainty
   - External dependencies
   - Resource availability
   - Market/customer validation

**Simple Formula**: Priority = (Value × Urgency) / (Effort × Risk)

### RICE Scoring (Optional)

For more rigorous prioritization:

**RICE = (Reach × Impact × Confidence) / Effort**

- **Reach**: How many users affected per quarter?
- **Impact**: How much impact per user? (Massive=3, High=2, Medium=1, Low=0.5, Minimal=0.25)
- **Confidence**: How confident in estimates? (High=100%, Medium=80%, Low=50%)
- **Effort**: Story points or person-months

**Example**:
```
TASK-150: Multi-tier discount system
Reach: 10,000 users per quarter
Impact: 2 (High - increases order value)
Confidence: 80% (Medium - some unknowns in rule engine)
Effort: 13 story points

RICE = (10,000 × 2 × 0.8) / 13 = 1,230.77
```

---

## Moving Tasks Between Sections

### Now → Complete (Archive to SPRINT.md)
When task is done:
```
1. Update task status to "Complete"
2. Archive to SPRINT.md or status history
3. Remove from BACKLOG.md
4. Update sprint progress
```

### Next → Now (Sprint Planning)
When promoting to current sprint:
```
1. Refine acceptance criteria (if needed)
2. Assign to agent/person
3. Verify dependencies resolved
4. Move to "Now" section
5. Update sprint capacity
```

### Later → Next (Backlog Grooming)
When work becomes imminent:
```
1. Detail requirements and acceptance criteria
2. Estimate effort (story points)
3. Identify dependencies
4. Set target sprint
5. Move to "Next" section
```

### New Idea → Later
When capturing new work:
```
1. Add to "Later" section with brief description
2. Note potential value and effort
3. List open questions
4. Set priority (P3/P4/Idea)
5. Review during monthly grooming
```

---

## Backlog Grooming Process

### Weekly Grooming (30-60 minutes)
```
1. Review "Next" section
   - Detail requirements for upcoming sprint
   - Update estimates as understanding improves
   - Identify and resolve dependencies
   
2. Review "Now" section
   - Check for blockers
   - Update task status
   - Adjust priorities if needed

3. Promote from "Later" to "Next"
   - Pull 2-3 items becoming high priority
   - Move refined items up
```

### Monthly Grooming (1-2 hours)
```
1. Review entire "Later" section
   - Retire stale ideas (mark as "Won't Do")
   - Merge duplicate ideas
   - Re-prioritize based on strategy

2. Validate "Next" section alignment
   - Ensure alignment with roadmap
   - Balance technical debt vs features
   - Confirm capacity for next 2-3 sprints

3. Collect new ideas
   - From customer feedback
   - From technical needs (refactoring, infrastructure)
   - From market/competitor analysis
```

---

## Update Instructions

### Adding New Work
```
1. Determine time horizon (Now/Next/Later)
2. Use appropriate template
3. Set initial priority
4. Document dependencies
5. Add to correct section
```

### During Sprint Planning
```
1. Review "Next" section for sprint candidates
2. Detail and estimate selected items
3. Move to "Now" section
4. Assign agents/people
5. Verify sprint capacity
```

### Daily Updates
```
1. Update task status in "Now" section
2. Add new blockers or dependencies
3. Adjust priorities if urgency changes
```

### Sprint End
```
1. Archive completed "Now" tasks
2. Move incomplete "Now" tasks (if still relevant)
3. Promote items from "Next" to "Now" for next sprint
4. Groom "Later" section
```

---

## Backlog Health Metrics

### Healthy Backlog Indicators
- ✅ **Now**: 5-10 tasks (1 sprint of work)
- ✅ **Next**: 15-30 tasks (2-3 sprints of work)
- ✅ **Later**: 20-50 items (ideas and future work)
- ✅ **Age**: 80% of "Now" items < 2 weeks old
- ✅ **Refinement**: 100% of "Now" items have acceptance criteria
- ✅ **Estimation**: 100% of "Next" items have effort estimates

### Warning Signs
- ⚠️ **Now** section has >15 tasks (over-committed)
- ⚠️ **Next** section is empty (no pipeline)
- ⚠️ **Later** section has >100 items (too much clutter)
- ⚠️ Tasks sitting in "Later" for >6 months (need decision: promote or retire)
- ⚠️ Multiple P0 items in "Now" (everything can't be critical)

---

## Integration with Workflows

### `/design` Command
```
1. Checks "Now" section for next unstarted task
2. Pulls task details and acceptance criteria
3. Generates technical design
4. Updates task status to "Design - In Progress"
```

### `/build` Command
```
1. Reads current task from CURRENT.md
2. References acceptance criteria from BACKLOG.md
3. Implements solution
4. Updates task status to "Build - In Progress"
```

### `/status` Command
```
1. Reads "Now" section for sprint progress
2. Reports completed vs. in-progress vs. blocked
3. Updates STATUS.md with task counts
```

### Sprint Planning (manual process)
```
1. Reviews "Next" section
2. Estimates team capacity
3. Selects items to promote to "Now"
4. Assigns tasks to agents
5. Records the sprint in SPRINT.md (kept inline for history)
```

---

## Example Templates

### P0 Task Template (Critical/Urgent)
```
### TASK-XXX: {Title}
**Priority**: P0  
**Status**: Not Started  
**Assigned To**: {Agent}  
**Estimate**: {points}  
**Sprint Goal**: {Goal}  

**Description**: {What broke or what's critical}

**Impact**: {Why this is P0}

**Acceptance Criteria**:
- {Criteria 1}
- {Criteria 2}

**Dependencies**: {None or list}  
**Risks**: {Known risks}  
```

### Feature Task Template (P1/P2)
```
### TASK-XXX: {Title}
**Priority**: P1  
**Status**: Not Started  
**Assigned To**: {Agent}  
**Estimate**: {points}  
**Sprint Goal**: {Goal}  

**Description**: {User story or feature description}

**User Value**: {Why user wants this}

**Acceptance Criteria**:
- {Criteria 1 - functional}
- {Criteria 2 - functional}
- {Criteria 3 - quality/performance}

**Dependencies**: {None or list}  
**Risks**: {Known risks}  
```

### Technical Debt Template
```
### DEBT-XXX: {Title}
**Priority**: P2  
**Status**: Not Started  
**Assigned To**: {Agent}  
**Estimate**: {points}  
**Type**: {Refactoring/Performance/Security/Infrastructure}  

**Description**: {What needs improvement}

**Current Problem**: {What's wrong with current state}

**Proposed Solution**: {How to fix it}

**Impact if Not Fixed**: {Technical or business risk}

**Dependencies**: {None or list}  
```

### Bug Fix Template
```
### BUG-XXX: {Title}
**Priority**: {P0-P3 based on severity}  
**Status**: Not Started  
**Assigned To**: {Agent}  
**Estimate**: {points}  
**Severity**: {Critical/High/Medium/Low}  

**Description**: {What's broken}

**Steps to Reproduce**:
1. {Step 1}
2. {Step 2}
3. {Step 3}

**Expected Behavior**: {What should happen}

**Actual Behavior**: {What actually happens}

**Acceptance Criteria**:
- Bug is fixed
- Regression test added
- Root cause documented

**Dependencies**: {None or list}  
```

---

## Related Files

- `.ai/state/STATUS.md` - Project-level health and sprint progress
- `.ai/state/CURRENT.md` - Active session tracking
- `.ai/state/SPRINT.md` - Sprint plan and retrospectives
- `.ai/context/` - Canonical context documents (`/sync` reconciles against these)

> Note: Backlog grooming and sprint planning are manual document processes maintained inline here. Use `/design` for planning and `/status` for progress; reconcile against context with `/sync`.

---

## Quick Reference

**Need to add work?** → Add to "Later", set priority, groom weekly  
**Need to start work?** → Check "Now" for next task  
**Planning sprint?** → Promote from "Next" to "Now"  
**Too many tasks?** → Use prioritization framework to rank  
**Task unclear?** → Move back to "Next" or "Later" until refined  

---

**File Purpose**: Work prioritization and backlog management  
**Update Frequency**: Daily (Now section), Weekly (grooming), Monthly (full review)  
**Maintained**: Manually (this is a document, not a command). Used as input by `/design`, `/status`, and reconciled by `/sync`.  
**Version**: 2.0
