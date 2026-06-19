# /roastme

Self-critique command to detect violations of engineering behavioral principles.

## Usage

```
/roastme design    # Critique architecture/design
/roastme build     # Critique implementation
```

## Purpose

Implements the "Would a senior engineer say this is overcomplicated?" test.

Detects:
- ❌ Overcomplication and premature abstraction
- ❌ Hidden assumptions
- ❌ Non-surgical changes (scope creep)
- ❌ Vague success criteria

---

## Critique Framework

### 1. Simplicity Test

**For `/roastme design`:**
- [ ] Is there code/architecture for features not requested?
- [ ] Are there abstractions with only 1 use case?
- [ ] Could proposed architecture be simpler?
- [ ] Is there "flexibility" nobody asked for?
- [ ] Microservices for <5 services? Event-driven for simple CRUD?

**For `/roastme build`:**
- [ ] Are there design patterns for single use?
- [ ] Are there abstract base classes with 1 subclass?
- [ ] Is there a service layer for 2 endpoints?
- [ ] Could 200 lines be 50 lines?
- [ ] Configuration system for 1 value?

**Overcomplication signals:**
- Strategy pattern with 1 implementation
- Factory pattern for single object type
- Repository pattern with 1 repository
- Middleware for single-use logic
- ORM for 3 simple queries

---

### 2. Assumption Test

**Check for:**
- [ ] Were assumptions stated explicitly or hidden in code?
- [ ] Were multiple interpretations presented or chosen silently?
- [ ] Did agent ask clarifying questions or guess?
- [ ] Are tradeoffs documented in DECISIONS.md?

**Red flags:**
- No questions asked despite vague requirements
- Complex implementation without explaining "why"
- Assumptions not documented anywhere
- Silently picked JWT when "authentication" could mean many things

---

### 3. Surgical Test (for `/roastme build` only)

**Check git diff:**
- [ ] Are there changes to files unrelated to the task?
- [ ] Was code "improved" that wasn't broken?
- [ ] Does diff include style changes, reformatting, or comment edits?
- [ ] Are there features not mentioned in implementation plan?

**Non-surgical signals:**
- Files changed not in task description
- Quote style changed ('' to "")
- Spacing/indentation modified
- Comments reworded
- Unrelated functions refactored
- Type hints added (when not requested)

**The test:** Every changed line should trace directly to the user's request.

---

### 4. Verification Test

**Check for:**
- [ ] Are success criteria vague ("make it work") or specific ("test X passes")?
- [ ] Can success be verified automatically?
- [ ] Is there a clear definition of "done"?
- [ ] Are verification steps actually executable?

**Vague criteria (BAD):**
- "Make it work"
- "Improve the code"
- "Fix the issue"
- "Test it manually"

**Specific criteria (GOOD):**
- "curl /api/login returns 200 with token"
- "npm test -- auth.test.js shows 5/5 passing"
- "Response time <100ms measured with ab tool"

---

## Output Format

```markdown
## RoastMe Report - [Design|Build]

**Date:** [timestamp]
**Agent:** [agent name]
**Task:** [task description]

---

### 🚨 Overcomplications Found: [count]

1. **[Component/File]:** [Issue description]
   - Current approach: [what agent did]
   - Simpler approach: [what should be done]
   - Estimated LoC reduction: [X lines → Y lines]

2. **[Component/File]:** [Issue]
   - ...

---

### 🚨 Hidden Assumptions Found: [count]

1. **[Assumption]:** [what agent assumed]
   - Should have asked: [question agent should ask]
   - Risk: [what could go wrong]

2. **[Assumption]:** ...

---

### 🚨 Non-Surgical Changes Found: [count]

1. **[File]:[Lines]:** [description]
   - Change type: [style/refactoring/scope creep]
   - Related to task: NO
   - Action: Revert

2. **[File]:[Lines]:** ...

---

### 🚨 Vague Success Criteria Found: [count]

1. **[Step]:** "[vague criteria]"
   - Make specific: [verifiable criterion]
   - Verification method: [command/test]

2. **[Step]:** ...

---

### 📊 Metrics

- **Simplicity score:** [0-100] (higher is simpler)
- **Lines of code:** [actual] vs [estimated needed] = [ratio]
- **Abstractions:** [count] ([X] with single use)
- **Files changed:** [count] ([X] unrelated to task)
- **Success criteria:** [X vague / Y total]

---

### ✅ Good Practices Found

- [List things agent did well per engineering principles]

---

### 🎯 Recommended Actions

**CRITICAL (must fix before proceeding):**
1. [Action 1]
2. [Action 2]

**IMPORTANT (should fix):**
1. [Action 1]
2. [Action 2]

**OPTIONAL (nice to have):**
1. [Action 1]

---

### 📋 Verdict

[ ] **APPROVED** - Follows engineering principles (0-2 minor issues)
[ ] **NEEDS REVISION** - Some violations found (3-5 issues)
[ ] **MAJOR REVISION REQUIRED** - Significant violations (6+ issues)

**Estimated fix time:** [X hours]

---

**Reviewer notes:**
[Additional context or observations]
```

---

## Rules

- Run automatically after `/design` and `/build` if configured in manifest.json
- Can be invoked manually: `/roastme design` or `/roastme build`
- Output saved to `.ai/reports/roastme/[timestamp]-[design|build].md`
- Update manifest.json with last_roastme timestamp and violation counts
- Block merge if MAJOR REVISION REQUIRED (6+ violations)

---

## Integration with Workflow

### After `/design`

```
1. Agent completes design (PRD + Architecture + Implementation plan)
2. Orchestrator runs: /roastme design
3. If violations found:
   - Present report to agent
   - Request fixes
   - Re-run roastme after fixes
4. Only proceed to human approval if roastme passes
```

### After `/build`

```
1. Agent completes implementation
2. Agent runs own verification steps
3. Orchestrator runs: /roastme build
4. If violations found:
   - Agent must fix before merge
5. Only proceed to pre-merge checklist if roastme passes
```

---

## Examples

### Example 1: Design Overcomplication

**Input:** `/roastme design` after agent designed microservices for todo app

**Output:**
```markdown
## RoastMe Report - Design

### 🚨 Overcomplications Found: 3

1. **Architecture: Microservices**
   - Current: 6 services (API Gateway, User Service, Todo Service, Auth Service, Notification Service, Analytics Service)
   - Simpler: Monolith with 3 modules
   - Justification: Requirements show 50 users, single team, no scaling need
   - LoC reduction: Estimated 2000 lines → 500 lines

2. **Authentication: Custom OAuth implementation**
   - Current: Building OAuth2 server from scratch
   - Simpler: Use JWT with simple token validation
   - Justification: No external clients, no need for OAuth complexity

3. **Database: Event sourcing**
   - Current: Event store + projections for simple CRUD
   - Simpler: PostgreSQL with direct queries
   - Justification: No audit trail requirement, no time-travel needs

### 🎯 Recommended Actions

CRITICAL:
1. Redesign as monolith architecture
2. Replace OAuth with JWT
3. Replace event sourcing with standard CRUD

Estimated fix time: 4 hours

### 📋 Verdict
[X] MAJOR REVISION REQUIRED - 3 significant overcomplications
```

### Example 2: Build Surgical Violations

**Input:** `/roastme build` after implementing login endpoint

**Output:**
```markdown
## RoastMe Report - Build

### 🚨 Non-Surgical Changes Found: 4

1. **routes/register.js:15-30**
   - Change type: Drive-by refactoring
   - Related to task: NO (task was "add login endpoint")
   - Action: Revert - handle registration in separate PR

2. **utils/validation.js:all**
   - Change type: Reformatting
   - Related to task: NO (changed quotes, spacing)
   - Action: Revert style changes

3. **middleware/logger.js:new file**
   - Change type: Scope creep
   - Related to task: NO (logging not in requirements)
   - Action: Remove or get explicit approval

### 🎯 Recommended Actions

CRITICAL:
1. Revert changes to register.js
2. Revert formatting changes to validation.js
3. Remove logger.js or move to separate PR

Estimated fix time: 30 minutes

### 📋 Verdict
[X] NEEDS REVISION - Non-surgical changes detected
```

---

## Configuration

In `manifest.json`:

```json
{
  "behavioral_compliance": {
    "discipline_enabled": true,
    "roastme_auto_run": true,
    "roastme_after_design": true,
    "roastme_after_build": true,
    "roastme_blocking_threshold": 6,
    "last_roastme_design": null,
    "last_roastme_build": null
  }
}
```

---

## Metrics Tracked

After each roastme run, update manifest.json:

```json
{
  "behavioral_compliance": {
    "simplicity_violations": 3,
    "assumption_violations": 1,
    "surgical_violations": 4,
    "verification_violations": 0,
    "simplicity_score": 0.65,
    "surgical_precision_score": 0.72
  }
}
```

---

**Remember:** RoastMe is your friend. It catches issues early before they become technical debt.
