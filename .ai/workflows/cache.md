# Workflow: Cache

## Overview
Cache management workflow to build, update, and maintain context snapshots for efficient project understanding. Enables fast context loading and reduces redundant analysis across sessions.

## Prerequisites
- Active project repository
- Read access to all project files
- Understanding of project structure
- Existing `.ai/runtime/cache/` directory (or will be created)

## Step-by-Step Instructions

### 1. Build or Update Repo Map
**Action**: Create or refresh a comprehensive repository structure map.
- Scan directory tree and file organization
- Identify key modules, components, and services
- Map file relationships and dependencies
- Note recent structural changes since last cache

**Output**: `repo-map.md` in `.ai/runtime/cache/`

**Tools**: File system traversal, dependency analysis

### 2. Summarize Architecture
**Action**: Extract and document high-level system architecture.
- Review ARCHITECTURE.md or infer from code structure
- Identify architectural patterns (MVC, microservices, layered, etc.)
- Document key components and their interactions
- Note technology stack and frameworks used
- Capture data flow and system boundaries

**Output**: Architecture summary in cache

**Checkpoints**:
- Are all major system components identified?
- Is the architecture pattern clear?
- Are external dependencies documented?

### 3. Summarize Modules
**Action**: Document purpose and responsibility of each module.
- List all major modules/packages
- Describe each module's responsibility
- Note public APIs and interfaces
- Identify inter-module dependencies
- Document key classes/functions per module

**Output**: Module inventory with descriptions

**Focus**: What each module does, not how it works internally

### 4. Summarize Routes
**Action**: Catalog API endpoints and navigation routes.
- List all API routes (REST, GraphQL, etc.)
- Document route parameters and methods
- Map frontend routes to components
- Note authentication/authorization requirements
- Capture route middleware and guards

**Output**: Route registry

**For web apps**: Include both API and UI routes
**For APIs**: Focus on endpoint inventory

### 5. Summarize Database
**Action**: Document database schema and data models.
- List all tables/collections
- Document key fields and relationships
- Note indexes and constraints
- Identify migration history
- Capture database type (SQL, NoSQL, etc.)

**Output**: Database schema summary

**If multiple databases**: Document each separately

### 6. Record Cache Metadata
**Action**: Add metadata about the cache itself.
- Timestamp of cache creation
- Git commit hash at cache time
- Files analyzed count
- Cache version/format
- Agent or process that created cache

**Output**: `cache-metadata.json`

**Example**:
```json
{
  "created_at": "2024-01-15T10:30:00Z",
  "git_commit": "a1b2c3d",
  "files_analyzed": 145,
  "cache_version": "1.0",
  "created_by": "memory-manager"
}
```

### 7. Invalidate Stale Cache When Relevant
**Action**: Detect and flag outdated cache entries.
- Compare current git commit with cache commit
- Check for file additions/deletions since cache
- Identify modified files since cache creation
- Mark specific cache sections as stale
- Trigger partial or full cache rebuild if needed

**Invalidation triggers**:
- Git commit hash mismatch
- Architecture files modified
- Major refactoring detected
- Cache age exceeds threshold (e.g., 7 days)

**Decision logic**:
- Minor changes → Partial update
- Major changes → Full rebuild
- No changes → Use cached data

## Expected Outcomes

### Deliverables
1. **Repo Map**: Complete file structure visualization
2. **Architecture Summary**: High-level system design
3. **Module Inventory**: Component catalog with descriptions
4. **Route Registry**: All endpoints and paths
5. **Database Schema**: Data model documentation
6. **Cache Metadata**: Tracking and versioning info

### Success Criteria
- Cache loads in <2 seconds
- All major components documented
- Cache accurately reflects current codebase
- Stale entries identified and flagged
- Metadata enables intelligent invalidation

## Troubleshooting Tips

### Issue: Cache build takes too long (>5 minutes)
**Solution**: 
- Use incremental caching (only changed areas)
- Parallelize independent summarization tasks
- Cache large dependencies separately
- Exclude non-essential files (node_modules, build artifacts)

### Issue: Cache frequently becomes stale
**Solution**:
- Reduce cache lifetime threshold
- Implement file watcher for automatic updates
- Use git hooks to trigger cache refresh
- Cache at more granular level (per module)

### Issue: Cache size too large (>10MB)
**Solution**:
- Store summaries, not full file contents
- Compress cache files
- Exclude verbose data (logs, test fixtures)
- Use references instead of duplication

### Issue: Inconsistent cache format across updates
**Solution**:
- Define strict cache schema
- Version cache format
- Implement migration logic for format changes
- Validate cache structure on load

### Issue: Unable to detect all routes automatically
**Solution**:
- Use framework-specific route extractors
- Parse route configuration files
- Combine static analysis with pattern matching
- Allow manual route annotation

## Best Practices

1. **Incremental Updates**: Update only changed sections when possible
2. **Atomic Operations**: Ensure cache updates are transactional
3. **Version Control**: Track cache format versions for compatibility
4. **Selective Caching**: Cache expensive-to-compute information only
5. **Fast Loading**: Optimize for read performance over write
6. **Clear Metadata**: Always include timestamps and commit hashes
7. **Graceful Degradation**: System works even if cache is missing
8. **Validation**: Verify cache integrity on load

## Cache Structure Example

```
.ai/
└── runtime/
    └── cache/
        ├── cache-metadata.json       # Version, timestamp, commit
        ├── repo-map.md               # File structure
        ├── architecture-summary.md   # System design
        ├── modules/
        │   ├── auth-module.md       # Per-module summaries
        │   ├── api-module.md
        │   └── ui-module.md
        ├── routes.json               # All endpoints
        └── database-schema.md        # Data models
```

## Performance Guidelines

- **Cache build time**: Target <2 minutes for medium projects (<1000 files)
- **Cache load time**: Target <2 seconds
- **Cache size**: Target <5MB compressed
- **Update frequency**: On-demand or per commit
- **Staleness threshold**: 7 days for active projects

## Related Workflows
- **Init**: Creates initial cache during project initialization
- **Build**: Loads cache for faster context during implementation
- **Sync**: May trigger cache update after significant changes
- **Status**: Can report cache freshness and validity
- **Audit**: Uses cache to understand codebase quickly

## Integration Points

**Agents:**
- `memory-manager` - Primary agent for cache operations
- `orchestrator` - Triggers cache updates when needed
- `architect` - Consumes architecture cache

**Commands:**
- `/cache rebuild` - Force full cache rebuild
- `/cache validate` - Check cache integrity
- `/cache clear` - Delete all cached data

**Files:**
- `.ai/runtime/cache/` - Cache storage location
- `ARCHITECTURE.md` - Source for architecture summary
- `package.json`, `requirements.txt` - Dependency sources

---

**Remember:** Good cache = fast context loading. Keep it fresh, keep it lean, keep it accurate.
