# Quick Start Guide

**Get started with Prodige Workflow in 5 minutes**

---

## For Absolute Beginners

### Step 1: Start Your Session (10 seconds)
```bash
/session-start
```
Loads your project context. First time? It'll create empty memory files.

### Step 2: Tell AI What You Want (Plain English!)
```bash
/magic create a todo app
```
or
```bash
/magic add user authentication
```
or
```bash
/magic fix the login bug
```

AI will:
1. Show you a plan
2. Ask "Shall I proceed?"
3. Wait for you to say "Yes"
4. Execute step by step
5. Verify quality
6. Report results

### Step 3: End Your Session (10 seconds)
```bash
/session-end
```
Saves everything for next time.

**That's it! You're building production-grade apps!** 🎉

---

## Three Commands is All You Need

```
/session-start  →  /magic <task>  →  /session-end
```

Everything else is automatic:
- ✅ Quality checks
- ✅ Testing
- ✅ Context saving
- ✅ Progress tracking

---

## Your First Real Task

Let's build a simple feature:

```bash
# 1. Start
/session-start

# 2. Build something
/magic create a contact form with name, email, and message fields

# AI shows plan:
# - Create ContactForm component
# - Add validation
# - Add submit handler
# - Add success/error messages
# - Write tests
# 
# Shall I proceed?

# 3. You approve
Yes

# AI executes...
# ✅ Component created
# ✅ Validation added
# ✅ Tests passing
# ✅ Quality verified
# 
# Done! What's next?

# 4. End session
/session-end
```

**Time**: 10-15 minutes
**Result**: Production-ready contact form with tests

---

## Safety Features (Don't Be Afraid!)

### Made a Mistake?
```bash
/undo
```
Reverts last AI change. Everything goes back.

### Want to Experiment Safely?
```bash
/checkpoint before-experiment
/magic try something risky
# Didn't work out?
/rollback before-experiment
```

### Check Code Quality Anytime
```bash
/verify
```
Runs tests, lint, build. Shows what's wrong.

---

## Common Scenarios

### Scenario 1: Starting a New Project
```bash
/session-start
/magic initialize a React app with TypeScript
/magic add routing with React Router
/magic create a homepage component
/session-end
```

### Scenario 2: Adding a Feature
```bash
/session-start
/checkpoint before-new-feature
/magic add dark mode toggle
/verify
# All good!
/session-end
```

### Scenario 3: Fixing a Bug
```bash
/session-start
/magic fix the form validation bug in ContactForm
# AI analyzes, fixes, tests
/verify
/session-end
```

### Scenario 4: Refactoring
```bash
/session-start
/checkpoint pre-refactor
/magic refactor UserService to use dependency injection
/verify
# If unhappy:
/rollback pre-refactor
# Try different approach
/session-end
```

---

## Tips for Success

### Tip 1: Be Specific
```bash
# ❌ Vague
/magic improve the code

# ✅ Specific  
/magic refactor the authentication service to separate concerns and improve testability
```

### Tip 2: Use Checkpoints
```bash
# Before risky work
/checkpoint stable-version

# Before big refactors
/checkpoint pre-refactor

# End of day
/checkpoint end-of-day
```

### Tip 3: Trust the Memory Bank
```bash
# Always start with
/session-start

# Always end with
/session-end

# AI remembers EVERYTHING between sessions
```

### Tip 4: Verify Often
```bash
# After each feature
/verify

# Before committing
/verify

# It's fast and free!
```

---

## Keyboard Shortcuts (Mental Model)

Think of it like this:

```
/session-start  = "Load my project"
/magic          = "Do this thing"
/verify         = "Is it good?"
/undo           = "Ctrl+Z"
/checkpoint     = "Save game"
/rollback       = "Load game"
/session-end    = "Save and quit"
```

---

## Next Steps

### After Your First Success
1. Read [PRODIGE.md](./PRODIGE.md) for complete guide
2. Try more complex features
3. Explore other commands

### Going Deeper
- Learn about workflows (`/design`, `/build`, `/review`)
- Use parallel execution (`/parallel`)
- Configure quality gates
- Set up team collaboration

### Getting Help
- Stuck? Run `/status` to see where you are; read [PRODIGE.md](./PRODIGE.md) for the command guide
- Check status: `/status`
- Read docs: Open PRODIGE.md

---

## Troubleshooting

### Memory Not Loading?
```bash
/session-start
# Will create memory files if missing
```

### Verification Failing?
```bash
/verify
# Shows what's wrong
# Offers to auto-fix
```

### Lost Your Place?
```bash
/session-start
# Shows what you were working on
# Shows your progress
# Shows open questions
```

### Broke Something?
```bash
/undo
# or
/rollback checkpoint-name
# Everything is recoverable!
```

---

## Example: Complete Feature Build

Let's build a real feature from start to finish:

```bash
# Start session
> /session-start

📚 Memory Bank Loaded
Last session: 2 hours ago
Project: MyApp
Ready to continue!

# Create checkpoint
> /checkpoint before-auth-feature

📍 Checkpoint created: before-auth-feature

# Build feature
> /magic add user authentication with JWT

🎯 Plan: JWT Authentication System

Understanding:
- JWT token-based auth
- Login/logout endpoints
- Protected routes
- Token refresh

Steps:
1. Design auth architecture
2. Implement auth service
3. Add login/logout routes
4. Add auth middleware
5. Write tests
6. Verify security

Estimated: 2-3 hours
Shall I proceed?

> Yes

[AI executes plan with progress updates]

✅ Step 1 complete: Architecture designed
✅ Step 2 complete: Auth service implemented
✅ Step 3 complete: Routes added
✅ Step 4 complete: Middleware working
✅ Step 5 complete: Tests passing
✅ Step 6 complete: Security verified

🔍 Running verification...
✅ Tests: 15/15 passed
✅ Lint: Clean
✅ Build: Success

💾 Memory updated

✅ Task Complete!

What would you like to work on next?

# Verify one more time
> /verify

🔍 Verification Results

✅ Tests: Passed (15 tests)
✅ Types: No errors
✅ Lint: Clean
✅ Build: Success

Overall: ✅ ALL PASSED

# Save session
> /session-end

💾 Memory Bank Updated

Session Summary:
- Accomplished: JWT authentication system
- Tests: 15 passing
- Quality: All checks passed
- Context preserved for next session

Great work today! 👋
```

**Time taken**: 2.5 hours
**Result**: Production-ready JWT authentication with:
- ✅ Complete implementation
- ✅ Full test coverage
- ✅ Security verified
- ✅ Documentation updated
- ✅ Ready to deploy

---

## You're Ready!

Remember the three essential commands:

```
1. /session-start
2. /magic <what you want>
3. /session-end
```

Everything else comes naturally as you build.

**Now go build something amazing!** 🚀

---

## Resources

- **Complete Guide**: [PRODIGE.md](./PRODIGE.md)
- **Technical Details**: [docs/SETUP.md](./docs/SETUP.md) · [docs/COMPATIBILITY.md](./docs/COMPATIBILITY.md)
- **All Changes**: [CHANGELOG.md](./CHANGELOG.md)
- **Project Overview**: [README.md](./README.md)

---

**Welcome to production-grade development made easy!**
