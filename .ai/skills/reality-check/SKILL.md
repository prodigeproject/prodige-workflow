---
name: reality-check
description: "Reality check for requirements and plans: identifies assumptions, ambiguities, missing requirements, and hidden risks before implementation."
---

# Reality Check

Systematically identify assumptions, ambiguities, and risks in requirements, designs, and plans before implementation starts.

## Purpose

Prevent implementation failures by catching problems early:
- **Assumptions:** Identify what's assumed but not validated
- **Ambiguities:** Find vague or unclear requirements
- **Missing requirements:** Discover gaps in specifications
- **Risks:** Highlight what could go wrong
- **Contradictions:** Detect conflicting requirements

**Philosophy:** Questions are cheaper than rewrites. Find problems in requirements, not production.

## When to Use

This skill is automatically selected by the orchestrator when:
- Reviewing design documents before implementation
- Evaluating feature proposals
- Assessing implementation plans
- User requests a reality check or requirements review
- Before starting major development work

## Process

### 1. Assumption Identification
Find what's assumed but not stated or validated:
- Technical assumptions (library capabilities, platform features)
- User behavior assumptions (how users will interact)
- Data assumptions (data quality, availability, format)
- Environment assumptions (network, performance, resources)
- Integration assumptions (API behavior, third-party services)

### 2. Ambiguity Detection
Identify vague or unclear requirements:
- Words like "fast", "simple", "user-friendly" (not measurable)
- Undefined edge cases
- Missing acceptance criteria
- Unclear success metrics
- Multiple possible interpretations

### 3. Gap Analysis
Find missing requirements:
- Error handling scenarios
- Edge cases and boundary conditions
- Non-functional requirements (performance, security)
- Accessibility requirements
- Monitoring and observability
- Migration and rollback strategies

### 4. Risk Assessment
Identify what could go wrong:
- Technical risks (complexity, unknowns)
- Integration risks (third-party dependencies)
- Performance risks (scalability concerns)
- Security risks (attack vectors)
- UX risks (confusion, frustration)
- Timeline risks (underestimated effort)

### 5. Contradiction Check
Find conflicting requirements:
- Mutually exclusive features
- Inconsistent specifications
- Conflicting priorities
- Incompatible constraints

## Output Format

Structure findings by category with specific examples:

**🤔 Assumptions Found:**
```
❓ "Users will always provide valid email addresses"
   → Reality: Users make typos, use fake emails for testing
   → Impact: Database fills with invalid data
   → Question: Do we validate email format? Verify ownership?

❓ "The API will always respond within 1 second"
   → Reality: Network issues, API downtime, rate limiting
   → Impact: App hangs, poor UX, timeout errors
   → Question: What's our timeout strategy? Retry logic? Error handling?

❓ "Users understand how to use drag-and-drop"
   → Reality: Not obvious on mobile, accessibility issues
   → Impact: Feature unusable for some users
   → Question: Do we need alternative interaction methods?
```

**❓ Ambiguities Detected:**
```
⚠️  "The page should load fast"
   → Problem: "Fast" is subjective and not measurable
   → Questions: 
      - Fast means what? 1 second? 3 seconds?
      - Measured how? LCP? Total load time?
      - For which network conditions? 4G? WiFi?
   → Need: Specific performance budget (e.g., "LCP < 2.5s on 4G")

⚠️  "Show recent users"
   → Problem: "Recent" is undefined
   → Questions:
      - Recent means how many? 10? 100?
      - Recent by what? Registration date? Last login?
      - Updated how often? Real-time? Daily?
   → Need: Specific criteria (e.g., "Last 50 users by login time, updated real-time")

⚠️  "Make it user-friendly"
   → Problem: Subjective, not actionable
   → Questions:
      - What specific behaviors make it user-friendly?
      - How do we measure user-friendliness?
      - User-friendly for which user groups?
   → Need: Specific UX requirements (e.g., "Max 3 clicks to complete task")
```

**🕳️ Missing Requirements:**
```
❌ Error Handling:
   - What happens if database is down?
   - How do we handle network timeouts?
   - What error messages do users see?

❌ Edge Cases:
   - What if user uploads 100MB file?
   - What if no results found?
   - What if user's session expires mid-action?

❌ Performance Requirements:
   - How many concurrent users should we support?
   - What's acceptable response time?
   - Any pagination or lazy loading needed?

❌ Security:
   - Who can access this feature?
   - Do we need rate limiting?
   - How do we prevent abuse?

❌ Accessibility:
   - Keyboard navigation?
   - Screen reader support?
   - Color contrast requirements?
```

**⚠️ Risks Identified:**
```
🔴 HIGH: Third-party API dependency
   → Risk: API downtime breaks our feature
   → Impact: Feature completely unavailable
   → Mitigation: Add fallback mechanism? Cache responses? Circuit breaker?

🟡 MEDIUM: Complex drag-and-drop on mobile
   → Risk: Poor mobile UX, implementation complexity
   → Impact: Feature unusable on mobile, delays
   → Mitigation: Simplify mobile UI? Use native patterns?

🟡 MEDIUM: Underestimated database query complexity
   → Risk: Performance issues with real data volumes
   → Impact: Slow page loads, poor UX
   → Mitigation: Review queries, add indexes, implement pagination?

🟢 LOW: New library dependency
   → Risk: Library maintenance, security issues
   → Impact: Future technical debt
   → Mitigation: Evaluate alternatives, plan migration strategy?
```

**❌ Contradictions Found:**
```
🔀 "Must load in under 1 second" vs "Show all 10,000 items"
   → Problem: Loading 10,000 items cannot be done in 1 second
   → Resolution needed: Pagination? Virtualization? Relax timing?

🔀 "Simple, minimalist UI" vs "Show all available filters"
   → Problem: Showing many filters contradicts minimalist design
   → Resolution needed: Hide filters in drawer? Prioritize subset?

🔀 "Real-time updates" vs "Minimize server load"
   → Problem: Real-time requires frequent polling/websockets (high load)
   → Resolution needed: Accept higher load? Relax real-time? Smart polling?
```

**✅ Clarification Questions:**
```
Need answers to these before implementing:

1. Email validation: Format only, or verify ownership?
2. Performance target: Specific time budget for key interactions?
3. "Recent users" definition: Count and sort criteria?
4. Error handling: What do users see when things fail?
5. Mobile support: Full parity with desktop or simplified?
6. Accessibility: WCAG level required (A, AA, AAA)?
7. Rate limiting: Threshold and behavior?
8. Data migration: How do we handle existing data?
```

## Rules

- **Question everything:** Don't accept vague requirements
- **Be specific:** Point to exact phrases and sections
- **Be constructive:** Frame as questions, not attacks
- **Prioritize risks:** Flag critical issues first
- **Provide examples:** Show what clarity looks like
- **Stay focused:** Don't derail with nice-to-haves

## Key Principles

**Assumptions Are Risks:**
Every assumption is a potential failure. Make them explicit and validate them.

**Vague = Trouble:**
If a requirement can be interpreted multiple ways, it will be. Pin down specifics.

**Edge Cases Are Core:**
Edge cases become production issues. Define behavior for boundary conditions.

**Questions Beat Rework:**
Asking questions before coding is infinitely cheaper than rewriting after.

## Question Templates

**For Assumptions:**
- "We're assuming X. What if Y happens instead?"
- "This assumes Z is always true. What validates that?"
- "What evidence do we have that this assumption holds?"

**For Ambiguities:**
- "What specifically does 'fast' mean? (time, metric, conditions)"
- "Can you give an example of what this looks like?"
- "How would we test that this requirement is met?"

**For Missing Requirements:**
- "What happens if [error scenario]?"
- "What's the expected behavior when [edge case]?"
- "How do we handle [boundary condition]?"

**For Risks:**
- "What could go wrong with this approach?"
- "What dependencies could fail?"
- "What assumptions could be violated?"

## Integration Points

- Works with **brainstorming** to validate designs early
- Informs **implementation-planning** about clarifications needed
- Feeds **security-review** with identified security gaps
- Used by **test-planning** to identify test cases

## Anti-Patterns to Catch

**Vague Requirements:**
- "User-friendly", "fast", "simple", "scalable"
- "Should work well", "needs to be good"
- "Handle most cases", "usually works"

**Hidden Assumptions:**
- "Users will just know how to..."
- "The API will always..."
- "Data will be in format..."
- "Network will be reliable..."

**Missing Error Handling:**
- No mention of failure scenarios
- No error messages specified
- No recovery strategies
- No fallback behavior

**Underspecified Behavior:**
- Edge cases not defined
- Boundary conditions ignored
- No acceptance criteria
- Success metrics missing

## Example Reality Check

**Design Document:**
> "Build a user dashboard that loads fast and shows recent activity with real-time updates."

**Reality Check:**

```
🤔 Assumptions:
- "Real-time updates" assumes websocket support (validated?)
- Assumes activity data is readily queryable (index exists?)
- Assumes users want constant updates (battery drain on mobile?)

❓ Ambiguities:
- "Loads fast" → Need specific: "Initial render < 2s on 3G"
- "Recent activity" → How many items? Last 24h? Last 50 actions?
- "Real-time" → True real-time or 5-second polling acceptable?

🕳️ Missing:
- Error handling: What if websocket disconnects?
- Edge cases: What if no activity? Empty state?
- Performance: How many concurrent users? Pagination?
- Mobile: Same real-time updates or optimized for battery?

⚠️ Risks:
- Real-time + fast loading may conflict (complexity vs performance)
- Websocket implementation adds significant complexity
- Battery drain on mobile could hurt UX

✅ Needs Clarification:
1. Define "fast": Specific time budget?
2. Define "recent": Count and time range?
3. Real-time critical or nice-to-have?
4. Mobile strategy: Full parity or simplified?
5. Fallback if websocket fails?
```

## Deliverable

Provide prioritized list of questions that must be answered before implementation can proceed safely. Group by:
1. **Blockers:** Must be answered before starting
2. **High priority:** Should be answered before main implementation
3. **Medium priority:** Can be answered during implementation
4. **Low priority:** Nice to clarify but not blocking
