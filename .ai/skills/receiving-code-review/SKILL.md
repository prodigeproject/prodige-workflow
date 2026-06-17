---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions - requires technical rigor and verification, not performative agreement
applies_to: [orchestrator, backend, frontend, qa]
mandatory: true
---

# Code Review Reception

## Prodige Integration

**Triggered By:** Prodige Reviewer Agent returning findings  
**Applies To:** All agents (Orchestrator, Backend, Frontend, QA)  
**Severity Handling:** Critical (🚫 blocks merge) | Important (⚠️ blocks next task) | Minor (💡 document)

When Prodige Reviewer Agent returns review findings, use this skill to:
- Understand feedback in context of Prodige architecture
- Verify against `.ai/context/ARCHITECTURE.md` and `.ai/context/DECISIONS.md`
- Push back when reviewer conflicts with architectural decisions
- Implement fixes that align with Prodige quality gates

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit instruction-file violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Prodige Severity Handling

**Critical Issues (🚫):**
- Blocks: Merge AND next task
- Response: STOP IMMEDIATELY
- Fix: ALL Critical issues before proceeding
- Re-review: REQUIRED after fixes

**Important Issues (⚠️):**
- Blocks: Next task (current task conditionally complete)
- Response: Fix before starting next task
- Fix: ALL Important issues
- Re-review: Brief verification sufficient

**Minor Issues (💡):**
- Blocks: Nothing
- Response: Record in `technical-debt.md`
- Fix: If trivial (<5 min), otherwise defer
- Re-review: Not needed

**Example Response:**
```markdown
## Review Findings: Task 3

**Critical:** SQL injection in login endpoint
- Stopping work immediately
- Fixing with parameterized queries
- Will request re-review after fix

**Important:** Missing error handling in payment flow
- Noted for fixing before Task 4
- Task 3 marked as conditionally complete

**Minor:** Magic number (5000) for timeout
- Recorded in technical-debt.md
- Will extract to constant when refactoring timeout logic
```

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From your human partner
- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From External Reviewers
```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

## Verify Against Prodige Context Files

Before implementing reviewer suggestions, check:

**`.ai/context/ARCHITECTURE.md`**
- Does suggestion violate established patterns?
- Is there existing approach for this?

**`.ai/context/DECISIONS.md`**
- Was this already decided?
- Does suggestion contradict past decision?

**`.ai/context/PRD.md`**
- Is suggested feature actually required?
- Or is it scope creep (YAGNI)?

**Example:**
```markdown
Reviewer: "Use microservices for user service"

Check ARCHITECTURE.md:
→ Line 45: "Monolith-first approach, extract services only when scaling requires"

Check DECISIONS.md:
→ Decision #12 (2026-05-10): "Start with monolith, defer microservices"

Response:
"This conflicts with architectural Decision #12 (monolith-first).
Keeping current implementation unless user wants to revise that decision."
```

## YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Implementation Order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  3. Test each fix individually
  4. Verify no regressions
```

## When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**If you're uncomfortable pushing back out loud:** Name that tension, then tell your partner about the issue you've seen. They'll appreciate your honesty.

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right - I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that..."
```

**Technical Verification (Good):**
```
Reviewer: "Remove legacy code"
✅ "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID - fix it or drop pre-13 support?"
```

**YAGNI (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "Grepped codebase - nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Good):**
```
your human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
✅ "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## Integration with Prodige Skills

**Used With:**
- **requesting-code-review:** Dispatches Reviewer → This skill handles response
- **subagent-driven-development:** Orchestrator receives findings → Uses this skill to coordinate fixes
- **verification-before-completion:** Pre-review quality checks prevent issues

**Workflow:**
```
Orchestrator:
  Request review (requesting-code-review)
    ↓
  Reviewer returns findings
    ↓
  Apply this skill (receiving-code-review)
    ↓
  If Critical/Important: Dispatch fix agent
    ↓
  Re-review cycle
```

## The Bottom Line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Then implement.

No performative agreement. Technical rigor always.
