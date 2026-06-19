---
name: memory-search
description: "Token-optimized retrieval from the Memory Bank. Use when asked 'did we solve this before?', 'how did we do X last time?', or when resuming work and you need prior-session context WITHOUT reading every memory file."
---

# Memory Search

Retrieve past work from the Memory Bank efficiently. **This skill overrides the default "read all memory files" behavior.** While active, follow the 3-layer protocol below instead of loading `sessionHistory.md`, `decisionLog.md`, etc. in full.

**Core principle:** Index first, fetch on demand. Read the lightweight index to find relevant entry IDs, then open only the entries you actually need. The question before every memory read is: "do I need the full entry, or can the index answer this?"

## Quick Protocol (your next action)

```
1. Read .ai/memory/index.md            → scan the entry table (id, date, type, topic)
2. Filter to 1-5 relevant entry IDs    → discard the rest
3. Open ONLY those entries             → jump to the matching section/file by id
```

Do NOT read `sessionHistory.md` or `decisionLog.md` end-to-end first. The index exists so you don't have to.

## When to Use

Use when the user references PREVIOUS sessions (not the current conversation):

- "Did we already fix this?"
- "How did we solve X last time?"
- "What did we decide about Y?"
- "What was I working on last week?"
- At `/session-start` to orient without loading every file in full.

## 3-Layer Workflow (ALWAYS Follow)

**NEVER open full entries before filtering. ~10x token savings.**

### Step 1: Index — Get the Entry Table

Read `.ai/memory/index.md`. It is a compact table of every recorded memory entry:

```
| ID     | Date       | Type     | Topic                         | Source file        |
|--------|------------|----------|-------------------------------|--------------------|
| M-0042 | 2026-06-17 | decision | Hybrid memory architecture    | decisionLog.md     |
| M-0041 | 2026-06-17 | bugfix   | Worker zombie process on exit | sessionHistory.md  |
| M-0040 | 2026-06-16 | pattern  | Zod schema convention         | conventions.md     |
```

Cost: ~10-30 tokens per entry. Types: `feature`, `bugfix`, `decision`, `pattern`, `discovery`, `session`.

### Step 2: Filter — Pick Relevant IDs

Scan topics. Select only the IDs that match the question. A query like "how did we handle auth" should narrow to 1-5 IDs, not 30.

### Step 3: Fetch — Open Only Those Entries

Open the source file named in the index and jump to the matching `### M-00XX` anchor. Read only those sections.

- For 1-2 entries: read the specific sections.
- For a cluster (e.g. a debugging saga), read the contiguous range in `sessionHistory.md`.

## Token Economics

| Approach | Tokens | Use case |
|----------|--------|----------|
| Read index.md | ~300-800 | "What's recorded? Find the right entry." |
| Fetch 1-3 entries | ~600-1,800 | "Show me what we decided/did." |
| index + fetch | ~1,000-2,600 | The primary workflow. |
| Read entire Memory Bank | ~8,000-20,000+ | Only when doing a full audit/compaction. |

**~5-10x savings** vs loading the whole Memory Bank. The narrower the question, the wider the gap.

The Memory Bank is: `index.md` (the index) + 4 indexed historical files that carry `### M-NNNN` anchors (`sessionHistory.md`, `decisionLog.md`, `conventions.md`, `progress.md`) + 2 current-state files read directly with no anchors (`activeContext.md`, `projectContext.md`).

## When to Read Full Files Instead

- **Full audit / compaction:** reviewing the entire history (use `/sync` or maintenance).
- **No index yet:** if `.ai/memory/index.md` is missing or stale, fall back to reading files AND regenerate the index (see `index.md` header).
- **Active session state:** `activeContext.md` and `projectContext.md` are small current-state files — read them directly at session start; they are not indexed.

## Integration with Other Skills

- Used by `/session-start` to orient cheaply before showing the summary.
- Pairs with `handoff-manager`: handoffs become indexed entries.
- Feeds `implementation-planning` and `systematic-debugging` with "have we hit this before?" recall.
- The index is maintained by the **memory-manager** agent at `/session-end` (see `.ai/memory/index.md`).

## Rules

- Index before fetch. Always.
- Filter to the fewest entries that answer the question.
- Never claim "we never did this" without first scanning the full index.
- If you fetch an entry and it is irrelevant, discard it — do not keep reading adjacent entries out of habit.
- Keep `activeContext.md`/`projectContext.md` direct-read (small, current); everything historical goes through the index.
