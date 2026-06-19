# Prodige Workflow - Quick Reference

**One-page cheat sheet for daily use**

---

## 🚀 3-Command Workflow (Beginners)

```bash
/session-start          # Load context
/magic <what you want>  # Do anything
/session-end            # Save progress
```

**That's all you need to know!** Everything else is automatic.

---

## 📋 Command Cheat Sheet

### Primary (Use These Most)

| Command | What | Example |
|---------|------|---------|
| `/session-start` | Load memory | Start of day |
| `/magic <task>` | Auto-route any task | `/magic add login` |
| `/verify` | Check quality | Before commit |
| `/session-end` | Save memory | End of day |

### Safety (Use Before Risky Work)

| Command | What | Example |
|---------|------|---------|
| `/checkpoint <name>` | Save point | `/checkpoint stable` |
| `/undo` | Revert last AI change | After mistake |
| `/rollback <name>` | Restore checkpoint | `/rollback stable` |

### Workflows (Advanced)

| Command | What | When |
|---------|------|------|
| `/init` | Initialize project | New project |
| `/design` | Architecture planning | Before building |
| `/build` | Implement feature | After design |
| `/fix` | Fix bugs | When bugs found |
| `/review` | Code review | Before merge |
| `/audit` | Security/dependency/debt analysis | Pre-release / health |
| `/refactor` | Improve code | Tech debt |
| `/docs` | Update docs | After changes |
| `/release` | Prepare a release | Shipping |

### Quality & System

| Command | What | When |
|---------|------|------|
| `/test` | TDD red-green-refactor | Writing tested code |
| `/roastme` | Brutal self-critique | Sanity-check a design/build |
| `/diagnose` | Project health check | Things feel off |
| `/sync` | Fix context drift | After manual edits |
| `/status` | Project status | Anytime |
| `/cache` | Manage token cache | Large repos |
| `/memory-init` | Scaffold Memory Bank | First run |

### Multi-agent

| Command | What | When |
|---------|------|------|
| `/parallel` | Multi-agent / multi-window build | Big features |
| `/agent` | Single focused worker session | Scoped task / worker window |

---

## 🎯 Common Workflows

### Daily Development
```bash
# Morning
/session-start

# Work
/magic add feature X
/magic fix bug Y
/verify

# Evening
/session-end
```

### Feature Development
```bash
/session-start
/checkpoint before-feature
/magic implement feature Z
/verify
/session-end
```

### Risky Refactoring
```bash
/session-start
/checkpoint pre-refactor
/magic refactor service X for better performance
/verify

# If not happy:
/rollback pre-refactor
# Try different approach

/session-end
```

### Bug Fixing
```bash
/session-start
/magic fix the login redirect issue
/verify
/session-end
```

---

## 💡 Pro Tips

### Tip 1: Start Every Session
```bash
/session-start  # Loads where you left off
```
No more re-explaining!

### Tip 2: Checkpoint Before Experiments
```bash
/checkpoint stable-build
/magic try experimental feature
# Can always rollback if needed
```

### Tip 3: Verify Before Committing
```bash
/verify  # Catches issues early
```

### Tip 4: Be Specific with /magic
```bash
# ❌ Vague
/magic improve code

# ✅ Specific  
/magic refactor user service to use dependency injection
```

### Tip 5: Use Descriptive Checkpoint Names
```bash
# ✅ Good
/checkpoint working-auth-system
/checkpoint pre-payment-integration

# ❌ Bad
/checkpoint temp
/checkpoint 1
```

---

## 🔍 Verification Quick Check

```bash
/verify
```

Runs automatically:
- ✅ Tests
- ✅ Type checking
- ✅ Linting
- ✅ Build

If failures → AI offers to auto-fix!

---

## 🛡️ Safety Quick Reference

### Undo Last Change
```bash
/undo
```
Reverts most recent AI change.

### Create Save Point
```bash
/checkpoint my-name
```
Creates named checkpoint.

### Restore Save Point
```bash
/rollback my-name
```
Restores to checkpoint.

### List Checkpoints
```bash
/rollback
```
Shows available checkpoints.

---

## 📚 Memory System

### What Gets Saved
- Project details
- Current tasks
- Decisions made
- Patterns learned
- Mistakes to avoid
- Session history

### When Saves Happen
- `/session-end` - Manual save
- Major decisions - Auto-logged
- Context changes - Auto-synced

### Memory Files (Advanced)
```
.ai/memory/
├── projectContext.md   # Project info
├── activeContext.md    # Current state
├── progress.md         # Tasks
├── decisionLog.md      # Decisions
├── conventions.md      # Patterns
└── sessionHistory.md   # History
```

---

## 🎨 Magic Command Examples

### Create Features
```bash
/magic create user authentication system
/magic add dark mode toggle
/magic implement payment integration
```

### Fix Bugs
```bash
/magic fix the login redirect bug
/magic resolve memory leak in dashboard
/magic fix broken tests in user module
```

### Improve Code
```bash
/magic refactor auth service for testability
/magic optimize database queries
/magic improve error handling in API
```

### Add Tests
```bash
/magic add tests for user service
/magic increase test coverage to 80%
```

### Documentation
```bash
/magic add API documentation
/magic update README with new features
/magic document the authentication flow
```

---

## ⚡ Keyboard Shortcuts (Mental Model)

Think of these as "save game" shortcuts:

- **F5** (Quick Save) = `/checkpoint`
- **F9** (Quick Load) = `/rollback`
- **Ctrl+Z** (Undo) = `/undo`
- **Ctrl+S** (Save) = `/session-end`

---

## 🐛 Troubleshooting

### Memory Not Loading
```bash
/session-start  # Creates if missing
```

### Verification Failing
```bash
/verify  # Shows errors, offers fixes
```

### Broke Something
```bash
/undo            # Quick revert
/rollback <name> # Go back further
```

### Lost Your Place
```bash
/session-start  # Loads last state
```

### Need Help
```bash
/status        # where am I?
```
See [PRODIGE.md](./PRODIGE.md) for the full command guide.

---

## 📊 Status Symbols

- 🎯 = Planning
- ✅ = Success
- ❌ = Error
- ⚠️ = Warning
- 🔄 = In Progress
- 📚 = Memory/Context
- 💾 = Saving
- 🔍 = Verification
- 🛡️ = Safety
- 📍 = Checkpoint

---

## 🎓 Learning Path

### Day 1
```bash
/session-start
/magic <task>
/session-end
```

### Week 1
```bash
+ /checkpoint
+ /undo
+ /verify
```

### Month 1
```bash
+ /design
+ /build
+ /review
```

---

## 📞 Quick Help

- **Full Guide**: [PRODIGE.md](./PRODIGE.md)
- **README**: [README.md](./README.md)
- **Use in your AI tool**: [docs/COMPATIBILITY.md](./docs/COMPATIBILITY.md) · [docs/SETUP.md](./docs/SETUP.md)

---

## 🎯 Remember

1. **Always** start with `/session-start`
2. **Use** `/magic` for everything
3. **Checkpoint** before risky work
4. **Verify** before committing
5. **Always** end with `/session-end`

---

**You're ready! Start building!** 🚀

```bash
/session-start
/magic build something awesome
/session-end
```
