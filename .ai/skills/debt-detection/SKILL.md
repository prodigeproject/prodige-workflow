---
name: debt-detection
description: "Detects and quantifies technical, knowledge, architecture, documentation, and testing debt; rates severity and produces a prioritized paydown plan in time/risk/money terms."
auto_load: [audit, refactor, sync]
applies_to: [architect, reviewer, backend, frontend]
---

# Skill: debt-detection

## Quick Protocol (your next action)
1. Scan the codebase for debt across 5 types: technical, knowledge, architecture, documentation, testing.
2. Back each finding with metrics/evidence (size, complexity, coverage, TODO age).
3. Rate severity and estimate remediation effort (hours/days/weeks).
4. Produce a prioritized paydown plan; express impact in time/risk/money terms.
Analyze the real codebase state; do not invent metrics.

## Purpose

Identify and quantify technical debt, knowledge debt, architecture debt, documentation debt, and testing debt across the codebase to prioritize remediation efforts.

## Description

The debt-detection skill systematically analyzes the codebase for various forms of debt that slow development, increase maintenance costs, or raise risks. It categorizes debt by type, severity, and remediation cost to enable informed decisions about debt paydown versus new feature development.

## When to use

- During sprint planning to allocate debt paydown time
- Before major feature additions (debt compounds complexity)
- After rapid development sprints or crunch periods
- When velocity is decreasing over time
- During architecture reviews
- Before refactoring initiatives
- Automatically selected by orchestrator for health checks

## Input

- Source code files across all modules
- Documentation and comments
- Test coverage reports
- Git history and change patterns
- Architecture diagrams and decisions
- TODO/FIXME comments in code
- Issue tracker labels (tech debt, refactor, etc.)

## Output

### Standard format:
- **Findings**: Specific debt instances with evidence
- **Debt type**: Technical/Knowledge/Architecture/Documentation/Testing
- **Severity**: Critical/High/Medium/Low
- **Impact**: Development velocity, bug risk, maintainability
- **Effort**: Estimated time to remediate (hours/days/weeks)
- **Recommended action**: Prioritized remediation plan
- **Risks**: Consequences of not addressing debt
- **Files affected**: Specific locations requiring work

## Usage Examples

### Example 1: Technical debt detection
```
Task: Analyze codebase for technical debt
Input: src/ directory (45,000 lines)
Output:
  Findings:
    - 15 classes exceed 500 lines (largest: 1,200 lines)
    - Cyclomatic complexity >15 in 23 functions
    - Duplicated code: 8 instances of similar API calling logic
    - 47 TODO comments, 12 are >6 months old
    - Error handling inconsistent across 30% of modules
  Debt type: Technical
  Severity: High
  Impact: New features take 30% longer, bugs in duplicated logic
  Effort: 3-4 weeks to remediate primary issues
  Recommended action:
    1. Extract common API logic to shared service (1 week)
    2. Refactor 5 largest classes (2 weeks)
    3. Standardize error handling (1 week)
    4. Address critical TODOs (ongoing)
  Risks: Accumulating complexity, harder onboarding, more bugs
  Files affected: src/services/*.ts, src/utils/api.ts (new)
```

### Example 2: Knowledge debt detection
```
Task: Identify knowledge gaps and undocumented decisions
Input: Project codebase and documentation
Output:
  Findings:
    - No architectural decision records (ADRs)
    - Critical business logic in src/billing/* lacks comments
    - 3 key algorithms without explanation (tax calc, pricing, discounts)
    - Team turnover: 2 original developers left, knowledge lost
    - No onboarding guide for new developers
  Debt type: Knowledge
  Severity: Critical
  Impact: Bus factor = 1 for billing system, slow onboarding
  Effort: 2 weeks to document critical paths
  Recommended action:
    1. Create ADRs for 5 major decisions (3 days)
    2. Document billing logic with examples (1 week)
    3. Write onboarding guide (3 days)
    4. Record video walkthrough of architecture (1 day)
  Risks: Project stalls if key person leaves, repeated mistakes
  Files affected: docs/adr/*.md (new), docs/ONBOARDING.md (new), src/billing/* (comments)
```

### Example 3: Architecture debt detection
```
Task: Evaluate architectural consistency and scalability
Input: src/ architecture, docs/architecture/
Output:
  Findings:
    - Circular dependencies between 4 modules
    - Tight coupling: Auth module directly calls 8 other modules
    - No service layer, controllers call database directly
    - Monolithic deployment but documentation describes microservices
    - Global state used for caching (not horizontally scalable)
  Debt type: Architecture
  Severity: High
  Impact: Cannot scale horizontally, hard to test, fragile changes
  Effort: 8-12 weeks major refactoring
  Recommended action:
    1. Break circular dependencies (2 weeks)
    2. Introduce service layer (4 weeks)
    3. Implement proper dependency injection (2 weeks)
    4. Replace global state with distributed cache (2 weeks)
    5. Update architecture docs to match reality (1 week)
  Risks: System cannot scale with user growth, outages likely
  Files affected: src/**/*.ts (architectural changes across codebase)
```

### Example 4: Documentation debt detection
```
Task: Audit documentation completeness and accuracy
Input: docs/, README.md, inline comments
Output:
  Findings:
    - API documentation 40% complete (15 of 38 endpoints)
    - README installation steps outdated (references old tool versions)
    - 8 public functions lack JSDoc comments
    - No contributing guidelines
    - Inline comments <10% of codebase (industry avg 20-30%)
  Debt type: Documentation
  Severity: Medium
  Impact: Hard for external contributors, slow onboarding, support load
  Effort: 2-3 weeks
  Recommended action:
    1. Complete API documentation (1 week)
    2. Update README with current setup (1 day)
    3. Add JSDoc to public APIs (3 days)
    4. Write CONTRIBUTING.md (2 days)
    5. Add inline comments to complex logic (ongoing)
  Risks: Frustrated users, wrong assumptions, repeated questions
  Files affected: docs/api/*.md, README.md, CONTRIBUTING.md (new), src/**/*.ts
```

### Example 5: Testing debt detection
```
Task: Analyze test coverage and quality
Input: Test files, coverage reports
Output:
  Findings:
    - Overall coverage: 45% (target: 80%)
    - 0% coverage in src/payments/ (critical path!)
    - No integration tests for API endpoints
    - 15 test files have only happy-path tests
    - E2E tests disabled due to flakiness (6 months ago)
    - Average test age: 8 months (code changes faster than tests)
  Debt type: Testing
  Severity: Critical
  Impact: Bugs in production, fear of refactoring, slow releases
  Effort: 4-6 weeks
  Recommended action:
    1. Add tests for payment module (1 week, highest priority)
    2. Implement integration tests (2 weeks)
    3. Add error case tests (1 week)
    4. Fix and re-enable E2E tests (1 week)
    5. Establish test-first culture (ongoing)
  Risks: Production incidents, customer data issues, regulatory problems
  Files affected: tests/**/*.test.ts (new and updated)
```

## Best Practices

### Debt Classification
- **Technical debt**: Code quality, duplication, complexity
- **Knowledge debt**: Missing docs, undocumented decisions, tribal knowledge
- **Architecture debt**: Poor structure, tight coupling, scalability issues
- **Documentation debt**: Outdated, incomplete, or missing docs
- **Testing debt**: Low coverage, missing test types, flaky tests

### Measurement Metrics
- Lines of code per file/class/function
- Cyclomatic complexity scores
- Code duplication percentage
- Test coverage percentage
- Comment density
- TODO/FIXME age distribution
- Time since last documentation update
- Number of circular dependencies

### Prioritization Framework
1. **Critical**: Blocks releases, security risks, data loss potential
2. **High**: Significantly impacts velocity or quality
3. **Medium**: Causes friction but has workarounds
4. **Low**: Minor inconveniences, cosmetic issues

### Debt Paydown Strategy
- **Boy Scout Rule**: Leave code better than you found it
- **20% time**: Allocate portion of each sprint to debt
- **Debt sprints**: Periodic sprints focused solely on debt
- **Opportunistic**: Fix debt when touching related code
- **Strategic**: Major refactoring initiatives for architectural debt

### Debt Prevention
- Enforce code quality gates in CI/CD
- Require tests for new features
- Mandate documentation updates in PRs
- Use linters and automated quality tools
- Regular architecture reviews
- Capture decisions in ADRs immediately
- Time-box technical spikes to prevent "research debt"

### Communication
- Visualize debt in dashboards (trend over time)
- Express debt in business terms (time, money, risk)
- Share debt reports with stakeholders regularly
- Celebrate debt paydown achievements
- Use debt metrics in retrospectives

## Rules

- Be concise but comprehensive in debt identification
- Be evidence-based using measurable metrics and examples
- Do not invent facts - analyze actual codebase state
- Prefer durable knowledge updates when debt patterns emerge
- Quantify impact in terms meaningful to business (time, risk, money)
- Balance thoroughness with actionability
- Prioritize debt by risk and remediation cost
- Recommend incremental remediation when possible
- Consider team capacity and business priorities
