---
name: documentation
description: "Maintains accurate, up-to-date project documentation (README, API docs, changelogs, ADRs, knowledge) by comparing docs against code reality and recommending specific updates."
auto_load: ["/docs", "/release", "/sync"]
applies_to: [architect, backend, frontend, reviewer]
---

# Documentation

## Quick Protocol (your next action)
1. Compare current docs (README/API/CHANGELOG/ADR/knowledge) against code reality.
2. Flag each gap or inaccuracy and tag its doc type, severity, and audience.
3. Recommend the specific update or new file needed (not just "update docs").
4. Name the exact files affected and the risk of leaving it stale.
Document reality, not aspirations; keep docs close to code.

## Purpose

Maintain comprehensive, accurate, and up-to-date project documentation including README, API docs, changelogs, architecture decisions, and contextual knowledge to ensure project clarity and maintainability.

## Description

The documentation skill ensures all project documentation stays synchronized with code reality. It identifies gaps, outdated information, and opportunities to improve documentation clarity. It covers user-facing docs, developer guides, API references, decision records, and knowledge management.

## When to use

- After implementing new features or changes
- Before releasing new versions (changelog updates)
- When making architectural decisions (ADRs)
- After refactoring or changing APIs
- When onboarding new team members (documentation gaps)
- When user questions reveal missing docs
- Automatically selected by orchestrator for updates

## Input

- Current documentation files (README, CHANGELOG, docs/)
- Recent code changes and commits
- API endpoints and signatures
- Architecture decisions and rationale
- User feedback and support questions
- Existing knowledge base and context files

## Output

### Standard format:
- **Findings**: Documentation gaps or inaccuracies identified
- **Doc type**: README/API/Changelog/ADR/Knowledge/Tutorial
- **Severity**: Critical/High/Medium/Low
- **Recommended action**: Specific updates or new docs needed
- **Audience**: Users/Developers/Contributors/Stakeholders
- **Risks**: Confusion, incorrect usage, or missed features
- **Files affected**: Specific documentation files

## Usage Examples

### Example 1: README updates after feature
```
Task: Update README after authentication feature
Input: New OAuth2 implementation, existing README.md
Output:
  Findings:
    - README still describes basic auth (OAuth2 not mentioned)
    - Installation section missing OAuth setup steps
    - Environment variables section incomplete
  Doc type: README
  Severity: High
  Recommended action:
    - Add "Authentication" section describing OAuth2 flow
    - Update "Getting Started" with OAuth provider setup
    - Document required env vars: CLIENT_ID, CLIENT_SECRET, CALLBACK_URL
    - Add example .env.example file
  Audience: Users, Developers
  Risks: Users cannot set up authentication correctly
  Files affected: README.md, .env.example (new)
```

### Example 2: Changelog for release
```
Task: Prepare changelog for v2.0.0 release
Input: Git commits since v1.5.0, CHANGELOG.md
Output:
  Findings:
    - 47 commits since last release not documented
    - 3 breaking changes not highlighted
    - 8 new features not listed
    - Bug fixes section incomplete
  Doc type: Changelog
  Severity: Critical
  Recommended action:
    - Add v2.0.0 section with date
    - BREAKING CHANGES subsection (API signature changes)
    - Added subsection (new features with examples)
    - Fixed subsection (bug fixes with issue numbers)
    - Deprecated subsection (features to be removed)
  Audience: All users
  Risks: Users unaware of breaking changes, upgrade issues
  Files affected: CHANGELOG.md
```

### Example 3: Architecture Decision Record
```
Task: Document decision to migrate to microservices
Input: Architecture discussion, technical spike results
Output:
  Findings:
    - Major architectural decision made but not documented
    - Rationale not captured for future reference
    - Trade-offs and alternatives not recorded
  Doc type: ADR (Architecture Decision Record)
  Severity: High
  Recommended action:
    - Create docs/decisions/ADR-003-microservices-migration.md
    - Include: Context, Decision, Consequences, Alternatives considered
    - Link to related spike reports and performance data
    - Update architecture diagram
  Audience: Developers, Architects, Future team members
  Risks: Decision rationale lost, repeated debates, context loss
  Files affected: docs/decisions/ADR-003.md (new), docs/architecture/diagram.png
```

### Example 4: API documentation gaps
```
Task: Review API documentation completeness
Input: src/api/routes/*.ts, docs/api/
Output:
  Findings:
    - 12 of 35 endpoints undocumented
    - Request/response schemas missing for 8 endpoints
    - No error codes documentation
    - Authentication requirements unclear
  Doc type: API documentation
  Severity: High
  Recommended action:
    - Generate OpenAPI/Swagger spec from code
    - Document all request/response schemas
    - Create error codes reference table
    - Add authentication section with examples
    - Include rate limiting information
  Audience: API consumers, Frontend developers
  Risks: Incorrect API usage, support burden, frustrated developers
  Files affected: docs/api/openapi.yaml (new), docs/api/errors.md (new)
```

### Example 5: Knowledge base update
```
Task: Update AI context with new patterns
Input: Recent refactoring to use repository pattern
Output:
  Findings:
    - New repository pattern not documented in knowledge base
    - Code examples use old direct database access
    - Best practices need updating
  Doc type: Knowledge/Context
  Severity: Medium
  Recommended action:
    - Update .ai/context/ARCHITECTURE.md with the repository pattern
    - Add examples showing correct usage
    - Document when to use repositories vs direct access
    - Update code generation templates
  Audience: AI agents, Developers
  Risks: AI generates code using outdated patterns
  Files affected: .ai/context/ARCHITECTURE.md, .ai/context/docs/ (generic example — use your project's actual knowledge/template locations)
```

### Example 6: Tutorial creation
```
Task: Create getting started tutorial
Input: User feedback about difficult onboarding
Output:
  Findings:
    - No step-by-step getting started guide
    - Users struggle with initial setup (5 support tickets)
    - Common pitfalls not documented
  Doc type: Tutorial
  Severity: High
  Recommended action:
    - Create docs/tutorials/getting-started.md
    - Include: Prerequisites, installation, first project, troubleshooting
    - Add screenshots for UI-heavy steps
    - Link common issues to solutions
    - Create video walkthrough (optional)
  Audience: New users
  Risks: High abandonment rate, poor first impression
  Files affected: docs/tutorials/getting-started.md (new), README.md (link)
```

## Best Practices

### Documentation Types
- **README**: Project overview, quick start, installation
- **CHANGELOG**: Version history, changes, breaking changes
- **API docs**: Endpoints, parameters, responses, examples
- **ADRs**: Architectural decisions with context and rationale
- **Tutorials**: Step-by-step guides for common tasks
- **Reference**: Detailed technical specifications
- **Troubleshooting**: Common issues and solutions

### Writing Principles
- Write for your audience (technical level)
- Start with examples, then explain details
- Use consistent terminology throughout
- Include code examples that actually work
- Add diagrams for complex concepts
- Keep it DRY - link instead of duplicating

### Structure Best Practices
- Use clear hierarchical headings
- Include table of contents for long docs
- Add "last updated" dates
- Link related documentation
- Use consistent file naming (kebab-case)
- Organize by user journey, not code structure

### Maintenance Strategy
- Update docs in same PR as code changes
- Review docs during code review
- Schedule quarterly documentation audits
- Track documentation coverage metrics
- Use automated doc generation where possible
- Archive outdated documentation, don't delete

### Changelog Guidelines
- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Categorize: Added, Changed, Deprecated, Removed, Fixed, Security
- Highlight breaking changes prominently
- Link to issues/PRs for context
- Write for users, not developers
- Include migration guides for major versions

### ADR Best Practices
- Number sequentially (ADR-001, ADR-002)
- Use template: Status, Context, Decision, Consequences
- Record rejected alternatives and why
- Link to related ADRs
- Mark as superseded when decision changes
- Keep them short (1-2 pages)

## Rules

- Be concise but comprehensive in documentation recommendations
- Be evidence-based using actual code and user feedback
- Do not invent facts - document reality, not aspirations
- Prefer durable knowledge updates when patterns emerge
- Prioritize documentation that prevents user confusion
- Balance completeness with maintainability
- Write for diverse audiences (adjust technical depth)
- Keep documentation close to code when possible
