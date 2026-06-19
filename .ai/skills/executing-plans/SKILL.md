---
name: executing-plans
description: Use when you have a written implementation plan to execute sequentially (fallback when subagent-driven-development not available)
auto_load: ["/build"]
applies_to: [backend, frontend, qa]
mandatory: false
---

# Executing Plans

## Prodige Integration

**Auto-Loaded By:** `/build` command (fallback mode)  
**When to Use:** Platform doesn't support subagent dispatch OR tasks are tightly coupled  
**Alternative:** subagent-driven-development (preferred when available)  
**Implementation Plan:** `.ai/context/IMPLEMENTATION.md`

This skill is a **sequential execution fallback** when:
- Platform lacks subagent support (Kiro without multi-agent mode)
- Tasks are too tightly coupled for parallel work
- Single-agent execution is explicitly requested

**Preference Order:**
1. ✅ subagent-driven-development (best quality, fresh context per task)
2. ⚠️ executing-plans (this skill - sequential fallback)

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Platform Detection:**

Before using this skill, check if subagent-driven-development is available:
- If subagent dispatch available → Use subagent-driven-development instead
- If not available → Use this skill (executing-plans)

Tell your human partner: "Superpowers works much better with subagent support. Quality will be significantly higher on platforms with multi-agent capabilities (Claude Code, Codex CLI, Codex App, Copilot CLI, Gemini CLI)."

## Prodige Implementation Plan Format

**Location:** `.ai/context/IMPLEMENTATION.md`

**Expected Structure:**
```markdown
# Feature Implementation Plan

## Overview
[Feature description]

## Global Constraints
- [Constraint 1: e.g., "Use existing auth middleware, don't create new"]
- [Constraint 2: e.g., "Follow REST conventions from ARCHITECTURE.md"]

## Tasks

### Task 1: [Task Title]
**Agent:** Backend | Frontend | QA  
**Files:** src/path/to/file.ts  
**Requirements:**
- [Requirement 1]
- [Requirement 2]

**Acceptance Criteria:**
- ✅ [Criterion 1]
- ✅ [Criterion 2]

**Verification:**
```bash
npm test path/to/test.ts
```

### Task 2: [Task Title]
[Same format]
```
```

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create todos for the plan items and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **using-git-worktrees** - Ensures isolated workspace (creates one or verifies existing)
- **implementation-planning** - Creates the plan this skill executes
- **finishing-a-development-branch** - Complete development after all tasks
