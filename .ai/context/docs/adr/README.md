# Architecture Decision Records (ADRs)

**A lightweight record of significant architectural decisions.**

---

## What are ADRs?

**Architecture Decision Records** document important technical choices made during the project. They answer "Why did we choose X over Y?" for future team members (including future you).

**Format**: 1-3 sentences minimum. [See ADR-FORMAT.md](./ADR-FORMAT.md) for details.

---

## Purpose

### For Humans
- **Onboarding**: New team members understand context
- **Maintenance**: Remember why decisions were made
- **Refactoring**: Know which constraints still apply
- **Avoiding rework**: Don't revisit settled decisions

### For Agents
- **Implementation guidance**: Follow established patterns
- **Decision validation**: Check if new choices align with ADRs
- **Context awareness**: Understand project constraints
- **Recommendation**: Suggest ADR creation when criteria met

---

## When to Create an ADR

**All three criteria must be true**:

1. **Hard to reverse** - Meaningful cost to change later
2. **Surprising** - Future reader will wonder "why this way?"
3. **Real trade-off** - Genuine alternatives existed

**Examples that qualify**:
- Database choice (PostgreSQL vs MongoDB)
- Architecture pattern (event sourcing vs CRUD)
- Deployment target (AWS vs GCP vs on-premises)
- Integration pattern (REST vs GraphQL vs gRPC)

**Examples that don't qualify**:
- Library choice (easy to swap)
- Code style (automated)
- File organization (easily refactored)
- Naming conventions (low cost to change)

[See ADR-FORMAT.md](./ADR-FORMAT.md) for complete criteria.

---

## Structure

### File Location
```
.ai/context/docs/adr/
├── README.md           ← This file
├── ADR-FORMAT.md       ← Format guide
├── 0001-*.md           ← First ADR
├── 0002-*.md           ← Second ADR
└── NNNN-*.md           ← Nth ADR
```

### File Naming
```
NNNN-short-slug.md

Examples:
0001-use-postgresql.md
0002-event-sourcing-for-orders.md
0003-monorepo-structure.md
```

**Sequential numbering** - Scan directory for highest number, increment.

---

## Minimal ADR Example

```markdown
# Use PostgreSQL for Primary Database

We need ACID transactions and complex queries for order processing.
PostgreSQL provides mature tooling, strong consistency, and good
performance for our scale. MongoDB was considered but rejected
due to transaction limitations across collections.
```

**That's a complete ADR.** Context, decision, why. Done.

---

## Creating an ADR

### Quick Process

1. **Recognize** architectural decision point
2. **Check** 3 criteria (hard to reverse + surprising + trade-off)
3. **Scan** `.ai/context/docs/adr/` for highest number
4. **Create** `NNNN-slug.md` (increment number)
5. **Write** 1-3 sentences: context, decision, why
6. **Commit** with the implementation

### Agent Workflow

```
Agent: "This is an architectural decision. Checking ADR criteria..."
Agent: "✓ Hard to reverse ✓ Surprising ✓ Trade-off"
Agent: "Should I create ADR-0005 for this?"
User: "Yes"
Agent: *Creates .ai/context/docs/adr/0005-decision-slug.md*
```

### Lazy Creation

**Create ADRs when needed, not upfront.**

Don't:
```
Day 1: "Let's write ADRs for all possible decisions"
→ Creates 50 empty ADRs
→ Most never filled out
→ ADR system abandoned
```

Do:
```
Day 15: "We're choosing PostgreSQL. ADR criteria met."
→ Create ADR-0001-use-postgresql.md
→ 3 sentences, done

Day 42: "Event sourcing for orders. ADR criteria met."
→ Create ADR-0002-event-sourcing-orders.md
→ 3 sentences, done
```

**Start when needed. Grow organically.**

---

## What Belongs in ADRs

### Architecture Shape
- **Monorepo vs polyrepo**
- **Microservices vs monolith**
- **Layered vs hexagonal architecture**

### Technology Lock-In
- **Database** (PostgreSQL, MongoDB, etc.)
- **Message bus** (RabbitMQ, Kafka, etc.)
- **Cloud provider** (AWS, GCP, Azure)
- **Auth system** (Auth0, Cognito, custom)

### Integration Patterns
- **Event-driven vs REST**
- **Sync vs async communication**
- **Shared database vs separate stores**

### Boundary Decisions
- **Context ownership** (who owns what data)
- **API contracts** (public interfaces)
- **Shared vs isolated state**

### Deliberate Deviations
- **Manual SQL instead of ORM** (performance)
- **REST instead of GraphQL** (simplicity)
- **Synchronous despite scale** (consistency)

### Non-Code Constraints
- **Compliance requirements** (on-premises only)
- **Performance SLAs** (<200ms response)
- **Partner contracts** (specific formats)

---

## What Doesn't Belong

### Easy to Reverse
- Folder structure
- Naming conventions
- Code style choices
- Utility libraries

### Not Surprising
- Using Git for version control
- Using TypeScript for new project
- Following REST conventions
- Using HTTPS for security

### No Real Alternative
- Validating user inputs
- Handling errors gracefully
- Writing tests
- Using secure authentication

**If you can change it in a day without breaking things, skip the ADR.**

---

## Status Lifecycle

```
[proposed] → accepted → [deprecated/superseded]

proposed:    Under discussion (optional, most skip this)
accepted:    Active decision, currently followed
deprecated:  No longer relevant (context changed)
superseded:  Replaced by newer decision (ADR-NNNN)
```

### Updating Status

```yaml
---
status: superseded by ADR-0042
---

# Old Decision

[Original content preserved for history]
```

**Don't delete old ADRs.** Update status, link to replacement.

---

## Integration with Prodige

### During `/design`

```
Architect: "We'll use event sourcing for orders"
Agent: "This meets ADR criteria. Create ADR-0002?"
Human: "Yes"
Agent: *Creates ADR, records in DECISIONS.md*
```

### During `/build`

```
Backend: "Implementing order creation"
Agent: *Checks ADR-0002-event-sourcing-orders.md*
Agent: "Following event sourcing pattern per ADR-0002"
```

### During `/review`

```
Reviewer: "Why are we not using ORM here?"
Agent: *Checks ADR-0004-manual-sql.md*
Agent: "Per ADR-0004, manual SQL for performance"
```

---

## Relationship to Other Docs

| Document | Purpose | Audience | Updates |
|----------|---------|----------|---------|
| **ADRs** | Architecture decisions | Technical team | Lazy, criteria-driven |
| **DECISIONS.md** | Team decisions | All stakeholders | During /design (HITL) |
| **decisionLog.md** | AI memory | Agent sessions | Real-time, inline |
| **ARCHITECTURE.md** | System structure | Technical team | When architecture evolves |
| **CONTEXT.md** | Domain vocabulary | Everyone | When terms clarified |

**ADRs focus on WHY** (architectural choices and constraints).  
**ARCHITECTURE.md focuses on WHAT** (current system structure).

> `DECISIONS.md` is the index/log of decisions; the full ADRs live here as individual files in `.ai/context/docs/adr/`. Log the high-level decision in `DECISIONS.md` and link to the detailed ADR.

---

## Examples

### Example 1: Database Choice

```markdown
# Use PostgreSQL for Primary Database

We need ACID transactions and complex queries. PostgreSQL provides
mature tooling and strong consistency. MongoDB was considered but
lacks strong transactions across collections.
```

### Example 2: Event Sourcing

```markdown
# Event Source Order Context

Orders are event-sourced to provide complete audit trail and enable
event-driven integration with Fulfillment. Trade-off: more complex
than CRUD, but audit requirements are critical.
```

### Example 3: Monorepo

```markdown
# Monorepo Structure

All services in one repo for easier cross-service changes and shared
code management. Polyrepo was considered but rejected for our team
size (5 devs) and frequent cross-cutting work.
```

### Example 4: Integration Pattern

```markdown
# Event-Driven Between Ordering and Fulfillment

Services communicate via RabbitMQ events (not synchronous HTTP).
Enables loose coupling and async processing. Trade-off: eventual
consistency, but acceptable for our use case.
```

### Example 5: Deliberate Deviation

```markdown
# Manual SQL Instead of ORM

Using raw SQL for complex reports. ORM generates inefficient queries
and hides performance issues. Trade-off: more code to maintain, but
10x faster queries and easier optimization.
```

---

## Maintenance

### Review Cadence

**Quarterly** (or during architecture reviews):
- Are decisions still valid?
- Any deprecated due to changed context?
- Any superseded by newer decisions?
- Update statuses

### Updating ADRs

**When decision changes**:
1. Create new ADR with updated decision
2. Mark old ADR status: `superseded by ADR-NNNN`
3. Link old ↔ new for traceability

**Don't edit old ADRs** - preserve history. It's valuable to see thinking evolution.

### Cleaning Up

**Don't delete**:
- Old ADRs (even superseded) - history is valuable
- Deprecated ADRs - context is still useful

**Do update**:
- Status frontmatter
- Links to superseding ADRs
- Add learnings in new ADR

---

## Getting Started

### Step 1: Create Directory

```bash
mkdir -p .ai/context/docs/adr
```

**Lazy creation**: Only create when first ADR is needed.

### Step 2: First ADR

When you make first ADR-worthy decision:

```bash
# Create ADR-0001
.ai/context/docs/adr/0001-your-first-decision.md

# Content:
# Your First Decision
Context, decision, why. (1-3 sentences)
```

### Step 3: Let It Grow

**Don't force it.** Create ADRs when:
- Making hard-to-reverse decision
- Future reader will wonder "why?"
- Trade-offs were considered

**Over time**, ADRs accumulate naturally as project evolves.

---

## Common Questions

### "How many ADRs should we have?"

**No target number.** Some projects have 5 ADRs after 2 years. Some have 50. Both are fine.

**Create when criteria met, not to hit a quota.**

### "Should we create ADRs for all past decisions?"

**No.** Start from now. Document future decisions.

**Exception**: If past decision is being questioned, create ADR then to capture context.

### "Can ADRs be updated?"

**Only status.** Don't edit content - it's historical record.

**If decision changes**: Create new ADR, mark old as superseded.

### "What if decision was wrong?"

**Create new ADR** explaining what was learned and new decision.

**Mark old as superseded.** Seeing evolution of thinking is valuable.

### "How detailed should ADRs be?"

**Start minimal** (1-3 sentences). Add optional sections (Consequences, Options) only if they add value.

**Most ADRs are 3-5 sentences.** That's perfect.

---

## Anti-Patterns

### ❌ Documenting Everything

```
ADR-0042: Use camelCase for variables
ADR-0043: Put tests in __tests__ folder
ADR-0044: Use Prettier for formatting
```

**Problem**: None meet 3 criteria. Just noise.

### ❌ Writing Essays

```markdown
# Use PostgreSQL

After extensive research spanning multiple months...
[15 paragraphs]
...therefore PostgreSQL.
```

**Problem**: Too long. Keep it 1-3 sentences.

### ❌ No Trade-Offs

```markdown
# Use Microservices

Microservices are better for scalability.
```

**Problem**: Missing trade-off (complexity, distributed debugging).

### ❌ Filling Templates

```markdown
## Context
[Empty]

## Decision
[Empty]

## Consequences
[Empty]
```

**Problem**: Template-driven. Write prose instead.

---

## Success Metrics

**Good ADR system**:
- New team members understand architectural context quickly
- Old decisions aren't revisited unnecessarily
- Implementation aligns with documented choices
- ADRs actually get created (not abandoned)

**Signs of success**:
- "Check ADR-0005" in code reviews
- New members read ADRs during onboarding
- Debates reference existing ADRs
- ADRs get created regularly (not upfront batch)

**Signs of failure**:
- No ADRs created in 6 months (too high barrier)
- 50 empty ADR templates (premature documentation)
- No one reads them (too verbose or unclear)
- Decisions made that contradict ADRs (not integrated)

---

## The Bottom Line

```
Lightweight: 1-3 sentences minimum
Criteria-driven: Hard to reverse + Surprising + Trade-off
Lazy creation: Create when needed, not upfront
Preserve history: Don't delete, update status
Focus on WHY: Not HOW to implement
```

**ADRs are the architectural memory of your project. Keep them simple, create them lazily, and they'll serve you well.**

---

**See Also**: [ADR-FORMAT.md](./ADR-FORMAT.md) for detailed format guide  
**Created**: When first ADR is needed (lazy)  
**Updated**: When status changes or decisions superseded

