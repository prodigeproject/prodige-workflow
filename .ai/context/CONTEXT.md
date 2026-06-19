<!-- TEMPLATE - every [bracketed] value is an INERT placeholder. If an agent sees bracketed placeholders, treat this file as not-yet-populated (no real content). Fill via /init, /design, /status. -->

# Project Context

**This file is a template.** Replace this content with your project's domain-specific terms and concepts.

---

## What is CONTEXT.md?

A **domain glossary** that defines terms specific to this project's context. It ensures everyone (humans and agents) uses consistent vocabulary when discussing the system.

**Purpose**:
- Establish shared vocabulary for domain concepts
- Eliminate ambiguity in requirements and design discussions
- Help new team members understand domain quickly
- Guide agents to use correct terminology in code and docs

**What belongs here**: Terms unique to your project's domain (e.g., "Order", "Invoice", "Shipment")  
**What doesn't belong**: General programming concepts (e.g., "timeout", "promise", "middleware")

---

## Language

**Example Term**:
A one or two sentence description of what this term means in your project's context.
_Avoid_: AlternativeName1, AlternativeName2, VagueTerms

**{Add your domain terms below}**:

---

## How to Use This File

### For Humans
- **Read when onboarding** to understand domain vocabulary
- **Reference during design** to ensure consistent terminology
- **Update when new concepts** emerge or ambiguities are discovered
- **Review during code reviews** to catch vocabulary drift

### For Agents
- **Loaded during `/design`** to inform requirement gathering
- **Used by `grill-with-docs`** to challenge fuzzy language
- **Referenced during `/build`** to ensure code uses correct terms
- **Updated inline** when new domain concepts are identified

### When to Create
- **Single context repos**: Create `CONTEXT.md` at repo root when first domain term needs definition
- **Multi-context repos**: Create `CONTEXT-MAP.md` first (see below), then individual `CONTEXT.md` per context

---

## Multi-Context Projects

If your project has multiple bounded contexts (e.g., microservices, modular monolith), create `CONTEXT-MAP.md` instead at repo root:

```md
# Context Map

## Contexts

- [ContextName1](./path/to/CONTEXT.md) — description
- [ContextName2](./path/to/CONTEXT.md) — description

## Relationships

- **Context1 → Context2**: How they interact
- **Shared**: What's shared between them
```

See [CONTEXT-MAP.md](./CONTEXT-MAP.md) template for details.

---

## Example: E-Commerce Domain

```md
# E-Commerce Context

## Language

**Order**:
A customer's request to purchase one or more products.
_Avoid_: Purchase, transaction, cart

**SKU**:
Stock Keeping Unit. A unique identifier for a product variant (color, size, etc).
_Avoid_: ProductCode, ItemNumber

**Fulfillment**:
The process of picking, packing, and shipping an order.
_Avoid_: Shipping, delivery

**Invoice**:
A request for payment sent to customer after order is placed.
_Avoid_: Bill, receipt

**Customer**:
A person or organization that places orders.
_Avoid_: User, client, buyer
```

---

## Rules for Writing Definitions

1. **Be opinionated**: Pick ONE preferred term, list alternatives under `_Avoid_`
2. **Keep definitions tight**: 1-2 sentences max. Define what it IS, not what it does
3. **Domain-specific only**: General programming concepts don't belong
4. **Group when natural**: Use subheadings if terms cluster
5. **Flag ambiguities**: If a term has multiple meanings in different contexts, note it

---

## Relationship to Other Docs

| Doc | Purpose | When to Use |
|-----|---------|-------------|
| **CONTEXT.md** | Domain glossary | When defining/clarifying domain terms |
| **PROJECT.md** | Project identity | Tech stack, goals, constraints |
| **ARCHITECTURE.md** | System structure | Components, boundaries, data flow |
| **DECISIONS.md** | Team decisions | Formal, approval-gated choices |
| **docs/adr/*.md** | Architecture decisions | Technical, hard-to-reverse choices |

**CONTEXT.md is complementary**, not a replacement. Each serves a different purpose.

---

## Maintenance

**Update inline during sessions**, don't batch:
- Add terms when clarifying fuzzy requirements
- Update definitions when domain understanding deepens
- Add `_Avoid_` items when ambiguous terms are used
- Flag terms that have different meanings in different contexts

**Review periodically**:
- During architecture reviews
- When onboarding new team members
- When refactoring domain models
- When discovering vocabulary drift

---

## Getting Started

1. **Delete this template content**
2. **Add your first domain term** (the one causing most confusion)
3. **Grow organically** as terms are discussed
4. **Don't try to be complete** upfront - lazy creation works best

**Remember**: This is a living document. Start small, grow as needed.

---

**Related**: [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md), [CONTEXT-MAP.md](./CONTEXT-MAP.md), [ADR-FORMAT.md](./docs/adr/ADR-FORMAT.md)  
**Created**: When first domain term needs definition  
**Updated**: Inline during design/build sessions

