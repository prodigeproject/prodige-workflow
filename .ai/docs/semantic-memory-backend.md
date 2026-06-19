# Semantic Memory Backend (Optional Add-On)

**Status:** Design / Spec — not implemented
**Scope:** An OPTIONAL, OPT-IN semantic ("find by meaning") search accelerator for the Prodige Memory Bank.
**Decision (TL;DR):** Default **OFF**. The markdown index (`.ai/memory/index.md`) remains the single source of truth and the default retrieval path. The semantic backend is a cache that can be absent, stale, or deleted at any time without breaking memory search.

---

## 1. Motivation & Non-Goals

### Motivation

The Memory Bank is pure markdown (`.ai/memory/*.md`) with a lightweight index (`.ai/memory/index.md`) and a 3-layer retrieval skill (`.ai/skills/memory-search/SKILL.md`: index → filter → fetch). This is portable, git-trackable, and token-cheap. Its one gap: retrieval is **lexical**. Finding a prior entry requires the query to share vocabulary with the index topic line. A question like "how did we stop the background task from hanging on exit" will not lexically match an entry titled "Worker zombie process on exit" even though they are the same thing.

A semantic layer closes that gap: embed the query, compare against embeddings of each `M-NNNN` entry, and return the closest matches by meaning — then hand those candidate IDs to the existing index → fetch flow.

### Non-Goals (explicit)

- **Do NOT replace markdown.** The `.md` files and `index.md` stay canonical. The backend never becomes the place where memory "lives."
- **Do NOT make it mandatory.** Every retrieval must work with the backend absent. No skill, command, or agent may hard-depend on it.
- **Do NOT sacrifice portability.** Cloning the repo and reading markdown must remain sufficient. No daemon, no required service, no network at read time.
- **Do NOT sacrifice git-trackability.** The vector store is a derived cache and is gitignored. Nothing semantic is committed.
- **Do NOT store secrets in memory.** No API keys, tokens, or credentials in `.ai/memory/**` (see §5).

---

## 2. Architecture

### Layering

```
Canonical (committed, source of truth)        Accelerator (derived, gitignored, optional)
┌─────────────────────────────────┐           ┌──────────────────────────────────────────┐
│ .ai/memory/*.md                 │  ingest   │ .ai/memory/.cache/memory.db (SQLite)       │
│ .ai/memory/index.md  (M-NNNN)   │ ────────► │  one row per M-NNNN + embedding vector     │
└─────────────────────────────────┘           └──────────────────────────────────────────┘
        ▲                                                     │
        │ fetch full entry by anchor                          │ semantic shortlist (candidate IDs)
        └─────────────────── memory-search skill ◄────────────┘
```

### Store

- **Location:** `.ai/memory/.cache/memory.db` — a single local SQLite file.
- **Gitignored:** add `.ai/memory/.cache/` to `.gitignore`. The cache is rebuildable from markdown and must never be committed.
- **Why SQLite:** zero-server, single-file, cross-platform, already mainstream. Vectors stored as a `BLOB` (packed float array) plus metadata columns; a vector extension (e.g. `sqlite-vec`) is optional — for the small entry counts here, an in-process brute-force cosine scan over all rows is fast enough and avoids a hard native dependency.

### Schema (one row per entry)

```sql
CREATE TABLE entries (
  id          TEXT PRIMARY KEY,   -- "M-0042"
  date        TEXT,               -- "2026-06-17"
  type        TEXT,               -- session|decision|pattern|bugfix|feature|discovery
  topic       TEXT,               -- one-line summary from index.md
  source_file TEXT,               -- "decisionLog.md"
  body        TEXT,               -- full entry text fetched from source anchor
  content_hash TEXT,              -- sha256(topic + body) for staleness detection
  embedding   BLOB,               -- packed float32[] of the embedding vector
  model       TEXT,               -- embedding model id, e.g. "all-MiniLM-L6-v2"
  dim         INTEGER,            -- vector dimension
  embedded_at TEXT                -- ISO timestamp
);

CREATE TABLE meta (
  key   TEXT PRIMARY KEY,         -- "model", "dim", "index_hash", "schema_version"
  value TEXT
);
```

### Ingestion (markdown → DB)

`index.md` is the authoritative list of entries. Ingestion walks it:

1. Parse the Index table in `index.md` → list of `(id, date, type, topic, source_file)`.
2. For each row, open `source_file` and extract the body under the `### M-NNNN — <topic>` anchor (read up to the next `M-NNNN` anchor or heading).
3. Compute `content_hash = sha256(topic + "\n" + body)`.
4. If the row is new or its hash changed, compute `embedding = embed(topic + "\n" + body)` and upsert into `entries`.
5. Record `meta.index_hash = sha256(index.md)` and the active `model`/`dim`.

Ingestion is **idempotent**: unchanged entries (same hash) are skipped, so re-running is cheap.

---

## 3. Retrieval Flow

The `memory-search` skill keeps its 3-layer protocol unchanged. The backend adds an **optional Step 0** in front of it.

```
Step 0 (OPTIONAL): Semantic shortlist
   - Precondition: backend present AND fresh (see §4). Else SKIP silently.
   - embed(query) → cosine-rank against entries.embedding → top-K candidate M-NNNN ids (e.g. K=8).
   ↓ feeds candidate ids into ↓
Step 1: Index    — read index.md (still authoritative for id → topic/source)
Step 2: Filter   — narrow candidates to 1-5 ids (semantic order is a hint, not a verdict)
Step 3: Fetch    — open ONLY those entries by their M-NNNN anchor in the source .md
```

Key properties:

- **Index stays authoritative.** Step 0 only proposes IDs; the resolution of an ID to its real topic/source/body always goes through `index.md` + the markdown file. If the DB and markdown disagree, markdown wins.
- **Shortlist, not answer.** Semantic ranking biases *which* entries to look at first. The model still applies judgment in Step 2 and reads ground truth in Step 3.

### Graceful degradation (required)

Step 0 is skipped — and the skill falls straight through to the existing pure-markdown Step 1 — whenever **any** of these hold:

- `.ai/memory/.cache/memory.db` is missing (never built, or deleted/gitignored on a fresh clone).
- `meta.index_hash != sha256(index.md)` (the DB is stale; markdown changed since last build).
- The embedding tool/runtime for query embedding is unavailable.
- Any error occurs querying the DB.

In all of these the result is simply the current behavior: read `index.md`, filter, fetch. No error is surfaced to the user; the accelerator is silently absent. This guarantees the backend can never *break* retrieval, only speed it up.

---

## 4. Sync / Freshness

### When to (re)build

- **Primary trigger:** at `/session-end`, *after* the memory-manager updates `index.md` and source files. New `M-NNNN` entries created this session get embedded then. This piggybacks on the moment markdown is already known-consistent.
- **On demand:** a `rebuild` command (below) for first-time setup, after archiving/compaction, or after switching embedding models.
- **Never at read time.** Retrieval must not trigger a build (that would create a soft dependency and a latency/error surface on the hot path). Read-time only *checks* freshness and skips if stale.

### Staleness detection

Two levels, both cheap:

- **Coarse (whole index):** compare `meta.index_hash` to `sha256(index.md)`. Mismatch ⇒ DB is stale ⇒ Step 0 is skipped until the next build.
- **Fine (per entry):** during ingest, compare each entry's `content_hash`. Only changed/new entries are re-embedded; deleted/renamed IDs are pruned. This keeps incremental builds near-instant.

A stale DB is never *wrong* for the user because Step 0 self-disables on coarse mismatch and falls back to markdown.

### Rebuild command sketch

```
/memory-reindex            # convenience wrapper, OFF by default
  → memory-cli rebuild     # full: drop + re-ingest every entry from index.md
  → memory-cli ingest      # incremental: only new/changed entries (run at /session-end)
```

> **Note:** `/memory-reindex` and the `memory-cli` script belong to this OPTIONAL opt-in add-on only. They are **not** core Prodige commands and are absent from the command registry; the core registered memory commands are `/memory-init`, `/session-start`, and `/session-end`.

---

## 5. Embedding Options (Pluggable)

The embedder is an interface, not a fixed choice. A single `embed(texts) -> vectors` function is swapped via config (`.ai/memory/.cache/` config or an env var). Two families:

### Local (preferred default when enabled)

- A small sentence-transformer (e.g. `all-MiniLM-L6-v2`, 384-dim) run locally, or an Ollama embedding model (e.g. `nomic-embed-text`) via `http://localhost`.
- Pros: no network, no keys, no per-call cost, privacy-preserving (memory text never leaves the machine).
- Cons: requires a local runtime/model download; first run is slower.

### API

- A hosted embeddings endpoint.
- Pros: no local model management, strong quality.
- Cons: network dependency, per-call cost, and **requires a secret**.

### Pluggability contract

- The `model` id and `dim` are recorded in `meta`. If the configured model differs from the stored one, the DB is treated as stale and rebuilt (vectors from different models are not comparable).
- **Secrets rule:** API keys are read from the environment (or the user's own secret store) at build time only. They are **never** written to `.ai/memory/**`, never to `memory.db`, and never committed. The committed markdown contains zero credentials. If no key/runtime is configured, the system simply stays in pure-markdown mode.

---

## 6. CLI / Script Sketch (pseudocode)

A single small script (e.g. `.ai/scripts/memory-cli`) exposing three verbs. Pseudocode — illustrative, not prescriptive.

```python
# memory-cli ingest        (incremental; default at /session-end)
def ingest():
    db = open_sqlite(".ai/memory/.cache/memory.db")   # create schema if missing
    rows = parse_index_table(".ai/memory/index.md")    # [(id,date,type,topic,src)]
    seen = set()
    for r in rows:
        seen.add(r.id)
        body = extract_anchor_body(r.source_file, r.id) # text under "### M-NNNN —"
        h = sha256(r.topic + "\n" + body)
        if db.get(r.id) and db.get(r.id).content_hash == h:
            continue                                    # unchanged → skip
        vec = embed(r.topic + "\n" + body)              # pluggable embedder
        db.upsert(id=r.id, ...=r, body=body, content_hash=h,
                  embedding=pack(vec), model=MODEL, dim=len(vec))
    db.prune(keep=seen)                                 # drop entries no longer in index
    db.set_meta("index_hash", sha256_file(".ai/memory/index.md"))
    db.set_meta("model", MODEL); db.set_meta("dim", DIM)

# memory-cli search "<query>"   (Step 0 shortlist; prints candidate ids)
def search(query, k=8):
    db = open_sqlite(".ai/memory/.cache/memory.db")
    if db is None: return []                            # missing → caller falls back
    if db.meta("index_hash") != sha256_file(".ai/memory/index.md"):
        return []                                       # stale  → caller falls back
    q = embed(query)
    scored = [(cosine(q, unpack(e.embedding)), e.id) for e in db.all()]
    return [id for _, id in sorted(scored, reverse=True)[:k]]

# memory-cli rebuild        (full reset; first-time setup / model change)
def rebuild():
    drop_table("entries"); ingest()
```

Behavioral contract for callers (the skill): treat an empty/None result from `search` as "no shortlist available" and proceed with the normal markdown index scan.

---

## 7. Risks & Tradeoffs vs. Pure Markdown

| Concern | Pure markdown (current) | + Semantic backend |
|---|---|---|
| Portability | Total — just files | Cache is local/derived; must degrade if absent |
| Git-trackability | Full diff history | Cache gitignored (good); markdown unchanged |
| Setup cost | Zero | Model/runtime install or API key |
| Recall by meaning | Lexical only | Strong |
| Failure modes | Essentially none | Embedding/runtime/store failures (must be non-fatal) |
| Determinism | Fully deterministic | Embeddings/model versions drift |

**Why this stays optional:** the reference system (claude-mem) layers SQLite + a Chroma vector store + an embedding worker process, and its own documentation is full of reliability problems — background **worker** lifecycle bugs (zombie/hung processes), **Chroma** instability, and **Windows**-specific failures. Adopting that stack as a *hard dependency* would import those failure modes into a system whose main virtue is that it is just markdown. So Prodige inverts the relationship: markdown is canonical and always works; the vector store is a removable accelerator that self-disables on any error. Worst case for the backend is "no speedup," never "broken memory." We also prefer a single SQLite file with in-process cosine over a separate vector-DB service specifically to avoid the worker/service reliability class of bugs.

Additional tradeoffs to accept:

- **Staleness:** between edits and the next build the DB lags; mitigated by coarse `index_hash` skip (§4) so stale never means wrong.
- **Model drift:** changing embedding models invalidates stored vectors; handled by the `model`/`dim` check forcing a rebuild.
- **Disk:** a few KB per entry; negligible and gitignored.

---

## 8. Decision: Default OFF

**The semantic backend ships disabled.** Out of the box, memory retrieval is exactly today's behavior: `memory-search` reads `index.md`, filters, and fetches markdown. No DB, no embedder, no network.

### How to enable (opt-in)

1. **Gitignore the cache:** ensure `.ai/memory/.cache/` is in `.gitignore`.
2. **Choose an embedder:** local (sentence-transformer / Ollama) or API. For API, provide the key via environment/secret store — never in `.ai/memory/**`.
3. **Build the cache once:** run `memory-cli rebuild`.
4. **Keep it fresh:** allow `/session-end` to run `memory-cli ingest` after the index update.
5. **(Optional) flip a flag:** a single config flag (e.g. `memory.semantic.enabled = true`) tells the `memory-search` skill it may attempt Step 0. With the flag off — or the DB missing/stale — Step 0 is skipped and nothing changes.

### How to disable / remove

Delete `.ai/memory/.cache/memory.db` (or the flag). Retrieval immediately reverts to pure markdown. Nothing else to undo, because nothing semantic was ever committed.
