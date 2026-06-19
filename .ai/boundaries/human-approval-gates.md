# Human Approval Gates

Certain operations in Prodige Workflow **require human approval** (HITL gates) and cannot be automated away. These gates are non-negotiable.

## Why This Is Out of Scope

### 1. Risk Management
AI agents can make mistakes. Humans provide:
- **Sanity checks** on major changes
- **Business context** AI doesn't have
- **Rollback decisions** based on impact assessment
- **Ethical oversight** on sensitive operations

### 2. Organizational Accountability
Decisions must be **attributable to humans**:
- Legal responsibility
- Audit trails for compliance
- Team coordination and communication
- Knowledge sharing

### 3. Trust Building
HITL gates build confidence:
- Teams trust systems that ask for approval
- Gradual automation as trust grows
- Safety nets prevent catastrophic errors

## Non-Negotiable HITL Gates

### 1. `/design` - Design Approval
**When**: After design document generated, before `/build`  
**Why**: Major architectural decisions require human judgment  
**What**: Review PRD.md, ARCHITECTURE.md, IMPLEMENTATION.md  
**Can't skip**: No

### 2. `/refactor` - Refactor Approval
**When**: Before large-scale code changes  
**Why**: Refactoring can break working code  
**What**: Review refactor plan and impact analysis  
**Can't skip**: No

### 3. `/release` - Release Approval
**When**: Before version bumps and tagging  
**Why**: Releases are public commitments  
**What**: Review CHANGELOG.md, version number, release notes  
**Can't skip**: No

### 4. `/parallel` - Parallel Work Planning
**When**: Before spawning multiple agents  
**Why**: Coordination failures can corrupt codebase  
**What**: Review task splits and dependencies  
**Can't skip**: No

### 5. `/rollback` - Checkpoint Restoration
**When**: Before reverting to previous checkpoint  
**Why**: Rollback loses recent work  
**What**: Confirm which checkpoint and what gets lost  
**Can't skip**: No

## Conditional HITL Gates

These can be skipped with flags but are recommended:

### 1. `/fix` - Bug Fix Review
**Default**: HITL if production bug or multi-file change  
**Skip**: `--auto-approve` for trivial fixes  
**Why**: Complex fixes need review

### 2. `/docs` - Documentation Changes
**Default**: HITL if major documentation restructure  
**Skip**: `--auto-approve` for typos/minor updates  
**Why**: Major doc changes affect team understanding

### 3. `/magic` - Magic Command Execution
**Default**: Always generates plan for approval  
**Skip**: Can't skip (magic is designed for HITL)  
**Why**: Magic serves beginners who need guidance

## What Can Be Automated

✅ **No HITL Required**:
- `/verify` - Automated quality checks
- `/review` - Code review (reports findings)
- `/audit` - Repository audit (reports issues)
- `/session-start` - Memory loading
- `/session-end` - Memory saving
- `/undo` - Revert last change (safe)
- `/checkpoint` - Create save point (safe)

## Escape Hatches

> **CONCEPTUAL / ILLUSTRATIVE:** `PRODIGE_AUTO_APPROVE` is a design illustration, not a
> shipped feature. No code in this workflow reads this environment variable, and setting
> it changes nothing at runtime. It exists to describe *how* a trusted-automation escape
> hatch could work and to frame the policy below. Do not expect the examples in this
> section to actually skip HITL gates today.

### For Trusted Automation (illustrative)

If you REALLY trust the AI (e.g., CI/CD environments), the intended model would look
like this:

```bash
# Illustrative only - this variable is not consumed by any shipped code.
export PRODIGE_AUTO_APPROVE=true

# Conceptually, these would skip HITL (use with caution!)
/design feature-name    # Would auto-approve design
/build feature-name     # Would proceed without review
```

**WARNING**: Even as a concept, this pattern would only ever be appropriate in:
- Automated testing environments
- Throwaway prototypes
- Well-tested workflows

**NEVER** intended for:
- Production codebases
- Team repositories
- Unfamiliar projects

### For Gradual Automation

Start with full HITL, gradually reduce as confidence grows:

**Week 1-2**: Full HITL for everything  
**Week 3-4**: Skip HITL for trivial `/fix`, `/docs`  
**Week 5-6**: Skip HITL for well-tested `/build` patterns
**Month 3+**: Consider an `AUTO_APPROVE`-style policy for specific workflows (conceptual; see note above)

But ALWAYS keep HITL for:
- `/design` (architectural decisions)
- `/refactor` (large changes)
- `/release` (public commitments)
- `/parallel` (coordination complexity)

## Philosophy Alignment

From SOUL.md Principle 9:
> "Human approval before irreversible changes"

Design, refactor, release, parallel work, rollback are all irreversible or high-impact.

From rules.md:
> "Never: Do not silently change architecture"

HITL gates prevent silent changes by forcing explicit approval.

## Prior Requests

- "Can we skip design approval for small features?" → NO
  - Small features can have big architectural impact
  - Approval takes 30 seconds, prevents hours of rework

- "Can `/magic` run without human review?" → NO
  - Magic is designed for beginners who need oversight
  - Use direct commands (`/build`, `/fix`) if you want less HITL

## Recommended Workflow

### For Beginners (Full HITL)
```bash
/session-start
/magic create user authentication
# Review plan → Approve
# Review implementation → Approve
/verify
/session-end
```

### For Experienced Devs (Selective HITL)
```bash
/session-start
/design auth-system          # HITL: Review design
/build auth-system           # HITL: Review plan
/fix typo --auto-approve     # Skip HITL: Trivial
/verify                      # No HITL: Automated
/session-end
```

### For Automation (Minimal HITL, Risky!)
```bash
# Illustrative only - PRODIGE_AUTO_APPROVE is not consumed by shipped code.
export PRODIGE_AUTO_APPROVE=true
/verify                      # Safe to automate
# Do NOT automate /design, /refactor, /release
```

## Metrics

Track HITL gate effectiveness:
- **Approval rate**: What % of plans get approved as-is?
- **Rejection rate**: What % get modified before approval?
- **Time at gate**: Average time from pause to approval
- **Error prevention**: Issues caught at HITL gates

Goal: High approval rate (AI learns) + Meaningful rejections (safety net works)

---

**Bottom Line**: HITL gates are features, not bugs. They keep Prodige trustworthy.
