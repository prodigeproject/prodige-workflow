# Context Size Limits

Prodige Workflow has practical limits on project size and complexity it can effectively handle.

## Supported Project Sizes

### ✅ Well-Supported (Sweet Spot)
- **Files**: 10-500 files
- **Codebase**: 5K-50K lines
- **Modules**: 3-20 modules
- **Team**: 1-10 developers

At this scale:
- Repomap works efficiently
- Context fits in memory
- Cache is effective
- Review is manageable

### ⚠️ Partially Supported (Challenging)
- **Files**: 500-2000 files
- **Codebase**: 50K-200K lines
- **Modules**: 20-50 modules
- **Team**: 10-30 developers

At this scale:
- Use `/parallel` for focused work
- Rely heavily on cache
- May need context pruning
- Review takes longer

### ❌ Not Well-Supported (Beyond Limits)
- **Files**: 2000+ files
- **Codebase**: 200K+ lines
- **Modules**: 50+ modules
- **Team**: 30+ developers

At this scale:
- Context windows overflow
- Repomap becomes slow
- Cache thrashing
- Better to use per-service Prodige instances

## Why These Limits Exist

### 1. AI Context Windows
Current LLMs have finite context (e.g., 200K tokens):
- Must fit: project context + code + conversation + skills
- Large projects exhaust context quickly
- Quality degrades with context overflow

### 2. Cognitive Load
Even AI has limits on complexity:
- Too many files → hard to navigate
- Too many modules → hard to understand dependencies
- Too many patterns → hard to maintain consistency

### 3. Tool Performance
Supporting tools have limits:
- ripgrep fast but memory-bound on huge codebases
- repomap crawls slowly on 10K+ files
- Git operations slow on giant repos

## Escape Hatches

### For Large Monorepos

**Option 1: Workspace Isolation**
Focus Prodige on one workspace at a time:
```bash
cd apps/user-service
/session-start  # Context only for this service
/magic add authentication
```

**Option 2: Multiple Prodige Instances**
One per service/module:
```
monorepo/
├── service-a/.ai/  # Independent Prodige instance
├── service-b/.ai/  # Independent Prodige instance
└── shared/.ai/     # Shared libraries instance
```

**Option 3: Sparse Checkout**
Use git sparse-checkout to limit visible files:
```bash
git sparse-checkout set apps/user-service
/session-start  # Only sees user-service
```

### For Legacy Codebases

**Option 1: Incremental Adoption**
Apply Prodige to new code only:
```
project/
├── legacy/     # Untouched by Prodige
└── modern/     # Managed by Prodige
    └── .ai/
```

**Option 2: Focused Refactoring**
Use Prodige for bounded refactors:
```bash
/refactor module-x  # Focus on one module
# Don't try to refactor entire legacy codebase at once
```

## What Prodige Does

### ✅ Handles Well
- Greenfield projects
- Microservices (per service)
- Well-modularized monoliths
- Active development areas

### ❌ Struggles With
- Entire enterprise monoliths
- Legacy codebases with 10K+ files
- Polyglot repos with 10+ languages
- Code without clear module boundaries

## Philosophy Alignment

From SOUL.md:
> "Modular beats monolithic"

Prodige works best with modular architectures. If your codebase is a giant monolith, that's an architectural issue Prodige can't solve alone.

## Recommended Approach

**For New Projects**:
- Start with Prodige from day 1
- Keep modules focused
- Avoid premature monoliths

**For Existing Projects**:
- Assess size against limits
- If oversized, use isolation strategies
- Consider architectural refactoring

**For Legacy Projects**:
- Don't try to Prodige-ize everything
- Focus on new features
- Gradual modernization

## Prior Requests

- None yet (boundary established based on practical experience)

---

**Bottom Line**: Prodige is powerful but not magic. Right-size your scope for best results.
