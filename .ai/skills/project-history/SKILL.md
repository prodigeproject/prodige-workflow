---
name: project-history
description: "Synthesize a narrative project-history report (evolution, decisions, debugging arcs, ROI) from the Memory Bank. Use when asked for a project history, development journey, retrospective, or 'what's the story of this project?'."
---

# Project History

Generate a narrative "Journey / project history" report by **synthesizing the Memory Bank** — pure markdown, **no database, no runtime**. This is the portable analogue of claude-mem's timeline-report, except it reads Prodige's own markdown memory instead of a SQLite timeline.

**Core principle:** The Memory Bank already holds the story (sessions, decisions, patterns, bugfixes). Your job is to read it cheaply via the index, then weave the entries into a readable narrative — genesis → evolution → decisions → debugging sagas → lessons — and close with an honest, markdown-derived ROI estimate.

## Quick Protocol (your next action)

```
1. Read .ai/memory/index.md FIRST    → scan the entry table (apply memory-search 3-layer discipline)
2. Group entry IDs by type + date    → session / decision / pattern / bugfix / feature / discovery
3. Fetch ONLY the entries you cite    → open source files at the matching M-XXXX anchor
4. Read sessionHistory, decisionLog, conventions, progress for narrative gaps
5. Check .ai/context/DECISIONS.md     → fold in formal ADRs if present
6. Draft the report sections (genesis → evolution → decisions → sagas → patterns → lessons)
7. Compute the markdown-derived Memory ROI (counts + reuse estimate, clearly labelled)
8. Save to ./project-history-<project>.md
```

Do NOT load every memory file end-to-end up front. Use the index to find what matters, then fetch on demand.

## When to Use

Use when the user asks for the *story* or *arc* of the project, not a single fact:

- "Give me the project history / development journey."
- "Write a retrospective of this project."
- "What's the story of this project? How did we get here?"
- "Summarize how the architecture evolved."
- During `/audit` to provide historical narrative context alongside the structural review.

For pinpoint recall ("did we fix X before?"), use `memory-search` instead — this skill is for the *whole narrative*.

## Sources (read in this order)

| Order | Source | What you pull from it |
|-------|--------|-----------------------|
| 1 | `.ai/memory/index.md` | Entry table — read FIRST. Find relevant `M-XXXX` ids, filter, fetch on demand. |
| 2 | `.ai/memory/sessionHistory.md` | Session arcs, bugfix sagas, discoveries — the chronological backbone. |
| 3 | `.ai/memory/decisionLog.md` | Technical decisions and their rationale. |
| 4 | `.ai/memory/conventions.md` | Learned patterns and conventions (work-pattern signal). |
| 5 | `.ai/memory/progress.md` | Completed features and current standing. |
| 6 | `.ai/context/DECISIONS.md` | Formal ADRs, *if the file exists*. Fold these into Key Decisions. |

Follow the **memory-search 3-layer discipline** (index → filter → fetch). Never read full memory files just to learn what they contain when the index can route you.

## Report Structure

Produce a narrative report (markdown) with these sections:

### 1. Project Genesis
How and why the project started. Pull from the earliest `session` entries and `projectContext.md` if referenced. What problem was it solving? What were the initial constraints?

### 2. Architectural Evolution
The arc of how the structure/design changed over time. Trace `decision` + `feature` entries chronologically. Show the "before → after" shifts, not just a list.

### 3. Key Decisions (with rationale)
The highest-leverage `decision` entries. For each: what was decided, why, what alternatives were weighed, and what it unblocked. Fold in `.ai/context/DECISIONS.md` ADRs where present.

### 4. Debugging Sagas / Challenges
The `bugfix` and `discovery` entries that were hard-won. Tell each as a short arc: symptom → investigation → root cause → fix → lesson. Group related bugfixes into a single saga where they belong together.

### 5. Work Patterns
What the `pattern`/`convention` entries and session cadence reveal about *how* the team works — recurring practices, conventions adopted, rhythms in the session history.

### 6. Lessons
Durable takeaways. What would the team carry into the next project? Surface anything explicitly recorded in `.ai/memory/lessons/` plus patterns you inferred.

### 7. Memory ROI (markdown-derived estimate)
A lightweight return-on-investment view computed **from the markdown only** — no DB, no instrumented token metrics. Be explicit that these are estimates derived by counting memory entries, not measured runtime telemetry.

Report:
- **Recorded entries:** count of `session`, `decision`, `pattern`, `bugfix`, `feature`, `discovery` entries (from the index table).
- **Context reused (estimate):** a rough estimate of context reused = number of times a prior decision/pattern/bugfix could be recalled instead of re-derived. Frame as a range, not a precise number.
- **Highest-value decisions:** the 2-3 decisions that unblocked the most downstream work.
- **Honesty note:** state plainly — "These figures are derived from counting Memory Bank markdown entries. They approximate value; they are not instrumented token measurements."

Example shape:

```
## Memory ROI (markdown-derived estimate)

- Sessions recorded:   12
- Decisions recorded:  8   (3 high-leverage)
- Patterns recorded:   5
- Bugfixes recorded:   6
- Features recorded:   9

Estimated context reused: ~15-25 recall events avoided re-derivation
  (counted as decisions + patterns + bugfixes referenced more than once).

Highest-value decisions:
  1. M-0002 — Hybrid memory architecture (unblocked the whole memory system)
  2. ...

Note: derived from Memory Bank markdown counts, not instrumented token metrics.
```

## Output

Save the report to `./project-history-<project>.md` by default (substitute the project name). If the user names a different path, honor it. Keep it narrative and scannable — prose for the story, tables/lists for the ROI and decision summaries.

## Rules

- **Index before fetch.** Always read `.ai/memory/index.md` first and filter to the entries you actually cite.
- **No DB, no runtime.** Everything is synthesized from markdown. Never imply instrumented telemetry exists.
- **Be honest about estimates.** Label every ROI number as a markdown-derived estimate.
- **Cite entry IDs.** Reference `M-XXXX` anchors so the narrative is traceable back to memory.
- **Narrate, don't dump.** Weave entries into arcs; do not paste raw memory entries verbatim.
- **Don't invent history.** If a section has no supporting entries, say so briefly rather than fabricating.
- **Skip missing sources gracefully.** If `.ai/context/DECISIONS.md` or `lessons/` is absent, note it and continue.

## Integration with Other Skills

- Builds on **memory-search** — reuse its 3-layer index → filter → fetch discipline to read the Memory Bank cheaply.
- Pairs with **handoff-manager** — handoffs become indexed entries; this skill stitches them into the larger journey.
- Surfaced during `/audit` as the historical-narrative companion to the structural and security review.
