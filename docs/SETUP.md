# Setup Guide

Get the Prodige Workflow running in your project, in any AI coding tool.

**Time required:** 5-15 minutes.

---

## What you're installing

Prodige is **prompt-level** — it's a set of instructions, not a program. It consists of:

- **`AGENTS.md`** — the universal entry point every AI tool reads first.
- **`.ai/`** — the workflow itself (commands, workflows, skills, agents, governance, memory).

There is no binary and no per-tool folder. Installing = copying these into your repo and
pointing your AI tool at `AGENTS.md`.

---

## Prerequisites

- An AI coding assistant or agent (Cursor, Claude Code, Copilot, Codex, Gemini, opencode,
  Windsurf, Cline, or an agentic framework like Hermes / OpenClaw / Pi).
- Git (recommended — enables the `/undo`, `/checkpoint`, `/rollback` safety commands).
- Your project directory (new or existing).

---

## Step 1 — Add Prodige to your project

Copy the two items into the root of your project:

```bash
# from the Prodige Workflow folder, into your project root
cp -r .ai /path/to/your-project/
cp AGENTS.md /path/to/your-project/
# optional but recommended:
cp install.sh install.ps1 /path/to/your-project/
```

On Windows PowerShell:

```powershell
Copy-Item .ai,AGENTS.md,install.sh,install.ps1 -Destination C:\path\to\your-project\ -Recurse
```

Your project root should now contain `AGENTS.md` and `.ai/`.

---

## Step 2 — Wire up your AI tool

Many tools read `AGENTS.md` natively and need **nothing else**: Codex, opencode, Cursor,
Zed, Jules, RooCode, and most agentic frameworks.

Tools that use their own instruction filename get a one-line pointer generated for them:

```bash
# Unix / macOS / Git Bash
./install.sh claude,cursor      # specific tools
./install.sh all --gitignore    # all tools, keep repo footprint minimal

# Windows PowerShell
powershell -File install.ps1 -Tools claude,cursor
powershell -File install.ps1 -Tools all -Gitignore
```

| Your tool | What it reads | Action |
|-----------|---------------|--------|
| Codex, opencode, Cursor, Zed, Jules, RooCode | `AGENTS.md` | nothing (native) |
| Claude Code | `CLAUDE.md` | `install … claude` |
| Gemini CLI | `GEMINI.md` | `install … gemini` |
| GitHub Copilot | `.github/copilot-instructions.md` | `install … copilot` |
| Cline | `.clinerules` | `install … cline` |
| Windsurf | `.windsurfrules` | `install … windsurf` |
| Hermes / OpenClaw / Pi / custom | system prompt | point it at `AGENTS.md` |

Full details and the agentic-framework integration: [COMPATIBILITY.md](./COMPATIBILITY.md).

---

## Step 3 — Initialize the project brain

Open your AI tool in the project and run:

```
/session-start
```

This loads the Memory Bank (creating empty files on first run). Then bootstrap context:

**New project (from an idea):**
```
/init
```
Describe what you want to build; the agent asks clarifying questions and creates the
context files (PROJECT, PRD, ARCHITECTURE, IMPLEMENTATION).

**Existing codebase:**
```
/init
```
The agent scans the repo, detects your stack, and populates `.ai/context/` to match what's
actually there.

Confirm it worked:
```
/status
```

You're ready. The everyday loop is:
```
/session-start  →  /magic <what you want>  →  /session-end
```

---

## Directory structure (what `.ai/` actually contains)

```text
your-project/
├── AGENTS.md                 # Universal entry point (all tools read this)
├── install.sh / install.ps1  # Generate tool-specific pointer files
├── .ai/
│   ├── SOUL.md               # Philosophy and tone
│   ├── boot/BOOT.md          # Mandatory startup sequence
│   ├── orchestrator/         # Command routing + skill-selection matrix
│   ├── commands/             # Command specs + registry.json
│   ├── workflows/            # Workflow definitions (build, fix, review, …)
│   ├── skills/               # Skills + manifest.json + skill-selection-matrix.json
│   ├── agents/               # Agent role definitions
│   ├── context/              # PROJECT, PRD, ARCHITECTURE, IMPLEMENTATION, manifest.json
│   ├── memory/               # Session persistence (activeContext, progress, decisionLog…)
│   ├── governance/           # Rules, quality gates, review gates, debt registry
│   ├── boundaries/           # What Prodige will NOT do
│   ├── checklists/           # Pre-build / pre-merge / review checklists
│   ├── templates/            # Report and review templates
│   ├── state/                # CURRENT, SPRINT, BACKLOG, STATUS
│   ├── scripts/              # Helper scripts (security-scan, lint-skills, …)
│   └── runtime/              # Session-local state (gitignored)
└── src/                      # Your code
```

---

## Commands you'll use

| Command | Purpose |
|---------|---------|
| `/session-start` · `/session-end` | Load / save Memory Bank (bookend every session) |
| `/magic <task>` | Main entry — auto-routes, plans, executes, verifies |
| `/init` · `/design` · `/build` | Bootstrap → plan → implement (TDD) |
| `/fix` · `/refactor` · `/review` · `/audit` | Debug, improve, review, analyze |
| `/test` · `/verify` | TDD cycle / run tests+lint+types+build |
| `/docs` · `/release` · `/sync` · `/status` | Docs, release prep, context sync, status |
| `/checkpoint` · `/undo` · `/rollback` | Safety net |
| `/parallel` · `/cache` | Multi-agent execution / token cache |

Full registry: `.ai/commands/registry.json`. Per-command docs: `.ai/commands/<name>.md`.

> Slash commands are a **convention** the booted agent follows — they work in every tool.
> If your chat UI swallows the leading `/`, just type the command without it
> (e.g. `build login` or "run the build command").

---

## Version control

Commit the workflow and your project context; ignore session-local runtime state.

**Commit:**
```text
AGENTS.md
.ai/                      # except runtime (below)
```

**Ignore** (already in `.gitignore`):
```text
.ai/runtime/              # sessions, locks, snapshots, cache — generated each session
```

If you ran `install … --gitignore`, the generated tool pointers (CLAUDE.md, .cursorrules, …)
are ignored too, since any teammate can regenerate them with the installer.

For teams: commit `.ai/context/`, `.ai/governance/`, `.ai/agents/`, and `.ai/memory/` so
everyone shares the same project brain.

---

## Troubleshooting

**Agent ignores the workflow / doesn't know the commands**
→ Confirm `AGENTS.md` is at the repo root and your tool's pointer exists
(`install … <tool>`). As a one-time fallback, tell the agent: "Read `AGENTS.md` and follow it."

**Tool can't read files on its own**
→ Paste the contents of `AGENTS.md` (and, if asked, `.ai/boot/BOOT.md`) into the chat once.

**Agent seems to have stale context**
→ Run `/sync`.

**Safety commands don't work**
→ `/undo`, `/checkpoint`, `/rollback` require the project to be a Git repository (`git init`).

**Verify the skill registry is intact** (after editing skills)
→ `powershell -File .ai/scripts/lint-skills.ps1` (or `bash .ai/scripts/lint-skills.sh`).

---

## Next steps

- [COMPATIBILITY.md](./COMPATIBILITY.md) — per-tool and agentic-framework integration
- [NEWBIE_MODE.md](./NEWBIE_MODE.md) — simplified commands for beginners
- [USAGE.md](./USAGE.md) — full workflow walkthrough
- [HITL_REVIEW_GATES.md](./HITL_REVIEW_GATES.md) — human approval gates
- [MULTI_WINDOW_AGENT_GUIDE.md](./MULTI_WINDOW_AGENT_GUIDE.md) — parallel agent work
