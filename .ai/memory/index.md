# Memory Index

Lightweight, searchable index of all Memory Bank entries. Read this FIRST (see the `memory-search` skill) instead of loading every memory file. Each row points to a full entry in a source file by its `M-XXXX` anchor.

**Owner:** memory-manager agent
**Updated:** automatically at `/session-end` (and whenever a decision/pattern/bugfix is recorded)
**Retrieval:** `memory-search` skill — index → filter → fetch

---

## How the index works

- Every significant memory entry gets a stable ID: `M-NNNN` (zero-padded, monotonically increasing).
- The entry is written to its source file with a matching anchor heading, e.g. `### M-0042 — Hybrid memory architecture`.
- This index keeps only a one-line summary per entry (~10-30 tokens). Fetch the full entry only when relevant.

### Entry types

| Type | Meaning | Source file |
|------|---------|-------------|
| `session` | A work-session summary | `sessionHistory.md` |
| `decision` | A technical decision + rationale | `decisionLog.md` |
| `pattern` | A learned convention/pattern | `conventions.md` |
| `bugfix` | A resolved bug + root cause | `sessionHistory.md` |
| `feature` | A completed feature | `progress.md` / `sessionHistory.md` |
| `discovery` | A non-obvious finding | `sessionHistory.md` |

---

## Index

| ID | Date | Type | Topic | Source file |
|----|------|------|-------|-------------|
| M-0001 | 2026-06-17 | session | Initial setup: audit UX-first vs governance-first approaches, Memory Bank scaffolded | sessionHistory.md |
| M-0002 | 2026-06-17 | decision | Hybrid architecture: adopt beginner-friendly UX, keep strong governance | decisionLog.md |

<!--
APPEND NEW ENTRIES ABOVE THIS COMMENT, NEWEST AT THE BOTTOM OF THE TABLE.
Keep one line per entry. Next ID: M-0003.
-->

---

## Maintenance

**At `/session-end`** (memory-manager):
1. For each new decision/pattern/bugfix/feature recorded this session, allocate the next `M-NNNN` id.
2. Write the full entry to its source file with a `### M-NNNN — <topic>` anchor.
3. Append a one-line row to the Index table above.
4. Add a single `session` entry summarizing the whole session.

**Rebuild (if index is missing or drifted):**
1. Scan `sessionHistory.md`, `decisionLog.md`, `conventions.md`, `progress.md`.
2. Assign ids to entries that lack an `M-NNNN` anchor (preserve existing ids).
3. Regenerate the Index table sorted by date ascending.

**Size & compaction (one policy):** index stays small (one line per entry). Compaction runs at `/session-end` and `/sync`, guarded by size (~5000 tokens / ~50KB). When `sessionHistory.md` archives entries past the rolling 30-day window into `archive/sessionHistory-<YYYY-Qn>.md`, **keep their index rows** but set each row's `source_file` to `archive/...`. (`conventions.md` has a soft cap of ~50 patterns; `archive/` is created lazily.)
