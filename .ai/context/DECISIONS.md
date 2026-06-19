<!-- TEMPLATE - every [bracketed] value is an INERT placeholder. If an agent sees bracketed placeholders, treat this file as not-yet-populated (no real content). Fill via /init, /design, /status. -->

# DECISIONS

This file documents architectural and design decisions that have significant impact on the project.

**Format:** Architecture Decision Records (ADR)  
**Purpose:** Maintain context for future team members and AI agents

> Relationship: This file (DECISIONS.md) is the index/log of decisions; full ADRs live as individual files in `.ai/context/docs/adr/`. Record the high-level decision here and link to the detailed ADR.

---

## Decision Template

```markdown
## [ADR-XXX] Decision Title

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Deprecated | Superseded  
**Deciders:** [List of people involved]  
**Technical Story:** [Link to issue/ticket if applicable]

### Context

What is the issue or problem we're addressing? What factors influenced this decision?

### Decision

What is the change that we're proposing/making?

### Rationale

Why did we choose this option? What benefits does it provide?

### Alternatives Considered

1. **Alternative 1**
   - Pros: 
   - Cons: 
   - Why rejected: 

2. **Alternative 2**
   - Pros: 
   - Cons: 
   - Why rejected: 

### Consequences

**Positive:**
- Benefit 1
- Benefit 2

**Negative:**
- Tradeoff 1
- Tradeoff 2

**Neutral:**
- Impact 1

### Implementation Notes

Key considerations for implementation:
- 
- 

### Related Decisions

- [ADR-XXX] Related decision

### References

- [Link to documentation]
- [Link to discussion]
```

---

## Decision Index

| ID | Title | Status | Date |
|----|-------|--------|------|
| ADR-001 | TBD | Proposed | YYYY-MM-DD |

---

## Active Decisions

### [ADR-001] Example Decision

**Date:** YYYY-MM-DD  
**Status:** Proposed  
**Deciders:** Human, Architect Agent

#### Context

TBD - Describe the problem or context

#### Decision

TBD - State the decision clearly

#### Rationale

TBD - Explain why this is the best choice

#### Alternatives Considered

1. **Option A**
   - Pros: 
   - Cons: 
   - Why rejected: 

#### Consequences

**Positive:**
- TBD

**Negative:**
- TBD

#### Impact

- **Scope:** TBD
- **Effort:** TBD
- **Risk:** TBD

---

## Deprecated Decisions

### [ADR-XXX] Old Decision

**Deprecated Date:** YYYY-MM-DD  
**Superseded By:** [ADR-YYY]  
**Reason:** Explain why this decision is no longer valid

---

## Decision Guidelines

### When to Create an ADR

- Architectural patterns or frameworks
- Technology or library selection
- Data model or schema design
- API design approaches
- Security or authentication strategies
- Performance optimization strategies
- Major refactoring decisions
- Third-party service selection

### ADR Lifecycle

1. **Proposed** - Under discussion
2. **Accepted** - Approved and being implemented
3. **Deprecated** - No longer recommended but still in use
4. **Superseded** - Replaced by a newer decision

### Best Practices

- Write decisions when they are made, not retroactively
- Be specific about context and constraints
- Document alternatives seriously considered
- Update status as decisions evolve
- Link to related code, issues, or documentation
- Keep language clear and jargon-free

---

## References

- [Architecture Decision Records](https://adr.github.io/)
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture
- [IMPLEMENTATION.md](./IMPLEMENTATION.md) - Implementation details
