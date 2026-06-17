# /rollback

Restore code to a previous checkpoint.

Travel back in time to any saved state.

---

## What This Does

Restores your code to an earlier checkpoint:
1. Shows what will change
2. Asks for confirmation (with safety checks)
3. Resets code to checkpoint state
4. Preserves commits in reflog for recovery

---

## Usage

```bash
# List available checkpoints
/rollback

# Rollback to specific checkpoint
/rollback pre-refactor

# Rollback to working version
/rollback working-version
```

---

## Instructions

Invoke the **git-guardian** agent to execute rollback protocol:

### Tasks

1. **If no checkpoint name provided**:
   - List available checkpoints
   - Show creation dates
   - Show usage instructions
   - Exit

2. **If checkpoint name provided**:
   - Verify checkpoint exists
   - Show what will change (commits to be undone)
   - Check for uncommitted changes
   - Offer to stash if needed

3. **Get confirmation**:
   - Show clear warning about reset
   - Explain what happens to commits
   - Require explicit confirmation

4. **Execute rollback**:
   - `git reset --hard checkpoint-{name}`
   - Verify success
   - Show current status

5. **Report results**:
   - Confirm rollback complete
   - Show restored state
   - Remind about reflog recovery if needed

### Output Format

Follow format in git-guardian agent:
- List of checkpoints (if no name)
- Preview of changes (if name provided)
- Confirmation prompt with warnings
- Success message with current status

---

## Safety Features

- ⚠️ **Always asks for confirmation** - Can't accidentally rollback
- ⚠️ **Checks for uncommitted changes** - Offers to stash first
- ⚠️ **Preserves in reflog** - Commits aren't deleted, just unreachable
- ⚠️ **Shows preview** - See what you're rolling back

---

## Important Notes

### Uncommitted Changes
If you have uncommitted changes, rollback will:
1. Warn you
2. Offer to stash them
3. Wait for your decision

### Commits After Checkpoint
Rollback moves HEAD to checkpoint. Commits after that point are:
- Still in reflog (recoverable)
- Not deleted from git database
- Can be recovered if needed

### Recovery
If you rollback by mistake:
```bash
# View reflog
git reflog

# Restore to commit
git reset --hard <commit-hash>
```

---

## When to Use

- Experiment failed? Rollback to last checkpoint
- Refactor went wrong? Rollback to pre-refactor
- Want to try different approach? Rollback and restart
- End of day, back to stable? Rollback to working-version

---

## Related Commands

- `/checkpoint` - Create save point
- `/undo` - Quick revert of last change (lighter than rollback)

---

**Warning**: Rollback is powerful - it resets your code. But it's safe because commits are preserved in reflog. 🔄
