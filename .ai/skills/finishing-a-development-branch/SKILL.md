---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work through Prodige's Release Gate by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow through Prodige's governance system.

**Core principle:** Verify tests → Detect environment → Pass Release Gate → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work through Prodige's Release Gate."

## Integration with Prodige

This skill integrates with Prodige's governance system:

- **Release Gate:** Final quality checkpoint before merge/PR (see `.ai/governance/review-gates.md`)
- **Review Gates:** Builds on Review Gate (code quality + spec compliance)
- **Commands:** Triggered by `/build` completion and `/parallel` merge operations
- **Runtime:** Uses `.ai/runtime/worktrees.json` for worktree provenance tracking

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with Release Gate until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Detect Environment

**Determine workspace state before presenting options:**

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule guard:** Verify not in submodule:
```bash
git rev-parse --show-superproject-working-tree 2>/dev/null
```

This determines which menu to show and how cleanup works:

| State | Menu | Cleanup | Notes |
|-------|------|---------|-------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 4 options | No worktree to clean up | Main repository checkout |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 4 options | Provenance-based (see Step 7) | Prodige-managed or manual worktree |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 3 options (no merge) | No cleanup (externally managed) | Platform-managed workspace |

### Step 3: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 4: Pass Release Gate

**Prodige's Release Gate is the final checkpoint before integration.**

Run the Release Gate checklist:

#### Release Gate Checklist

**Quality Verification:**
- [ ] All tests passing
- [ ] No compiler warnings or lint errors
- [ ] Code review completed (Review Gate passed)
- [ ] Implementation Gate requirements met

**Documentation:**
- [ ] CHANGELOG.md updated (if applicable)
- [ ] API documentation current
- [ ] Breaking changes documented

**Integration Safety:**
- [ ] Base branch up to date (`git pull origin <base>`)
- [ ] No merge conflicts
- [ ] CI/CD pipeline passing (if available)

**Governance Compliance:**
- [ ] Spec requirements fulfilled
- [ ] Design decisions documented in `.ai/context/DECISIONS.md`
- [ ] No deviations from approved architecture

**If any Release Gate item fails:** Report the failure and stop. User must resolve before proceeding.

**If Release Gate passes:** Continue to Step 5.

### Step 5: Present Options

**Normal repo and named-branch worktree — present exactly these 4 options:**

```
Release Gate passed ✅

Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Detached HEAD — present exactly these 3 options:**

```
Release Gate passed ✅

Implementation complete. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)
3. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 6: Execute Choice

#### Option 1: Merge Locally

```bash
# Get main repo root for CWD safety
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

# Ensure base branch is current
git checkout <base-branch>
git pull origin <base-branch>

# Merge — verify success before removing anything
git merge <feature-branch> --no-ff -m "Merge <feature-branch>: <brief-description>"

# Verify tests on merged result
<test command>

# Only after merge succeeds: cleanup worktree (Step 7), then delete branch
```

**Integration with Prodige context:**
```bash
# Update CHANGELOG.md
echo "## [$(date +%Y-%m-%d)] - <feature-name>" >> .ai/context/CHANGELOG.md
echo "- Merged <feature-branch>" >> .ai/context/CHANGELOG.md

# Update DECISIONS.md if architectural changes made
# (Manual review - ask user if needed)
```

Then: Cleanup worktree (Step 7), then delete branch:

```bash
git branch -d <feature-branch>
```

**Report completion:**
```
✅ Merged to <base-branch>
✅ Tests passing
✅ Worktree cleaned up
✅ Branch deleted

Release complete. Ready for next task.
```

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR using platform CLI (if available)
gh pr create --title "<feature-name>" --body "<description>" --base <base-branch>
# or
glab mr create --title "<feature-name>" --description "<description>" --target-branch <base-branch>
```

**PR Description Template:**
```markdown
## Summary
<Brief description of changes>

## Changes
- <Change 1>
- <Change 2>

## Testing
- All tests passing (X tests, 0 failures)
- Manual testing: <describe>

## Checklist
- [x] Release Gate passed
- [x] Tests passing
- [x] Documentation updated
- [x] CHANGELOG updated

## Related
- Spec: `.ai/context/designs/<spec-file>.md`
- Implementation plan: `.ai/context/IMPLEMENTATION.md`
```

**Do NOT clean up worktree** — user needs it alive to iterate on PR feedback.

**Report:**
```
✅ Pushed to origin/<feature-branch>
✅ PR created: <PR-URL>
✅ Worktree preserved for PR iteration

Next: Wait for PR review, then use this skill again to clean up after merge.
```

#### Option 3: Keep As-Is

Report: 
```
Keeping branch <name>.
Worktree preserved at <path>.
Release Gate passed - ready to merge when you're ready.
```

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
⚠️  WARNING: This will permanently delete:
- Branch: <name>
- All commits: <commit-list>
- Worktree at: <path>

This cannot be undone.

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

Then: Cleanup worktree (Step 7), then force-delete branch:
```bash
git branch -D <feature-branch>
```

**Report:**
```
✅ Branch deleted
✅ Worktree removed
✅ Work discarded

Ready for next task.
```

### Step 7: Cleanup Workspace

**Only runs for Options 1 and 4.** Options 2 and 3 always preserve the worktree.

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

**If `GIT_DIR == GIT_COMMON`:** Normal repo, no worktree to clean up. Done.

**If worktree exists, check provenance:**

#### Prodige Worktree Tracking

Prodige tracks worktree provenance in `.ai/runtime/worktrees.json`:

```json
{
  "worktrees": [
    {
      "path": "/path/to/.worktrees/feature-branch",
      "branch": "feature-branch",
      "created": "2024-01-15T10:30:00Z",
      "createdBy": "using-git-worktrees",
      "status": "active"
    }
  ]
}
```

**Check provenance:**
```bash
# Check if worktree is Prodige-managed
if [ -f .ai/runtime/worktrees.json ]; then
  # Parse JSON to check if this worktree is tracked
  # If tracked: Prodige owns cleanup
  # If not tracked: Externally managed
fi
```

**If worktree path is under `.worktrees/` or `worktrees/`:** Prodige created this worktree — we own cleanup.

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git worktree remove "$WORKTREE_PATH"
git worktree prune  # Self-healing: clean up any stale registrations

# Update Prodige tracking
# Remove from .ai/runtime/worktrees.json
```

**Otherwise:** The host environment (harness) owns this workspace. Do NOT remove it. If your platform provides a workspace-exit tool, use it. Otherwise, leave the workspace in place.

## Integration with Prodige Commands

### `/build` Completion

After `/build` completes all implementation tasks:

1. `/build` invokes this skill automatically
2. Release Gate verification runs
3. User chooses integration option
4. Workflow completes

### `/parallel` Merge Operations

After parallel agents complete:

1. Each agent uses this skill in their worktree
2. Orchestrator collects completion status
3. Orchestrator merges work following Option 1 or 2
4. All worktrees cleaned up atomically

**Parallel-specific considerations:**
- **Lock coordination:** Check `.ai/runtime/locks/` before merge
- **Conflict detection:** Verify no overlapping file changes
- **Atomic cleanup:** All parallel worktrees removed together

### Rollback Integration

If user invokes `/rollback` after this skill:

```bash
# Rollback reads CHANGELOG.md for recent merges
# Can undo Option 1 merges (if not pushed)
# Cannot undo Option 2 PRs (must close PR manually)
```

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch | Update Context |
|--------|-------|------|---------------|----------------|----------------|
| 1. Merge locally | yes | - | - | yes | CHANGELOG.md |
| 2. Create PR | - | yes | yes | - | PR description |
| 3. Keep as-is | - | - | yes | - | - |
| 4. Discard | - | - | - | yes (force) | - |

## Prodige-Specific Patterns

### Context Synchronization

When Option 1 chosen (merge locally):

```bash
# Update context files
echo "## [$(date +%Y-%m-%d)] - Feature: <name>" >> .ai/context/CHANGELOG.md
echo "### Changes" >> .ai/context/CHANGELOG.md
echo "<summary>" >> .ai/context/CHANGELOG.md

# If architectural decision made
if [ "<has-architecture-change>" = "yes" ]; then
  echo "## Decision: <title>" >> .ai/context/DECISIONS.md
  echo "Date: $(date +%Y-%m-%d)" >> .ai/context/DECISIONS.md
  echo "Context: <context>" >> .ai/context/DECISIONS.md
  echo "Decision: <decision>" >> .ai/context/DECISIONS.md
fi
```

### Worktree Provenance Tracking

Update `.ai/runtime/worktrees.json` on cleanup:

```json
{
  "worktrees": [
    {
      "path": "/path/to/.worktrees/feature-branch",
      "branch": "feature-branch",
      "created": "2024-01-15T10:30:00Z",
      "createdBy": "using-git-worktrees",
      "status": "completed",
      "completedAt": "2024-01-15T12:45:00Z",
      "completionMethod": "merged-locally"
    }
  ]
}
```

### Cache Invalidation

After merge (Option 1):

```bash
# Invalidate relevant cache entries
# (If cache-manager skill is active)
# Ensures next session has fresh context
```

## Common Mistakes

**Skipping Release Gate**
- **Problem:** Merge code that doesn't meet quality standards
- **Fix:** Always run Release Gate checklist before presenting options

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before Release Gate

**Open-ended questions**
- **Problem:** "What should I do next?" is ambiguous
- **Fix:** Present exactly 4 structured options (or 3 for detached HEAD)

**Cleaning up worktree for Option 2**
- **Problem:** Remove worktree user needs for PR iteration
- **Fix:** Only cleanup for Options 1 and 4

**Deleting branch before removing worktree**
- **Problem:** `git branch -d` fails because worktree still references the branch
- **Fix:** Merge first, remove worktree, then delete branch

**Running git worktree remove from inside the worktree**
- **Problem:** Command fails silently when CWD is inside the worktree being removed
- **Fix:** Always `cd` to main repo root before `git worktree remove`

**Cleaning up externally-managed worktrees**
- **Problem:** Removing a worktree the harness/platform created causes phantom state
- **Fix:** Check provenance - only clean up Prodige-managed worktrees (`.worktrees/` or tracked in `worktrees.json`)

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

**Not updating Prodige context**
- **Problem:** CHANGELOG.md and DECISIONS.md become stale
- **Fix:** Update context files on Option 1 completion

**Ignoring parallel lock coordination**
- **Problem:** Race conditions when multiple agents finish simultaneously
- **Fix:** Check `.ai/runtime/locks/` before merge in parallel workflows

## Red Flags

**Never:**
- Skip Release Gate verification
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request
- Remove a worktree before confirming merge success
- Clean up worktrees you didn't create (provenance check)
- Run `git worktree remove` from inside the worktree
- Skip context updates (CHANGELOG.md) on merge
- Ignore locks in parallel workflows

**Always:**
- Run Release Gate checklist before offering options
- Verify tests before Release Gate
- Detect environment before presenting menu
- Present exactly 4 options (or 3 for detached HEAD)
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only
- `cd` to main repo root before worktree removal
- Run `git worktree prune` after removal
- Update CHANGELOG.md on successful merge
- Check worktree provenance before cleanup
- Coordinate with locks in parallel workflows

## Governance Integration Summary

This skill is the final step in Prodige's governance workflow:

```
PRD Gate → Architecture Gate → Implementation Gate → Review Gate → **Release Gate** → Merge/PR
```

**Release Gate ensures:**
- All tests passing
- Code review complete
- Documentation current
- Breaking changes documented
- Governance requirements met

**After Release Gate:**
- Option 1: Merge locally → Update context → Clean up
- Option 2: Create PR → Preserve worktree for iteration
- Option 3: Keep as-is → User decides timing
- Option 4: Discard → Confirm → Clean up

This skill bridges implementation completion to code integration, ensuring quality and governance compliance at every step.

