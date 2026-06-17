# Prodige Skills Library
## Quality Enforcement Through Systematic Processes

**Version:** 1.0 (Phase 1)  
**Last Updated:** 2026-06-17  
**Status:** Production Ready

---

## Overview

Prodige Skills are **process documentation files** that agents must follow to ensure consistent, high-quality output. Skills are automatically loaded by the Orchestrator based on command and context.

**Philosophy:**
- Skills are NOT optional suggestions
- Skills are mandatory protocols
- Skills are auto-loaded (agents don't choose)
- Skills enforce quality gates

## How Skills Work

### Auto-Loading by Orchestrator

The Orchestrator automatically loads relevant skills based on:
1. **Command executed** (`/build`, `/fix`, `/design`, etc.)
2. **Agent role** (Backend, Frontend, QA, etc.)
3. **Task type** (implementation, debugging, review, etc.)

**Example:**
```
User: /build user authentication

Orchestrator:
1. Reads command: /build
2. Checks skill-selection.matrix.json
3. Auto-loads skills:
   - test-driven-development (mandatory for implementation)
   - verification-before-completion (universal)
4. Dispatches Backend agent with skills loaded
5. Backend agent MUST follow loaded skills
```

### Enforcement Mechanisms

Skills are enforced through multiple layers:

1. **Quality Gates** (`.ai/governance/quality-gates.md`)
   - Skills define what "quality" means
   - Gates block progress if skill not followed

2. **Checklists** (`.ai/checklists/`)
   - Pre-build, pre-merge checklists reference skills
   - Must complete skill requirements to pass checklist

3. **Agent Instructions** (`.ai/agents/`)
   - Agent files explicitly require skill usage
   - Agents trained to load and follow skills

4. **Context Sync** (`.ai/context/`)
   - Skill compliance recorded in context
   - Drift detected if skills bypassed

5. **Verification** (verification-before-completion skill)
   - Mandatory evidence before completion claims
   - No "done" without verification

## Current Skills (Phase 1)

### 1. test-driven-development.md
**Status:** ✅ Production Ready  
**Auto-Loaded:** `/build`, `/fix`, `/refactor` workflows  
**Required For:** Backend, Frontend, QA agents  

**Purpose:** Enforce RED-GREEN-REFACTOR cycle for all implementation

**Key Rules:**
- Write failing test FIRST (no exceptions)
- Watch test fail before implementing
- Write minimal code to pass
- Refactor while staying green
- Code before test = DELETE code and start over

**Integration:**
- Works with `systematic-debugging` (bug fixes)
- Verified by `verification-before-completion`
- Tracked in quality gates

**File:** `.ai/skills/test-driven-development.md`

---

### 2. verification-before-completion.md
**Status:** ✅ Production Ready  
**Auto-Loaded:** ALL workflows (universal)  
**Required For:** ALL agents  

**Purpose:** Require evidence before any completion claim

**Key Rules:**
- No "done" claims without fresh verification
- 5-step gate: Identify → Run → Read → Verify → Claim
- Provide command, output, and result evidence
- Previous runs don't count (fresh run required)

**Integration:**
- Universal gate for all workflows
- Required in pre-merge checklist
- Evidence recorded in handoffs

**File:** `.ai/skills/verification-before-completion.md`

---

### 3. systematic-debugging.md
**Status:** ✅ Production Ready  
**Auto-Loaded:** `/fix` workflow  
**Required For:** ALL agents (when debugging)  

**Purpose:** Scientific root cause analysis before fixes

**Key Rules:**
- NO fixes without Phase 1 (root cause) complete
- 4-phase protocol: Investigation → Pattern → Hypothesis → Implementation
- STOP after 3 failed fixes (question architecture)
- Use TDD for fix implementation

**Integration:**
- Mandatory in `/fix` workflow
- Uses `test-driven-development` for fixes
- Uses `verification-before-completion` for verification
- Updates context if architecture changes

**File:** `.ai/skills/systematic-debugging.md`

---

## Skill Selection Matrix

| Command | Auto-Loaded Skills | Mandatory |
|---------|-------------------|-----------|
| `/init` | - | No |
| `/design` | *Phase 2: brainstorming, writing-plans* | Yes |
| `/build` | test-driven-development, verification-before-completion | Yes |
| `/fix` | systematic-debugging, test-driven-development, verification-before-completion | Yes |
| `/review` | *Phase 3: requesting-code-review* | Yes |
| `/audit` | - | No |
| `/refactor` | test-driven-development, verification-before-completion | Yes |
| `/docs` | verification-before-completion | Yes |
| `/release` | verification-before-completion | Yes |
| `/parallel` | *Phase 4: using-git-worktrees, dispatching-parallel-agents* | Yes |
| `/sync` | verification-before-completion | Yes |

*Italic = Future phases (not yet implemented)*

---

## Agent-Skill Matrix

| Agent | Required Skills | Optional Skills |
|-------|----------------|-----------------|
| **Backend** | test-driven-development, verification-before-completion | systematic-debugging |
| **Frontend** | test-driven-development, verification-before-completion | systematic-debugging |
| **QA** | test-driven-development, verification-before-completion | systematic-debugging |
| **Reviewer** | verification-before-completion | *requesting-code-review (Phase 3)* |
| **Docs** | verification-before-completion | - |
| **Architect** | verification-before-completion | *brainstorming, writing-plans (Phase 2)* |
| **Orchestrator** | verification-before-completion | *skill-loading logic* |

---

## Usage Examples

### Example 1: Build Workflow with TDD

**User Command:**
```
/build login validation
```

**Orchestrator:**
```
Loading skills for /build:
- test-driven-development ✓
- verification-before-completion ✓

Dispatching Backend agent with IMPLEMENTATION.md task.
```

**Backend Agent:**
```
Loading test-driven-development skill...

Task: Implement validateLogin function

Step 1 (RED): Writing failing test
[writes test]

Step 2: Verify test fails
Command: npm test -- validateLogin.test.ts
Result: FAIL - validateLogin is not defined ✓

Step 3 (GREEN): Write minimal code
[writes implementation]

Step 4: Verify test passes
Command: npm test -- validateLogin.test.ts
Result: PASS - 1/1 tests passed ✓

Step 5: Refactor (if needed)
[code is clean, no refactor needed]

Loading verification-before-completion skill...

Command: npm test
Result: 147/147 tests passed
Exit code: 0

Task complete with evidence.
```

---

### Example 2: Fix Workflow with Debugging

**User Command:**
```
/fix login button not working on mobile
```

**Orchestrator:**
```
Loading skills for /fix:
- systematic-debugging ✓
- test-driven-development ✓
- verification-before-completion ✓

Dispatching Frontend agent.
```

**Frontend Agent:**
```
Loading systematic-debugging skill...

Phase 1: Root Cause Investigation
1. Error: "Cannot read property 'click' of undefined"
2. Reproduce: Mobile viewport (375px) ✓
3. Recent changes: Responsive design added 2 days ago
4. Trace: buttonRef points to hidden element on mobile
Root cause: Mobile button missing event handler

Phase 2: Pattern Analysis
Working: Desktop button has handler
Broken: Mobile button (separate element) no handler
Difference: Handler only on desktop variant

Phase 3: Hypothesis
Hypothesis: Attach handler to both button variants
Test: [adds logging]
Confirmed: Mobile button undefined

Phase 4: Implementation
Loading test-driven-development skill...

RED: [writes failing test for mobile button]
Verify RED: FAIL ✓
GREEN: [attaches handler to both buttons]
Verify GREEN: PASS ✓
REFACTOR: [extracts shared component]
Verify: PASS ✓

Loading verification-before-completion skill...

Command: npm test -- LoginButton.test.tsx
Result: 8/8 tests passed

Regression check:
Command: npm test
Result: 147/147 tests passed

Bug fixed with evidence.
```

---

## Roadmap: Future Skills (Phase 2-5)

### Phase 2: Design Enhancement (Week 3-4)
- [ ] **brainstorming.md** - Socratic exploration before design
- [ ] **writing-plans.md** - Detailed implementation plans

### Phase 3: Execution Enhancement (Week 5-6)
- [ ] **subagent-driven-development.md** - Automated task dispatch
- [ ] **executing-plans.md** - Fallback for non-subagent platforms
- [ ] **requesting-code-review.md** - Automated reviewer dispatch
- [ ] **receiving-code-review.md** - Systematic feedback handling

### Phase 4: Parallel Work Safety (Week 7-8)
- [ ] **using-git-worktrees.md** - Workspace isolation
- [ ] **dispatching-parallel-agents.md** - Concurrent work patterns

### Phase 5: Polish & Documentation (Week 9-10)
- [ ] **finishing-a-development-branch.md** - Branch completion protocol
- [ ] **writing-skills.md** - TDD for creating new skills

---

## For Developers: Creating New Skills

### Skill File Structure

```markdown
# [Skill Name]
## Prodige Skill - [Brief Description]

**Auto-Loaded By:** [Which workflows/commands]  
**Required For:** [Which agents]  
**Enforcement:** [How it's enforced]  
**Source:** [Adapted from X / Original]

---

## Overview
[What this skill does and why it exists]

## Prodige Integration
[How skill integrates with Prodige workflows]

## The Iron Law
[Core non-negotiable rule in a code block]

## When to Use
[When skill applies, with examples]

## [Main Content Sections]
[Step-by-step process, with examples]

## Red Flags - STOP
[Warning signs that skill is being bypassed]

## Common Rationalizations
[Table of excuses and reality checks]

## Integration with Other Skills
[How this skill works with other skills]

## Agent-Specific Guidelines
[Variations per agent type]

## Verification Checklist
[Checklist before claiming skill complete]

## Examples
[Complete real-world examples]

## The Bottom Line
[Final reinforcement of core rule]

---

**Skill Version:** [X.Y]  
**Last Updated:** [Date]  
**Enforcement:** [Quality Gate / Workflow]  
**Related Skills:** [List related skills]
```

### Skill Development Process (Phase 5)

When creating new skills (after Phase 5):
1. Use **writing-skills.md** skill (TDD for documentation)
2. Test skill with subagent pressure testing
3. Document baseline behavior (without skill)
4. Write skill addressing rationalizations
5. Close loopholes through refactor cycle
6. Deploy and validate

---

## Troubleshooting

### Issue: Agent bypasses skill
**Symptom:** Agent writes code without TDD, claims "done" without verification, etc.

**Solutions:**
1. Check if skill is loaded (agent should reference it explicitly)
2. Review agent instructions for loopholes
3. Make skill requirements more explicit
4. Add examples of good vs bad behavior
5. Test with pressure scenarios

### Issue: Skill slows development
**Symptom:** Simple tasks take too long

**Solutions:**
1. Expected for first 1-2 weeks (learning curve)
2. Speed improves as agents internalize patterns
3. Measure quality improvement (should be significant)
4. If truly problematic: Consider fast-track for trivial changes
5. Don't compromise quality for speed

### Issue: Skill conflicts with existing rules
**Symptom:** Skill contradicts governance rules or agent instructions

**Solutions:**
1. Skills take precedence (skills ARE the governance)
2. Update conflicting rules to align with skills
3. Document resolution in DECISIONS.md
4. Update agent instructions

### Issue: Unclear when skill applies
**Symptom:** Agent doesn't know when to use skill

**Solutions:**
1. Check skill-selection.matrix.json (Orchestrator config)
2. Make trigger conditions more explicit in skill
3. Add more "When to Use" examples
4. Update Orchestrator logic

---

## Quality Metrics (Phase 1 Target)

### Success Indicators
- ✅ Test coverage ≥90% (TDD enforced)
- ✅ Bug escape rate -60% (systematic debugging)
- ✅ False "done" claims -90% (verification enforced)
- ✅ First-time fix rate ≥85% (root cause analysis)
- ✅ Regression rate <5% (TDD + verification)

### Measurement
Track these metrics weekly:
1. Test coverage per feature
2. Bugs found in production vs. caught in development
3. Number of completion claims without evidence (should be 0)
4. Number of failed fixes before success
5. Number of regressions introduced

**Target:** Achieve metrics within 4 weeks of Phase 1 deployment

---

## Support & Feedback

### Reporting Issues
**File:** `.ai/governance/skill-issues.md` (create if needed)

**Template:**
```markdown
## Skill Issue Report

**Skill:** [name]
**Date:** [date]
**Reporter:** [agent or human]

**Issue:**
[Description of what went wrong]

**Expected Behavior:**
[What should have happened]

**Actual Behavior:**
[What actually happened]

**Context:**
- Command: [command used]
- Agent: [which agent]
- Task: [what task was being performed]

**Suggested Fix:**
[Optional: How to improve the skill]
```

### Continuous Improvement
Skills should evolve based on real usage:
1. Collect feedback weekly
2. Identify common rationalizations
3. Close loopholes
4. Add clarifying examples
5. Update skill files
6. Re-test with agents

---

## FAQ

### Q: Can agents skip skills?
**A:** No. Skills are mandatory when auto-loaded by Orchestrator. Only human can approve exceptions.

### Q: What if skill is wrong for this task?
**A:** Report as skill issue. Orchestrator may need better trigger logic.

### Q: Do skills apply to human developers?
**A:** Yes. Skills document best practices for the project. Humans should follow them too.

### Q: Can we customize skills per project?
**A:** Yes. Skills are in `.ai/skills/` and can be adapted. Keep core rules intact.

### Q: How do we know skills are working?
**A:** Measure quality metrics. If bug rates drop and test coverage rises, skills work.

### Q: Skills make everything slower!
**A:** Initial slowdown is normal (learning curve). Measure: Are you spending less time debugging? That's the real speed gain.

---

## Version History

### v1.0 - Phase 1 (2026-06-17)
- ✅ test-driven-development.md
- ✅ verification-before-completion.md
- ✅ systematic-debugging.md
- ✅ Skills README
- ✅ Integration with quality gates
- ✅ Integration with checklists
- ✅ Agent instructions updated

### Planned

**v1.1 - Phase 2** (Week 3-4)
- brainstorming.md
- writing-plans.md

**v1.2 - Phase 3** (Week 5-6)
- subagent-driven-development.md
- executing-plans.md
- requesting-code-review.md
- receiving-code-review.md

**v1.3 - Phase 4** (Week 7-8)
- using-git-worktrees.md
- dispatching-parallel-agents.md

**v1.4 - Phase 5** (Week 9-10)
- finishing-a-development-branch.md
- writing-skills.md

---

**Document Version:** 1.0  
**Last Updated:** 2026-06-17  
**Status:** Production Ready (Phase 1)  
**Next Review:** After 2 weeks of Phase 1 usage
