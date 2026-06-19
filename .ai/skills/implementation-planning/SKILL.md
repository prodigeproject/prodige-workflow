---
name: implementation-planning
description: "Translates approved designs into safe, modular, testable implementation plans with ordered phases, dependency mapping, risk mitigation, and verification checkpoints."
auto_load: ["/design", "/magic"]
applies_to: [architect, planner, backend, frontend]
---

# Implementation Planning

## Quick Protocol (your next action)
1. Break the approved design into ordered phases of small (0.5-2 day) testable tasks.
2. Map dependencies (what blocks what) and what can run in parallel.
3. Assess risks high-first, with mitigation and a rollback path per phase.
4. Define a testing strategy and a verification checkpoint for each phase.
5. List files to create/modify/delete and estimate effort. Base it on the real codebase.

## Purpose

Translate approved design specifications into safe, modular, testable implementation plans with clear execution phases, risk mitigation strategies, and verification checkpoints.

## Description

The implementation-planning skill bridges the gap between high-level design and concrete code implementation. It breaks down features into manageable, ordered tasks, identifies dependencies and risks, plans testing strategies, and creates a roadmap that balances speed with quality and safety.

## When to use

- After design approval and before coding begins
- When starting a new feature or major change
- Before refactoring initiatives
- When coordinating work across multiple agents
- For complex features requiring phased delivery
- When estimating effort and timelines
- Automatically selected by orchestrator after design phase

## Input

- Approved design specifications and requirements
- Existing codebase and architecture
- Technical constraints and dependencies
- Team capacity and skill sets
- Timeline and deadline requirements
- Risk tolerance and quality standards

## Output

### Standard format:
- **Implementation phases**: Ordered, logical breakdown
- **Task breakdown**: Specific, testable work items
- **Dependencies**: What must be done before what
- **Risk assessment**: Potential issues and mitigation
- **Testing strategy**: Unit, integration, E2E test plans
- **Rollout plan**: Feature flags, gradual rollout, rollback
- **Estimated effort**: Time estimates per phase/task
- **Files affected**: Files to create, modify, or delete


## Usage Examples

### Example 1: New authentication feature
```
Task: Plan implementation for OAuth2 authentication
Input: Design doc specifying OAuth2 with Google and GitHub providers
Output:
  Implementation phases:
    Phase 1: Foundation (2 days)
      - Set up OAuth library and configuration
      - Create database schema for users and tokens
      - Implement basic user model
    Phase 2: OAuth Flow (3 days)
      - Implement OAuth callback endpoints
      - Add session management
      - Create authentication middleware
    Phase 3: Provider Integration (3 days)
      - Google OAuth integration with tests
      - GitHub OAuth integration with tests
      - Provider selection UI
    Phase 4: Security & Polish (2 days)
      - CSRF protection
      - Rate limiting
      - Error handling and user feedback
  
  Task breakdown (Phase 1 detail):
    1. Install passport.js and OAuth strategies
    2. Create User model (id, email, provider, token fields)
    3. Create migration for users table
    4. Write User model unit tests
    5. Set up environment variables for OAuth credentials
  
  Dependencies:
    - Phase 2 depends on Phase 1 completion
    - Provider integrations (Phase 3) can be parallel
    - Need OAuth app credentials from Google/GitHub before Phase 3
  
  Risk assessment:
    - High: OAuth callback URL changes require provider reconfiguration
    - Medium: Session storage strategy affects scalability
    - Low: Provider API changes (mitigated by library abstraction)
  
  Testing strategy:
    - Unit tests: User model, token validation, middleware
    - Integration tests: Full OAuth flow with mock providers
    - E2E tests: Real provider authentication in staging
    - Security tests: CSRF, session fixation, token leakage
  
  Rollout plan:
    - Feature flag: OAUTH_ENABLED (default false)
    - Phase 1: Internal testing only
    - Phase 2: Beta users (10%)
    - Phase 3: Gradual rollout (25%, 50%, 100%)
    - Keep basic auth as fallback for 2 weeks
  
  Estimated effort: 10 days development + 2 days testing
  
  Files affected:
    - src/auth/oauth/GoogleStrategy.ts (new)
    - src/auth/oauth/GitHubStrategy.ts (new)
    - src/auth/middleware/authenticate.ts (modify)
    - src/models/User.ts (modify)
    - migrations/20240115_oauth.sql (new)
    - config/auth.ts (modify)
```

### Example 2: Database migration plan
```
Task: Plan migration from MongoDB to PostgreSQL
Input: Design specifying PostgreSQL with schema design
Output:
  Implementation phases:
    Phase 1: Preparation (1 week)
      - Set up PostgreSQL instance
      - Design normalized schema
      - Create migration scripts for data
    Phase 2: Dual-Write (2 weeks)
      - Implement repository layer abstraction
      - Write to both databases simultaneously
      - Monitor sync errors
    Phase 3: Verification (1 week)
      - Compare data consistency
      - Performance benchmarking
      - Fix sync issues
    Phase 4: Cutover (3 days)
      - Switch reads to PostgreSQL
      - Monitor performance
      - Remove MongoDB writes
    Phase 5: Cleanup (1 week)
      - Remove MongoDB dependencies
      - Optimize queries
      - Archive old data
  
  Risk assessment:
    - Critical: Data loss during migration
    - High: Performance degradation
    - High: Downtime during cutover
    - Medium: Query performance differences
  
  Mitigation:
    - Full database backup before each phase
    - Canary deployment for reads (1% → 10% → 100%)
    - Automated consistency checking
    - Rollback plan for each phase
  
  Testing strategy:
    - Load testing with production-like data (1M records)
    - Chaos engineering: Kill connections, network issues
    - Data integrity checks (checksums, counts)
    - Performance regression tests
  
  Estimated effort: 5-6 weeks (includes buffer for issues)
```

### Example 3: Refactoring monolith to modules
```
Task: Plan refactoring of 5000-line monolith service
Input: Current AuthService.ts with multiple responsibilities
Output:
  Implementation phases:
    Phase 1: Extract utilities (1 day)
      - Move validation functions to validators/
      - Move formatters to formatters/
      - Update imports
    Phase 2: Separate concerns (3 days)
      - Extract PasswordService (hashing, validation)
      - Extract SessionService (session management)
      - Extract TokenService (JWT creation, validation)
    Phase 3: Refactor core (2 days)
      - Slim down AuthService to orchestration
      - Inject extracted services
      - Update dependency injection config
    Phase 4: Testing (2 days)
      - Update all test files
      - Add integration tests
      - Verify behavior unchanged
  
  Task breakdown (Phase 2 detail):
    1. Create src/auth/services/PasswordService.ts
    2. Move hash/compare methods with tests
    3. Create SessionService with session CRUD
    4. Create TokenService with JWT methods
    5. Update AuthService to use new services
  
  Dependencies:
    - Must maintain all tests passing after each phase
    - Cannot change public API (breaking change)
    - Phase 2 tasks can be done in parallel
  
  Testing strategy:
    - Golden tests: Record outputs before refactoring
    - Behavior verification: All existing tests must pass
    - New unit tests: Each extracted service
    - Integration smoke tests: Full auth flows
  
  Rollout plan:
    - No rollout needed (internal refactoring)
    - Deploy to staging first
    - Monitor error rates closely
    - Can rollback via git revert
  
  Files affected:
    - src/auth/AuthService.ts (modify, reduce from 800 to 200 lines)
    - src/auth/services/PasswordService.ts (new)
    - src/auth/services/SessionService.ts (new)
    - src/auth/services/TokenService.ts (new)
    - tests/auth/*.test.ts (update all)
```

### Example 4: API versioning implementation
```
Task: Plan adding API versioning to existing REST API
Input: Design for v2 API with breaking changes
Output:
  Implementation phases:
    Phase 1: Infrastructure (2 days)
      - Add version routing middleware
      - Set up v1 and v2 route structures
      - Implement version header/URL parsing
    Phase 2: Duplicate v1 to v2 (1 day)
      - Copy all v1 routes to v2
      - Ensure v1 still works
      - Add version tests
    Phase 3: Implement v2 changes (1 week)
      - Update v2 endpoints with new schemas
      - Implement new features in v2
      - Keep v1 unchanged
    Phase 4: Documentation (2 days)
      - Document v2 API
      - Create migration guide
      - Update OpenAPI specs
  
  Task breakdown (Phase 1 detail):
    1. Create src/api/middleware/version.ts
    2. Parse Accept-Version header or /v1, /v2 prefix
    3. Set request.apiVersion property
    4. Create src/api/v1/ and src/api/v2/ folders
    5. Move existing routes to v1/
  
  Risk assessment:
    - Medium: Routing complexity increases
    - Medium: Code duplication between versions
    - Low: Client confusion about which version to use
  
  Testing strategy:
    - Version negotiation tests
    - Parallel tests for v1 and v2
    - Contract tests to prevent breaking v1
    - E2E tests for both versions
  
  Rollout plan:
    - v1 remains default for existing clients
    - v2 opt-in via header or URL
    - Announce deprecation timeline for v1 (6 months)
    - Monitor adoption metrics
  
  Estimated effort: 2 weeks + ongoing maintenance
  
  Files affected:
    - src/api/middleware/version.ts (new)
    - src/api/v1/*.ts (moved from src/api/)
    - src/api/v2/*.ts (new, duplicated from v1)
    - docs/api/v2/ (new)
```

### Example 5: Performance optimization plan
```
Task: Plan optimization to reduce API response time
Input: Profiling data showing slow database queries
Output:
  Implementation phases:
    Phase 1: Measurement (2 days)
      - Add detailed performance logging
      - Set up APM (Application Performance Monitoring)
      - Establish baseline metrics
    Phase 2: Database optimization (1 week)
      - Add missing indexes (identified from slow query log)
      - Optimize N+1 queries (use eager loading)
      - Implement query result caching
    Phase 3: Application optimization (1 week)
      - Add Redis caching layer
      - Implement response compression
      - Optimize serialization
    Phase 4: Validation (3 days)
      - Load testing with production traffic patterns
      - Verify metrics improvement
      - Document optimizations
  
  Task breakdown (Phase 2 detail):
    1. Analyze slow query log for missing indexes
    2. Add indexes to users.email, orders.created_at
    3. Find N+1 queries using query counter
    4. Add eager loading to User.orders query
    5. Implement Redis cache for user profiles (TTL: 5min)
  
  Risk assessment:
    - Medium: Cache invalidation complexity
    - Medium: Over-indexing slows writes
    - Low: Redis dependency
  
  Testing strategy:
    - Performance benchmarks (before/after)
    - Load tests with JMeter (100 req/sec)
    - Cache hit rate monitoring
    - Regression tests for correctness
  
  Success metrics:
    - P50 response time: 200ms → 50ms
    - P99 response time: 2000ms → 300ms
    - Database CPU: 70% → 40%
    - Cache hit rate: >80%
  
  Estimated effort: 3 weeks
  
  Files affected:
    - migrations/add_indexes.sql (new)
    - src/cache/UserCache.ts (new)
    - src/repositories/UserRepository.ts (modify)
```

## Best Practices

### Planning Principles
- **Break down**: Large tasks into small, testable chunks
- **Sequence smartly**: Dependencies first, independent work in parallel
- **Risk first**: Tackle high-risk items early (fail fast)
- **Incremental delivery**: Ship small, working pieces regularly
- **Reversibility**: Plan rollback strategies for each phase

### Task Breakdown Guidelines
- Each task should take 0.5-2 days (not weeks)
- Tasks should have clear done criteria
- Include testing as explicit tasks
- Identify blocking vs. parallelizable tasks
- Assign tasks to appropriate agents/specialists

### Risk Management
- **Identify**: What could go wrong?
- **Assess**: Likelihood and impact
- **Mitigate**: How to prevent or reduce?
- **Monitor**: Metrics to watch during rollout
- **Rollback**: Quick path to previous state

### Testing Strategy Tiers
1. **Unit tests**: Individual functions and classes
2. **Integration tests**: Multiple components together
3. **E2E tests**: Full user flows
4. **Performance tests**: Load and stress testing
5. **Security tests**: Vulnerability scanning
6. **Manual tests**: Exploratory testing

### Rollout Strategies
- **Big bang**: All at once (risky, simple)
- **Phased**: Gradual rollout by percentage
- **Canary**: Test with small subset first
- **Blue-green**: Parallel environments, switch traffic
- **Feature flags**: Toggle features on/off dynamically

### Estimation Techniques
- **Bottom-up**: Sum individual task estimates
- **Top-down**: Total scope divided by phases
- **Analogous**: Compare to similar past work
- **Buffer**: Add 20-50% for unknowns
- **Track**: Compare estimates to actuals for learning

### Communication Plan
- Daily standups during implementation
- Weekly progress reports to stakeholders
- Blocker escalation within 24 hours
- Decision documentation in ADRs
- Post-implementation retrospective

## Rules

- Be concise but comprehensive in planning
- Be evidence-based using codebase analysis
- Do not invent facts - base plans on reality
- Prefer durable knowledge updates when patterns emerge
- Balance thoroughness with pragmatism
- Consider team capacity and skills
- Plan for failure with rollback strategies
- Include verification at each phase
- Communicate risks clearly and early
- Update plans as implementation reveals new information

---

## Bite-Sized Task Authoring (merged from `writing-plans`)

> This section absorbs the former `writing-plans` skill. Use it when turning a phase
> into a written, hand-off-ready plan document. A companion reviewer prompt lives at
> [plan-document-reviewer-prompt.md](./plan-document-reviewer-prompt.md).

Write the plan assuming the implementer has zero context for the codebase: name exact
files, show real code, give exact commands with expected output. DRY. YAGNI. TDD.
Frequent commits.

### Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a fresh
reviewer's gate. Fold setup/config/scaffolding/docs into the task whose deliverable
needs them; split only where a reviewer could meaningfully reject one task while
approving its neighbor. Each task ends with an independently testable deliverable.

### Each step is one action (2-5 minutes)
- "Write the failing test" — step
- "Run it to make sure it fails" — step
- "Implement the minimal code to make the test pass" — step
- "Run the tests and make sure they pass" — step
- "Commit" — step

### Task Structure Template

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [exact signatures used from earlier tasks]
- Produces: [exact names/types later tasks rely on]

- [ ] Step 1: Write the failing test   (show the test code)
- [ ] Step 2: Run test to verify it fails   (exact command + expected FAIL)
- [ ] Step 3: Write minimal implementation   (show the code)
- [ ] Step 4: Run test to verify it passes   (exact command + expected PASS)
- [ ] Step 5: Commit   (exact git command)
```

### No Placeholders (plan failures — never write these)
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling / validation / handle edge cases"
- "Write tests for the above" without the actual test code
- "Similar to Task N" — repeat the code; the implementer may read tasks out of order
- References to types/functions/methods not defined in any task

### Self-Review before handoff
1. **Spec coverage:** every spec requirement maps to a task (list gaps).
2. **Placeholder scan:** remove every red flag above.
3. **Type consistency:** signatures/names used in later tasks match earlier definitions.

### Execution Handoff
Offer the implementer a choice: **subagent-driven-development** (recommended, fresh
subagent per task + review between tasks) or **executing-plans** (inline, batched with
checkpoints).
