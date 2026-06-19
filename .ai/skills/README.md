# Prodige Skills Library
## Quality Enforcement Through Systematic Processes

**Version:** 3.0  
**Last Updated:** 2026-06-18  
**Status:** Production Ready — 37 skills + 2 global

---

## Overview

Prodige Skills are **process documentation files** that agents must follow to ensure consistent, high-quality output. Skills are automatically loaded by the Orchestrator based on command and context.

**Philosophy:**
- Skills are NOT optional suggestions
- Skills are mandatory protocols
- Skills are auto-loaded (agents don't choose)
- Skills enforce quality gates

---

## Skill Index, Canonical Merges & Disambiguation

> **Status (v3.0, 2026-06-18):** 37 skills + 2 global. The authoritative list is
> `manifest.json`. The authoritative auto-load config is `skill-selection-matrix.json`
> (the orchestrator's flat `skill-selection.matrix.json` is a derived view kept in sync).
> Run `.ai/scripts/lint-skills.ps1` (or `.sh`) to verify no drift.

### Canonical merges (duplicates removed)
These pairs were duplicates and have been merged. Old names are **aliases** (see `manifest.json`):

| Old name | Canonical skill | Notes |
|----------|-----------------|-------|
| `tdd` | **`test-driven-development`** | Single TDD source of truth (rationalization table + sub-docs) |
| `diagnose` (skill) | **`systematic-debugging`** | 6-phase protocol. NB: `/diagnose` *command* (health check) is unrelated |
| `writing-plans` | **`implementation-planning`** | Plan authoring absorbed; see its "Bite-Sized Task Authoring" section |

### When to use look-alike skills (NOT duplicates — keep them distinct)

| Need | Use |
|------|-----|
| Sharpen vague requirements / surface assumptions & risks | `reality-check` |
| Explore an idea into an approved design/spec | `brainstorming` |
| Adversarially stress an existing design vs docs/ADRs | `grill-with-docs` |
| Pinpoint recall of a specific past decision/fact | `memory-search` |
| Synthesize the whole project narrative/history | `project-history` |
| Detect code-vs-docs drift | `context-sync` |
| Classify & quantify debt for paydown | `debt-detection` |
| Deep supply-chain/CVE/license audit | `dependency-review` (security-review defers here) |
| Logic-level vulnerability review | `security-review` |
| Split a plan into parallel streams | `parallel-planner` |
| Execute/dispatch the parallel work | `dispatching-parallel-agents` |

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

## Core Skills (detailed)

> The full set of **37 skills + 2 global** is authoritatively listed in `manifest.json`,
> with auto-load wiring in `skill-selection-matrix.json`. The three skills detailed below
> are the universal quality backbone; every other skill builds on the same enforcement model.

### 0. efficient-communication (global)
**Status:** ✅ Production Ready  
**Auto-Loaded:** ALL commands (global skill)  
**Required For:** ALL agents  

**Purpose:** Communicate clearly and concisely — natural, on-point, helpful for everyone from vibe coders to experts

**Key Rules:**
- Natural and conversational (not robotic, not cryptic)
- Efficient but complete (include necessary context, spell out terms)
- Action-oriented (tell users what to DO)
- Adaptive complexity (match response length to question)
- Length targets: simple 1-3, standard 3-6, complex 6-10 lines

**Integration:**
- Global skill (loaded for every command via skill-selection-matrix.json)
- Defined in SOUL.md communication style
- Replaces the "Caveman" anti-pattern (too cryptic to understand)

**File:** `.ai/skills/efficient-communication/SKILL.md`

---

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

**File:** `.ai/skills/test-driven-development/SKILL.md`

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

**File:** `.ai/skills/verification-before-completion/SKILL.md`

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

**File:** `.ai/skills/systematic-debugging/SKILL.md`

---

## Skill Selection Matrix

| Command | Auto-Loaded Skills | Mandatory |
|---------|-------------------|-----------|
| `/init` | - | No |
| `/design` | repomap, roastme, reality-check (+brainstorming, implementation-planning) | Yes |
| `/build` | test-driven-development, verification-before-completion | Yes |
| `/fix` | systematic-debugging, test-driven-development, verification-before-completion | Yes |
| `/review` | requesting-code-review, receiving-code-review, security-review | Yes |
| `/audit` | dependency-review, debt-detection, performance-review | No |
| `/refactor` | test-driven-development, verification-before-completion | Yes |
| `/docs` | documentation, verification-before-completion | Yes |
| `/release` | verification-before-completion | Yes |
| `/parallel` | using-git-worktrees, dispatching-parallel-agents, parallel-planner | Yes |
| `/sync` | context-sync, verification-before-completion | Yes |

*See `skill-selection-matrix.json` for the authoritative, complete mapping.*

---

## Agent-Skill Matrix

| Agent | Required Skills | Optional Skills |
|-------|----------------|-----------------|
| **Backend** | test-driven-development, verification-before-completion | systematic-debugging |
| **Frontend** | test-driven-development, verification-before-completion | systematic-debugging |
| **QA** | test-driven-development, verification-before-completion | systematic-debugging |
| **Reviewer** | verification-before-completion, requesting-code-review | security-review, performance-review |
| **Docs** | verification-before-completion, documentation | context-sync |
| **Architect** | verification-before-completion | brainstorming, implementation-planning, reality-check |
| **Orchestrator** | verification-before-completion | parallel-planner, dispatching-parallel-agents |

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

## Skill Catalog (37 + 2 global)

All skills below are implemented and production-ready. See `manifest.json` for the
authoritative list and `skill-selection-matrix.json` for auto-load wiring.

**Global (always loaded):** efficient-communication, verification-before-completion

**Design & planning:** brainstorming, implementation-planning, reality-check, roastme, repomap,
parallel-planner, test-planning

**Implementation & debugging:** test-driven-development, systematic-debugging, clean-code,
reuse-rebuild

**Review & quality:** requesting-code-review, receiving-code-review, security-review,
performance-review, accessibility-review, dependency-review, debt-detection, review-learning,
grill-with-docs

**Execution & parallelism:** subagent-driven-development, executing-plans,
dispatching-parallel-agents, using-git-worktrees, finishing-a-development-branch,
lock-manager, snapshot-manager

**Knowledge & context:** documentation, context-sync, memory-search, project-history,
cache-manager, handoff-manager

**Tooling & meta:** ripgrep, writing-skills

> Note: a few entries above are aliases/merges — see the Canonical merges table at the top.

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

### Skill Development Process

When creating or revising a skill, use the **writing-skills** skill (TDD for documentation):
1. Use **writing-skills** skill (TDD for documentation)
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

## Quality Metrics

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

**Target:** Sustain these metrics across all 37 skills in production

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

### v3.0 (2026-06-18) — current
- 37 skills + 2 global, all production-ready
- Canonical merges applied: `tdd`→`test-driven-development`, `diagnose`→`systematic-debugging`, `writing-plans`→`implementation-planning` (old names kept as aliases)
- Disambiguation table added for look-alike skills
- All skills carry YAML frontmatter; auto-load wired via `skill-selection-matrix.json`
- Drift verified by `.ai/scripts/lint-skills.ps1` (or `.sh`)

### v1.0 (2026-06-17) — initial
- test-driven-development, verification-before-completion, systematic-debugging
- Skills README, integration with quality gates and checklists
- Agent instructions updated

---

**Document Version:** 3.0  
**Last Updated:** 2026-06-18  
**Status:** Production Ready — 37 skills + 2 global  
**Next Review:** Periodic — keep in sync with `manifest.json`
