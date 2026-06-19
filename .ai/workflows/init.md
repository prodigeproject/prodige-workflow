# Workflow: Init

## Purpose
Initialize project context by analyzing repository, idea, or notes to build foundational context for the AI system. Creates structured knowledge base under `.ai/context/` without code generation.

**Core principle:** Evidence-based initialization. Extract what exists, mark what doesn't, ask only critical questions.

---

## Prerequisites
- Access to project source (repository, documentation, or idea description)
- Write permissions to `.ai/` directory
- Understanding of initialization mode (repo/idea/notes)

## Step-by-Step Instructions

### 1. Determine Initialization Mode

**Identify source type:**

**Mode: Repository**
- Existing codebase available
- Directory structure accessible
- Files can be scanned

**Mode: Idea**
- New project concept
- No code exists yet
- Starting from description

**Mode: Notes**
- Planning documents available
- Requirements documented
- Design artifacts exist

**Select appropriate mode based on project state.**

**Skill:** Context assessment

### 2. Gather Evidence from Source

**For Repository Mode:**
- Scan directory structure recursively
- Read package.json/requirements.txt/pom.xml
- Parse README.md and documentation files
- Identify entry points (main.js, index.html, app.py)
- Check .git for history patterns
- Review configuration files

**For Idea Mode:**
- Parse idea description carefully
- Extract explicit requirements
- Identify domain keywords
- Note technical hints (if any)
- Record constraints mentioned

**For Notes Mode:**
- Read all provided documents
- Extract structured information
- Consolidate overlapping content
- Note contradictions
- Build unified view

**Rule:** Only use available information. No invention.

### 3. Analyze Tech Stack and Architecture

**Extract technical details:**

**Tech Stack Identification:**
- Programming languages (from file extensions, manifests)
- Frameworks (from dependencies, imports)
- Database systems (from config, dependencies)
- Build tools (from scripts, config files)
- Testing frameworks (from dev dependencies)

**Architecture Pattern Recognition:**
- Monolith vs. Microservices (from structure)
- Frontend/Backend separation (from directories)
- API style (REST/GraphQL from routes, schema)
- Data access patterns (from code organization)
- State management (from library usage)

**Mark UNKNOWN for unclear items:**
```markdown
## Tech Stack
- Language: TypeScript ✓
- Framework: React ✓
- Backend: [UNKNOWN - no server code found]
- Database: PostgreSQL ✓
- Authentication: [UNKNOWN - needs clarification]
```

**Skill:** Technology pattern recognition

### 4. Map Component Relationships

**Build mental model of system structure:**

**Identify:**
- Entry points and initialization flow
- Module boundaries and dependencies
- Data flow direction
- External integrations
- Shared utilities

**Create component map:**
```
Frontend (React)
  ├── Components/
  ├── Services/ → API Client
  └── State/ → Redux Store

Backend (Node.js)
  ├── Routes/
  ├── Controllers/
  ├── Services/
  ├── Models/ → Database
  └── Middleware/
```

**For Idea/Notes mode:** Create proposed structure with `[PROPOSED]` markers.

### 5. Fill Context Scaffold

**Create structured context files (all under `.ai/context/`):**

Produce the full canonical context set: `PROJECT.md`, `PRD.md`, `ARCHITECTURE.md`,
`IMPLEMENTATION.md`, `DECISIONS.md`, `CONTEXT.md`, `CHANGELOG.md`, and `manifest.json`.
Create only what evidence supports; scaffold the rest with `[UNKNOWN]` markers.

**`.ai/context/manifest.json`** — context index with canonical schema fields:
- `schema_version` (string)
- `context_version` (integer, starts at 1)
- `last_sync` (ISO 8601 timestamp)

**`.ai/context/ARCHITECTURE.md`** — single architecture/tech source of truth, organized into sections:

**Architecture section**
- System type (monolith, microservices, serverless)
- Component structure
- Integration points
- Design patterns identified

**Tech Stack section**
- Languages and versions
- Frameworks and libraries
- Build and deployment tools
- Development dependencies

**Dependencies section**
- Production dependencies with purposes
- Development dependencies
- Peer dependencies
- Vulnerability notes (if any)

**Patterns section**
- Code organization patterns
- Naming conventions observed
- Error handling approach
- Testing patterns

**`.ai/state/CURRENT.md`**
- Initialization timestamp
- Source mode used
- Completeness assessment
- Verification status

**Also scaffold the remaining canonical state files:**
- `.ai/state/SPRINT.md` — active sprint scope and goals (empty/initial sprint)
- `.ai/state/BACKLOG.md` — outstanding work items (seed from unknowns/next steps)
- `.ai/state/STATUS.md` — project status snapshot

**Rule:** Every statement must trace to evidence. Use `[UNKNOWN]` liberally.

### 6. Mark Unknowns Explicitly

**Record gaps as an "Open Questions" section in `.ai/context/PRD.md`:**

**Categorize by priority:**

**HIGH Priority (Blocking):**
- Missing core architecture decisions
- Unclear deployment strategy
- Unknown authentication mechanism

**MEDIUM Priority (Important):**
- Incomplete error handling approach
- Unclear scaling strategy
- Missing testing strategy

**LOW Priority (Nice to know):**
- Style guide preferences
- Documentation standards

**Format:**
```markdown
## HIGH Priority

### Authentication Strategy
- **Status:** Unknown
- **Impact:** Core security implementation blocked
- **Evidence:** No auth code found, no docs mention
- **Discovery method:** Ask stakeholder OR review requirements

## MEDIUM Priority

### Error Handling Pattern
- **Status:** Inconsistent
- **Impact:** Code quality concern
- **Evidence:** Some files use try-catch, others don't
- **Discovery method:** Code review OR establish standard
```

### 7. Identify Critical Questions

**Generate maximum 3 critical questions for human clarification:**

**Question Selection Criteria:**
- HIGH priority unknowns only
- Answers unblock significant work
- Cannot be inferred from evidence
- Has multiple valid interpretations

**Question Format:**
```markdown
## Critical Questions (Requires Human Input)

**Q1: What is the target deployment environment?**
- Options: Cloud (AWS/GCP/Azure), On-premise, Hybrid
- Impact: Determines infrastructure decisions
- Blocking: Architecture design, DevOps setup

**Q2: What is the expected user scale?**
- Options: < 1K users, 1K-10K, 10K-100K, > 100K
- Impact: Database choice, caching strategy, architecture
- Blocking: Performance requirements, tech stack validation

**Q3: Is real-time functionality required?**
- Options: Yes (WebSocket/SSE), No (REST only)
- Impact: Backend architecture, client-state management
- Blocking: Technology selection, protocol design
```

**Rule:** Ask only what's critical. Everything else goes in the PRD "Open Questions" section.

**Skill:** `clean-code` (Thinking before doing - asking right questions)

### 8. Create Initial State Document

**Generate `.ai/state/CURRENT.md`:**

```markdown
# Current State

**Initialized:** [timestamp]
**Mode:** [repo/idea/notes]
**Source:** [path or description]

## Completeness Assessment

- Architecture: [Complete / Partial / Unknown]
- Tech Stack: [Complete / Partial / Unknown]
- Dependencies: [Complete / Partial / Unknown]
- Unknowns documented: [Yes / No]
- Questions asked: [0-3]

## Initial Status

**Project Type:** [Web App / API / Library / CLI / Mobile / etc.]
**Maturity:** [New / Prototype / Active Development / Production / Maintenance]
**Code Size:** [lines of code estimate]
**Documentation Quality:** [Good / Fair / Poor / None]

## Next Steps

1. [Action based on mode]
2. [Action based on unknowns]
3. [Action based on questions]
```

### 9. Warm Initial Cache

**Create cache with extracted knowledge:**

**Cache repository map:**
```bash
# Generate file tree
# Record module structure
# Index key files
```

**Cache architecture summary:**
- Component relationships
- Entry points
- Key abstractions
- Integration points

**Cache tech stack:**
- Dependencies quick reference
- Framework patterns
- Common utilities

**Output:** `.ai/runtime/cache/` populated with structured data.

**Skill:** Cache management

### 10. Validate No Code Generation

**CRITICAL CHECK before completion:**

**Verify:**
- [ ] No .js, .ts, .py, .java files created
- [ ] No code snippets generated in context files
- [ ] No implementation suggestions embedded
- [ ] Only analysis and documentation created

**Exception:** Example structure diagrams in markdown are OK.

**Rule:** Init phase is analysis only. Code comes in Build phase.

### 11. Create Initialization Report

**Generate summary for human review:**

```markdown
# Initialization Complete

**Mode:** Repository Analysis
**Duration:** [time]
**Files Scanned:** [count]
**Context Files Created:** [count]

## What We Learned

### Tech Stack
[Summary of identified technologies]

### Architecture
[Brief architecture description]

### Patterns
[Key patterns identified]

## Confidence Levels

- Tech Stack: ████████░░ 80%
- Architecture: ██████░░░░ 60%
- Dependencies: ██████████ 100%

## Unknowns Identified

- HIGH priority: [count]
- MEDIUM priority: [count]
- LOW priority: [count]

## Critical Questions

[List 0-3 questions or "None - sufficient context available"]

## Next Steps

1. Review `.ai/context/` files for accuracy
2. Answer critical questions (if any)
3. Run `/sync` to validate consistency
4. Run `/cache update` to refresh cache
5. Ready for `/design` or `/build`
```

### 12. Create Next Actions Recommendation

**Based on initialization results, suggest workflow:**

**If High Unknowns + Critical Questions:**
```
Recommended: Answer questions first, then /design
```

**If Complete Context from Repo:**
```
Recommended: /sync to validate, then /build
```

**If Idea Mode:**
```
Recommended: /design to create PRD and architecture
```

**If Notes Mode:**
```
Recommended: Review context accuracy, then /design or /build
```

---

## Output Structure

```
.ai/context/
├── PROJECT.md           # Project identity, vision, stakeholders
├── PRD.md               # Requirements, constraints, concept, and Open Questions (gaps)
├── ARCHITECTURE.md      # System architecture + tech stack + dependencies + patterns
├── IMPLEMENTATION.md    # Technical implementation plan
├── DECISIONS.md         # Architectural decisions discovered
├── CONTEXT.md           # Domain glossary and key terms
├── CHANGELOG.md         # Notable changes log
└── manifest.json        # schema_version, context_version (int), last_sync (ISO)

.ai/state/
├── CURRENT.md           # Initialization / current state
├── SPRINT.md            # Active sprint scope and goals
├── BACKLOG.md           # Outstanding work items
└── STATUS.md            # Project status snapshot

.ai/runtime/cache/
└── [initialized cache entries]
```

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Evidence-based** | Only use discoverable facts | Every statement traces to source |
| **Mark unknowns** | Explicit about gaps | PRD "Open Questions" is comprehensive |
| **Limited questions** | Ask only critical items | Max 3 questions |
| **No invention** | No assumptions without marking | No `[UNKNOWN]` missing |
| **Analysis only** | No code generation | No implementation files created |

---

## Red Flags - STOP

- Generated code files during init
- Made up technical details without evidence
- Skipped PRD "Open Questions" creation
- Asked more than 3 questions
- Created implementation suggestions
- Assumed architecture without evidence

**If you see these:** STOP. Review init principles. Restart workflow.

---

## Integration Points

**Skills:**
- `clean-code` - Think before coding, ask questions (Step 7)
- Repository scanning patterns
- Cache management (Step 9)

**Commands:**
- `/init` - Triggers this workflow
- `/sync` - Follow-up validation
- `/cache` - Cache management

**Next Workflows:**
- `design.md` - For new projects or incomplete context
- `build.md` - For projects with complete context
- `sync.md` - Validate initialization accuracy

**Agents:**
- `architect` - May use context for decisions
- `orchestrator` - Routes based on init results

---

## Common Workflows

### New Project (Idea Mode)
```
/init from idea → Answer questions → /design → /build
```

### Existing Project (Repo Mode)
```
/init from repo → /sync → /build
```

### Documentation-Heavy (Notes Mode)
```
/init from notes → Review context → /design (if needed) → /build
```

---

**Remember:** Init is foundation. Quality here determines quality everywhere else. Take time to be thorough.
