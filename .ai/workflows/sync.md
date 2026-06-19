# Workflow: Sync

## Overview
Synchronization workflow to detect and resolve drift between repository state, documentation, cache, and context files. Ensures consistency across all project artifacts and keeps the AI agent's understanding aligned with actual codebase state.

## Prerequisites
- Active project repository
- Existing context files in `.ai/context/`
- Cache system initialized (`.ai/runtime/cache/`)
- Git repository with commit history
- Read/write permissions for context and cache files

## Step-by-Step Instructions

### 1. Compare Repo with Context

**Action**: Verify that context files accurately reflect the current repository state.

**Check alignment:**
- Read `.ai/context/PROJECT.md` - Does it match current project scope?
- Read `.ai/context/ARCHITECTURE.md` - Does it match actual code architecture?
- Read `.ai/context/CONTEXT.md` - Are domain terms still accurate?
- Read `.ai/context/DECISIONS.md` - Are past decisions still valid?

**Detect drift:**
- New features implemented but not documented in context
- Removed features still documented in context
- Architectural changes not reflected in ARCHITECTURE.md
- New dependencies not documented
- Changed tech stack not updated

**Tools:**
```bash
# Check recent commits for architectural changes
git log --oneline -n 20

# Check for new files/directories
git diff --name-status [last-sync-commit]..HEAD
```

**Output**: List of context files that need updates

**Checkpoints**:
- Do context files reflect current reality?
- Are there undocumented changes?
- Is terminology still consistent?

### 2. Compare Docs with Implementation

**Action**: Ensure documentation matches actual code implementation.

**Verify consistency:**
- Check README.md setup instructions against actual setup process
- Verify API documentation matches actual API endpoints
- Compare code comments with actual function behavior
- Check CHANGELOG.md for undocumented changes
- Validate configuration examples in docs

**Common drift scenarios:**
- Function signatures changed but docs not updated
- New environment variables required but not documented
- API endpoints renamed but docs still reference old names
- Removed features still documented
- New configuration options not documented

**Detection approach:**
```bash
# Find functions mentioned in docs
grep -r "functionName" docs/

# Check if they exist in code
grep -r "functionName" src/

# Compare API routes in docs vs code
grep -r "app.get\|app.post" src/ > actual-routes.txt
grep -r "GET\|POST" docs/api/ > documented-routes.txt
diff actual-routes.txt documented-routes.txt
```

**Output**: List of documentation requiring updates

### 3. Compare Cache with Repo

**Action**: Verify cache freshness and detect stale cached data.

**Check cache state:**
- Read `.ai/runtime/cache/snapshot.json` - When was last snapshot?
- Compare cached file hashes with current file hashes
- Check if cached summaries reflect current code
- Verify cached dependencies match `package.json`/`requirements.txt`
- Check if cached test results are current

**Cache drift indicators:**
- Cache timestamp older than recent commits
- File modification times newer than cache time
- Hash mismatches between cache and current files
- Dependency changes not reflected in cache
- Test results in cache don't match last test run

**Tools:**
```bash
# Check last cache update
ls -l .ai/runtime/cache/snapshot.json

# Check file modification times
find src/ -newer .ai/runtime/cache/snapshot.json

# Compare dependency files
diff <(cat .ai/runtime/cache/dependencies.json) <(cat package.json)
```

**Output**: Cache freshness report, list of stale cache entries

### 4. Identify Drift

**Action**: Consolidate all detected inconsistencies and categorize by severity.

**Drift categories:**

**High-priority drift** (breaks functionality):
- Context describes non-existent features
- Documentation has wrong API endpoints
- Cache contains invalid data
- Security-related documentation outdated

**Medium-priority drift** (misleading):
- Feature descriptions don't match implementation
- Architecture diagrams outdated
- Setup instructions incomplete
- Performance characteristics changed

**Low-priority drift** (cosmetic):
- Terminology inconsistencies
- Style guide not followed
- Comment formatting
- Minor doc typos

**Create drift report:**
```markdown
## Drift Analysis Report

**Generated:** [timestamp]

### High Priority
- [ ] Context: PROJECT.md references removed "auth-v1" module
- [ ] Docs: API.md documents deprecated /users endpoint

### Medium Priority
- [ ] Architecture: ARCHITECTURE.md shows old database schema
- [ ] Cache: Test results cached from 3 days ago

### Low Priority
- [ ] Docs: README.md has minor typos
- [ ] Context: Terminology inconsistency ("user" vs "account")

**Total drift items:** 6
**Estimated sync time:** 20 minutes
```

**Skill:** Systematic analysis and prioritization

### 5. Suggest Updates

**Action**: Propose specific changes to resolve each drift item.

**For each drift item, provide:**
- What needs to change
- Specific file(s) to update
- Suggested new content
- Rationale for change

**Update suggestion format:**
```markdown
### Drift Item: [Description]

**File:** `.ai/context/PROJECT.md`

**Current state:**
```
Project includes auth-v1 authentication module using JWT tokens.
```

**Proposed change:**
```
Project uses auth-v2 authentication module with OAuth2 and refresh tokens.
```

**Reason:** auth-v1 was replaced with auth-v2 in commit abc123f (2024-01-15)

**Impact:** Medium - Affects onboarding documentation

**Auto-fixable:** Yes
```

**Categorize updates:**
- **Auto-fixable**: Straightforward updates (typos, version numbers)
- **Requires review**: Content changes that may need human judgment
- **Breaking changes**: Updates that affect external users/APIs

### 6. Ask Approval for Major Context Changes

**Action**: Present significant changes to human for approval before applying.

**Major changes requiring approval:**
- Modifications to project scope (PROJECT.md)
- Architectural decisions or reversals (ARCHITECTURE.md, DECISIONS.md)
- Changes to core terminology (CONTEXT.md)
- Removal of documented features
- Changes to public APIs or interfaces

**Minor changes (auto-apply):**
- Typo fixes
- Formatting corrections
- Adding missing but obvious documentation
- Cache refreshes
- Version number updates

**Approval request format:**
```markdown
## Sync Approval Required

**Change type:** Context update
**Severity:** High
**Files affected:** 3

### Proposed Changes:

#### 1. Update ARCHITECTURE.md
**Change:** Remove reference to deprecated auth-v1 module
**Reason:** Module removed in commit abc123f
**Impact:** Documentation consistency

#### 2. Update PROJECT.md
**Change:** Add new "notifications" feature to scope
**Reason:** Feature implemented but not documented
**Impact:** Project scope definition

#### 3. Update CONTEXT.md
**Change:** Standardize "user" terminology (currently mixed with "account")
**Reason:** Code uses "user" consistently
**Impact:** Terminology consistency

**Approve all changes? (y/n)**
**Approve individually? (y/n)**
```

**Wait for human decision before proceeding with major updates.**

**Skill:** Human-in-the-loop (HITL) gate for significant changes

### 7. Apply Approved Updates

**Action**: Execute all approved synchronization updates.

**Update sequence:**
1. Apply auto-fixable changes first
2. Apply approved context changes
3. Update documentation
4. Refresh cache
5. Update manifest version

**For each update:**
```bash
# Backup before changes
cp .ai/context/PROJECT.md .ai/context/PROJECT.md.backup

# Apply changes
# [make updates to files]

# Verify changes
git diff .ai/context/

# Stage changes
git add .ai/context/
```

**Track updates:**
```markdown
## Sync Execution Log

- [✓] Updated PROJECT.md (removed auth-v1 reference)
- [✓] Updated ARCHITECTURE.md (updated database schema diagram)
- [✓] Updated API.md (corrected endpoint documentation)
- [✓] Refreshed cache snapshot
- [✓] Bumped manifest context_version to 13
- [ ] Pending: CONTEXT.md terminology update (awaiting approval)

**Applied:** 5/6 changes
**Status:** Sync 83% complete
```

### 8. Update Manifest Version

**Action**: Update the context manifest to track sync history.

**Manifest update:**
- Read `.ai/context/manifest.json`
- Bump `context_version` (integer, e.g., 12 → 13)
- Update `last_sync` timestamp (ISO 8601)
- Record sync summary

**Manifest format:**
```json
{
  "schema_version": "1.0",
  "context_version": 13,
  "last_sync": "2024-01-20T10:30:00Z",
  "syncHistory": [
    {
      "context_version": 13,
      "last_sync": "2024-01-20T10:30:00Z",
      "itemsFixed": 5,
      "driftDetected": ["context", "docs", "cache"],
      "summary": "Synchronized auth module documentation and cache"
    }
  ]
}
```

**Versioning scheme:**
- `schema_version`: Fixed string describing the manifest schema; only changes when the manifest structure itself changes.
- `context_version`: Monotonic integer; incremented by `/sync` on every successful sync.
- `last_sync`: ISO 8601 timestamp of the most recent sync.

### 9. Refresh Cache

**Action**: Regenerate cache with current repository state.

**Cache refresh steps:**
1. Clear stale cache entries
2. Regenerate file snapshots
3. Update dependency cache
4. Refresh test result cache
5. Update file hash index
6. Regenerate code summaries (if using AI-generated summaries)

**Commands:**
```bash
# Clear old cache (if cache tool exists)
cache clear --stale

# Regenerate cache
cache rebuild --full

# Verify cache
cache verify
```

**Cache verification:**
- All tracked files have current hashes
- No stale timestamps
- Dependency tree accurate
- Test results current

**Output:** Fresh cache synchronized with repository state

### 10. Generate Sync Report

**Action**: Create comprehensive report of sync operation.

**Output format:** see `.ai/templates/SYNC_REPORT.md`

**Record any new technical debt to `.ai/governance/debt/technical-debt.md`** — append (do not overwrite) any drift items or shortcuts uncovered during sync that won't be fixed now, so the canonical debt registry stays current.

**Report sections:**

```markdown
# Sync Report

**Date:** 2024-01-20T10:30:00Z
**Duration:** 8 minutes
**Manifest context_version:** 12 → 13

## Summary
- **Drift items detected:** 6
- **Items fixed:** 5
- **Items pending approval:** 1
- **Cache entries refreshed:** 142
- **Files updated:** 3

## Drift Resolution

### High Priority (2/2 fixed)
- [✓] Context: Removed auth-v1 reference from PROJECT.md
- [✓] Docs: Updated API endpoints in API.md

### Medium Priority (2/2 fixed)
- [✓] Architecture: Updated database schema in ARCHITECTURE.md
- [✓] Cache: Refreshed test results (3 days stale)

### Low Priority (1/2 fixed)
- [✓] Docs: Fixed typos in README.md
- [⏳] Context: Terminology standardization (pending approval)

## Files Modified
- `.ai/context/PROJECT.md` (1 section updated)
- `.ai/context/ARCHITECTURE.md` (schema diagram updated)
- `docs/api/API.md` (endpoint documentation corrected)
- `.ai/runtime/cache/snapshot.json` (full refresh)

## Next Sync Recommended
Based on project activity: 7 days

## Action Items
- [ ] Review pending terminology update in CONTEXT.md
- [ ] Monitor for new drift (auto-check in 7 days)
```

### 11. Commit Sync Changes

**Action**: Commit all synchronization updates to git.

**Commit format:**
```bash
git add .ai/context/ .ai/runtime/cache/ docs/
git commit -m "chore: sync context, docs, and cache

Drift resolution:
- Updated PROJECT.md: removed auth-v1 references
- Updated ARCHITECTURE.md: corrected database schema
- Updated API.md: fixed endpoint documentation
- Refreshed cache: 142 entries updated
- Manifest context_version: 12 → 13

Sync report: 5/6 items fixed, 1 pending approval"
```

**Skill:** Clean git history with descriptive commits

## Expected Outcomes

### Deliverables
1. **Sync Report**: Comprehensive drift analysis and resolution summary
2. **Updated Context Files**: All context files synchronized with codebase
3. **Updated Documentation**: Docs match implementation
4. **Fresh Cache**: Cache reflects current repository state
5. **Updated Manifest**: `context_version` bumped, `last_sync` updated, sync history recorded

### Success Criteria
- All high-priority drift resolved
- Context files accurately describe current project
- Documentation matches implementation
- Cache is fresh (< 24 hours old)
- No breaking inconsistencies remain
- Manifest `context_version` bumped and `last_sync` updated

## Troubleshooting Tips

### Issue: Too much drift detected to fix in one session
**Solution**:
- Prioritize by severity (high → medium → low)
- Fix high-priority items first
- Schedule follow-up sync for remaining items
- Consider implementing automated sync checks

### Issue: Conflicting information in different context files
**Solution**:
- Identify source of truth (usually: code is truth)
- Update all conflicting files to match source of truth
- Add cross-references between related context files
- Document resolution in DECISIONS.md

### Issue: Cache corruption or incompatible cache version
**Solution**:
```bash
# Full cache reset
rm -rf .ai/runtime/cache/*
cache init
cache rebuild --full
```

### Issue: Human approval required but human unavailable
**Solution**:
- Apply only auto-fixable changes
- Document pending approvals in `.ai/runtime/queue/approvals.md`
- Set reminder for follow-up when human available
- Generate interim sync report showing partial progress

### Issue: Git conflicts during sync commit
**Solution**:
```bash
# Stash sync changes
git stash

# Pull latest
git pull

# Reapply sync
git stash pop

# Resolve conflicts (context files usually safe to overwrite)
# Re-commit
```

## Best Practices

1. **Regular Sync Schedule**: Run sync weekly or after major feature implementations
2. **Automate Where Possible**: Use hooks or CI/CD to auto-detect drift
3. **Version Control Sync Changes**: Always commit sync updates with clear messages
4. **Document Approvals**: Keep record of human decisions on major changes
5. **Monitor Drift Trends**: Track how often drift occurs to identify documentation gaps
6. **Sync After Refactoring**: Always sync after major code restructuring
7. **Keep Cache Fresh**: Stale cache degrades AI agent performance
8. **Validate After Sync**: Run quick verification to ensure sync didn't break anything

## Related Workflows
- **Audit**: Use sync findings to inform audit priorities
- **Status**: Sync is part of comprehensive status check
- **Build**: Sync before starting new feature implementation
- **Review**: Sync ensures reviewers have accurate context
- **Cache**: Cache workflow is subset of sync workflow

## Integration Points

**Context Files:**
- Reads/Updates: `PROJECT.md`, `ARCHITECTURE.md`, `CONTEXT.md`, `DECISIONS.md`
- Reads/Updates: `.ai/context/manifest.json` (`schema_version`, `context_version`, `last_sync`)

**Cache:**
- Reads/Updates: `.ai/runtime/cache/snapshot.json`
- Regenerates: All cache entries

**Documentation:**
- Reads/Updates: `README.md`, `API.md`, CHANGELOG.md`, architecture docs

**Skills:**
- Systematic analysis (drift detection)
- Human-in-the-loop (HITL) gate for major changes
- Git workflow (clean commits)

**Commands:**
- `cache rebuild` - Regenerate cache
- `cache verify` - Verify cache integrity
- `/audit` - Comprehensive audit (includes sync)
- `/status` - Quick status check (includes sync check)

---

## Sync Frequency Recommendations

| Project Phase | Sync Frequency | Rationale |
|---------------|----------------|-----------|
| **Active Development** | Every 2-3 days | High change velocity |
| **Maintenance Mode** | Weekly | Lower change frequency |
| **Pre-Release** | Daily | Critical documentation accuracy |
| **Post-Major Refactor** | Immediately | Significant structural changes |
| **After External PR Merge** | Immediately | Unknown code changes |

---

**Remember:** Sync is preventive maintenance. Regular syncing prevents large drift accumulation and keeps the AI agent's understanding aligned with reality. Small, frequent syncs are easier than large, infrequent ones.
