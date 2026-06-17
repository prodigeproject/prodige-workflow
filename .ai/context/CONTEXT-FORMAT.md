# CONTEXT.md Format Guide

How to structure and write domain glossaries for your project.

---

## File Structure

```markdown
# {Context Name}

{One or two sentence description of what this context is and why it exists}

## Language

**TermName**:
{One or two sentence description of the term}
_Avoid_: AlternativeName1, AlternativeName2

**AnotherTerm**:
{Definition}
_Avoid_: Synonym1, Synonym2
```

---

## Writing Rules

### 1. Be Opinionated

**Pick ONE preferred term** for each concept. List rejected alternatives under `_Avoid_`.

```markdown
✅ GOOD:
**Customer**:
A person or organization that places orders.
_Avoid_: User, client, buyer, account

❌ BAD:
**Customer / User / Client**:
The person who uses our system.
```

**Why**: Forces clarity. "Customer or user?" becomes "Customer. Period."

---

### 2. Keep Definitions Tight

**1-2 sentences maximum**. Define what it IS, not what it does.

```markdown
✅ GOOD:
**Invoice**:
A request for payment sent to customer after order placement.
_Avoid_: Bill, receipt

❌ BAD (too long):
**Invoice**:
An invoice is a document that we generate and send to customers
requesting payment for goods or services. It includes line items,
tax calculations, payment terms, and due dates. Invoices are created
after the order is fulfilled and can be sent via email or mail...
```

**Why**: Definitions should clarify, not explain implementation. Keep it crisp.

---

### 3. Domain-Specific Only

**Only include terms unique to your project's context.** General programming concepts don't belong.

```markdown
✅ BELONGS:
**Order**: Customer's request to purchase products
**SKU**: Stock Keeping Unit identifier
**Fulfillment**: Process of picking, packing, shipping

❌ DOESN'T BELONG:
**Promise**: JavaScript async primitive
**Middleware**: Express request handler
**DTO**: Data Transfer Object
**API**: Application Programming Interface
```

**Test**: "Is this concept unique to this domain, or general programming?"
- Unique to domain → Add it
- General programming → Skip it

**Why**: CONTEXT.md is about domain vocabulary, not technical vocabulary.

---

### 4. Group Terms When Natural

**Use subheadings** when terms cluster into logical groups.

```markdown
✅ GOOD (natural groups):
# E-Commerce Context

## Order Management

**Order**: Customer's request to purchase
**LineItem**: Single product within an order
**OrderStatus**: Current state of order (pending, confirmed, shipped)

## Inventory

**SKU**: Stock Keeping Unit identifier
**Stock**: Available quantity of a SKU
**Backorder**: Order for out-of-stock SKU

## Fulfillment

**Shipment**: Physical delivery of order
**Tracking Number**: Carrier identifier for shipment
**Warehouse**: Storage facility

✅ ALSO GOOD (flat list for small domains):
# Simple Service Context

## Language

**User**: Person with account
**Session**: Authenticated user connection
**Token**: JWT for session validation
```

**Why**: Groups help navigation. But don't force groups - flat list is fine for small domains.

---

### 5. Flag Ambiguities

**When a term has multiple meanings** in different contexts, note it explicitly.

```markdown
**Transaction**:
In payment context: A financial operation (charge, refund).
In database context: A unit of work with ACID properties.
_Note_: Specify which meaning when discussing requirements.
```

**Why**: Prevents miscommunication when same word has different meanings.

---

## Single vs Multi-Context

### Single Context (Most Repos)

**One `CONTEXT.md` at repo root.**

```
my-project/
├── .ai/
│   └── context/
│       └── CONTEXT.md  ← Single domain glossary
├── src/
└── ...
```

**Use when**: Project has one cohesive domain (e.g., single service, simple app)

### Multiple Contexts (Bounded Contexts)

**Create `CONTEXT-MAP.md` at repo root**, then individual `CONTEXT.md` per context.

```
my-project/
├── .ai/
│   └── context/
│       ├── CONTEXT-MAP.md  ← Lists all contexts
│       └── CONTEXT.md      ← Shared terms (optional)
├── src/
│   ├── ordering/
│   │   └── CONTEXT.md      ← Ordering-specific terms
│   ├── billing/
│   │   └── CONTEXT.md      ← Billing-specific terms
│   └── fulfillment/
│       └── CONTEXT.md      ← Fulfillment-specific terms
└── ...
```

**Use when**: Project has multiple bounded contexts (e.g., microservices, modular monolith)

**CONTEXT-MAP.md structure**:
```markdown
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — Receives and tracks orders
- [Billing](./src/billing/CONTEXT.md) — Generates invoices
- [Fulfillment](./src/fulfillment/CONTEXT.md) — Manages shipping

## Relationships

- **Ordering → Fulfillment**: Emits `OrderPlaced` events
- **Fulfillment → Billing**: Emits `ShipmentDispatched` events
- **Shared**: `CustomerId`, `Money` types
```

See [CONTEXT-MAP.md](./CONTEXT-MAP.md) for full template.

---

## Example: Complete CONTEXT.md

```markdown
# Online Bookstore Context

## Language

**Order**:
A customer's request to purchase one or more books.
_Avoid_: Purchase, transaction, cart

**ISBN**:
International Standard Book Number. Unique identifier for a book edition.
_Avoid_: BookCode, ProductID

**Member**:
A customer with an active subscription for discounts and benefits.
_Avoid_: Subscriber, premium user

**Wishlist**:
A saved list of books a customer wants to purchase later.
_Avoid_: Favorites, saved items, bookmarks

**Inventory**:
Available stock of books in our warehouse.
_Avoid_: Stock, supply

**Fulfillment**:
The process of picking, packing, and shipping an order.
_Avoid_: Delivery, shipping process

**Backorder**:
An order for a book that's currently out of stock.
_Avoid_: Pre-order (different concept - unreleased book)
```

---

## When to Create CONTEXT.md

**Lazy creation principle**: Don't create until needed.

**Create when**:
- First domain term causes confusion in design discussion
- Requirements use fuzzy/ambiguous terms
- Team has different understanding of same concept
- New team member asks "what's an X?"

**Don't create**:
- Just because template says so
- As documentation checkbox
- Before domain concepts emerge

**Start small**: Add one term. Let it grow organically.

---

## How Agents Use This

### During `/design`
```
Agent loads CONTEXT.md → Uses terms in requirements gathering
User says "user" → Agent asks: "Do you mean Customer or Member?"
User introduces new term → Agent adds to CONTEXT.md inline
```

### During `grill-with-docs`
```
Agent challenges fuzzy language:
User: "When the user buys a thing..."
Agent: "Clarify: Is 'user' a Customer or Member? Is 'thing' a Book?"
```

### During `/build`
```
Agent references CONTEXT.md → Uses correct terms in code
Variable naming: "customer" not "user"
Type naming: "Order" not "Purchase"
```

---

## Maintenance Workflow

### During Sessions (Inline Updates)

**Add terms** when clarifying requirements:
```
User: "The customer can save items for later"
Agent: "I'll add 'Wishlist' to CONTEXT.md"
Agent: *Adds Wishlist definition inline*
```

**Update definitions** when understanding deepens:
```
Agent: "Initial definition was incomplete. Updating..."
Agent: *Updates Order definition to include subscription discounts*
```

**Add `_Avoid_` items** when ambiguity discovered:
```
User: "The user does X"
Agent: "Which term? Customer or Member?"
User: "Customer"
Agent: *Adds "user" to _Avoid_ list for Customer*
```

### Periodic Reviews

**Review during**:
- Architecture reviews (quarterly)
- Team retros (when vocabulary drift noticed)
- Onboarding (new members find confusing terms)
- Refactoring (domain model changes)

**Look for**:
- Terms that need clarification
- Missing terms (gaps in glossary)
- Outdated definitions (domain evolved)
- Redundant entries (merge similar terms)

---

## Integration with Workflows

### `/design` Workflow
1. Orchestrator loads CONTEXT.md
2. Architect uses terms when gathering requirements
3. Grill-with-docs challenges fuzzy language
4. CONTEXT.md updated inline with new terms

### `/build` Workflow
1. Agent references CONTEXT.md for terminology
2. Code uses consistent names (matching CONTEXT.md)
3. New domain concepts → update CONTEXT.md

### `/review` Workflow
1. Reviewer checks code terminology against CONTEXT.md
2. Vocabulary drift → flag for correction
3. Missing terms → add to CONTEXT.md

---

## Relationship to Other Docs

| Document | Purpose | Content |
|----------|---------|---------|
| **CONTEXT.md** | Domain vocabulary | Terms, definitions, avoid lists |
| **PROJECT.md** | Project identity | Tech stack, goals, constraints |
| **ARCHITECTURE.md** | System structure | Components, boundaries, flows |
| **DECISIONS.md** | Team decisions | High-level, approval-gated |
| **docs/adr/*.md** | Architecture decisions | Technical, hard-to-reverse |

**CONTEXT.md focuses on WHAT things are called** (vocabulary).  
**Other docs focus on WHY/HOW** (decisions, structure, implementation).

---

## Common Mistakes

### ❌ Too Verbose

```markdown
**Order**:
An order is a data structure that represents a customer's
intent to purchase products. It contains line items, each
with a quantity and price. Orders go through multiple
states (pending, confirmed, shipped). Orders are created
when customers check out and are stored in the database...
```

**Fix**: Keep it to 1-2 sentences defining what it IS.

### ❌ Implementation Details

```markdown
**Order**:
A document stored in MongoDB with schema validation using Mongoose.
```

**Fix**: Focus on domain concept, not implementation.

### ❌ Not Opinionated

```markdown
**Customer / User / Client**:
The person using our system.
_Avoid_: Buyer
```

**Fix**: Pick ONE term, list others under _Avoid_.

### ❌ General Programming Terms

```markdown
**API**: Application Programming Interface
**Promise**: JavaScript async primitive
**Middleware**: Express request handler
```

**Fix**: Only domain-specific terms belong here.

---

## Quick Reference

### Adding a Term

```markdown
**{TermName}**:
{1-2 sentence definition}
_Avoid_: {Alternative1}, {Alternative2}
```

### Updating a Term

```markdown
**Order**:
~~Old definition~~
New, improved definition based on deeper understanding
_Avoid_: Purchase, ~~OldAvoid~~, NewAvoid
```

### Flagging Ambiguity

```markdown
**Transaction**:
In payments: Financial operation.
In database: ACID unit of work.
_Note_: Specify context when discussing.
```

---

## Tools & Automation

**Linting** (future):
- Check code variable names against CONTEXT.md
- Flag drift when wrong terms used
- Suggest corrections

**Auto-linking** (future):
- Link terms in docs to CONTEXT.md definitions
- Hover tooltip shows definition
- Click to jump to glossary

**Currently**: Manual maintenance. Let it grow organically.

---

## The Bottom Line

```
Be opinionated: Pick ONE term
Keep definitions tight: 1-2 sentences
Domain-specific only: No general programming
Lazy creation: Start when needed
Inline updates: Don't batch
```

**CONTEXT.md is a living document. Start small. Grow as needed.**

---

**Related**: [CONTEXT.md](./CONTEXT.md) template, [CONTEXT-MAP.md](./CONTEXT-MAP.md) template  
**Source**: Matt Pocock grill-with-docs skill  
**Version**: 2.0

