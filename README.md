# 🚀 Prodige Workflow OS

**The Developer Cockpit, Git Sentinel & AI Model Context Protocol (MCP) for Production-Grade Software Engineering.**

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production_Ready-green.svg)]()
[![MCP](https://img.shields.io/badge/MCP-Enabled-orange.svg)]()

Prodige is an open-source, prompt-level **AI Orchestration Operating System** designed to standardize, secure, and accelerate software development for solo developers, teams, and enterprise engineering environments.

---

## 🎯 What is Prodige?

Prodige is a hybrid AI workflow system that combines:
*   **Beginner-friendly UX** - simple commands, automatic routing.
*   **Enterprise governance** - TDD gates, Surgical changes, and Secret scanners.
*   **Memory persistence** - context stays across sessions, saving token costs.
*   **Safety features** - Git checkpoints and rollback points for confident development.
*   **Developer Dashboard** - real-time visualization of agent status, tasks, and locks.
*   **Model Context Protocol (MCP)** - bridges Prodige capabilities to external tools like Cursor, Cline, and Hermes.

### Perfect For

*   ✅ **Vibe Coders** - Simple commands, automatic routing, no complexity.
*   ✅ **Professional Developers** - Full control, powerful workflows, quality gates.
*   ✅ **Teams** - Governance, documentation, collaboration features.
*   ✅ **Enterprise** - Compliance, audit trails, formal processes, secret guard.

---

## 🧩 Works in Any AI Tool & Agent

Prodige is prompt-level — no binary, no plugin, no per-tool folders. One file bootstraps it everywhere: **`AGENTS.md`** (read natively by Codex, opencode, Cursor, Zed, Jules, RooCode, and most agentic frameworks). Tools with their own instruction file get a one-line pointer:

```bash
./install.sh all          # or specific tools: claude,cursor,cline
powershell -File install.ps1 -Tools all
```

### Model Context Protocol (MCP) Integration
You can expose Prodige context and locking mechanisms as structured tools to MCP-enabled editors (like Cursor, Cline, VSCode, RooCode) or agent channels (Hermes, OpenClaw).

Add this configuration to your editor's MCP server settings:
```json
{
  "mcpServers": {
    "prodige-workflow": {
      "command": "node",
      "args": ["C:/Users/PC/Downloads/AI_Engineering_OS_v1_0/Ref/Prodige Workflow/.ai/scripts/prodige-mcp.js"]
    }
  }
}
```
Exposed Tools:
*   `get_active_context`: Safely retrieves the active task focus and file plans without reading large markdown files (saves token bloat).
*   `acquire_lock`: Permits agents to acquire locks on files to prevent conflicts in parallel sessions.

---

## 🚀 5-Minute Quick Start

### 1. Start Your Session
```bash
/session-start
```
Loads project context so the AI never has to ask you to re-explain.

### 2. Tell AI What You Want
```bash
/magic create a todo app with authentication
```
AI will plan, ask approval, execute, verify, and report.

### 3. Save Your Progress
```bash
/session-end
```
Everything saved for the next session.

---

## 🎁 Key Features & Innovations

### 1. Memory Bank System
Never re-explain your project. Memory persists across sessions.
```bash
/session-start  # Loads everything
# Work on your project
/session-end    # Saves everything
```

### 2. Visual Cockpit CLI (`prodige-cli.js`)
An interactive terminal dashboard showing active focus, dynamic checkbox task lists (from `task.md`), file locks, and Git status.
```bash
node .ai/scripts/prodige-cli.js status
```

### 3. Pre-Commit Git Sentinel Guard
Automatically intercepts commits to enforce software craftsmanship:
*   **TDD Gate**: Rejects commits if source code changed but no test files were created/modified.
*   **Surgical Changes**: Blocks commits if changes touch files outside the active `activeContext.md` plan.
*   **Secret Guard**: Scans staged diff additions for API keys (OpenAI, AWS, etc.) and private key blocks before commits are made.
*   *Hook location:* Installed under `.git/hooks/pre-commit` (calls `.ai/scripts/prodige-sentinel.sh`).

### 4. Atomic Checkpoint & Time-Travel Rollback
Save and restore states cleanly without context drift.
```bash
# Save code state + AI memory bank
node .ai/scripts/prodige-cli.js checkpoint migration-init

# Roll back code (Git) + AI memory bank atomically
node .ai/scripts/prodige-cli.js rollback migration-init
```

### 5. Auto-release Stale Locks
Ensures that if an agent crashes, locks on resources are released automatically when the PID is dead or the lock is >2 hours old.
```bash
powershell -File .ai/scripts/release-locks.ps1
```

---

## 📋 Essential Commands

| Command | What It Does |
|---------|--------------|
| `/session-start` | Load memory and context |
| `/magic <task>` | Main entry point - auto-routes everything |
| `/verify` | Check code quality (tests, lint, types, build) |
| `/undo` | Revert last AI change |
| `/checkpoint` | Create named save point |
| `/rollback` | Restore to checkpoint |
| `/session-end` | Save session |

See [PRODIGE.md](./PRODIGE.md) for all commands and detailed usage.

---

## 🏗️ Architecture

```
.ai/
├── memory/               # Session context & state persistence
│   ├── activeContext.md  # Focus task
│   ├── projectContext.md # Codebase identity
│   ├── progress.md       # Metrics & completed checklist
│   ├── decisionLog.md    # Architecture log
│   ├── conventions.md    # Code patterns learned
│   └── sessionHistory.md # Audit history
├── scripts/              # Automation, Linters, Sentinel Hook
│   ├── prodige-cli.js    # CLI Dashboard & Checkpoints
│   ├── prodige-mcp.js    # Model Context Protocol Server
│   ├── prodige-sentinel  # Git Sentinel Hook (PS1/SH)
│   └── release-locks     # Auto-release stale locks (PS1/SH)
├── runtime/              # Locks, session states & backup cache
│   ├── locks/            # Active resource locks
│   ├── cache/            # Token-saving summaries & checkpoints
│   └── audit.log         # Tamper-proof audit trails
├── agents/               # Multi-agent specialized role instructions
│   ├── magic-orchestrator.md    # Main entry point
│   ├── memory-manager.md        # Memory system
│   ├── verification-runner.md   # Quality checks
│   └── git-guardian.md          # Safety features
├── commands/             # Command specifications
├── context/              # Formal project documentation
└── governance/           # Quality rules
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
node .ai/scripts/prodige-cli.js checkpoint before-experiment
/magic try something
/verify
# if needed:
node .ai/scripts/prodige-cli.js rollback before-experiment
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

## 💪 Why Prodige?

### vs Manual Development
*   ⚡ **10x faster** - AI handles implementation details.
*   🎯 **Higher quality** - Automatic verification, TDD, and secret checks.
*   🧠 **No context loss** - Memory persists across sessions.

### vs Other AI Workflows
*   🎁 **Beginner-friendly** - Simple entry point (`/magic`).
*   🛡️ **Safety first** - Undo/checkpoint/rollback.
*   📚 **Memory persistence** - No re-explanation needed.
*   ✅ **Quality mandatory** - Verification built-in.
*   🏢 **Enterprise-ready** - Secret scanners, atomic writes, backup states, and audit trails.
*   🔌 **Tool-agnostic** - Works in any AI assistant via `AGENTS.md` and MCP.

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
/build with quality gates (TDD, Surgical changes & Secret guard)
/audit compliance
/release with approval
```
Full governance and audit trail.

---

## 🔧 Requirements

*   Git repository (for safety features)
*   Project files (package.json, requirements.txt, etc.)
*   AI assistant with file system access or MCP client support

---

## 📖 Examples

### Build a Feature
```
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
```
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
```
User: node .ai/scripts/prodige-cli.js checkpoint pre-refactor
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
node .ai/scripts/prodige-cli.js rollback name   # Restore checkpoint
```

### Need Help?
```bash
/magic help
/status
```
Or read [PRODIGE.md](./PRODIGE.md) for detailed guide.

---

## 📜 License

Distributed under the Apache License 2.0. See [LICENSE](LICENSE) for more information.

---

## 🙏 Influences

Prodige Workflow OS is an independent framework. Its design draws structural and behavioral lessons from prior art across the AI-agent orchestration and development tooling spaces, refining them into a unified, editor-agnostic, enterprise-hardened software engineering framework.

---

## 📞 Support

*   Documentation: [PRODIGE.md](./PRODIGE.md)
*   Technical Details: [IMPLEMENTATION_GUIDE.md](./Ref/IMPLEMENTATION_GUIDE.md)
*   Architecture: [AUDIT_REPORT.md](./Ref/AUDIT_REPORT.md)
