---
name: handoff-manager
description: "Creates and validates comprehensive handoff documentation capturing context, decisions, files affected, and next steps for seamless continuity across sessions and agents."
auto_load: ["/parallel"]
applies_to: [orchestrator, architect, backend, frontend, qa]
---

# Handoff Manager

## Quick Protocol (your next action)
1. Write a 2-3 sentence summary of what was accomplished this session.
2. Capture current state, key decisions + rationale, and files affected.
3. List prioritized next steps and any blockers (with contact + unblock estimate).
4. Note open questions, then assess handoff completeness (Complete/Partial).
5. Save to `.ai/runtime/handoffs/handoff-<timestamp>.md`. Write for someone with zero context.

## Purpose

Ensure seamless continuity between work sessions, agents, and team members by creating, validating, and managing comprehensive handoff documentation that captures context, decisions, and next steps.

## Description

The handoff-manager skill orchestrates knowledge transfer between agents, sessions, and team members. It ensures that critical context isn't lost when work stops, changes hands, or resumes later. It validates handoff completeness, identifies missing information, and maintains handoff documentation standards.

## When to use

- At the end of every agent work session
- Before switching between agents (frontend → backend)
- When hitting context limits or token budgets
- Before long breaks or end of workday
- When handing off to human developers
- After completing major features or milestones
- Automatically selected by orchestrator before agent termination

## Input

- Current work session context and state
- Tasks completed, in-progress, and pending
- Recent decisions and rationale
- Open questions or blockers
- Modified files and code changes
- Test results and known issues

## Output

### Standard format:
- **Session summary**: What was accomplished
- **Current state**: Where work stands now
- **Context**: Key decisions and rationale
- **Next steps**: Prioritized actions for continuation
- **Blockers**: Issues preventing progress
- **Open questions**: Decisions needed
- **Files affected**: Changed/created/deleted files
- **Handoff quality**: Completeness assessment

## Usage Examples

### Example 1: Agent-to-agent handoff
```
Task: Frontend agent completing UI, handing off to backend
Input: UI components completed, API integration needed
Output:
  Session summary:
    - Built user dashboard with 5 components
    - Implemented form validation
    - Added responsive layouts for mobile
  Current state:
    - UI complete and tested locally
    - Mock API data in use
    - Ready for real API integration
  Context:
    - Chose Material-UI for consistency with design system
    - Form validation uses Yup schema (see schemas/user.ts)
    - Dashboard state managed with React Query
  Next steps:
    1. Backend: Create POST /api/users endpoint
    2. Backend: Implement validation matching frontend schema
    3. Frontend: Replace mock data with API calls
    4. Frontend: Add error handling for API failures
  Blockers: None
  Open questions:
    - Should user creation be async with confirmation email?
    - Rate limiting requirements for form submission?
  Files affected:
    - src/components/Dashboard.tsx (new)
    - src/components/UserForm.tsx (new)
    - src/schemas/user.ts (new)
  Handoff quality: Complete ✓
```

### Example 2: End of session handoff
```
Task: End work session mid-feature
Input: Partial implementation of payment processing
Output:
  Session summary:
    - Started payment integration with Stripe
    - Completed webhook setup (50% done)
  Current state:
    - Stripe SDK installed and configured
    - Webhook endpoint created but not tested
    - Database schema updated for payment records
    - Frontend payment form NOT started
  Context:
    - Using Stripe Checkout (not custom form) per ADR-015
    - Webhook signing secret in .env.local (not committed)
    - Payment records stored in payments table with foreign key to orders
  Next steps:
    1. Test webhook endpoint with Stripe CLI
    2. Implement webhook event handlers (payment.succeeded, payment.failed)
    3. Add error handling and retry logic
    4. Create frontend payment flow
    5. Write integration tests
  Blockers:
    - Need Stripe test API keys from DevOps
  Open questions:
    - Refund policy implementation timing?
    - Should we support payment methods other than cards?
  Files affected:
    - src/api/stripe/webhook.ts (in-progress)
    - src/models/Payment.ts (new)
    - migrations/20240115_add_payments.sql (new)
  Handoff quality: Partial - needs Stripe credentials to continue
```

### Example 3: Cross-team handoff
```
Task: AI agent to human developer handoff
Input: Automated refactoring complete, manual review needed
Output:
  Session summary:
    - Refactored authentication module for better testability
    - Extracted 3 new services from AuthController
    - Updated 15 test files
  Current state:
    - All tests passing locally
    - Code coverage increased from 65% to 82%
    - Ready for human review and PR
  Context:
    - Refactoring addresses technical debt from Q4 review
    - Preserved all existing API signatures (no breaking changes)
    - Used dependency injection pattern consistently
  Next steps:
    1. Human review: Code quality and logic correctness
    2. Human review: Test coverage adequacy
    3. Create pull request with detailed description
    4. Deploy to staging environment
    5. Monitor for issues
  Blockers: None
  Open questions:
    - Should we refactor UserController using same pattern?
    - Update architecture docs now or after PR approval?
  Files affected: (17 files, see git diff)
    - src/auth/AuthController.ts (refactored)
    - src/auth/services/*.ts (3 new services)
    - tests/auth/*.test.ts (updated)
  Handoff quality: Complete - ready for human review ✓
```

### Example 4: Incomplete handoff detection
```
Task: Validate handoff from previous agent
Input: Handoff notes from agent session
Output:
  Findings:
    - Session summary too vague ("worked on API")
    - No context about decision rationale
    - Files affected section empty
    - No clear next steps
  Handoff quality: Incomplete ✗
  Recommended action:
    - Request clarification from previous agent logs
    - Analyze git commits to determine changes
    - Review modified files to understand scope
    - Reconstruct context from code and tests
    - Create proper handoff documentation
  Risks: Lost context, duplicate work, wrong assumptions
  Files affected: .ai/runtime/handoffs/session-XYZ.md (needs updating)
```

### Example 5: Blocker escalation
```
Task: Create handoff with critical blocker
Input: Work stopped due to missing credentials
Output:
  Session summary:
    - Attempted to configure AWS S3 integration
    - Setup AWS SDK and basic upload logic
  Current state:
    - Code ready but cannot test without credentials
    - Work stopped at credential configuration step
  Context:
    - Following AWS best practices per security guidelines
    - Using IAM roles (not access keys) for production
    - S3 bucket name: prod-app-uploads
  Next steps:
    1. ⚠️ BLOCKED: Obtain AWS credentials from DevOps
    2. Configure AWS credentials in environment
    3. Test file upload functionality
    4. Implement file deletion and listing
  Blockers:
    - CRITICAL: Missing AWS IAM credentials
    - Contact: devops@company.com or #devops Slack
    - Estimated unblock time: 1-2 hours
  Open questions: None
  Files affected:
    - src/services/S3Service.ts (ready, untested)
    - config/aws.ts (needs credentials)
  Handoff quality: Complete with blocker ⚠️
  Escalation: DevOps notified via Slack
```

## Best Practices

### Handoff Documentation Structure
- **Executive summary**: 2-3 sentences of what happened
- **Detailed context**: Decisions, rationale, constraints
- **State assessment**: Current completeness percentage
- **Action items**: Specific, prioritized next steps
- **Dependencies**: What's needed to continue
- **Knowledge transfer**: Key learnings or gotchas

### Quality Checklist
- ✓ Summary is clear and specific
- ✓ All decisions have rationale documented
- ✓ Next steps are actionable and prioritized
- ✓ Blockers clearly identified with contact info
- ✓ Files affected list is complete
- ✓ Open questions are explicit
- ✓ Handoff can be understood without verbal explanation

### Handoff Types
- **Session continuity**: Same agent, different session
- **Agent transition**: Different specialized agent
- **Human escalation**: AI to human developer
- **Team handoff**: Cross-team or shift change
- **Emergency stop**: Context limit or critical issue

### Context Preservation
- Save partial work in progress branches
- Document why specific approaches were chosen
- Include links to relevant docs or discussions
- Note what was tried and didn't work
- Capture environment-specific details

### Blocker Management
- Identify blockers early and loudly
- Include specific contact information
- Estimate time to unblock
- Provide workarounds if available
- Escalate critical blockers immediately

### Handoff Storage
- Store in `.ai/runtime/handoffs/` directory
- Use the canonical template [`HANDOFF_TEMPLATE.md`](../../runtime/handoffs/HANDOFF_TEMPLATE.md);
  its sections map 1:1 to this skill's standard format (session summary, current
  state, context, files affected, tests run, next steps, blockers, open questions,
  and handoff quality)
- Name by timestamp: `handoff-2024-01-15-1430.md`
- Link handoffs chronologically
- Archive old handoffs after completion
- Use consistent markdown template

## Rules

- Be concise but comprehensive in handoff notes
- Be evidence-based using actual work completed
- Do not invent facts - document reality
- Prefer durable knowledge updates when patterns emerge
- Always create handoff at end of session
- Validate handoff completeness before terminating
- Escalate blockers immediately, don't hide them
- Write for someone with no context about your session
- Include both what worked and what didn't
