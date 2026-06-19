# Context Documentation

This folder contains the **approved project context** - the single source of truth for project understanding, architecture, and implementation plans.

---

## Overview

The context folder provides structured documentation that guides both human developers and AI agents throughout the project lifecycle. All major decisions, requirements, and architectural choices are captured here.

**⚠️ Important:** Do not treat draft documents as approved. Only implement based on approved context.

---

## Core Files

### 📋 [PROJECT.md](./PROJECT.md)
**Purpose:** Project identity, vision, and strategic context

**Contains:**
- Project name, vision, and goals
- Problem statement and opportunity
- Target users and personas
- Core use cases
- Scope and boundaries
- Business rules and constraints
- Success metrics

**When to use:**
- Starting a new project
- Onboarding team members
- Making strategic decisions
- Evaluating scope changes

---

### 📦 [PRD.md](./PRD.md)
**Purpose:** Product Requirements Document - detailed feature specifications

**Contains:**
- User stories with acceptance criteria
- Feature descriptions and flows
- Functional and non-functional requirements
- Edge cases and error handling
- Success metrics and KPIs
- Timeline and milestones

**When to use:**
- Planning new features
- Writing implementation plans
- Conducting design reviews
- Validating completeness

---

### 🏗️ [ARCHITECTURE.md](./ARCHITECTURE.md)
**Purpose:** System architecture and technical design

**Contains:**
- Architecture overview and patterns
- Tech stack decisions
- System diagrams (component, deployment)
- Module boundaries and interfaces
- Data flow and API design
- Database models
- Security model
- Performance and scalability considerations

**When to use:**
- Making technology choices
- Designing new components
- Reviewing system integration
- Troubleshooting architectural issues

---

### 🔨 [IMPLEMENTATION.md](./IMPLEMENTATION.md)
**Purpose:** Detailed implementation plan for approved features

**Contains:**
- Implementation strategy and phases
- File plan (new, modified, deleted)
- Modular code organization
- Test strategy and cases
- Migration and rollback plans
- Risk assessment
- Timeline and approval status

**When to use:**
- Before starting implementation
- Planning code changes
- Estimating effort
- Reviewing implementation approach

---

### 🎯 [DECISIONS.md](./DECISIONS.md)
**Purpose:** Architecture Decision Records (ADRs)

**Contains:**
- Context for each decision
- Decision rationale
- Alternatives considered
- Consequences and tradeoffs
- Implementation notes

**When to use:**
- Making significant technical decisions
- Understanding past choices
- Evaluating new alternatives
- Onboarding new team members

---

### 📚 [CONTEXT.md](./CONTEXT.md)
**Purpose:** Domain glossary - the project's ubiquitous language

**Contains:**
- Domain-specific terms and definitions
- Preferred terms with `_Avoid_` alternatives
- Ambiguity flags where a term has multiple meanings

**When to use:**
- Clarifying fuzzy requirements during `/design`
- Ensuring consistent terminology in code and docs
- Onboarding to the project's vocabulary

**See also:** [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) (writing guide) and [CONTEXT-MAP.md](./CONTEXT-MAP.md) (multi-context projects)

---

### 📝 [CHANGELOG.md](./CHANGELOG.md)
**Purpose:** Project change history

**Contains:**
- Version history
- Feature additions
- Bug fixes
- Breaking changes
- Migration notes

**When to use:**
- Before releases
- Tracking project evolution
- Writing release notes
- Debugging production issues

---

### ⚙️ [manifest.json](./manifest.json)
**Purpose:** Context metadata and approval tracking (canonical)

**Contains:**
- `name` and `version` - project identity
- `context_version` - integer, bumped by `/sync`
- `last_sync` - ISO-8601 timestamp or null
- `approvals` - per-document approved true/false
- `files` - tracked context files

See [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md#manifestjson-schema) for the full schema.

**When to use:**
- Checking approval status
- Version tracking
- Workflow automation

---

### 🗂️ [docs/adr/](./docs/adr/)
**Purpose:** Architecture Decision Records (canonical ADR location)

**Contains:**
- Individual ADR files named `NNNN-slug.md`
- [ADR-FORMAT.md](./docs/adr/ADR-FORMAT.md) - tight ADR format guide
- [README.md](./docs/adr/README.md) - when and how to create ADRs

**When to use:**
- Recording hard-to-reverse technical decisions
- Linking detailed ADRs from DECISIONS.md

---

## Document Status

Each document has a status indicator:

| Status | Meaning | Can Implement? |
|--------|---------|----------------|
| **Draft** | Work in progress | ❌ No |
| **Review** | Under review | ❌ No |
| **Approved** | Ready for implementation | ✅ Yes |
| **Deprecated** | No longer valid | ❌ No |

---

## Workflow

### 1. Project Initialization
```
PROJECT.md (Draft) → Review → Approved
```

### 2. Feature Planning
```
PRD.md (Draft) → Review → Approved
↓
ARCHITECTURE.md (Draft) → Review → Approved
↓
IMPLEMENTATION.md (Draft) → Review → Approved
```

### 3. Implementation
```
Follow IMPLEMENTATION.md
↓
Update CHANGELOG.md
↓
Update DECISIONS.md (if applicable)
```

### 4. Post-Implementation
```
Update context if core understanding changes
↓
Mark IMPLEMENTATION.md as Complete
↓
Archive or create new IMPLEMENTATION.md for next feature
```

---

## Rules

### ✅ Do

- **Keep context up-to-date:** Update when implementation reveals new understanding
- **Link documents:** Cross-reference related decisions and requirements
- **Be specific:** Avoid vague statements like "TBD" in approved docs
- **Version control:** Track changes in CHANGELOG.md
- **Seek approval:** Get human approval before marking as "Approved"

### ❌ Don't

- **Don't implement from drafts:** Only approved documents are implementation-ready
- **Don't skip documentation:** All significant changes require context updates
- **Don't duplicate information:** Link to other docs instead of repeating
- **Don't leave orphaned decisions:** Update DECISIONS.md when context changes
- **Don't assume approval:** Explicit human approval is required

---

## Context Update Triggers

Update context documentation when:

- ✅ Core project understanding changes
- ✅ Architecture decisions are made
- ✅ New features are planned
- ✅ Significant implementation changes occur
- ✅ Business rules change
- ✅ Performance requirements change
- ✅ Security model evolves

---

## Best Practices

### For Humans

1. **Review regularly:** Keep context aligned with reality
2. **Approve explicitly:** Use manifest.json to track approval
3. **Communicate changes:** Update CHANGELOG.md for visibility
4. **Validate completeness:** Use checklists in each document
5. **Archive old versions:** Move superseded docs to archive

### For AI Agents

1. **Check status first:** Only implement from approved documents
2. **Follow links:** Read related documents for full context
3. **Ask when unclear:** Request human clarification for ambiguities
4. **Propose updates:** Suggest context changes when implementation reveals gaps
5. **Respect boundaries:** Don't make architectural decisions without approval

---

## Integration with Workflow

### With `.ai/agents/`
Agents read context files to understand:
- What to build (PRD.md)
- How to build it (ARCHITECTURE.md, IMPLEMENTATION.md)
- Why decisions were made (DECISIONS.md)

### With `.ai/state/`
Context provides the "what should be" while state tracks "what is":
- Context = approved plan
- State = current progress

### With `.ai/memory/`
Memory stores interaction history and decisions that feed into context updates.

---

## Troubleshooting

### Problem: Context is outdated
**Solution:** Schedule regular context reviews, especially after major changes

### Problem: Duplicate information across files
**Solution:** Use links and references; keep each file focused on its purpose

### Problem: Implementation deviates from context
**Solution:** Either update context or fix implementation - never let them diverge

### Problem: Unclear approval status
**Solution:** Check manifest.json and document headers for explicit approval

---

## Quick Reference

| Need | File | Section |
|------|------|---------|
| Project purpose | PROJECT.md | Vision, Problem |
| Feature requirements | PRD.md | User Stories, Features |
| System design | ARCHITECTURE.md | Architecture Summary, Diagrams |
| Tech stack | ARCHITECTURE.md | Tech Stack |
| Implementation steps | IMPLEMENTATION.md | Implementation Strategy |
| Past decisions | DECISIONS.md | All ADRs |
| Detailed ADRs | docs/adr/ | `NNNN-slug.md` files |
| Domain vocabulary | CONTEXT.md | Language |
| Change history | CHANGELOG.md | Version entries |
| Approval status | manifest.json | `approvals` object |

---

## Related Documentation

- **[`.ai/boot/BOOT.md`](../boot/BOOT.md)** - Workflow initialization
- **[`.ai/state/STATUS.md`](../state/STATUS.md)** - Current project status
- **[`.ai/memory/`](../memory/)** - Session history and decisions
- **[`.ai/workflows/`](../workflows/)** - Process guides

---

## Maintenance

### Regular Tasks

- [ ] **Weekly:** Review open questions in all docs
- [ ] **Before each sprint:** Validate PRD and IMPLEMENTATION alignment
- [ ] **After major changes:** Update ARCHITECTURE and DECISIONS
- [ ] **Before releases:** Update CHANGELOG
- [ ] **Monthly:** Archive completed/deprecated content

### Ownership

| Document | Primary Owner | Reviewers |
|----------|---------------|-----------|
| PROJECT.md | Product Owner | All stakeholders |
| PRD.md | Product Manager | Tech Lead, Designer |
| ARCHITECTURE.md | Architect/Tech Lead | Engineers |
| IMPLEMENTATION.md | Lead Engineer | Team members |
| DECISIONS.md | Architect | Engineering team |
| CHANGELOG.md | Release Manager | All contributors |

---

## Version

**Context Schema Version:** 1.0  
**Last Updated:** Check individual file headers  
**Maintained By:** Project team

---

**Questions?** Refer to `.ai/workflows/` for detailed process guides or consult with the project owner.
