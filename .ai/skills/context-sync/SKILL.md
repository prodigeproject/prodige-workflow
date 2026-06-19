---
name: context-sync
description: "Detects and resolves drift between code, documentation, and contextual knowledge, classifying each drift and recommending concrete sync actions to keep artifacts consistent."
auto_load: ["/build", "/fix", "/review", "/audit", "/sync"]
applies_to: [architect, backend, frontend, reviewer, qa]
---

# Context Sync

## Quick Protocol (your next action)
1. Pick the code plus its docs/comments/ADRs/knowledge and compare them side by side.
2. Flag each drift with evidence (file:line) and classify: code-ahead, doc-ahead, or conflicting.
3. Decide the source of truth (default: code, unless docs define requirements).
4. State the concrete sync action and severity for each drift.
Compare actual content; never invent behavior.

## Purpose

Detect and resolve drift between code implementation, documentation, and contextual knowledge to maintain consistency across all project artifacts.

## Description

The context-sync skill continuously monitors alignment between source code, documentation, comments, README files, architecture decisions, and AI context knowledge. It identifies inconsistencies where documentation describes behavior that code doesn't implement, or code has evolved beyond documented capabilities.

## When to use

- After implementing new features or changes
- Before releasing or deploying updates
- During code review process
- When onboarding new team members
- After refactoring or architectural changes
- When documentation seems outdated
- Automatically selected by orchestrator for consistency checks

## Input

- Source code files and implementations
- Documentation files (README, API docs, guides)
- Code comments and inline documentation
- Architecture decision records (ADRs)
- Durable knowledge and context files
- Test files and specifications

## Output

### Standard format:
- **Findings**: Specific drift instances with evidence
- **Drift type**: Code-ahead, doc-ahead, or conflicting
- **Severity**: Critical/High/Medium/Low
- **Recommended action**: Sync operations needed
- **Risks**: Confusion, bugs, or incorrect assumptions
- **Files affected**: Specific files requiring updates

## Usage Examples

### Example 1: Code-ahead drift
```
Task: Check sync after API refactoring
Input: src/api/UserService.ts, docs/API.md
Output:
  Findings:
    - UserService.createUser() now returns Promise<User> (was User)
    - Added optional 'metadata' parameter not in docs
    - Removed deprecated 'profile' parameter still documented
  Drift type: Code-ahead
  Severity: High
  Recommended action:
    - Update API.md to reflect async signature
    - Document new 'metadata' parameter with examples
    - Remove 'profile' parameter from docs
    - Add migration guide for breaking changes
  Risks: Developers using old docs will write incorrect code
  Files affected: docs/API.md, CHANGELOG.md, examples/*.ts
```

### Example 2: Documentation-ahead drift
```
Task: Validate feature completeness
Input: docs/FEATURES.md, src/features/notifications/
Output:
  Findings:
    - Docs describe push notification support (not implemented)
    - Docs show webhook configuration UI (not in codebase)
    - Missing implementation for 3 documented notification types
  Drift type: Doc-ahead
  Severity: Critical
  Recommended action:
    - Option 1: Implement missing features per documentation
    - Option 2: Mark features as "planned" or "upcoming" in docs
    - Add feature flags for partial implementations
  Risks: Users expect functionality that doesn't exist
  Files affected: docs/FEATURES.md, src/features/notifications/NotificationService.ts
```

### Example 3: Comment drift
```
Task: Review inline documentation accuracy
Input: src/utils/dateHelpers.ts
Output:
  Findings:
    - formatDate() comment says "returns ISO 8601" but returns custom format
    - parseTimestamp() handles timezone but comment says UTC only
    - getRelativeTime() comment mentions removed 'locale' parameter
  Drift type: Code-comment conflict
  Severity: Medium
  Recommended action:
    - Update formatDate() comment to describe actual format
    - Expand parseTimestamp() comment with timezone behavior
    - Remove outdated 'locale' reference from getRelativeTime()
  Risks: Developer confusion, incorrect usage assumptions
  Files affected: src/utils/dateHelpers.ts
```

### Example 4: Architecture drift
```
Task: Validate architecture consistency
Input: docs/architecture/ARCHITECTURE.md, src/
Output:
  Findings:
    - Docs describe microservices but code is monolithic
    - Event-driven pattern documented but using direct calls
    - Database diagram shows PostgreSQL, code uses MongoDB
  Drift type: Major architectural conflict
  Severity: Critical
  Recommended action:
    - Option 1: Update architecture docs to reflect reality
    - Option 2: Create migration plan to documented architecture
    - Document decision in ADR with rationale
  Risks: Misaligned expectations, wrong architectural decisions
  Files affected: docs/architecture/*, docs/decisions/ADR-*.md
```

### Example 5: Knowledge drift
```
Task: Sync AI context with recent changes
Input: .ai/knowledge/patterns.md, src/services/
Output:
  Findings:
    - Knowledge describes factory pattern for services (now using DI container)
    - Documented error handling pattern not followed in 5 new services
    - Outdated import paths in code examples
  Drift type: Knowledge-code drift
  Severity: Medium
  Recommended action:
    - Update patterns.md with current DI approach
    - Document error handling deviations or enforce pattern
    - Refresh all code examples with correct imports
  Risks: AI agents make suggestions based on outdated patterns
  Files affected: .ai/knowledge/patterns.md, .ai/knowledge/examples/*.ts
```

## Best Practices

### Detection Strategies
- **Automated checks**: Use linters to validate doc-code sync
- **Cross-reference**: Link documentation to specific code locations
- **Version tracking**: Tag docs with code version/commit they describe
- **Change triggers**: Auto-flag drift when certain files change
- **Regular audits**: Schedule periodic manual sync reviews

### Drift Prevention
- Update docs in same commit as code changes
- Use doc generation tools (JSDoc, Swagger, etc.)
- Require documentation updates in PR checklist
- Write tests that validate documented behavior
- Use living documentation where possible

### Sync Priorities
1. **Critical**: Security docs, API contracts, data schemas
2. **High**: User-facing features, installation guides, tutorials
3. **Medium**: Architecture docs, internal APIs, patterns
4. **Low**: Historical context, internal notes, examples

### Resolution Workflow
1. **Identify**: Detect drift with evidence
2. **Analyze**: Determine source of truth (code or docs?)
3. **Decide**: Choose sync direction (update code or docs?)
4. **Execute**: Make changes atomically when possible
5. **Verify**: Confirm consistency after changes
6. **Prevent**: Add checks to avoid repeat drift

### Documentation Standards
- Use clear versioning (v1.2.3) in docs
- Date last review/update on each doc page
- Include "Last synced with: commit abc123"
- Mark deprecated features clearly
- Separate "current" from "planned" features

## Rules

- Be concise but thorough in drift detection
- Be evidence-based with specific examples and line numbers
- Do not invent facts - compare actual content
- Prefer durable knowledge updates when patterns emerge
- Always suggest concrete sync actions, not just "update docs"
- Consider user impact when prioritizing fixes
- Default to code as source of truth unless docs define requirements
