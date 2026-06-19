---
name: reuse-rebuild
description: "Enforces disciplined decision-making: prefer reuse, then refactor, then rebuild only with strong justification."
---

# Reuse, Refactor, or Rebuild

Make evidence-based decisions about whether to reuse existing code, refactor it, or rebuild from scratch.

## Quick Protocol (your next action)
1. Search the codebase for existing code that already does this (do this first).
2. Evaluate what you find: functionality, quality, performance, compatibility.
3. Apply the ladder: REUSE as-is > REFACTOR > REBUILD (last resort).
4. If rebuilding, justify why reuse/refactor fail and extract any salvageable logic.
Bias toward working code; never propose building without searching.

## Purpose

Prevent wasteful rebuilding by establishing a clear decision framework:
- **Reuse:** Use existing code as-is when it meets requirements
- **Refactor:** Improve existing code to meet new requirements
- **Rebuild:** Create new implementation only when justified

This skill fights the common AI tendency to rebuild everything instead of working with existing code.

## When to Use

This skill is automatically selected by the orchestrator when:
- Planning to implement new features
- Considering refactoring existing code
- Evaluating whether to use existing utilities/components
- Proposing architectural changes
- Writing implementation plans

## Decision Framework

### Option 1: REUSE (Preferred)

**Use existing code as-is when:**
- ✓ It already does what you need
- ✓ Code quality is acceptable
- ✓ Performance is adequate
- ✓ No breaking changes needed
- ✓ Fits the current architecture

**Example:** Need a date formatter → found `lib/formatDate.ts` that handles all required cases → use it

### Option 2: REFACTOR (Next Best)

**Improve existing code when:**
- ✓ Core logic is sound but needs adjustment
- ✓ Can be improved without breaking API
- ✓ Refactor is localized and low-risk
- ✓ Tests exist to prevent regressions
- ✓ Improves code quality for future use

**Example:** Found `api/users.ts` but needs pagination → add pagination to existing endpoint → refactor

### Option 3: REBUILD (Last Resort)

**Create new implementation only when:**
- Existing code is fundamentally wrong for the use case
- Refactoring would be more complex than rebuilding
- Architecture has changed and old code doesn't fit
- Security/performance issues require ground-up redesign
- No existing code addresses the need

**Requires justification explaining:**
1. Why reuse is not possible
2. Why refactor is not feasible
3. What makes rebuild the better choice
4. What the rebuild will provide that refactor cannot

**Example:** Need real-time updates → existing polling approach can't be adapted → rebuild with WebSocket architecture

## Process

### 1. Search First
Before proposing any implementation:
- Search for existing code that does similar things
- Check utilities, helpers, and shared modules
- Look for similar patterns in the codebase
- Review recent commits for relevant work

### 2. Evaluate What Exists
For each piece of existing code found:
- **Functionality:** Does it do what we need?
- **Quality:** Is the code maintainable and clear?
- **Performance:** Does it meet performance requirements?
- **Compatibility:** Does it fit our architecture and patterns?
- **Extensibility:** Can it be adapted if needed?

### 3. Make the Decision
Apply the decision framework:
1. Can we reuse as-is? → Do that
2. If not, can we refactor? → Do that
3. If not, must we rebuild? → Justify it

### 4. Document the Decision
Clearly state:
- What existing code was considered
- Why reuse/refactor wasn't chosen (if applicable)
- What approach is recommended and why
- What the implementation will involve

## Output Format

**Search Findings:**
```
🔍 Found existing code:
  ✓ lib/formatDate.ts - Handles date formatting
  ✓ hooks/useUser.ts - Fetches user data
  ✓ components/UserCard.tsx - Displays user info
```

**Evaluation:**
```
📊 Assessment:
  lib/formatDate.ts:
    - Functionality: ✓ Handles all required formats
    - Quality: ✓ Well-tested, clean code
    - Performance: ✓ Adequate
    - Compatibility: ✓ Fits our patterns
    → DECISION: REUSE

  hooks/useUser.ts:
    - Functionality: ⚠ Missing error retry logic
    - Quality: ✓ Good structure
    - Performance: ✓ Adequate
    - Compatibility: ✓ Fits our patterns
    → DECISION: REFACTOR (add retry logic)

  components/UserCard.tsx:
    - Functionality: ✗ Built for different layout
    - Quality: ⚠ Tightly coupled to old design
    - Performance: ✓ Adequate
    - Compatibility: ✗ Doesn't match new design system
    → DECISION: REBUILD (new component with shared logic extracted)
```

**Recommendations:**
```
✅ REUSE:
  - lib/formatDate.ts (as-is)

🔧 REFACTOR:
  - hooks/useUser.ts
    - Add exponential backoff retry logic
    - Keep existing API and tests
    - Estimated effort: 30 minutes

🏗️ REBUILD:
  - components/UserCard.tsx → components/UserProfile.tsx
    - Justification: New design system and layout requirements
    - Why not refactor: Component structure fundamentally different
    - Reuse approach: Extract user data formatting logic to shared utility
    - Estimated effort: 2 hours
```

## Rules

- **Search before proposing:** Never suggest building without checking what exists
- **Bias toward reuse:** When in doubt, prefer using what's there
- **Refactor over rebuild:** If it can be fixed, fix it rather than replace it
- **Justify rebuilds:** Rebuilding requires clear explanation of why alternatives won't work
- **Extract when rebuilding:** If rebuilding, extract and reuse any salvageable logic
- **Evidence-based:** Base decisions on actual code inspection, not assumptions

## Key Principles

**YAGNI (You Aren't Gonna Need It):**
- Don't rebuild to add features that aren't required
- Don't refactor to add flexibility that isn't needed
- Solve today's problem, not tomorrow's hypothetical

**Working Code Bias:**
- Existing code that works is valuable
- Bugs can be fixed, features can be added
- Don't throw away working code without good reason

**Incremental Improvement:**
- Small refactors are safer than big rebuilds
- Improve code as you work with it
- Leave code better than you found it

## Integration Points

- Works with **ripgrep** to search for existing implementations
- Informs **implementation-planning** about reuse vs rebuild strategy
- Works with **clean-code** to assess refactoring opportunities
- Coordinates with **debt-detection** to identify code that needs rebuild

## Anti-Patterns

- ❌ **"I'll just rewrite it"** - Rebuilding without searching for existing code
- ❌ **"That code is old"** - Age alone is not a reason to rebuild
- ❌ **"I don't understand it"** - Invest time to understand before rebuilding
- ❌ **"It's not perfect"** - Perfect is the enemy of good
- ❌ **"It would be fun to rebuild"** - Fun is not a business justification
- ❌ **"I could do it better"** - Probably, but is it worth the cost?

## Red Flags for Unnecessary Rebuilds

Watch for these in proposals:
- No mention of existing code search
- Vague reasons like "outdated" or "not modern"
- Rebuilding working code to use newer libraries
- Rewriting for style/preference rather than requirements
- No clear benefit articulated

## Green Lights for Justified Rebuilds

Rebuilds are justified when:
- Fundamental architectural mismatch (REST → GraphQL)
- Security vulnerabilities in core design
- Performance issues that can't be fixed incrementally
- Technology is deprecated/unsupported
- Cost of maintaining exceeds cost of rebuilding

## Examples

**Good Decision Process:**
```
Request: "Add pagination to user list"

Search: Found getUserList() in lib/api.ts
Evaluation: 
  - Returns all users at once
  - Well-tested function
  - Used in 3 places

Decision: REFACTOR
  - Add limit/offset parameters
  - Maintain backward compatibility with default values
  - Update call sites as needed
  
Why not rebuild: Core logic is sound, just needs parameters
```

**Bad Decision Process:**
```
Request: "Add pagination to user list"

Proposal: "Let's rebuild the entire API layer using tRPC"

❌ Problem:
  - No search for existing code
  - Massive scope creep
  - No justification for full rebuild
  - Solves problem not asked for
```

**Justified Rebuild:**
```
Request: "Add real-time collaboration"

Search: Found polling-based update system
Evaluation:
  - Polls every 5 seconds
  - Can't detect conflicts in real-time
  - Not scalable to 100+ users

Decision: REBUILD with WebSocket architecture
Justification:
  - Polling fundamentally can't provide real-time updates
  - Refactoring to reduce polling interval doesn't solve core issue
  - WebSocket approach is architectural change, not incremental
  - Existing data layer can be reused with new transport
```
