---
name: performance-review
description: Use when reviewing code in hot paths, data-heavy operations, or user-facing latency-sensitive features - detects algorithmic, query, memory, and frontend performance issues before they regress production.
auto_load: ["/review", "/audit"]
applies_to: [reviewer, backend, frontend, qa]
mandatory_when: ["hot paths", "loops over user data", "DB queries", "API endpoints", "render-critical UI"]
---

# Performance Review

Catch performance problems at review time, when they are cheap to fix — not in
production, when they are expensive and urgent.

## Prodige Severity Alignment

Performance issues are **not automatically Minor.** Classify by user/system impact:

| Condition | Severity |
|-----------|----------|
| Crash, OOM, timeout, connection-pool exhaustion | 🚫 **Critical** (blocks merge) |
| Noticeable UX degradation (>2s), N+1 on a core list, unbounded growth | ⚠️ **Important** (blocks next task) |
| Optimization opportunity, small dataset, rare path | 💡 **Minor** (debt register) |

**Test:** "Will a real user or the system *feel* this under realistic load?"
If yes → at least Important.

## When to Use

- Code in a request hot path or tight loop
- Any database access (queries, ORM calls)
- Operations over user-controlled-size collections
- Render-critical frontend components
- `/audit` runs and pre-release checks

## Review Checklist

### 1. Algorithmic complexity
- [ ] No O(n²) (or worse) over data that can grow (nested loops over the same set)
- [ ] No repeated work inside loops that could be hoisted
- [ ] Appropriate data structures (Set/Map for lookups vs array.includes)
- [ ] 🚫 Critical if quadratic on unbounded user data in a hot path

### 2. Database access
- [ ] **No N+1 queries** — related data loaded via JOIN / eager load / batch
- [ ] Queries hit an index (no full scans on large tables)
- [ ] Pagination on any list endpoint that can grow
- [ ] No `SELECT *` pulling unused columns over the wire
- [ ] Transactions scoped tightly (not held across network calls)
- [ ] 🚫 Critical: query that locks a hot table for long / unbounded result set in memory

### 3. Memory & resources
- [ ] No unbounded arrays/maps/caches (eviction or limit present)
- [ ] Streams used for large files instead of loading whole into memory
- [ ] Connections/handles released (pool, file, socket)
- [ ] No memory retained by closures/listeners that should be freed
- [ ] 🚫 Critical: leak or unbounded growth that ends in OOM

### 4. Concurrency & I/O
- [ ] Independent async work parallelized (Promise.all) not awaited serially
- [ ] No blocking sync I/O on the request path
- [ ] External calls have timeouts and are not made inside loops unbatched

### 5. Frontend (if applicable)
- [ ] Expensive renders memoized; no work in render that belongs in effect/memo
- [ ] Lists virtualized when large
- [ ] Routes/components code-split / lazy-loaded
- [ ] No layout thrashing (read/write DOM interleaved)
- [ ] Bundle impact reasonable (no heavy dep added for trivial use)

## Suggested Budgets (adjust per project)

| Metric | Budget |
|--------|--------|
| API response (p95) | ≤ 200 ms |
| DB query | ≤ 100 ms |
| Page load (p95) | ≤ 3 s |
| JS bundle (initial) | ≤ 500 KB |
| Memory per request | stable, no growth across N requests |

Record actual numbers in the review when perf-sensitive code changes. "Feels fast"
is not evidence — paste a benchmark, query plan, or profiler snapshot.

## Detection Patterns (what to grep / look for)

```
# N+1: a query/await inside a loop over results
for (const x of rows) { await db.query(...) }      // ❌ batch instead

# Quadratic: array.includes / find inside a loop over the same array
items.filter(a => others.find(b => b.id === a.id)) // ❌ use a Set/Map

# Unbounded memory: pushing to an array without limit in a stream/loop
while (true) { buffer.push(chunk) }                // ❌ stream/flush

# Serial awaits that are independent
const a = await f(); const b = await g();          // ❌ Promise.all([f(),g()])

# SELECT * on wide/large table
SELECT * FROM events                               // ❌ select needed columns
```

## Output Format

```
### Performance: {Title}
**Severity:** {Critical/Important/Minor}
**Location:** {file:line}
**Problem:** {what is slow and why}
**Measured/Estimated impact:** {e.g. 101 queries for 100 users; ~2.3s p95}
**Fix:** {concrete change}
**After:** {expected improvement, benchmark if available}
```

### Example

```
### Performance: N+1 query in user list
**Severity:** Important
**Location:** src/users/list.controller.ts:45
**Problem:** Orders fetched per-user in a loop → 1 + N queries.
**Measured impact:** 100 users = 101 queries, ~2.1s p95.
**Fix:** Eager-load orders via JOIN / `include: { orders: true }`.
**After:** 1 query, ~120ms p95.
```

## False-Positive Awareness

Not every loop is a problem. Before flagging:
- Is the data bounded and small? → likely Minor or skip.
- Is this a one-time/admin/offline path? → severity drops.
- Is there already a cache/index handling it? → acknowledge mitigation.

Premature optimization is itself a discipline violation. Flag real, demonstrable
cost — not theoretical micro-optimizations.

## Integration

- **Auto-loaded:** `/review`, `/audit`
- **Feeds:** Feature/Refactor review templates (§6 / safety gates)
- **Works with:** `clean-code`, `debt-detection`, `roastme`
- **Escalates to:** Important/Critical in the merge gate per table above
