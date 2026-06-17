# /checkpoint

Create a named save point you can return to later.

Like a save game in development - go back anytime!

---

## What This Does

Creates a named checkpoint (git tag) that you can rollback to:
1. Commits any uncommitted changes
2. Tags current state with your name
3. Allows easy restoration later

---

## Usage

```bash
# Create checkpoint with specific name
/checkpoint pre-refactor

# Create checkpoint with auto-generated name
/checkpoint

# Later, restore with:
/rollback pre-refactor
```

---

## Instructions

Invoke the **git-guardian** agent to execute checkpoint protocol:

### Tasks

1. **Check working directory**:
   - If uncommitted changes exist, commit them
   - Ensure clean state for checkpoint

2. **Create checkpoint**:
   - Generate name (use provided or auto-generate)
   - Create git tag: `checkpoint-{name}`
   - Record metadata

3. **Report creation**:
   - Show checkpoint name
   - Show how to restore later
   - List recent checkpoints

### Output Format

Follow format in git-guardian agent:
- Checkpoint created confirmation
- Name and timestamp
- Restoration command
- List of recent checkpoints

---

## Good Checkpoint Names

```bash
/checkpoint pre-refactor         # Before big refactor
/checkpoint working-version      # Known good state
/checkpoint before-experiment    # Before trying something
/checkpoint stable-build         # After successful build
```

---

## When to Create Checkpoints

Create checkpoints before:
- ✅ Major refactoring
- ✅ Trying experimental approach
- ✅ Making architecture changes
- ✅ Risky operations
- ✅ End of day (working state)

---

## Auto-Checkpoints

Some commands create automatic checkpoints:
- `/refactor` - Creates checkpoint before refactoring
- `/build` (large) - Creates checkpoint before big builds
- Magic orchestrator - Creates checkpoints for risky operations

---

## Managing Checkpoints

```bash
# List checkpoints
/rollback              # Shows list when no name given

# Compare checkpoints
git diff checkpoint-name1..checkpoint-name2

# Delete checkpoint (manual)
git tag -d checkpoint-old-name
```

---

## Related Commands

- `/undo` - Quick revert of last change
- `/rollback` - Restore to checkpoint

---

**Pro Tip**: Create checkpoints liberally! They're free and can save hours of work. 📍
