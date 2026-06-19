# Agent Handoff Template

> **File**: `.ai/runtime/handoffs/HANDOFF_TEMPLATE.md`  
> **Purpose**: Standard format for worker-to-reviewer (and agent-to-agent) handoffs  
> **Produced by**: the `handoff-manager` skill  
> **Saved as**: `.ai/runtime/handoffs/handoff-<timestamp>.md`  
> **Related**: [Runtime README](../README.md), [ORCHESTRATOR](../../orchestrator/ORCHESTRATOR.md)

---

## Overview

This template mirrors the `handoff-manager` skill output. Complete every section so the
handoff can be understood by someone with zero context about your session. Sections map
1:1 to the skill's standard format: session summary, current state, context, next steps,
blockers, open questions, files affected, and a handoff-quality assessment.

---

## Handoff Metadata

**Session ID**: `[unique session identifier, e.g. session-backend-feature-20240115-143022]`  
**Agent Role**: `[e.g., orchestrator, architect, backend, frontend, qa]`  
**Snapshot Reference**: `[snapshot_id if applicable, e.g. snapshot-20240115-143022]`  
**Started**: `[YYYY-MM-DD HH:MM]`  
**Completed**: `[YYYY-MM-DD HH:MM]`  
**Duration**: `[approximate duration]`

---

## Session Summary

[2-3 sentences describing what was accomplished this session. Be specific.]

---

## Current State

[Where the work stands now. Include an approximate completeness assessment, what is
working, what is mocked or stubbed, and what is not started.]

---

## Context (Decisions and Rationale)

### Technical Decisions

1. **[Decision Topic]**
   - **Choice**: [What was chosen]
   - **Alternatives Considered**: [Other options]
   - **Rationale**: [Why this choice was made]
   - **Impact**: [What this affects]

### Deferred Decisions

1. **[Topic]**: [Why deferred and who should decide]

---

## Files Affected

| File Path | Change Type | Summary |
|-----------|-------------|---------|
| `path/to/file1.js` | Modified | [What changed and why] |
| `path/to/file2.js` | Created | [Purpose of new file] |
| `path/to/file3.js` | Deleted | [Reason for deletion] |

**Total Files Changed**: [number]

---

## Tests Run

### Automated Tests

```bash
[Commands run and results]
```

**Results**:
- Tests Passed: [number]
- Tests Failed: [number]
- Coverage: [percentage if known]

### Manual Testing

- [ ] [Test scenario 1]
- [ ] [Test scenario 2]

**Notes**: [Any issues found or edge cases discovered]

---

## Next Steps

Prioritized, actionable steps for the reviewer or next agent:

1. [Action required next]
2. [Follow-up task]
3. [Future improvement]

---

## Blockers

- **[Blocker]**: [Description, contact info, and estimated unblock time]
- _If none: write "None"._

---

## Open Questions

1. **[Question]**: [Context for the decision needed]
- _If none: write "None"._

---

## Risks / Known Issues

### Critical Issues

- **[Issue]**: [Description and recommended action]

### Medium Issues

- **[Issue]**: [Description]

### Technical Debt Introduced

- **[Debt]**: [Why it was necessary and how to address later]

---

## Verification

[How can the reviewer verify these changes are correct? List concrete steps.]

---

## Needs Reviewer Attention

### High Priority

1. **[Item]**: [Why this needs careful review]

### Approval Required

- [ ] [Specific decision that needs sign-off]

---

## Context Updates Needed

### Documentation Updates

- [ ] `[file/path]`: [What needs to be documented]

### Cache Updates

- [ ] `repo-map.md`
- [ ] `architecture-summary.md`
- [ ] `module-summaries/[module].md`

### Related Work

**Blocked By**: [List any dependencies]  
**Blocks**: [What is waiting on this work]  
**Related Handoffs**: [Links to related handoff documents]

---

## Handoff Quality

**Assessment**: `[Complete | Partial | Complete with blocker]`

**Reasoning**: [Why this assessment - what, if anything, is missing for full continuity]

---

## Handoff Checklist

Before submitting this handoff, ensure:

- [ ] Session summary is clear and specific
- [ ] Current state reflects reality
- [ ] All decisions have rationale documented
- [ ] Files affected list is accurate and complete
- [ ] Tests were run and results documented
- [ ] Next steps are actionable and prioritized
- [ ] Blockers are clearly flagged with contact info
- [ ] Open questions are explicit
- [ ] Handoff quality is assessed

---

**Handoff Submitted By**: [Agent role/name]  
**Handoff Date**: [YYYY-MM-DD HH:MM]  
**Status**: [Draft | Ready for Review | Approved]
