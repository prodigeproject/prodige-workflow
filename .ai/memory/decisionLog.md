# Decision Log

Architecture Decision Records (ADRs) for important technical decisions.

---

## Template

```markdown
## [YYYY-MM-DD] - [Decision Title]

### Context
[What is the situation requiring a decision?]
[What forces are at play?]
[What constraints exist?]

### Decision
[What did we decide to do?]

### Options Considered

#### Option 1: [Name]
**Pros**:
- [Pro 1]
- [Pro 2]

**Cons**:
- [Con 1]
- [Con 2]

#### Option 2: [Name]
**Pros**:
- [Pro 1]

**Cons**:
- [Con 1]

### Rationale
[Why did we choose this option over the others?]
[What factors were most important?]
[What tradeoffs are we accepting?]

### Consequences
**Positive**:
- [Positive consequence 1]
- [Positive consequence 2]

**Negative**:
- [Negative consequence 1]
- [Negative consequence 2]

**Neutral**:
- [Neutral change 1]

### Status
`Accepted` | `Superseded by [ADR-XXX]` | `Rejected` | `Proposed`

### Related Decisions
- [Link to related ADR]

### Follow-up Actions
- [ ] [Action item 1]
- [ ] [Action item 2]
```

---

## Example Decisions

### [2026-06-17] - Adopt Hybrid Workflow Architecture

#### Context
We needed a workflow system that works for both beginner vibe coders and production-grade applications. Two systems were evaluated: Claude-Boris (excellent UX) and Prodige (strong governance).

#### Decision
Implement hybrid architecture that adopts Boris's UX features (Memory Bank, Magic Command, Safety System) while keeping Prodige's governance model (HITL gates, formal context docs, quality gates).

#### Options Considered

**Option 1: Pure Boris**
- Pros: Simple, beginner-friendly, proven
- Cons: Lacks enterprise governance, no HITL gates

**Option 2: Pure Prodige**
- Pros: Strong governance, team-ready
- Cons: Steep learning curve for beginners

**Option 3: Hybrid** (Chosen)
- Pros: Best of both worlds, gradual complexity
- Cons: More implementation work

#### Rationale
Hybrid approach allows vibe coders to start with simple `/magic` command while still maintaining production-grade quality through governance. Progressive disclosure of complexity.

#### Consequences
**Positive**:
- Accessible to beginners
- Scales to production needs
- Maintains quality standards

**Negative**:
- More code to maintain
- Two mental models to support

#### Status
`Accepted`

#### Follow-up Actions
- [x] Complete audit report
- [x] Create implementation guide
- [ ] Implement Phase 1 (Memory Bank)
- [ ] Implement Phase 2 (Magic Command)
- [ ] User testing

---

## Active Decisions

[Decisions currently being implemented or recently made]

---

## Historical Decisions

[Older decisions for reference]

---

**Last Updated**: 2026-06-17  
**Update Frequency**: When significant decisions are made
