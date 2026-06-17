# PRODIGE Workflow

**Production-Grade Development Made Easy**

The AI workflow system designed for everyone - from vibe coders to enterprise teams.

---

## 🚀 Quick Start

### For Beginners (Vibe Coders)

```bash
# 1. Start your session
/session-start

# 2. Tell AI what you want (in plain English!)
/magic create a todo app with user authentication

# 3. AI will:
#    - Show you a plan
#    - Ask for approval
#    - Execute step by step
#    - Verify quality
#    - Save progress

# 4. End your session
/session-end
```

That's it! Everything else is automatic.

---

## 📚 Essential Commands

### The Big Three

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/session-start` | Load your project context | Start of every session |
| `/magic <task>` | Do anything! Auto-routes to right workflow | Anytime you want to build something |
| `/session-end` | Save your progress | End of every session |

### Safety Net Commands

| Command | What It Does | Example |
|---------|--------------|---------|
| `/undo` | Revert last AI change | Made a mistake? `/undo` |
| `/checkpoint name` | Create save point | Before risky work: `/checkpoint pre-refactor` |
| `/rollback name` | Go back to save point | Experiment failed: `/rollback pre-refactor` |
| `/verify` | Check code quality | Before committing: `/verify` |

---

## 💡 How It Works

### The Magic Command

`/magic` is your main entry point. It:

1. **Understands** what you want (even vague requests!)
2. **Plans** the approach and shows you
3. **Asks approval** before doing anything
4. **Executes** step by step with updates
5. **Verifies** quality automatically
6. **Saves** everything to memory

### Example Flow

```
You: /magic add dark mode to my app

AI: 🎯 Plan: Add Dark Mode

Understanding:
- Add theme toggle
- Implement dark/light themes
- Persist user preference

Steps:
1. Design theme system
2. Implement toggle component
3. Add CSS variables for themes
4. Test across components
5. Verify quality

Estimated: 2 hours
Shall I proceed? (Yes/No)

You: Yes

AI: [Executes plan with progress updates]
    ✅ Step 1 complete
    ✅ Step 2 complete
    ...
    
    🔍 Running verification...
    ✅ All checks passed!
    
    💾 Updated memory bank
    
    Done! What's next?
```

---

## 🧠 Memory Bank System

**Never re-explain your project again!**

The Memory Bank remembers:
- ✅ Your project details
- ✅ What you're working on
- ✅ Decisions you made
- ✅ Patterns that work
- ✅ Mistakes to avoid

### How Memory Works

```
/session-start  →  Loads everything from last session
                   You can continue exactly where you left off

[Work on your project]

/session-end    →  Saves everything for next time
                   Nothing is lost
```

---

## 🛡️ Safety Features

### Undo Anything

```bash
# Made a mistake?
/undo

# AI shows what will be reverted
# You confirm
# Everything goes back
```

### Checkpoint & Rollback

```bash
# Before risky work
/checkpoint before-experiment

# Try something
/magic refactor the entire user service

# Didn't work out?
/rollback before-experiment

# Back to safe state!
```

### Verification

```bash
# Check if code is good
/verify

# AI runs:
# - Tests
# - Linting
# - Type checks
# - Build

# If issues found, can auto-fix!
```

---

## 📋 All Commands by Category

### Primary Commands
- `/magic <task>` - Main entry point, auto-routes everything
- `/session-start` - Load memory and context
- `/session-end` - Save session

### Safety & Recovery
- `/undo` - Revert last change
- `/checkpoint [name]` - Create save point
- `/rollback [name]` - Restore checkpoint

### Quality
- `/verify` - Run all quality checks

### Workflows (Advanced)
- `/init` - Initialize new project
- `/design` - Create architecture/design
- `/build` - Implement features
- `/fix` - Fix bugs
- `/refactor` - Improve code
- `/review` - Code review
- `/docs` - Update documentation

### System
- `/status` - Check project status
- `/sync` - Sync context
- `/cache` - Manage cache

---

## 🎓 Learning Path

### Level 1: Beginner
**Just use these 3 commands:**
1. `/session-start`
2. `/magic <what you want>`
3. `/session-end`

You're now building production-grade apps! 🎉

### Level 2: Intermediate
**Add safety commands:**
- `/checkpoint` before risky changes
- `/undo` when needed
- `/verify` before commits

Now you're developing confidently!

### Level 3: Advanced
**Use specific workflows:**
- `/design` for architecture planning
- `/build` for implementation
- `/review` for quality checks
- `/parallel` for multi-agent work

Now you're an expert!

---

## 🎯 Common Workflows

### Starting a New Feature

```bash
/session-start
/checkpoint before-new-feature
/magic add user profile page
# AI plans, you approve, it builds
/verify
# All good!
/session-end
```

### Fixing a Bug

```bash
/session-start
/magic fix the login redirect bug
# AI analyzes, fixes, tests
/verify
/session-end
```

### Refactoring Code

```bash
/session-start
/checkpoint pre-refactor
/magic refactor auth service for better testability
# AI plans, you review, it refactors
/verify
# If not happy:
/rollback pre-refactor
# Try different approach
/session-end
```

### Daily Development

```bash
# Morning
/session-start
# Shows what you were working on yesterday

# During the day
/magic <task 1>
/magic <task 2>
/checkpoint stable-build
/magic <experiment>

# End of day
/session-end
# Everything saved for tomorrow
```

---

## 🔧 Configuration

### Project Structure

```
your-project/
├── .ai/                      # Prodige workflow system
│   ├── memory/               # Session persistence
│   │   ├── projectContext.md
│   │   ├── activeContext.md
│   │   ├── progress.md
│   │   ├── decisionLog.md
│   │   ├── conventions.md
│   │   └── sessionHistory.md
│   ├── agents/               # AI agents
│   ├── commands/             # Command definitions
│   ├── context/              # Formal documentation
│   ├── governance/           # Quality rules
│   └── runtime/              # Temporary state
├── PRODIGE.md               # This file
└── [your code files]
```

### First Time Setup

```bash
# If starting fresh project
/init from idea: "Build a task management app"

# If existing project
/session-start
# Fill in the memory bank as you work
```

---

## 💪 Power User Tips

### Tip 1: Checkpoint Frequently
```bash
# Create checkpoints at stable points
/checkpoint working-version
/checkpoint end-of-day
/checkpoint before-major-refactor
```

### Tip 2: Use Descriptive Names
```bash
# Good checkpoint names
/checkpoint stable-auth-system
/checkpoint pre-payment-integration

# Bad checkpoint names
/checkpoint temp
/checkpoint 123
```

### Tip 3: Verify Often
```bash
# After each feature
/verify

# Before commits
/verify

# It's free and fast!
```

### Tip 4: Trust the Memory Bank
```bash
# Start every session
/session-start

# End every session
/session-end

# The AI will remember everything!
```

### Tip 5: Be Specific with /magic
```bash
# ❌ Vague
/magic improve code

# ✅ Specific
/magic refactor user service to use dependency injection for better testability
```

---

## 🐛 Troubleshooting

### Memory Bank Not Loading?
```bash
# Check if memory exists
ls .ai/memory/

# If empty, initialize
/session-start
# Memory will be created as you work
```

### Verification Failing?
```bash
/verify
# Shows what's wrong
# Offers to auto-fix

# If auto-fix doesn't work:
# Read the error messages
# AI can help: /magic fix verification errors
```

### Lost Your Place?
```bash
/session-start
# Loads last state

# Or check progress directly
cat .ai/memory/progress.md
cat .ai/memory/activeContext.md
```

### Broke Something?
```bash
# Undo last change
/undo

# Or rollback to checkpoint
/rollback [checkpoint-name]

# Everything is recoverable!
```

---

## 🎨 Philosophy

### For Beginners
- **Simple entry point** - One command does everything
- **Plain English** - No need to know technical details
- **Safe experimentation** - Can always undo
- **Automatic quality** - Verification built-in
- **Context preservation** - Never re-explain

### For Experts
- **Powerful workflows** - Access to all features
- **Governance** - Quality gates and review process
- **Parallel execution** - Multi-agent coordination
- **Formal documentation** - PRD, Architecture, ADRs
- **Team collaboration** - Shared context and decisions

### Core Principles
1. **Plan First** - Always show plan before execution
2. **Quality by Default** - Verification is mandatory
3. **Safety First** - Everything reversible
4. **Progressive Disclosure** - Simple start, power available
5. **Memory Persistence** - Context never lost

---

## 📊 Success Metrics

After using Prodige Workflow:
- ⏱️ **Time to first working feature**: < 30 minutes
- 🧠 **Context re-explanation time**: < 2 minutes (vs 20+ minutes)
- ✅ **Code quality score**: > 85% (tests, lint, build pass)
- 😊 **Developer satisfaction**: High confidence and speed

---

## 🆘 Get Help

### In-Workflow Help
```bash
# Show command help
/magic help

# List available commands
/status

# Check current context
/session-start
```

### Understanding Output
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

## 🎉 You're Ready!

Start with just three commands:
1. `/session-start`
2. `/magic <what you want>`
3. `/session-end`

Everything else will come naturally as you build.

**Welcome to production-grade development made easy!** 🚀

---

**Version**: 2.0 (Boris-Prodige Hybrid)  
**Last Updated**: 2026-06-17
