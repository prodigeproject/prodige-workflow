# Cache Strategy

Cache exists to reduce token usage and speed up multi-agent work.

## What should be cached?

- Repo map
- Architecture summary
- Module summaries
- Dependency summary
- Route/API summary
- Database schema summary
- Current known issues
- Test map
- Design decisions summary

## Where?

```text
.ai/runtime/cache/
```

## Cache files

```text
repomap.json
architecture-summary.md
modules/
dependencies.json
routes.md
database.md
tests.md
known-issues.md
```

## When to use cache

Agents should load cache before reading large files.

## When to invalidate cache

Invalidate cache when:
- major architecture changes
- dependency changes
- database schema changes
- route/API changes
- auth changes
- folder structure changes
- module refactor happens

## Command

```text
/cache update
/cache invalidate auth
/cache status
```
