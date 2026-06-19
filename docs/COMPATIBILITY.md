# Compatibility — Run Prodige in Any AI Tool

Prodige is a **prompt-level workflow**: it lives entirely in `AGENTS.md` + the `.ai/`
directory. No binary, no plugin, no per-tool folder. Any assistant that can read project
files and follow instructions can run it.

There is **one source of truth**: `AGENTS.md`. Every tool-specific file is a thin pointer to
it, so there is never a second copy to maintain.

---

## How it works

1. `AGENTS.md` (repo root) is the universal entry point. It tells the agent to boot from
   `.ai/boot/BOOT.md` and how to interpret `/commands`.
2. Tools that read `AGENTS.md` natively need **zero setup**.
3. Tools that look for their own filename get a 3-line pointer that just says "read AGENTS.md".
   Generate those with the installer.

```bash
# Unix / macOS / Git Bash
./install.sh claude,cursor          # wire up specific tools
./install.sh all --gitignore        # wire up all, keep repo clean

# Windows PowerShell
pwsh install.ps1 -Tools claude,cursor
pwsh install.ps1 -Tools all -Gitignore
```

---

## Tool matrix

| Tool / Assistant | Reads | Setup |
|------------------|-------|-------|
| OpenAI Codex / Codex CLI | `AGENTS.md` | none (native) |
| opencode | `AGENTS.md` | none (native) |
| Cursor | `AGENTS.md` (recent) or `.cursorrules` | none, or `install … cursor` |
| Zed | `AGENTS.md` | none (native) |
| Jules / Factory / RooCode | `AGENTS.md` | none (native) |
| Claude Code | `CLAUDE.md` | `install … claude` |
| Gemini CLI | `GEMINI.md` | `install … gemini` |
| GitHub Copilot | `.github/copilot-instructions.md` | `install … copilot` |
| Cline | `.clinerules` | `install … cline` |
| Windsurf | `.windsurfrules` | `install … windsurf` |
| Hermes / OpenClaw / Pi / custom | system-prompt / instructions config | point it at `AGENTS.md` |

> Filenames evolve. If your tool isn't listed, point its "project instructions" / "rules" /
> "system prompt" setting at `AGENTS.md` — that is the whole integration.

---

## Commands work everywhere

Prodige `/commands` are a **convention**, not a native tool feature, so they are portable:

- The agent, once booted from `AGENTS.md`, treats a leading-slash token as a command:
  resolve via `.ai/commands/registry.json` → read `.ai/commands/<cmd>.md` → run the workflow.
- If a tool's chat UI swallows the leading `/`, type the command without it
  (`build login`, `prodige build login`, or "run the build command"). The agent treats them
  the same as `/build login`.

This means you get the same `/session-start → /magic → /session-end` flow in every tool.

---

## Agentic frameworks (Hermes, OpenClaw, Pi, custom orchestrators)

These run their own loop, but they all accept custom instructions / a system prompt. The
integration is one step:

> Load `AGENTS.md` (or, if the framework wants the full spec inline, `.ai/boot/BOOT.md`)
> as the agent's system/instructions context.

Concretely:
- **Hermes / Pi / custom Python or TS agents:** set the agent's system prompt to the contents
  of `AGENTS.md`, or instruct it: "Read `AGENTS.md` in the project root and follow it."
- **OpenClaw and other plugin hosts:** add `AGENTS.md` to the instruction set the host injects
  at session start. No command-rewriting plugin is required — Prodige changes *behavior*, not
  the commands your tools run.
- For multi-agent setups, every spawned agent should receive the same `AGENTS.md` seed so they
  share the workflow, skills, and HITL gates.

Because Prodige is prompt-level, there is nothing to compile or hook — feeding `AGENTS.md` to
the agent is the entire installation.

---

## Verifying an install

After wiring a tool, start a session and run:

```
/status
```

If the agent reports project status (and references `.ai/`), the bootstrap worked. If it does
not recognize the command, ask it to "read AGENTS.md and follow it", then retry — that
confirms whether the pointer file was picked up by your tool.
