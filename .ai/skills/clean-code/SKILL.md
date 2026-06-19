---
name: clean-code
description: "Clean code and engineering discipline: modularity, readability, sizing, naming, duplication, separation of concerns, plus the four behavioral principles - think before coding, simplicity first, surgical changes, and goal-driven execution. Global skill applied to all coding work."
global: true
auto_load: [build, fix, refactor, review, design]
applies_to: [orchestrator, architect, backend, frontend, qa, reviewer, docs]
---

# Skill: clean-code

## Quick Protocol (your next action)
1. Read the target file(s); measure function/class size, nesting depth, duplication, and naming.
2. Flag each violation with file:line and a severity (Critical/High/Medium/Low).
3. For each, give a concrete refactor: extract method, rename, dedupe, or split responsibility.
4. Order fixes by severity; keep tests green and public APIs intact while refactoring.
Base every finding on actual code, not assumptions.

## Purpose

Ensure code is modular, readable, maintainable, and properly separated by concern following clean code principles and best practices.

## Description

The clean-code skill evaluates code quality by analyzing modularity, readability, function size, naming conventions, duplication, and separation of concerns. It identifies violations of clean code principles and recommends refactoring to improve maintainability and reduce technical debt.

## When to use

- During code review before committing changes
- After implementing new features or modules
- When onboarding new team members (readability matters)
- Before major refactoring (establish baseline)
- When code complexity metrics are high
- Automatically selected by orchestrator for quality checks

## Input

- Source code files to analyze
- Project coding standards and style guides
- Language-specific best practices
- Complexity thresholds and metrics

## Output

### Standard format:
- **Findings**: Specific code quality issues identified
- **Severity**: Critical/High/Medium/Low per finding
- **Recommended action**: Concrete refactoring suggestions
- **Benefits**: Expected improvements (readability, maintainability)
- **Risks**: Potential breaking changes or side effects
- **Files affected**: Exact files and line numbers

## Usage Examples

### Example 1: Function too large
```
Task: Review authentication service
Input: src/auth/AuthService.ts (350 lines, single class)
Output:
  Findings:
    - login() method is 85 lines (threshold: 30)
    - Mixes validation, database, caching, logging concerns
    - Cyclomatic complexity: 15 (threshold: 10)
  Severity: High
  Recommended action:
    - Extract validateCredentials() method
    - Extract cacheSession() method
    - Extract logAuthAttempt() method
    - Consider separate classes for each concern
  Benefits: Testability +40%, readability +60%
  Risks: Medium - requires updating 8 test files
  Files affected: src/auth/AuthService.ts, tests/auth/AuthService.test.ts
```

### Example 2: Naming and duplication
```
Task: Review utility functions
Input: src/utils/helpers.ts
Output:
  Findings:
    - Function names unclear: processData(), handleStuff(), doThing()
    - Duplicated date formatting logic in 4 functions
    - Magic numbers: 86400, 604800 without explanation
  Severity: Medium
  Recommended action:
    - Rename to domain-specific names (formatUserDate, parseApiTimestamp)
    - Extract formatDate() utility, reuse across functions
    - Define constants: SECONDS_PER_DAY, SECONDS_PER_WEEK
  Benefits: Readability +50%, duplication -75%
  Risks: Low - pure functions, easy to test
  Files affected: src/utils/helpers.ts, src/utils/constants.ts (new)
```

### Example 3: Separation of concerns
```
Task: Review order processing module
Input: src/orders/OrderProcessor.ts
Output:
  Findings:
    - OrderProcessor handles: validation, payment, inventory, email, logging
    - 12 dependencies injected into single class
    - Violates Single Responsibility Principle
  Severity: Critical
  Recommended action:
    - Split into: OrderValidator, PaymentProcessor, InventoryManager, NotificationService
    - Create OrderOrchestrator to coordinate
    - Use event-driven pattern for cross-cutting concerns
  Benefits: Maintainability +80%, testability +90%, reusability +100%
  Risks: High - architectural change, requires integration testing
  Files affected: src/orders/*.ts (7 new files), tests/orders/*.test.ts
```

### Example 4: Code smells
```
Task: Detect code smells in legacy module
Input: src/legacy/ReportGenerator.ts
Output:
  Findings:
    - God class: 45 methods, 1200 lines
    - Feature envy: 30 calls to ExternalDataService methods
    - Inappropriate intimacy: Direct access to 5 internal fields of other classes
    - Dead code: 8 unused private methods
  Severity: High
  Recommended action:
    - Move data fetching logic to ReportDataService
    - Use public APIs instead of field access
    - Remove dead code after verification
    - Split into: ReportBuilder, ReportFormatter, ReportExporter
  Benefits: Coupling -60%, complexity -50%
  Risks: High - extensive changes, requires thorough testing
  Files affected: src/legacy/ReportGenerator.ts + 4 new service files
```

## Best Practices

### Code Review Checklist
- **Function size**: Max 30-40 lines per function
- **Class size**: Max 200-300 lines per class
- **Parameters**: Max 3-4 parameters (use objects for more)
- **Nesting depth**: Max 3 levels of indentation
- **Cyclomatic complexity**: Max 10 per function

### Naming Conventions
- Use intention-revealing names (getUserById vs get)
- Avoid abbreviations unless domain-standard (HTTP, API)
- Boolean functions: isActive, hasPermission, canEdit
- Use consistent vocabulary across codebase

### Modularity Principles
- Single Responsibility: Each class/function does one thing
- Open/Closed: Open for extension, closed for modification
- Dependency Inversion: Depend on abstractions, not concretions
- DRY (Don't Repeat Yourself): Extract common logic
- KISS (Keep It Simple, Stupid): Simplest solution wins

### Refactoring Strategy
- Start with highest severity issues
- Use automated refactoring tools when available
- Refactor in small, testable increments
- Keep tests green during refactoring
- Update documentation after changes

### Quality Metrics
- Track code coverage (target: 80%+)
- Monitor cyclomatic complexity trends
- Measure code churn (frequent changes = poor design)
- Review code duplication percentage
- Assess comment density (too many = unclear code)

## Rules

- Be concise but specific in recommendations
- Be evidence-based using measurable metrics
- Do not invent facts - analyze actual code
- Prefer durable knowledge updates when patterns emerge
- Balance pragmatism with perfectionism
- Consider team capacity and deadlines
- Prioritize changes by impact and effort

---

## Engineering Discipline (Behavioral Principles)

Beyond static code quality, this skill enforces four behavioral principles that prevent
the most common coding mistakes. They are mandatory for all non-trivial work (use
judgment on trivial one-liners). They bias toward caution over raw speed.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly; if uncertain, ask instead of silently picking an interpretation.
- If multiple interpretations exist, present them with pros/cons — don't choose silently.
- If a simpler approach exists, say so and push back when warranted.
- If something is unclear, stop and name what's confusing before proceeding.

**Red flags:** starting implementation immediately on a vague request, picking an
interpretation silently, building the complex option when a simple one fits, coding on guesses.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked ("add login" ≠ add 2FA, OAuth, password reset).
- No abstractions for single-use code — wait for 2+ real use cases before abstracting.
- No "flexibility"/configurability that wasn't requested.
- No error handling for impossible scenarios.
- If you wrote 200 lines and it could be 50, rewrite it.

**The overcomplication test:** "Would a senior engineer call this overcomplicated?"
If YES or MAYBE → simplify. Add complexity only with 2+ real use cases, an explicit
request, or a measurable problem it solves.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code, comments, or formatting while doing an unrelated task.
- Don't refactor things that aren't broken ("while we're here" is how scope creeps).
- Match existing style even if you'd do it differently.
- Notice unrelated dead code? Mention it, don't delete it.
- Remove imports/variables/functions that *your* change made unused — but leave
  pre-existing dead code alone unless asked.

**Traceability test:** every changed line should trace directly to the request. For each
diff hunk ask "did the task require this?" If no → revert it.

### 4. Goal-Driven Execution

**Define verifiable success criteria up front. Loop until verified.**

Don't just say what you'll do — state how you'll prove it worked.

```
Plan:
1. Add POST /auth/login        → verify: curl returns JWT token
2. Protect /api/users          → verify: request without token returns 401
3. Add auth unit tests         → verify: test suite passes
```

Good criteria are automatically checkable, have a clear pass/fail, and need no subjective
judgment. Weak criteria ("make it work", "clean it up", "fix the issue") force constant
clarification. Strong criteria let the agent verify its own work and know when it's done.
(Final evidence-gathering before any completion claim is enforced by
`verification-before-completion`.)

### Self-Check Before Finishing

- [ ] Did I state assumptions and ask about real ambiguities?
- [ ] Did I choose the simplest approach that works?
- [ ] Does every changed line trace to the task?
- [ ] Did I define and verify success criteria?
- [ ] Would a senior engineer approve this?

Any NO → revise before submitting.
