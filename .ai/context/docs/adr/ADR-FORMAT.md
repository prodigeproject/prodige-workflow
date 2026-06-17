# Architecture Decision Record (ADR) Format

**Tight format.** 1-3 sentences minimum. Value is in recording the decision exists, not filling sections.

---

## Template

```markdown
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

**That's it.** An ADR can be a single paragraph.

---

## File Location & Naming

**Location**: `docs/adr/`  
**Naming**: `NNNN-slug.md` (sequential numbering)

**Examples**:
- `0001-use-postgresql.md`
- `0002-event-sourcing-for-orders.md`
- `0003-monorepo-structure.md`

**Numbering**: Scan `docs/adr/` for highest existing number, increment by one.

---

## Minimal Example

```markdown
# Use PostgreSQL for Primary Database

We need ACID transactions and complex queries for order processing.
PostgreSQL provides mature tooling, strong consistency, and good
performance for our scale. MongoDB was considered but rejected
due to transaction limitations across collections.
```

**That's a complete ADR.** Context, decision, why. Done.

---

## Optional Sections

**Only add these when they provide genuine value.** Most ADRs won't need them.

### Status (Frontmatter)

```yaml
---
status: accepted
---

# Use PostgreSQL for Primary Database
```

**Possible statuses**:
- `proposed` - Under discussion
- `accepted` - Active decision
- `deprecated` - No longer relevant
- `superseded by ADR-NNNN` - Replaced by newer decision

**Use when**: Decisions are revisited or evolve over time.

### Considered Options

```markdown
# Use PostgreSQL for Primary Database

We need ACID transactions and complex queries. PostgreSQL provides
mature tooling and strong consistency.

## Considered Options

- **PostgreSQL**: ACID, complex queries, mature ✓ Chosen
- **MongoDB**: Flexible schema, but weak transactions
- **MySQL**: Good performance, but less feature-rich
```

**Use when**: Rejected alternatives are worth remembering (prevents reconsidering them).

### Consequences

```markdown
# Event Sourcing for Order Context

Orders are event-sourced to provide audit trail and enable
event-driven communication with Fulfillment context.

## Consequences

- **Positive**: Complete audit trail, replay capability, event-driven integration
- **Negative**: More complex than CRUD, requires event store infrastructure
- **Neutral**: Team needs training on event sourcing patterns
```

**Use when**: Non-obvious downstream effects need calling out.

---

## When to Create an ADR

**All three must be true**:

### 1. Hard to Reverse

Cost of changing your mind later is meaningful.

```
✅ ADR-worthy:
- Chose PostgreSQL over MongoDB (migration = weeks)
- Event-sourced order context (refactor = months)
- Monorepo structure (split = major effort)

❌ Not ADR-worthy:
- Chose lodash over ramda (swap = hours)
- Naming convention for tests (change anytime)
- Log format (easy to change)
```

### 2. Surprising Without Context

Future reader will wonder "why on earth did they do it this way?"

```
✅ ADR-worthy:
- Using manual SQL instead of ORM (surprising choice)
- REST instead of GraphQL (would expect GraphQL)
- Synchronous instead of async (unexpected for this scale)

❌ Not ADR-worthy:
- Using TypeScript (obvious for new projects)
- Using Express for Node.js API (standard choice)
- Using Git for version control (universal)
```

### 3. Result of Real Trade-Off

There were genuine alternatives, you picked one for specific reasons.

```
✅ ADR-worthy:
- PostgreSQL over MongoDB (real trade-offs)
- Event-driven over REST (architectural implications)
- Microservices over monolith (complexity vs scalability)

❌ Not ADR-worthy:
- Using JavaScript (no alternative for browser)
- Using HTTPS (security requirement, no choice)
- Following coding standards (team policy, not decision)
```

**If any of the three is false, skip the ADR.** Just do it and move on.

---

## What Qualifies for ADR

### Architecture Shape

```markdown
# Monorepo Structure

All services in one repo for easier cross-service changes and
shared code management. Considered polyrepo but chose monorepo
for our team size (5 devs) and frequent cross-service work.
```

### Integration Patterns

```markdown
# Event-Driven Communication Between Contexts

Ordering and Billing communicate via domain events (not HTTP).
Enables loose coupling and async processing. Trade-off: eventual
consistency and need for message bus infrastructure.
```

### Technology Lock-In

```markdown
# AWS as Cloud Provider

Deploying to AWS for managed services and team expertise.
Considered GCP but AWS has better managed RDS and team knows it.
Trade-off: vendor lock-in, but migration cost acceptable vs
productivity gain.
```

**Record**: Database, message bus, auth provider, deployment target  
**Skip**: Libraries (too easy to swap), utilities, dev tools

### Boundary Decisions

```markdown
# Customer Data Owned by Customer Context

Customer data (profiles, addresses) owned exclusively by Customer
context. Other contexts reference via CustomerId only. Prevents
coupling and data duplication. Trade-off: need to query Customer
API for customer details.
```

**The explicit no-s are as valuable as the yes-s.**

### Deliberate Deviations

```markdown
# Manual SQL Instead of ORM

Using raw SQL queries for complex reporting. ORM generates
inefficient queries and hides performance issues. Trade-off:
more code, but 10x faster queries and easier optimization.
```

**Anything where reasonable reader would assume opposite.**

### Non-Code Constraints

```markdown
# No AWS Services (Compliance)

Cannot use AWS due to customer compliance requirements mandating
on-premises deployment. Using self-hosted PostgreSQL, RabbitMQ,
and Redis. Trade-off: more operational overhead, but meets
compliance.
```

**Constraints not visible in code but affecting decisions.**

### Rejected Alternatives (When Non-Obvious)

```markdown
# REST Over GraphQL

Using REST API instead of GraphQL. Considered GraphQL but
rejected due to: (1) no need for flexible queries, (2) REST
simpler for mobile clients, (3) team knows REST better.
Trade-off: less flexible, but faster to ship.
```

**Prevents someone suggesting GraphQL again in 6 months.**

---

## What Doesn't Qualify

### Easy to Reverse

```
❌ Skip:
- Folder structure (reorganize anytime)
- Naming conventions (refactor easily)
- Code formatting (automated)
- Library choice (swap quickly)
```

### Not Surprising

```
❌ Skip:
- Using Git (universal)
- Using TypeScript (standard)
- Following REST conventions (expected)
- Using JWT for auth (common pattern)
```

### No Real Alternative

```
❌ Skip:
- Using HTTPS (security requirement)
- Validating inputs (best practice)
- Handling errors (necessary)
- Writing tests (mandatory)
```

---

## Example ADRs

### Minimal (Preferred)

```markdown
# Use Event Sourcing for Order Context

Orders are event-sourced to provide complete audit trail and
enable event-driven integration with Fulfillment. Trade-off:
more complexity than CRUD, but critical for our audit requirements.
```

### With Options

```markdown
# Monorepo Structure

All services in single repo for easier dependency management.

## Considered Options

- **Monorepo**: Easier cross-service changes ✓ Chosen
- **Polyrepo**: Better isolation, but harder coordination
- **Hybrid**: Complex, rejected
```

### With Status

```yaml
---
status: superseded by ADR-0042
---

# Use REST for All APIs

Using REST for all APIs for simplicity and team familiarity.

[Note: Superseded by ADR-0042 which introduces GraphQL for
mobile clients while keeping REST for internal services.]
```

### With Consequences

```markdown
# Event-Driven Communication

Services communicate via RabbitMQ events for loose coupling.

## Consequences

- **Positive**: Loose coupling, async processing, resilient
- **Negative**: Eventual consistency, need for idempotency
- **Neutral**: Requires RabbitMQ infrastructure
```

---

## Creating an ADR

### Agent Workflow

```
1. Recognize decision point (architecture, integration, tech)
2. Check 3 criteria: Hard to reverse? Surprising? Trade-off?
3. If all true, offer: "Should I create ADR for this decision?"
4. If yes:
   a. Scan docs/adr/ for highest number
   b. Create NNNN-slug.md (increment number)
   c. Write 1-3 sentence summary
   d. Add optional sections only if valuable
5. If no, proceed without ADR
```

### Human Workflow

```
1. Making architectural decision
2. Check: Is this ADR-worthy? (3 criteria)
3. If yes:
   a. Create docs/adr/NNNN-slug.md
   b. Write context, decision, why (1-3 sentences)
   c. Add optional sections if helpful
4. Commit with decision
```

---

## Numbering Convention

**Sequential**: `0001`, `0002`, `0003`, ...

**Padding**: 4 digits (supports 9999 ADRs - sufficient for any project)

**Find next number**:
```bash
# List existing ADRs
ls docs/adr/

# Output:
# 0001-use-postgresql.md
# 0002-event-sourcing.md
# 0003-monorepo.md

# Next number: 0004
```

**Don't skip numbers.** Even if ADR is superseded, keep it for history.

---

## Status Lifecycle

```
proposed → accepted → deprecated/superseded

proposed:    Under discussion, not yet implemented
accepted:    Active decision, currently in use
deprecated:  No longer relevant (context changed)
superseded:  Replaced by newer decision (link to new ADR)
```

**Most ADRs start as `accepted`** (skip `proposed` unless decision is contentious).

---

## Integration with Prodige

### During `/design`

```
Architect makes hard-to-reverse decision
→ Agent asks: "Create ADR?"
→ If yes, create docs/adr/NNNN-slug.md
→ Record in DECISIONS.md as well (high-level)
```

### During `/build`

```
Agent references ADR when making implementation choices
→ "ADR-0002 specifies event sourcing for orders"
→ Implements according to decision
```

### During `/review`

```
Reviewer checks implementation against ADRs
→ "This bypasses event store, violates ADR-0002"
→ Flags for correction
```

---

## Relationship to Other Docs

| Doc | Purpose | Content | Updates |
|-----|---------|---------|---------|
| **docs/adr/*.md** | Architecture decisions | Technical, hard-to-reverse | Lazy, when criteria met |
| **DECISIONS.md** | Team decisions | High-level, business impact | During /design with HITL |
| **decisionLog.md** | AI memory | Informal, session continuity | Real-time, inline |
| **ARCHITECTURE.md** | System structure | Components, boundaries | When architecture evolves |

**All three decision docs coexist** with clear separation:
- **ADR**: Architecture-specific, technical, permanent record
- **DECISIONS.md**: Team-shared, formal, approval-gated
- **decisionLog.md**: AI memory bank, informal, rapid

---

## Maintenance

### Updating Status

```yaml
---
status: superseded by ADR-0042
---

# Old Decision Title

[Keep original content for history]
```

**Don't delete superseded ADRs.** Mark status, link to replacement.

### Correcting ADRs

**If decision was wrong**:
1. Create new ADR with corrected decision
2. Mark old ADR as `superseded by ADR-NNNN`
3. Document what was learned

**Don't edit history** - it's valuable to see evolution of thinking.

### Reviewing ADRs

**Periodic review** (quarterly or during architecture reviews):
- Are decisions still valid?
- Any deprecated due to context change?
- Any superseded by newer decisions?
- Update statuses accordingly

---

## Common Mistakes

### ❌ Too Verbose

```markdown
# Use PostgreSQL

We evaluated multiple database options for our application.
After extensive research and prototyping, we determined that
PostgreSQL would be the best fit for our needs due to...
[5 more paragraphs]
```

**Fix**: 1-3 sentences. Be concise.

### ❌ Not ADR-Worthy

```markdown
# Use Prettier for Code Formatting

Using Prettier to format code consistently.
```

**Fix**: Easy to reverse, not surprising, no trade-off = Skip ADR.

### ❌ Missing Trade-Offs

```markdown
# Use Microservices

Using microservices for better scalability.
```

**Fix**: Mention trade-offs (complexity, distributed debugging).

### ❌ No Context

```markdown
# Event Sourcing

We're using event sourcing.
```

**Fix**: Why? What problem does it solve? What's the trade-off?

---

## Quick Reference

### ADR Template

```markdown
# {Decision Title}

{Context: What problem/need}
{Decision: What we chose}
{Why: Reason for choice}
{Trade-off: What we're accepting}
```

### 3 Criteria Checklist

- [ ] Hard to reverse (meaningful cost to change)
- [ ] Surprising without context (future reader will wonder why)
- [ ] Result of trade-off (genuine alternatives existed)

**All three must be true → Create ADR**

### File Naming

```
docs/adr/NNNN-short-slug.md

Examples:
0001-use-postgresql.md
0002-event-sourcing-orders.md
0003-monorepo-structure.md
```

---

## The Bottom Line

```
Keep it tight: 1-3 sentences minimum
Only when criteria met: Hard to reverse + Surprising + Trade-off
Sequential numbering: 0001, 0002, 0003...
Lazy creation: Create when needed, not upfront
Document trade-offs: What you're accepting, not just benefits
```

**ADRs record THAT a decision was made and WHY. Not HOW to implement.**

---

**Related**: [README.md](./README.md), [CONTEXT.md](../../CONTEXT.md), [DECISIONS.md](../../DECISIONS.md)  
**Source**: Matt Pocock tight ADR format  
**Version**: 2.0

