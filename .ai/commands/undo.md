# /undo

Revert the last AI-made change.

Your safety net - makes development risk-free.

---

## What This Does

Safely reverts the most recent changes made by AI:
1. Finds last AI commit or saved patch
2. Applies reverse changes
3. Restores code to previous state
4. Preserves change for potential redo

---

## Usage

```bash
# Simple - just undo last AI change
/undo

# It will show what will be undone and ask for confirmation
```

---

## Instructions

Invoke the **git-guardian** agent to execute undo protocol:

### Tasks

1. **Find what to undo**:
   - Check for `.ai/runtime/last-change.patch`
   - Or find last AI commit in git history

2. **Show what will be reverted**:
   - List files affected
   - Show brief summary of changes
   - Ask for confirmation

3. **Execute undo**:
   - Apply patch in reverse, or
   - Revert git commit
   - Archive the patch for potential redo

4. **Report results**:
   - What was reverted
   - Current git status
   - Reminder that change is archived

### Output Format

Follow format in git-guardian agent:
- Clear list of what will be undone
- Confirmation prompt
- Success message with details

---

## Safety Features

- ✅ Always asks for confirmation
- ✅ Preserves reverted changes in archive
- ✅ Works even if you've made more changes after AI
- ✅ Clear about what will be reverted

---

## When to Use

- Made a mistake? `/undo`
- AI went wrong direction? `/undo`
- Want to try different approach? `/undo`
- Experiment freely! You can always undo.

---

## Related Commands

- `/checkpoint` - Create save point before risky changes
- `/rollback` - Go back to earlier checkpoint (bigger undo)

---

**Remember**: With `/undo`, there's no such thing as a mistake, only experiments! 🔄
