# AGENTS.md — Prodige Workflow

> **Universal entry point.** This single file bootstraps the Prodige Workflow in **any**
> AI coding assistant or agentic framework. It is the one file every tool reads first.
> Tool-specific files (CLAUDE.md, GEMINI.md, .clinerules, …) are thin pointers to this one —
> there is exactly one source of truth: this file + the `.ai/` directory.

You are operating inside a project that uses the **Prodige Workflow** — a tool-agnostic AI
development operating system stored in the `.ai/` directory. Follow it.

---

## 1. Boot sequence (do this first, once per session)

Read these in order, then act on them:

1. `.ai/boot/BOOT.md` — the mandatory startup sequence (this is the spec; obey it).
2. `.ai/SOUL.md` — philosophy and tone.
3. `.ai/orchestrator/ORCHESTRATOR.md` — how commands route to workflows, skills, and agents.
4. `.ai/skills/manifest.json` — the registry of available skills.

`BOOT.md` will tell you to load memory (`.ai/memory/`), boundaries (`.ai/boundaries/`),
context (`.ai/context/`), and the global skills. Do what it says.

If you cannot read files autonomously, ask the user to paste `.ai/boot/BOOT.md`.

---

## 2. The command convention (works in every tool)

Prodige commands are written as `/<command> <args>`. They are **a convention, not a native
feature** — so they work in any tool once you (the agent) follow this rule:

> When the user's message starts with `/<word>` (optionally with arguments), treat it as a
> Prodige command:
> 1. Look it up in `.ai/commands/registry.json`.
> 2. Read the matching `.ai/commands/<command>.md`.
> 3. Execute the mapped workflow in `.ai/workflows/<workflow>.md`, auto-loading the skills
>    that `.ai/skills/skill-selection-matrix.json` lists for that command.
> 4. Respect the command's HITL flag (ask for approval where required).

**If your host intercepts the leading slash** (some chat UIs do), the user may write the
command without it — `build login`, `prodige build login`, or "run the build command".
Treat all of these the same as `/build login`.

### Command quick reference

| Command | Purpose |
|---------|---------|
| `/session-start` | Load Memory Bank + orient (start every session) |
| `/magic <task>` | Main entry — auto-routes to the right workflow with planning + verification |
| `/init` | Initialize project brain and structure |
| `/design` | Create/update PRD, architecture, implementation plan |
| `/build` | Implement approved design (TDD) |
| `/fix` | Diagnose + fix a bug (systematic debugging) |
| `/review` | Review code quality |
| `/audit` | Security/dependency/debt analysis |
| `/refactor` | Improve structure without changing behavior |
| `/test` | TDD red-green-refactor cycle |
| `/verify` | Run tests, lint, types, build |
| `/docs` | Update documentation |
| `/release` | Prepare a release |
| `/sync` | Sync context + state |
| `/status` | Report project status |
| `/checkpoint` · `/undo` · `/rollback` | Safety: save point / revert / restore |
| `/parallel` | Multi-agent / multi-window execution |
| `/cache` | Manage token-saving cache |

Full registry: `.ai/commands/registry.json`. Full docs per command: `.ai/commands/<name>.md`.

The simplest path for any user: `/session-start` → `/magic <what you want>` → `/session-end`.

---

## 3. Non-negotiable rules (summary — full text in `.ai/boot/BOOT.md`)

- **Think before coding** — ask about real ambiguities, state assumptions, present tradeoffs.
- **Simplicity first** — minimum code that solves the problem; no speculative abstraction.
- **Surgical changes** — touch only task-related files; no drive-by refactors.
- **TDD mandatory** — write the failing test first; code-before-test = delete and restart.
- **Verify before claiming done** — evidence (command + output) before any "done"/"passing".
- **Systematic debugging** — root cause before fix; after 3 failed fixes, escalate.
- **Respect HITL gates** — do not skip required human approvals.

These are enforced by skills in `.ai/skills/` (notably `clean-code`,
`test-driven-development`, `verification-before-completion`, `systematic-debugging`).

---

## 4. Portability notes

- This workflow is **prompt-level** — it needs no binary, no plugin, and no per-tool folder.
  Any assistant that can read project files and follow instructions can run it.
- Tools that read their own instruction filename get a thin pointer to this file. Generate
  pointers for your tool(s) with `install.ps1` / `install.sh` (see `docs/COMPATIBILITY.md`).
- Agentic frameworks (Hermes, OpenClaw, Pi, custom orchestrators): load this `AGENTS.md`
  as the agent's system/instructions context. That is the entire integration.

---

*One source of truth: this file + `.ai/`. Keep tool-specific files as pointers, never copies.*
