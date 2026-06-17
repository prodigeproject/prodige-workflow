# Audit: Minimal Files - Remediation Plan

**Date**: 17 Juni 2026  
**Status**: IN PROGRESS  
**Goal**: Ensure all files are properly wired and functional

---

## 🔍 Audit Findings

### Category 1: MINIMAL TEMPLATES (Need Enhancement)

**Location**: `.ai/templates/`

#### 1. AUDIT_REPORT.md ⚠️
**Current**: Only section headers, no guidance  
**Issue**: Agents don't know what to put in each section  
**Action**: Add instructions + examples for each section

#### 2. CODE_REVIEW.md ⚠️ (Need to check)
**Status**: Need to read and assess

#### 3. DESIGN_REVIEW.md ⚠️ (Need to check)
**Status**: Need to read and assess

#### 4. PARALLEL_PLAN.md ⚠️ (Need to check)
**Status**: Need to read and assess

#### 5. SYNC_REPORT.md ⚠️ (Need to check)
**Status**: Need to read and assess

---

### Category 2: MINIMAL STATE FILES (Intentionally Minimal - But Need Instructions)

**Location**: `.ai/state/`

#### 1. CURRENT.md ⚠️
**Current**: Empty template fields  
**Issue**: No instructions on when/how to update  
**Action**: Add header with update instructions + examples

#### 2. STATUS.md ⚠️
**Current**: Only says "Use /status"  
**Issue**: No context on what /status does or format  
**Action**: Add status format guide + examples

#### 3. BACKLOG.md ⚠️
**Current**: Only section headers (Now/Next/Later)  
**Issue**: No prioritization guide or format  
**Action**: Add prioritization criteria + format guide

#### 4. SPRINT.md ⚠️ (Need to check)
**Status**: Need to read and assess

---

### Category 3: PLACEHOLDER DOCS (Need Real Content)

**Location**: `docs/`

#### 1. API.md ❌
**Current**: "Project-specific documentation goes here"  
**Issue**: Placeholder, no actual guidance  
**Action**: Replace with API documentation guide + template

#### 2. DEPLOYMENT.md ❌
**Current**: "Project-specific documentation goes here"  
**Issue**: Placeholder, no actual guidance  
**Action**: Replace with deployment guide + checklist

---

### Category 4: GOOD FILES (No Action Needed)

#### ✅ SOUL.md
- Well-defined principles
- Clear coding values
- Wired into BOOT.md

#### ✅ NEWBIE_MODE.md
- Clear audience (non-technical vibe coders)
- Minimum commands listed
- Explanation guidelines
- Stop-and-ask gates defined

#### ✅ docs/HITL_REVIEW_GATES.md (assumed from name)
#### ✅ docs/MULTI_WINDOW_AGENT_GUIDE.md (assumed)
#### ✅ docs/CACHE_STRATEGY.md (assumed)

---

## 🎯 Remediation Priority

### Priority 1 (CRITICAL - Template Enhancement)
1. **AUDIT_REPORT.md** - Used by /audit workflow
2. **CODE_REVIEW.md** - Used by /review workflow
3. **DESIGN_REVIEW.md** - Used by /design workflow

### Priority 2 (HIGH - State File Instructions)
4. **CURRENT.md** - Active session tracking
5. **STATUS.md** - Project status reporting
6. **BACKLOG.md** - Task prioritization

### Priority 3 (MEDIUM - Documentation Guides)
7. **API.md** - API documentation guide
8. **DEPLOYMENT.md** - Deployment guide
9. **PARALLEL_PLAN.md** - Parallel execution template
10. **SYNC_REPORT.md** - Context sync report

---

## 📋 Remediation Actions

### Action 1: Enhance Templates
- Add "How to Use" section
- Add "What Goes Here" for each section
- Add examples
- Add checklist

### Action 2: Add State File Instructions
- Add header with "When to Update"
- Add format guide
- Add examples
- Link to relevant workflows

### Action 3: Replace Placeholders
- Create actual guide content
- Add templates within guides
- Add checklists
- Link to related workflows

---

## ✅ Success Criteria

**For each file**:
- [ ] Clear purpose statement
- [ ] Usage instructions (when/how to update)
- [ ] Format guide or template
- [ ] At least one example
- [ ] Links to related workflows/skills
- [ ] No placeholders

**Overall**:
- [ ] All templates usable by agents without guessing
- [ ] All state files have update instructions
- [ ] All docs files have real content (no placeholders)
- [ ] Everything is "wired" (referenced in workflows/BOOT.md)

---

## 🔄 Execution Plan

### Session 1 (Current)
- ✅ Audit and identify minimal files
- 🔄 Fix Priority 1 templates (AUDIT_REPORT, CODE_REVIEW, DESIGN_REVIEW)

### Session 2
- Fix Priority 2 state files (CURRENT, STATUS, BACKLOG)
- Check PARALLEL_PLAN and SYNC_REPORT

### Session 3
- Fix Priority 3 docs (API, DEPLOYMENT)
- Final verification

---

**Started**: 17 Juni 2026 16:15  
**Next Update**: After Priority 1 complete

