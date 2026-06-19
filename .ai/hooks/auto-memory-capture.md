# Auto Memory Capture (Agent-Lifecycle Hook)

## Purpose

Remove the dependency on a human remembering to run `/session-end`. Memory should be captured **automatically** at meaningful boundaries, not only when a person types a command. This closes the biggest gap in the markdown Memory Bank: lost continuity when `/session-end` is skipped.

> Git hooks in this folder fire on `commit`/`push`. This hook fires on **agent lifecycle events** provided by the host IDE/runtime (Kiro, Cursor, etc.). It is the runtime complement to the manual `/session-end` command.

---

## What it does

On a boundary event, append a lightweight entry to a pending buffer and (at session boundaries) fold it into the Memory Bank + Index:

```
boundary event ─▶ capture {what changed, decisions, files} ─▶ append to .ai/memory/index.md (+ source file)
```

It reuses the exact maintenance protocol from `/session-end` (allocate `M-NNNN`, write entry, append index row). The hook does NOT replace `/session-end`; it makes the capture happen even if the command is never run.

---

## Recommended event mapping

| Event | When it fires | Action | Cost |
|-------|---------------|--------|------|
| `postTaskExecution` | After a spec/plan task completes | Capture one entry for that task (feature/bugfix) | Low — fires rarely |
| `agentStop` | When an agent run ends | If meaningful work happened, fold buffer into Memory Bank + Index | Low-Medium |
| `preCompact` / context-limit | Before context is compacted | Force a capture so nothing is lost | Low |

**Avoid** firing a full capture on every single turn — it is expensive and noisy. Capture at task/session boundaries only. Use a "meaningful work" guard: skip if no files changed and no decision was recorded.

---

## Kiro hook example

Create via the Kiro Hook UI, or place a hook file with this shape:

```json
{
  "name": "Auto Memory Capture",
  "version": "1.0.0",
  "description": "Append session work to the Memory Bank + Index automatically",
  "when": {
    "type": "postTaskExecution"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Run the Memory Index maintenance step from .ai/commands/session-end.md for the task that just completed: allocate the next M-NNNN id, write the full entry to its source file with a ### M-NNNN anchor, and append one row to .ai/memory/index.md. Only capture if files changed or a decision was made. Do not run the full session-end report."
  }
}
```

For continuous safety, an additional `agentStop` hook can fold any uncaptured work into the bank. Keep its prompt guarded ("only if meaningful work happened") to avoid redundant captures.

---

## Generic fallback (no event runtime)

If the host has no agent-lifecycle hooks, approximate auto-capture by:

1. Wiring index maintenance into the `pre-commit` hook — every commit records an entry (commit message + changed files → `M-NNNN`).
2. Keeping `/session-end` as the explicit, complete capture.

Commit-driven capture is coarser than event-driven but still removes the "I forgot to run /session-end" failure mode, since commits happen naturally.

---

## Guardrails

- **Idempotent:** never write a duplicate entry for the same task — check the latest `M-NNNN` and the buffer first.
- **Cheap:** the hook appends index rows; it does not regenerate the whole index.
- **Quiet:** no entry when there is nothing meaningful (no diff, no decision).
- **Secrets:** never write secret values into memory entries — reference by key name only.

---

**Version:** 1.0.0
**Status:** Spec — enable per host (Kiro hook) or via pre-commit fallback
**Related:** `.ai/skills/memory-search/SKILL.md`, `.ai/memory/index.md`, `.ai/commands/session-end.md`
