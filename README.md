# Prodige Workflow v2.0

**Production-Grade Development Made Easy**

An AI workflow system designed for everyone - from vibe coders to enterprise teams.

---

## 🎯 What is Prodige?

Prodige is a hybrid AI workflow system that combines:
- **Beginner-friendly UX** - simple commands, automatic routing
- **Enterprise governance** from original Prodige
- **Memory persistence** for session continuity
- **Safety features** for confident development
- **Quality automation** for production-grade code

### Perfect For

✅ **Vibe Coders** - Simple commands, automatic routing, no complexity  
✅ **Professional Developers** - Full control, powerful workflows, quality gates  
✅ **Teams** - Governance, documentation, collaboration features  
✅ **Enterprise** - Compliance, audit trails, formal processes  

---

## 🧩 Works in Any AI Tool

Prodige is prompt-level — no binary, no plugin, no per-tool folders. One file bootstraps it
everywhere: **`AGENTS.md`** (read natively by Codex, opencode, Cursor, Zed, Jules, RooCode, and
most agentic frameworks). Tools with their own instruction file get a one-line pointer:

```bash
./install.sh claude,cursor          # or: all
powershell -File install.ps1 -Tools claude,cursor
```

Agentic frameworks (Hermes, OpenClaw, Pi, custom): point the agent's system/instructions at
`AGENTS.md`. Full matrix: [docs/COMPATIBILITY.md](./docs/COMPATIBILITY.md).

---

## 🚀 5-Minute Quick Start

### 1. Start Your Session
```bash
/session-start
```
Loads project context so you never have to re-explain.

### 2. Tell AI What You Want
```bash
/magic create a todo app with authentication
```
AI will plan, ask approval, execute, verify, and report.

### 3. Save Your Progress
```bash
/session-end
```
Everything saved for next session.

**That's it!** You're now building production-grade apps. 🎉

---

## 📚 Documentation

- **[PRODIGE.md](./PRODIGE.md)** - Complete user guide
- **[AUDIT_REPORT.md](./Ref/AUDIT_REPORT.md)** - Architecture decisions
- **[IMPLEMENTATION_GUIDE.md](./Ref/IMPLEMENTATION_GUIDE.md)** - Technical details

---

## 🎁 Key Features

### 1. Memory Bank System
Never re-explain your project. Memory persists across sessions.

```bash
/session-start  # Loads everything
# Work on your project
/session-end    # Saves everything
```

### 2. Magic Command
One command for everything. AI figures out the rest.

```bash
/magic add user authentication
/magic fix the login bug
/magic refactor for better performance
```

### 3. Safety Features
Experiment without fear. Everything is reversible.

```bash
/undo           # Revert last change
/checkpoint     # Create save point
/rollback       # Restore checkpoint
```

### 4. Quality Verification
Automatic quality checks ensure production-grade code.

```bash
/verify         # Runs tests, lint, types, build
```

---

## 📋 Essential Commands

| Command | What It Does |
|---------|--------------|
| `/session-start` | Load memory and context |
| `/magic <task>` | Main entry point - auto-routes everything |
| `/verify` | Check code quality |
| `/undo` | Revert last AI change |
| `/checkpoint` | Create named save point |
| `/rollback` | Restore to checkpoint |
| `/session-end` | Save session |

See [PRODIGE.md](./PRODIGE.md) for all commands and detailed usage.

---

## 🏗️ Architecture

```
.ai/
├── memory/              # 🆕 Session persistence
│   ├── projectContext.md
│   ├── activeContext.md
│   ├── progress.md
│   ├── decisionLog.md
│   ├── conventions.md
│   └── sessionHistory.md
├── agents/              # 🆕 Enhanced agents
│   ├── magic-orchestrator.md    # 🆕 Main entry point
│   ├── memory-manager.md         # 🆕 Memory system
│   ├── verification-runner.md    # 🆕 Quality checks
│   ├── git-guardian.md           # 🆕 Safety features
│   └── [existing agents]
├── commands/            # 🆕 Extended commands
│   ├── magic.md                  # 🆕 Auto-routing
│   ├── session-start.md          # 🆕 Load context
│   ├── session-end.md            # 🆕 Save context
│   ├── verify.md                 # 🆕 Quality checks
│   ├── undo.md                   # 🆕 Safety
│   ├── checkpoint.md             # 🆕 Safety
│   ├── rollback.md               # 🆕 Safety
│   └── [existing commands]
├── context/             # Formal documentation
├── governance/          # Quality rules
└── [other folders]
```

---

## 🎓 Learning Path

### Level 1: Beginner (Day 1)
```bash
/session-start
/magic <what you want>
/session-end
```
**You're building production apps!** ✅

### Level 2: Intermediate (Week 1)
Add safety:
```bash
/checkpoint before-experiment
/magic try something
/verify
/undo  # if needed
```
**You're developing confidently!** 🚀

### Level 3: Advanced (Month 1)
Use specific workflows:
```bash
/design
/build
/review
/parallel
```
**You're an expert!** 🎯

---

## 💪 Why Prodige v2?

### vs Manual Development
- ⚡ **10x faster** - AI handles implementation details
- 🎯 **Higher quality** - Automatic verification
- 🧠 **No context loss** - Memory persists across sessions

### vs Other AI Workflows
- 🎁 **Beginner-friendly** - Simple entry point (`/magic`)
- 🛡️ **Safety first** - Undo/checkpoint/rollback
- 📚 **Memory persistence** - No re-explanation needed
- ✅ **Quality mandatory** - Verification built-in
- 🏢 **Enterprise-ready** - Governance and compliance

### vs Original Prodige
- ➕ **Added Memory Bank** - Session persistence
- ➕ **Added Magic Command** - Simplified UX
- ➕ **Added Safety Features** - Undo/checkpoint/rollback
- ➕ **Added Verification** - Automatic quality checks
- ✅ **Kept governance** - Quality gates, HITL
- ✅ **Kept formal docs** - PRD, Architecture, ADRs

---

## 🎯 Use Cases

### Solo Developer
```bash
/session-start
/magic build feature X
/verify
/session-end
```
Simple, fast, high quality.

### Team Project
```bash
/design feature Y
# Review plan with team
/build feature Y
/review
# Create PR with quality verified
```
Collaborative with governance.

### Enterprise Application
```bash
/init from PRD
/design with architecture review
/build with quality gates
/audit compliance
/release with approval
```
Full governance and audit trail.

---

## 🔧 Requirements

- Git repository (for safety features)
- Project files (package.json, requirements.txt, etc.)
- AI assistant with file system access

---

## 📖 Examples

### Build a Feature
```bash
User: /magic add user authentication with email and password

AI: 🎯 Plan: User Authentication System

Understanding:
- Email/password login
- Secure password storage
- Session management
- Protected routes

Steps:
1. Design authentication architecture
2. Implement auth service
3. Create login/register UI
4. Add route protection
5. Write tests
6. Verify security

Estimated: 3 hours
Shall I proceed?

User: Yes

AI: [Executes with progress updates]
    ✅ All steps complete
    🔍 Verification passed
    💾 Memory updated
    
    Feature complete! 🎉
```

### Fix a Bug
```bash
User: /magic fix the login redirect bug

AI: [Analyzes issue]
    Found: Redirect logic missing return URL
    
    Fix:
    - Add returnUrl parameter
    - Preserve URL through auth flow
    - Default to dashboard if no returnUrl
    
    Applying fix...
    ✅ Fixed
    🔍 Tests pass
    
    Bug fixed! Want me to add a test for this edge case?
```

### Refactor Code
```bash
User: /checkpoint pre-refactor
User: /magic refactor user service to use dependency injection

AI: [Plans refactor]
    [Implements]
    [Tests]
    🔍 Verification passed
    
User: /verify
AI: ✅ All quality checks passed!

User: /session-end
AI: 💾 Session saved. Great work today!
```

---

## 🆘 Troubleshooting

### Memory Not Loading?
```bash
/session-start
# If empty, memory will be created as you work
```

### Verification Failing?
```bash
/verify
# AI will offer to auto-fix issues
```

### Broke Something?
```bash
/undo            # Quick revert
/rollback name   # Restore checkpoint
```

### Need Help?
```bash
/magic help
/status
```
Or read [PRODIGE.md](./PRODIGE.md) for detailed guide.

---

## 🎉 Get Started

1. **Read** [PRODIGE.md](./PRODIGE.md) (5 minutes)
2. **Try** the quick start above
3. **Build** something amazing!

---

## 📜 License

[Your License Here]

---

## 🙏 Influences

Prodige is built in-house. Its design draws lessons from prior art across the
AI-workflow space — beginner-friendly UX, enterprise governance, and code-quality
discipline — but the architecture, structure, and skills here are our own work.

---

## 📞 Support

- Documentation: [PRODIGE.md](./PRODIGE.md)
- Technical Details: [IMPLEMENTATION_GUIDE.md](./Ref/IMPLEMENTATION_GUIDE.md)
- Architecture: [AUDIT_REPORT.md](./Ref/AUDIT_REPORT.md)

---

**Version**: 2.0  
**Release Date**: 2026-06-17  
**Status**: Production Ready ✅

**Welcome to production-grade development made easy!** 🚀
