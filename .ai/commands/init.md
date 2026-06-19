# /init

Menginisialisasi project brain dengan menganalisis repository, ide, atau notes untuk membangun context awal sistem.

## Syntax

```
/init from <source> [: description]
```

## Modes

### 1. From Repository
Menganalisis existing codebase untuk membangun project brain.

```bash
/init from repo
```

**Process:**
1. Scan directory structure
2. Analyze package.json/dependencies
3. Parse README dan documentation
4. Extract architecture patterns
5. Identify tech stack
6. Map component relationships
7. Generate initial brain structure

**Output:**
- `.ai/context/ARCHITECTURE.md` (system architecture, tech stack, dependencies)
- `.ai/context/manifest.json` (schema_version, context_version, last_sync)
- Canonical state files (`.ai/state/CURRENT.md`, `SPRINT.md`, `BACKLOG.md`, `STATUS.md`)
- Initial cache warming

### 2. From Idea
Membuat project brain dari deskripsi ide atau konsep.

```bash
/init from idea: Build a task management app with real-time collaboration
```

**Process:**
1. Parse idea description
2. Identify core features
3. Suggest tech stack options
4. Propose architecture
5. Create initial brain scaffold
6. Mark unknowns yang perlu clarification

**Output:**
- `.ai/context/PRD.md` (concept, requirements) + `.ai/context/PROJECT.md` (identity)
- `.ai/context/ARCHITECTURE.md` (proposed architecture)
- open-questions section in `.ai/context/PRD.md` (unknowns)
- Critical questions (max 3)

### 3. From Notes
Membangun project brain dari notes atau dokumen planning.

```bash
/init from notes: path/to/planning-doc.md
```

**Process:**
1. Parse notes/documentation
2. Extract requirements
3. Identify technical constraints
4. Map stakeholder needs
5. Build knowledge graph
6. Generate structured brain

**Output:**
- `.ai/context/PRD.md` (requirements, constraints)
- `.ai/context/PROJECT.md` (stakeholders, identity)
- Gap analysis

## Parameters

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| `source` | Yes | Source type: `repo`, `idea`, `notes` | `repo` |
| `description` | Conditional | Description atau path (required untuk `idea` dan `notes`) | `Build a chat app` |

## Examples

### Initialize from Existing Repo
```bash
# Scan current repository
/init from repo

# System akan:
# ✓ Analyze code structure
# ✓ Extract tech stack
# ✓ Map dependencies
# ✓ Generate brain files
# ✓ Warm up cache
```

### Initialize from Idea
```bash
# New project idea
/init from idea: E-commerce platform with AI recommendations

# System akan:
# ✓ Parse idea
# ✓ Suggest architecture
# ✓ Propose tech stack
# ✓ Identify unknowns
# ✓ Ask 3 critical questions
```

**Example Questions:**
1. What's the expected scale? (1K, 10K, 100K users)
2. Payment integration required? (Stripe, PayPal, etc.)
3. Target platform? (Web, Mobile, Both)

### Initialize from Notes
```bash
# From planning document
/init from notes: docs/project-brief.md

# From multiple notes
/init from notes: docs/requirements.md, docs/tech-decisions.md

# System akan:
# ✓ Parse all documents
# ✓ Extract requirements
# ✓ Consolidate information
# ✓ Build knowledge base
# ✓ Highlight gaps
```

## Rules & Constraints

### Core Rules

1. **No Invention**
   - Never fabricate information
   - Only use available facts
   - Mark assumptions clearly

2. **Fill Available Information**
   - Extract all discoverable data
   - Organize systematically
   - Create logical structure

3. **Mark Unknowns**
   - Explicitly label missing information
   - Categorize by priority
   - Suggest discovery methods

4. **Limited Questions**
   - Ask maximum 3 critical questions
   - Focus on blocking unknowns
   - Prioritize high-impact clarifications

5. **No Coding**
   - Initialization phase only
   - Analysis and planning focus
   - Code generation comes later

### Validation Rules

```yaml
required_outputs:
  - brain_structure: yes
  - tech_stack_identified: yes
  - architecture_mapped: yes
  - unknowns_documented: yes
  
constraints:
  - no_code_generation: true
  - max_questions: 3
  - no_assumptions_without_marking: true
  - complete_available_scan: true
```

## Output Structure

### Context Directory Structure
```
.ai/context/
├── PROJECT.md           # Project identity, vision, stakeholders
├── PRD.md               # Requirements, concept, constraints, open questions
├── ARCHITECTURE.md      # System architecture, tech stack, dependencies, patterns
├── IMPLEMENTATION.md    # Technical implementation plan
├── DECISIONS.md         # Architectural decisions
├── CONTEXT.md           # Domain glossary and key terms
├── CHANGELOG.md         # Notable changes log
└── manifest.json        # schema_version, context_version (int), last_sync (ISO)

.ai/state/
├── CURRENT.md           # Current phase and active focus
├── SPRINT.md            # Active sprint scope and goals
├── BACKLOG.md           # Outstanding work items
└── STATUS.md            # Project status snapshot

.ai/runtime/cache/
└── [initialized cache]
```

### Sample ARCHITECTURE.md
```markdown
# Architecture Overview

## Type
Microservices / Monolith / Serverless / [UNKNOWN]

## Structure
- Frontend: React + TypeScript
- Backend: Node.js + Express
- Database: PostgreSQL
- Cache: Redis

## Patterns Identified
- Repository pattern for data access
- Service layer for business logic
- Controller pattern for routes

## Unknowns
- [ ] Authentication strategy not clear
- [ ] Deployment target not specified
```

## Error Handling

### Repository Not Found
**Error:** `Unable to scan repository`

**Solutions:**
- Verify current directory is project root
- Check read permissions
- Ensure .git directory exists (for git repos)

```bash
# Check current directory
pwd

# Retry from correct location
cd /path/to/project
/init from repo
```

### Insufficient Information
**Warning:** `Limited information available, brain may be incomplete`

**Actions:**
- Review UNKNOWNS.md
- Answer critical questions
- Provide additional context
- Run `/init from notes:` with more documentation

### Parsing Error
**Error:** `Failed to parse [source]`

**Solutions:**
- Validate source format
- Check file accessibility
- Review error details
- Try alternative source

```bash
# If notes parsing fails
/init from idea: [summarize notes content]
```

## Best Practices

### 1. Prepare Before Init
```bash
# Ensure repo is clean
git status

# Have documentation ready
ls docs/

# Run from project root
/init from repo
```

### 2. Combine Sources
```bash
# Start with repo
/init from repo

# Enhance with notes
# Manually merge docs/planning.md into .ai/context/

# Update unknowns
# Edit the open-questions section in .ai/context/PRD.md
```

### 3. Answer Questions Promptly
```bash
# Init will ask questions
/init from idea: Social network for developers

# Provide clear answers
# Q1: Expected scale? 
# A: 10K users initially

# Q2: Authentication?
# A: OAuth + JWT

# Q3: Real-time features?
# A: Yes, WebSocket for chat
```

### 4. Review Generated Context
```bash
# After init, review all files
ls .ai/context/

# Verify accuracy
cat .ai/context/ARCHITECTURE.md

# Fill unknowns
vim .ai/context/PRD.md  # open-questions section
```

### 5. Validate with Sync
```bash
# After initialization
/init from repo

# Validate consistency
/sync

# Should show: "System initialized, in sync"
```

## Common Workflows

### New Project from Scratch
```bash
# 1. Define idea
/init from idea: Task management with AI prioritization

# 2. Answer questions (max 3)
# [Respond to prompts]

# 3. Review context
cat .ai/context/PRD.md

# 4. Warm cache
/cache update

# 5. Begin development
# Ready to start coding
```

### Onboarding to Existing Project
```bash
# 1. Clone repository
git clone [repo-url]
cd project

# 2. Initialize context
/init from repo

# 3. Review extracted knowledge
ls .ai/context/

# 4. Check unknowns
cat .ai/context/PRD.md  # open-questions section

# 5. Validate
/sync
```

### Hybrid Initialization
```bash
# 1. Start with repo
/init from repo

# 2. Review unknowns
cat .ai/context/PRD.md  # open-questions section

# 3. Supplement with documentation
# Manually add docs/architecture.md insights to .ai/context/

# 4. Re-sync
/sync

# 5. Update cache
/cache update
```

## Performance Considerations

### Large Repositories
- Init may take 2-5 minutes for repos > 100K LOC
- Progress indicators will show scanning status
- Cache warming happens in background

### Optimization Tips
```bash
# Exclude large directories
echo "node_modules/\ndist/\nbuild/" > .aiignore

# Then initialize
/init from repo
```

### Resource Usage
- Memory: ~200-500MB during scan
- Disk: Creates 1-5MB of brain files
- Network: None (local only)

## Integration with Other Commands

```bash
# Complete initialization workflow
/init from repo        # Initialize brain
/cache update         # Warm cache
/sync                 # Verify consistency

# Before starting work
/init from notes: sprint-planning.md
/parallel build checkout  # Setup parallel work

# Mid-project enhancement
/init from idea: Add real-time notifications
# Merge with existing brain manually
```

## Troubleshooting

### Incomplete Brain
**Symptom:** Many UNKNOWNS, sparse architecture

**Solution:**
```bash
# Provide more context
/init from notes: docs/*.md

# Or answer questions interactively
# Review and fill gaps manually
```

### Incorrect Tech Stack Detection
**Symptom:** Wrong frameworks identified

**Solution:**
```bash
# Edit context manually
vim .ai/context/ARCHITECTURE.md

# Or re-init with notes
/init from notes: docs/tech-stack.md
```

### Init Hangs
**Symptom:** Process stuck during scanning

**Solution:**
```bash
# Cancel (Ctrl+C)
# Add .aiignore
echo "large-data-folder/" > .aiignore

# Retry
/init from repo
```

## Related Commands

- `/sync` - Validate brain consistency after init
- `/cache update` - Warm cache with initialized brain
- `/parallel` - Use initialized brain for parallel work
- `agents/architect.md` - Uses brain for architecture decisions
