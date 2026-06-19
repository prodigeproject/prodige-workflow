---
name: cache-manager
description: "Manages context caching to optimize token usage and cost by creating, incrementally updating, and invalidating caches while verifying integrity before reuse."
auto_load: ["/parallel", "/cache"]
applies_to: [orchestrator, backend, frontend]
---

# Cache Manager

## Quick Protocol (your next action)
1. Check existing cache metadata/timestamps and recent file changes.
2. Decide the operation: create, incremental update, or invalidate (prefer partial over full clear).
3. Cache stable core/utils; exclude volatile files (tests, configs, generated code).
4. Verify cache integrity (hashes) before use; estimate token savings vs rebuild cost.
Measure actual token usage; never invent cache stats.

## Purpose

Manage context caching to optimize token usage and reduce costs by creating, using, and invalidating token-saving cache strategies across sessions.

## Description

The cache-manager skill handles intelligent caching of frequently accessed context, code patterns, and knowledge to minimize redundant token consumption. It tracks what should be cached, when cache becomes stale, and when to refresh or invalidate cached content.

## When to use

- When starting a new session with existing project context
- After significant code changes that invalidate cached context
- When token usage is high due to repeated context loading
- During handoffs between agents or sessions
- Automatically selected by orchestrator for optimization

## Input

- Current project state and files
- Previous cache metadata and timestamps
- Recent code changes and modifications
- Session continuity requirements

## Output

### Standard format:
- **Findings**: Current cache state analysis
- **Recommended action**: Cache operations (create/update/invalidate)
- **Cache strategy**: What to cache and for how long
- **Token savings**: Estimated optimization impact
- **Risks**: Stale data or consistency concerns
- **Files affected**: Cache manifests and metadata files

## Usage Examples

### Example 1: Creating initial cache
```
Task: Initialize cache for new project session
Input: Fresh project with 50+ source files
Output:
  Findings: No existing cache detected, project has stable core modules
  Recommended action: Create cache for src/core/* and src/utils/*
  Cache strategy: Cache stable modules, exclude test files
  Token savings: ~15,000 tokens per session
  Risks: Low - core modules change infrequently
  Files affected: .ai/runtime/cache/CACHE_MANIFEST.json, .ai/runtime/cache/module-summaries/
```

### Example 2: Invalidating stale cache
```
Task: Update cache after refactoring
Input: Major refactoring in authentication module
Output:
  Findings: Cache entries for src/auth/* are 3 days old, 12 files modified
  Recommended action: Invalidate auth module cache, retain other entries
  Cache strategy: Rebuild auth cache, keep utils and core cached
  Token savings: 8,000 tokens saved, 3,000 tokens cost to rebuild
  Risks: Medium - partial invalidation may miss dependencies
  Files affected: .ai/runtime/cache/CACHE_MANIFEST.json, .ai/runtime/cache/module-summaries/auth.md
```

### Example 3: Session continuity
```
Task: Resume work from previous session
Input: Session ended mid-feature, cache is 2 hours old
Output:
  Findings: Cache is fresh, covers 80% of needed context
  Recommended action: Use existing cache, load only recent changes
  Cache strategy: Incremental update for files modified in last session
  Token savings: ~12,000 tokens
  Risks: Low - recent cache with clear delta
  Files affected: .ai/runtime/cache/CACHE_MANIFEST.json, .ai/runtime/cache/snapshot.json
```

## Best Practices

### Cache Manifest (canonical)

The cache index lives at `.ai/runtime/cache/CACHE_MANIFEST.json`. Its `entries`
keys and the file paths they point to are canonical — read and write exactly
these names so the manifest, this skill, and the files on disk always agree:

| Manifest key | File path it tracks | Produced by |
|---|---|---|
| `snapshot` | `.ai/runtime/cache/snapshot.json` | snapshot state + file hashes |
| `dependencies` | `.ai/runtime/cache/dependencies.json` | dependency snapshot for change detection |
| `repo_map` | `.ai/runtime/cache/repo-map.md` | repomap skill (markdown view) |
| `repomap_json` | `.ai/runtime/cache/repomap.json` | repomap skill (structured view) |
| `architecture_summary` | `.ai/runtime/cache/architecture-summary.md` | architecture overview |
| `module_summaries` | `.ai/runtime/cache/module-summaries/` | per-module summaries |

Manifest shape: `{ "cache_version": <int>, "last_updated": <iso8601|null>,
"entries": { <key>: { "path": <string>, "status": "fresh"|"stale"|"missing" } } }`.
Update `last_updated` and each entry's `status` on every cache operation. Never
invent a key or path that is not in this table.

### Cache Strategy
- Cache stable, frequently accessed code (utilities, core modules, interfaces)
- Exclude volatile files (tests, configs, generated code)
- Set expiration based on change frequency (24h for active, 7d for stable)
- Version cache entries with file hashes for integrity

### Invalidation Rules
- Invalidate immediately after major refactoring
- Use dependency analysis to find transitive invalidation needs
- Prefer partial invalidation over full cache clear
- Track invalidation reasons for learning

### Optimization
- Monitor token savings vs cache management overhead
- Balance cache granularity (file-level vs module-level)
- Compress cached content for large codebases
- Implement lazy loading for cached context

### Safety
- Always verify cache integrity before use
- Include checksums or hashes for cached content
- Fallback to fresh load if cache validation fails
- Log cache hits/misses for optimization insights

## Rules

- Be concise in cache recommendations
- Be evidence-based using file timestamps and change patterns
- Do not invent cache statistics - measure actual token usage
- Prefer durable knowledge updates when cache patterns emerge
- Prioritize correctness over aggressive caching
- Document cache decisions for transparency
