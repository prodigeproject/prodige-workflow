# /sync

Mendeteksi context drift dengan membandingkan berbagai sumber kebenaran dalam sistem untuk memastikan konsistensi.

## Syntax

```bash
/sync [--fix] [--verbose]
```

## Purpose

Sistem AI bekerja dengan multiple sources of truth:
- Repository code
- Documentation
- Context (`.ai/context/`)
- Runtime state (`.ai/state/`)
- Cache (`.ai/runtime/cache/`)

Ketika sumber-sumber ini tidak sinkron, terjadi **context drift** yang menyebabkan:
- Incorrect AI responses
- Outdated recommendations
- Stale cache hits
- Inconsistent state

`/sync` mendeteksi dan (opsional) memperbaiki drift ini.

## How It Works

### Comparison Matrix

```
          Repo  README  Docs  Brain  State  Cache
Repo       -      ✓      ✓     ✓      ✓      ✓
README     ✓      -      ✓     ✓      ✓      -
Docs       ✓      ✓      -     ✓      ✓      -
Brain      ✓      ✓      ✓     -      ✓      ✓
State      ✓      ✓      ✓     ✓      -      ✓
Cache      ✓      -      -     ✓      ✓      -
```

### Detection Process

1. **Repository Scan**
   - Latest commit hash
   - Modified files since last sync
   - Dependency changes

2. **README Analysis**
   - Project description vs brain
   - Tech stack mentioned vs actual
   - Setup instructions vs reality

3. **Documentation Check**
   - API docs vs actual API
   - Architecture docs vs code structure
   - Guides vs current workflow

4. **Brain Validation**
   - Brain content vs repository
   - Unknowns vs discovered information
   - Decisions vs implementation

5. **State Verification**
   - Current state vs repository state
   - Pending tasks vs completed work
   - Session state vs reality

6. **Cache Health**
   - Cache age vs code changes
   - Hit rate analysis
   - Stale entry detection

## Options

| Option | Description | Example |
|--------|-------------|---------|
| `--fix` | Automatically fix detected drift | `/sync --fix` |
| `--verbose` | Show detailed comparison | `/sync --verbose` |
| `--dry-run` | Show what would be fixed without applying | `/sync --fix --dry-run` |

## Output

### 1. In Sync ✓
Semua sumber konsisten, tidak ada action required.

```bash
/sync

# Output:
✓ Repository: Clean, last commit abc123
✓ README: Matches brain and repository
✓ Documentation: Up to date
✓ Brain: Consistent with codebase
✓ State: Current
✓ Cache: Fresh (hit rate: 87%)

Status: IN SYNC
No action required.
```

### 2. Drift Detected ⚠
Inkonsistensi ditemukan dengan recommended actions.

```bash
/sync

# Output:
⚠ DRIFT DETECTED

Issues Found:
1. Repository: 15 commits since last sync
   → Brain may be outdated
   
2. README: Mentions MongoDB, but repository uses PostgreSQL
   → README needs update
   
3. Docs: API endpoint /v2/users not documented
   → Documentation incomplete
   
4. Brain: UNKNOWNS.md lists auth strategy, but JWT implemented
   → Brain needs update
   
5. State: CURRENT.md shows "planning phase", but code exists
   → State is stale
   
6. Cache: Last updated 7 days ago, 45 files changed since
   → Cache needs refresh

Recommended Actions:
1. Update brain: /init from repo
2. Update README: Edit README.md (manual)
3. Generate docs: /docs generate
4. Update state: Edit .ai/state/CURRENT.md
5. Refresh cache: /cache clear && /cache update

Run '/sync --fix' to auto-fix what's possible.
```

### 3. Critical Drift 🔴
Serious inkonsistensi yang require immediate attention.

```bash
/sync

# Output:
🔴 CRITICAL DRIFT DETECTED

Critical Issues:
1. Brain describes microservices architecture, but code is monolithic
   → Major architectural mismatch
   
2. State shows production deployment, but repository in broken state
   → State critically wrong
   
3. Dependencies in package.json don't match Brain TECH_STACK.md
   → Cannot trust system recommendations

Required Actions (MANUAL):
1. Audit architecture: Review .ai/context/ARCHITECTURE.md vs actual code
2. Validate state: Verify .ai/state/ reflects reality
3. Reconcile dependencies: Sync package.json with brain

DO NOT PROCEED until critical drift resolved.
Human approval and manual intervention required.
```

## Examples

### Basic Sync Check
```bash
# Regular sync check
/sync

# Output shows status
# Take recommended actions
```

### Auto-Fix Mode
```bash
# Automatically fix what's possible
/sync --fix

# Output:
✓ Cache refreshed
✓ State updated from repository
✓ Brain synchronized
⚠ Manual fixes still needed:
  - Update README.md line 15-20
  - Add API documentation for /v2/users
```

### Verbose Analysis
```bash
# Detailed comparison
/sync --verbose

# Shows:
# - Line-by-line diffs
# - Detailed conflict analysis
# - Specific file changes needed
```

### Dry Run
```bash
# See what would be fixed
/sync --fix --dry-run

# Output:
Would execute:
1. /cache clear
2. /cache update
3. Update .ai/state/CURRENT.md:
   - line 5: "phase: planning" → "phase: implementation"
4. Update open-questions in .ai/context/PRD.md:
   - Remove: "Auth strategy unclear"

Run without --dry-run to apply.
```

## What Gets Compared

### 1. Repository ↔ Brain
```
Repository State          Context Content
├── src/                 ├── ARCHITECTURE.md
├── package.json         ├── PRD.md
├── README.md            ├── PROJECT.md
└── docs/                └── DECISIONS.md

Checks:
- Tech stack matches
- Architecture consistent
- Dependencies aligned
- Unknowns resolved
```

### 2. README ↔ Reality
```
README Claims            Actual State
├── "Uses MongoDB"       ├── PostgreSQL in use
├── "React 18"           ├── React 17 in package.json
└── "Serverless"         └── Express server in code

Checks:
- Accuracy of claims
- Current setup instructions
- Correct tech stack listed
```

### 3. Documentation ↔ Code
```
API Documentation        Actual API
├── GET /v1/users        ├── GET /v1/users ✓
├── POST /v1/users       ├── POST /v1/users ✓
└── [missing]            └── GET /v2/users ✗

Checks:
- All endpoints documented
- Parameters correct
- Response formats match
```

### 4. State ↔ Progress
```
.ai/state/               Repository
├── phase: "planning"    ├── 5000 LOC written
├── tasks: []            ├── Features implemented
└── next: "design"       └── Tests passing

Checks:
- Phase matches progress
- Tasks reflect reality
- Next steps make sense
```

### 5. Cache ↔ Freshness
```
Cache Entry              Source File
├── user.service.ts      ├── Modified 2 days ago
│   cached 7 days ago    │   [STALE]
└── auth.service.ts      └── Modified 1 hour ago
    cached 1 hour ago        [FRESH]

Checks:
- Cache age vs file changes
- Hit rate health
- Memory usage reasonable
```

## Auto-Fix Capabilities

### What Can Be Auto-Fixed

✓ **Cache Issues**
- Refresh stale cache
- Clear invalid entries
- Rebuild cache index

✓ **State Updates**
- Update phase based on code analysis
- Sync task completion
- Refresh timestamps

✓ **Manifest Update**
- Bump `context_version` (integer) in `.ai/context/manifest.json`
- Update `last_sync` (ISO timestamp) in `.ai/context/manifest.json`
- Record sync summary in history

✓ **Brain Sync**
- Re-scan repository
- Update tech stack
- Refresh dependencies

✓ **Minor Inconsistencies**
- Formatting differences
- Timestamp updates
- Metadata refresh

### What Requires Manual Fix

✗ **Architectural Conflicts**
- Documentation says X, code does Y
- Requires human decision

✗ **README Inaccuracies**
- Written content must be reviewed
- Human must verify claims

✗ **Major Drift**
- Brain completely out of sync
- Requires re-initialization

✗ **Documentation Gaps**
- Missing documentation must be written
- Cannot auto-generate without context

## Error Handling

### Sync Failed
**Error:** `Sync check failed: Unable to access repository`

**Solutions:**
- Verify you're in project root
- Check file permissions
- Ensure .git directory exists

### Cannot Determine Drift
**Warning:** `Ambiguous state: Cannot determine source of truth`

**Actions:**
- Manual review required
- Check `.ai/logs/sync-error.log`
- May need to re-init: `/init from repo`

### Fix Failed
**Error:** `Auto-fix failed for: cache refresh`

**Solutions:**
- Check specific error message
- Try manual command: `/cache clear && /cache update`
- Check disk space and permissions

## Best Practices

### 1. Regular Sync Checks
```bash
# At start of every session
/sync

# After major changes
git pull
/sync

# Before important operations
/parallel build feature
/sync  # Ensure clean state first
```

### 2. Fix Drift Immediately
```bash
# Don't ignore warnings
/sync
# Shows drift

# Fix ASAP
/sync --fix
# Or manual fixes
```

### 3. Sync Before Commit
```bash
# Ensure consistency
/sync
git add .
git commit -m "Feature X"
```

### 4. Sync After Merge
```bash
# After merging branches
git merge feature-branch
/sync --fix
/cache update
```

### 5. Document Manual Fixes
```bash
/sync
# Shows manual fixes needed

# Do the fixes
# Document in commit message
git commit -m "Sync fixes: Update README, add API docs"
```

## Integration with Other Commands

### With /init
```bash
# If critical drift detected
/sync
# Output: Critical drift in brain

# Re-initialize
/init from repo
/sync  # Should now be in sync
```

### With /cache
```bash
# Sync often triggers cache updates
/sync
# Output: Cache stale

/cache clear
/cache update
/sync  # Verify fixed
```

### With /parallel
```bash
# Always sync before parallel work
/sync
/parallel build feature

# And after merge
/parallel merge feature
/sync
```

## Performance

- **Sync check:** 2-10 seconds
- **Auto-fix:** 10-60 seconds
- **Verbose mode:** 10-30 seconds

## Troubleshooting

### False Positives
**Symptom:** Sync reports drift but manual check shows consistency

**Solution:**
```bash
# Clear and rebuild cache
/cache clear
/cache update
/sync
```

### Always Shows Drift
**Symptom:** Sync never reports "in sync"

**Cause:** Configuration issue or corrupted state

**Solution:**
```bash
# Nuclear option: full reset
/init from repo --force
/cache clear
/cache update
/sync
```

### Slow Sync
**Symptom:** Sync takes > 30 seconds

**Cause:** Large repository or stale cache

**Optimization:**
```bash
# Add .aiignore
echo "node_modules/\ndist/\n*.log" > .aiignore
/sync
```

## Related Commands

- `/init` - Re-initialize brain if critical drift
- `/cache` - Manage cache that sync checks
- `.ai/state/` - State files that sync validates

## Monitoring

### Sync Health Metrics
Track over time:
- Drift frequency
- Time between syncs
- Auto-fix success rate
- Manual fix time

### Recommended Frequency
- **Per session:** At least once
- **After git ops:** Always
- **Before parallel:** Always
- **Continuous:** Every 30-60 minutes during active development

---

**Remember:** Sync early, sync often. Context drift leads to incorrect AI behavior.
