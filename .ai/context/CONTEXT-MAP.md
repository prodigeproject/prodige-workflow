# Context Map

**This file is a template for multi-context projects.** Delete this if you have a single-context repo.

---

## What is a Context Map?

A **registry of bounded contexts** in your project and how they relate to each other.

**Use when**: Your project has multiple distinct domains (e.g., microservices, modular monolith)  
**Skip when**: Single cohesive domain (use single `CONTEXT.md` instead)

---

## Contexts

List all bounded contexts with their locations and purposes:

**Template**:
```markdown
- [ContextName](./path/to/CONTEXT.md) — One sentence description
```

**Example**:
- [Ordering](./src/ordering/CONTEXT.md) — Receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — Generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — Manages warehouse picking and shipping
- [Customer](./src/customer/CONTEXT.md) — Manages customer accounts and profiles

---

## Relationships

Describe how contexts interact with each other:

**Template**:
```markdown
- **ContextA → ContextB**: How A interacts with B
- **ContextC ↔ ContextD**: Bidirectional relationship
- **Shared**: What's shared across contexts
```

**Example**:
- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering → Customer**: Ordering queries Customer context for customer details via REST API
- **Shared**: All contexts share `CustomerId` and `Money` value objects

---

## Context Boundaries

**Explicit boundaries prevent coupling:**

### Ordering Context
- **Owns**: Orders, line items, order status
- **References**: CustomerId (owned by Customer), ProductId (owned by Catalog)
- **Exposes**: `OrderPlaced`, `OrderCancelled` events
- **Consumes**: `PaymentReceived` from Billing

### Billing Context
- **Owns**: Invoices, payments, transactions
- **References**: OrderId (owned by Ordering), CustomerId (owned by Customer)
- **Exposes**: `PaymentReceived`, `InvoiceGenerated` events
- **Consumes**: `ShipmentDispatched` from Fulfillment

### Fulfillment Context
- **Owns**: Shipments, tracking numbers, warehouse operations
- **References**: OrderId (owned by Ordering), SKU (owned by Inventory)
- **Exposes**: `ShipmentDispatched`, `ShipmentDelivered` events
- **Consumes**: `OrderPlaced` from Ordering

### Customer Context
- **Owns**: Customer profiles, addresses, preferences
- **References**: None (independent)
- **Exposes**: `CustomerRegistered`, `AddressChanged` events
- **Consumes**: None

---

## Integration Patterns

**How contexts communicate:**

### Event-Driven (Preferred)
- **Pattern**: Publish/subscribe via message bus
- **Used by**: Ordering → Fulfillment, Fulfillment → Billing
- **Why**: Loose coupling, async processing

### REST API (When Needed)
- **Pattern**: Synchronous HTTP requests
- **Used by**: Ordering → Customer (read-only queries)
- **Why**: Need immediate response for customer details

### Shared Database (Avoid)
- **Pattern**: Direct database access
- **Used by**: None (explicitly avoided)
- **Why**: Creates tight coupling

---

## Shared Vocabulary

**Terms used across ALL contexts:**

**CustomerId**:
Unique identifier for a customer across all contexts.
_Type_: UUID
_Owned by_: Customer context

**Money**:
Value object representing currency amount.
_Type_: `{ amount: number, currency: string }`
_Owned by_: Shared kernel

**Timestamp**:
ISO 8601 datetime string.
_Type_: string
_Owned by_: Shared kernel

---

## Context-Specific Terms

Each context has its own `CONTEXT.md` with domain-specific terms:

- **Ordering**: Order, LineItem, OrderStatus
- **Billing**: Invoice, Payment, Transaction
- **Fulfillment**: Shipment, TrackingNumber, Warehouse
- **Customer**: Customer, Address, PaymentMethod

**See individual CONTEXT.md files for full glossaries.**

---

## How Agents Use This

### Context Selection
```
Agent reads CONTEXT-MAP.md → Identifies relevant context
User asks about "shipping" → Agent loads Fulfillment CONTEXT.md
User asks about "invoices" → Agent loads Billing CONTEXT.md
```

### Cross-Context Work
```
Agent working on Ordering → References Customer context
Agent ensures: OrderId owned by Ordering, CustomerId referenced only
Agent checks: Communication via events (not direct calls)
```

### New Feature Development
```
Agent: "This feature spans Ordering and Billing contexts"
Agent: Loads both CONTEXT.md files
Agent: Ensures proper boundary respect (no coupling)
```

---

## Maintenance

### Adding a Context

1. Create new `CONTEXT.md` in context directory
2. Add entry to "Contexts" section above
3. Document relationships with existing contexts
4. Define boundary (owns, references, exposes, consumes)
5. Update integration patterns if new pattern introduced

### Updating Relationships

1. When integration changes (e.g., events → REST API)
2. When new shared types emerge
3. When boundaries shift (ownership changes)
4. Document in commit message and CHANGELOG

### Splitting Contexts

1. Document reason (context too large, clear boundary)
2. Create new CONTEXT.md for split context
3. Update CONTEXT-MAP.md with new context
4. Migrate terms from old to new CONTEXT.md
5. Update relationships

### Merging Contexts

1. Document reason (contexts too coupled, no clear boundary)
2. Merge CONTEXT.md files
3. Remove entry from CONTEXT-MAP.md
4. Update relationships
5. Update integration patterns

---

## Example: E-Commerce Platform

```markdown
# Context Map

## Contexts

- [Catalog](./src/catalog/CONTEXT.md) — Product information and inventory
- [Ordering](./src/ordering/CONTEXT.md) — Customer orders and order management
- [Payment](./src/payment/CONTEXT.md) — Payment processing and transactions
- [Fulfillment](./src/fulfillment/CONTEXT.md) — Warehouse and shipping operations
- [Customer](./src/customer/CONTEXT.md) — Customer accounts and profiles

## Relationships

- **Ordering → Catalog**: Queries product details and availability
- **Ordering → Customer**: Queries customer information
- **Ordering → Payment**: Triggers payment processing
- **Ordering → Fulfillment**: Emits `OrderPlaced` event to start fulfillment
- **Fulfillment → Catalog**: Updates inventory after shipment
- **Payment → Ordering**: Emits `PaymentConfirmed` event
- **Shared**: `CustomerId`, `ProductId`, `Money`, `Address`

## Context Boundaries

### Catalog Context
- **Owns**: Products, SKUs, inventory levels
- **Exposes**: Product query API, `InventoryUpdated` events
- **Consumes**: `OrderShipped` from Fulfillment

### Ordering Context
- **Owns**: Orders, line items, order status
- **References**: ProductId, CustomerId
- **Exposes**: `OrderPlaced`, `OrderCancelled` events
- **Consumes**: `PaymentConfirmed` from Payment

### Payment Context
- **Owns**: Transactions, payment methods, charges
- **References**: OrderId, CustomerId
- **Exposes**: `PaymentConfirmed`, `PaymentFailed` events
- **Consumes**: Payment requests from Ordering

### Fulfillment Context
- **Owns**: Shipments, tracking, warehouse locations
- **References**: OrderId, ProductId
- **Exposes**: `OrderShipped`, `OrderDelivered` events
- **Consumes**: `OrderPlaced` from Ordering

### Customer Context
- **Owns**: Customer profiles, addresses, preferences
- **Exposes**: Customer query API, `CustomerUpdated` events
- **Consumes**: None (independent context)

## Integration Patterns

- **Event-Driven**: Ordering ↔ Fulfillment, Ordering ↔ Payment
- **REST API**: Ordering → Catalog, Ordering → Customer
- **Message Queue**: RabbitMQ for all event-driven communication
```

---

## When to Use Context Map

### Use CONTEXT-MAP.md When:
- Multiple teams own different parts of system
- Clear bounded contexts exist (e.g., microservices)
- Terms have different meanings in different areas
- Contexts communicate via events/APIs
- Domain is large enough to warrant separation

### Use Single CONTEXT.md When:
- Single team owns entire system
- One cohesive domain model
- Terms have consistent meaning throughout
- No need for context boundaries
- Small to medium domain

**Don't force**: If you're unsure, start with single CONTEXT.md. Split later if needed.

---

## Relationship to DDD

**Context Map aligns with Domain-Driven Design concepts:**

- **Bounded Context** = One entry in Context Map
- **Context Boundaries** = Explicitly defined ownership
- **Ubiquitous Language** = Terms in each CONTEXT.md
- **Integration Patterns** = How contexts communicate
- **Shared Kernel** = Shared vocabulary section

**You don't need to know DDD** to use Context Map effectively. Just think of it as "which parts of the system have their own vocabulary?"

---

## The Bottom Line

```
Multi-context repos: Create CONTEXT-MAP.md + per-context CONTEXT.md
Single-context repos: Skip this, use single CONTEXT.md
List contexts, relationships, boundaries
Document integration patterns
Update when contexts change
```

**Context Map is for projects with multiple distinct domains. Most projects don't need this.**

---

**Related**: [CONTEXT.md](./CONTEXT.md) template, [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) guide  
**Source**: Matt Pocock multi-context pattern  
**Version**: 2.0

