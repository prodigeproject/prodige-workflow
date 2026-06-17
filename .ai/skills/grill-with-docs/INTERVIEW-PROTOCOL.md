# Interview Protocol

Question strategies for effective design grilling.

---

## Core Principle

**Never accept vague language.** Challenge everything until precision is reached.

```
User: "Users can manage their stuff"
❌ Agent: "OK, I'll add user management"
✅ Agent: "Define 'manage': Create? Update? Delete? All three?
         Define 'stuff': Profile? Orders? Both?
         Define 'users': Customers? Admins? Both?"
```

---

## The 5 Question Strategies

### 1. Challenge Assumptions

**Surface hidden assumptions before they become bugs.**

```
User: "Add order cancellation"

❌ Passive:
Agent: "OK, adding order cancellation"

✅ Challenge:
Agent: "Cancellation triggers:
       - Customer initiates? Admin? Both?
       - Automatic timeout? Payment failure?
       - All order states? Or only 'pending'?
       
       Current assumption: Customer-initiated, pending-only.
       Correct?"
```

**Pattern**:
```
Statement → Question WHO + WHEN + WHAT + CONSTRAINTS
```

**Examples**:
```
"Users can edit profile"
→ WHO can edit? (self-only or admins too?)
→ WHEN can edit? (always or only verified accounts?)
→ WHAT can edit? (all fields or subset?)
→ CONSTRAINTS? (rate limits, validation rules)

"System sends notifications"
→ WHO receives? (customers, admins, both?)
→ WHEN sent? (immediate, batched, scheduled?)
→ WHAT triggers? (order placed, shipped, delivered?)
→ HOW delivered? (email, SMS, push?)
```

---

### 2. Probe Boundaries

**Find where concept ends and another begins.**

```
User: "Customers have addresses"

❌ Passive:
Agent: "OK, customer has address field"

✅ Probe:
Agent: "Address boundaries:
       
       Singular or multiple?
       - One address per customer? Or address book?
       
       Type differentiation?
       - Shipping vs billing? Or same?
       
       Mutability?
       - Can update after order placed? Or frozen?
       
       Persistence after deletion?
       - Customer deletes account, addresses deleted too?
       - Or preserved for order history?"
```

**Pattern**:
```
Concept → Ask SINGULAR/PLURAL + TYPES + MUTABILITY + LIFECYCLE
```

**Examples**:
```
"Orders have items"
→ Min/max items? (0 allowed? 1000 limit?)
→ Duplicate items? (same item twice = quantity 2 or two entries?)
→ Item modification? (can change after order placed?)
→ Item deletion? (remove from order or mark deleted?)

"Users have roles"
→ One role or multiple? (single role or role set?)
→ Role hierarchy? (admin > manager > user?)
→ Role assignment? (self-select or admin-only?)
→ Role persistence? (permanent or session-based?)
```

---

### 3. Invent Scenarios

**Create edge cases that force precision.**

```
User: "Customers can cancel orders"

❌ Passive:
Agent: "OK, add cancel button"

✅ Invent scenarios:
Agent: "Scenario 1: Cancel after payment processed
       → Automatic refund? Manual? No refund?
       
       Scenario 2: Cancel after partial shipment
       → Cancel remaining only? Or full order impossible?
       
       Scenario 3: Cancel order with promo code
       → Promo credit returned? Lost? Prorated?
       
       Scenario 4: Customer cancels 10 orders in 1 day
       → Fraud check? Rate limit? Allow?
       
       Scenario 5: Cancel order for out-of-stock item
       → Different flow? Same as normal cancel?"
```

**Pattern**:
```
Feature → Invent 5 EDGE CASES that stress different dimensions
```

**Categories for edge case invention**:
1. **Timing**: Before/during/after critical states
2. **Volume**: Zero, one, many, maximum
3. **State conflicts**: Multiple actors, concurrent actions
4. **Failure modes**: Network fail, payment fail, timeout
5. **Boundary conditions**: First, last, minimum, maximum

**Example template**:
```
Feature: "{User statement}"

Scenario 1 (timing): {Before critical point}
Scenario 2 (timing): {During critical point}
Scenario 3 (timing): {After critical point}
Scenario 4 (volume): {Zero case}
Scenario 5 (volume): {Maximum case}
Scenario 6 (conflict): {Concurrent access}
Scenario 7 (failure): {System failure}
Scenario 8 (boundary): {Edge of valid range}
```

---

### 4. Check Consistency

**Find conflicts with existing domain model.**

```
User: "Orders can be 'submitted', 'processing', 'done'"

Agent reads CONTEXT.md:
**OrderStatus**: pending, paid, shipped, delivered

❌ Passive:
Agent: "OK, using submitted/processing/done"

✅ Check:
Agent: "CONFLICT: Your CONTEXT.md defines OrderStatus as:
       'pending, paid, shipped, delivered'
       
       But you just said: 'submitted, processing, done'
       
       These don't match. Which is correct?
       
       A) Update CONTEXT.md to use new terms
       B) Your statement should use existing terms
       C) Both systems exist (why two status models?)"
```

**Pattern**:
```
New statement → COMPARE with CONTEXT.md + ADRs + CODE
                → Surface conflicts
                → Force resolution
```

**Check against**:
1. **CONTEXT.md**: Defined terms and their meanings
2. **docs/adr/*.md**: Documented decisions
3. **Existing code**: Implemented behavior
4. **PROJECT.md**: Tech stack and constraints

**Example**:
```
User: "Users can post comments"

Agent checks CONTEXT.md:
- "Customer" defined (person who places orders)
- "Admin" defined (person who manages system)
- NO "User" defined

Agent: "Your CONTEXT.md doesn't define 'User'.
       Do you mean Customer? Admin? Both? New concept?
       
       If new, how does 'User' relate to Customer/Admin?"
```

---

### 5. Force Specificity

**Convert vague to precise.**

```
User: "System sends notifications"

❌ Passive:
Agent: "OK, adding notifications"

✅ Force specificity:
Agent: "Notification specifics:
       
       CHANNEL: Email? SMS? Push? In-app? All?
       
       TIMING: Immediate? Batched (how often)? Scheduled (when)?
       
       TRIGGER: What events? (Order placed, shipped, delivered?)
       
       RECIPIENT: Customer only? Admin too? Configurable?
       
       CONTENT: Static template? Dynamic based on context?
       
       FAILURE: Retry on fail? How many times? Alert on permanent failure?
       
       PREFERENCES: User can disable? Per-channel? Per-event?"
```

**Pattern**:
```
Vague statement → Ask 7 W questions:
- WHO (actor/recipient)
- WHAT (specific action/content)
- WHEN (timing/trigger)
- WHERE (location/boundary)
- WHY (business rule/constraint)
- HOW (mechanism/channel)
- HOW MANY (quantity/frequency)
```

**Vague terms to challenge**:
```
"Manage"     → Create? Read? Update? Delete? All?
"Handle"     → Accept? Reject? Transform? Store? Forward?
"Process"    → Validate? Calculate? Store? Send?
"Stuff"      → Exactly what entities/data?
"Things"     → Exactly what collection?
"Users"      → Customers? Admins? Both? Other role?
"System"     → Which component? Service? Module?
"Later"      → How long? Seconds? Days?
"Some"       → How many? All? None? Subset?
"Usually"    → Always? 90%? Configurable?
```

---

## Question Sequencing

### Start Broad, Narrow Down

```
Level 1 (Concept):
"You want 'order cancellation'. Define cancellation."

Level 2 (Actor):
"WHO can cancel? Customer? Admin? Both?"

Level 3 (Constraints):
"Customer cancels - which states allow it? All? Just pending?"

Level 4 (Mechanisms):
"Cancel button location? Order detail page? Email link? Both?"

Level 5 (Side effects):
"Refund automatic? Manual approval? Instant or delayed?"

Level 6 (Edge cases):
"What if cancel after partial shipment? After full delivery?"
```

**Pattern**: Concept → Actor → Constraints → Mechanism → Effects → Edges

---

## Asking One Question at a Time

**DON'T dump all questions**:
```
❌ "Who can cancel, when can they cancel, where is cancel button,
   what happens to refund, how long does refund take, what if
   already shipped, what if customer has coupon, what about..."
```

**DO ask sequentially**:
```
✅ "First: WHO can cancel orders? Customer? Admin? Both?"

[Wait for answer]

✅ "Got it, customer-only. Next: WHEN can customers cancel?
   All order states? Or only before shipment?"

[Wait for answer]

✅ "OK, only pending orders. Next: What triggers refund?
   Automatic on cancel? Or manual approval needed?"

[Continue...]
```

**Why**: Cognitive overload. One question → one answer → move forward.

---

## Recommended Answer Pattern

**For each question, provide recommendation:**

```
Agent: "WHO can cancel orders?
       
       Recommendation: Customer-only, for simplicity.
       Admin can cancel via separate admin flow (not same UI).
       
       Rationale:
       - Customer self-service reduces support load
       - Separate admin flow has audit trail + approval
       - Mixed UI would complicate permissions
       
       Agree?"
```

**Pattern**:
```
Question
↓
Recommendation (pick one option)
↓
Rationale (why that option)
↓
Ask for confirmation
```

**Why**: Speeds up decision-making. User can accept, reject, or refine.

---

## Cross-Reference with Code

**When discussing existing feature, check code first.**

```
User: "Orders can be partially cancelled"

Agent: "Let me check existing code..."
Agent: *Reads OrderService.cancel()*

Result A (Code agrees):
"✓ Code confirms: OrderService.cancel() accepts lineItemIds parameter,
  supports partial cancellation. Proceeding with that assumption."

Result B (Code conflicts):
"✗ Code shows: Order.cancel() marks entire order as cancelled,
  no partial logic exists.
  
  You said 'partial cancellation possible' - which is right?
  A) Code is outdated, needs update (new feature)
  B) You misspoke, only full cancellation exists
  C) Partial exists elsewhere (where?)"
```

**Don't assume user knows current implementation.** Code is source of truth.

---

## Escalation Patterns

### When User is Uncertain

```
User: "I think customers can cancel... probably..."

❌ Accept:
Agent: "OK, customers can cancel"

✅ Escalate:
Agent: "You sound uncertain ('I think', 'probably').
       
       This is a critical decision (refunds, accounting).
       We need certainty before implementing.
       
       Options:
       A) Check existing system behavior (I can explore code)
       B) Check with domain expert (who owns this decision?)
       C) Design both scenarios (can-cancel vs cannot-cancel)
       
       Which approach?"
```

### When Conflicting Information

```
User statement: "Orders are immutable after placement"
Code shows: Order.updateLineItems() method exists

Agent: "CONFLICT detected:
       - You said: 'Orders immutable after placement'
       - Code shows: Order.updateLineItems() exists and is used
       
       Which is correct?
       A) Code is wrong (legacy, should be removed)
       B) Your statement is wrong (orders ARE mutable)
       C) Both right in different contexts (when is each true?)"
```

### When Missing Documentation

```
User uses term: "Fulfillment center"
CONTEXT.md: Term not defined

Agent: "Term 'Fulfillment center' not in CONTEXT.md.
       
       Should I add it?
       
       Proposed definition:
       **Fulfillment Center**:
       Physical warehouse where orders are picked and shipped.
       _Avoid_: Warehouse, distribution center
       
       Accurate?"
```

---

## Common Anti-Patterns

### ❌ Accepting First Answer

```
User: "Orders can be cancelled"
Agent: "OK, adding cancel feature"
```

**Problem**: Vague. Didn't probe WHO, WHEN, HOW.

**Fix**: Challenge every statement.

---

### ❌ Asking Leading Questions

```
Agent: "Orders can be cancelled by customers, right?"
```

**Problem**: Suggests answer. User may agree without thinking.

**Fix**: Open-ended.
```
Agent: "WHO can cancel orders? Customer? Admin? Both? Other?"
```

---

### ❌ Technical Implementation Too Early

```
User: "Users can cancel orders"
Agent: "Should we use soft delete or hard delete in database?"
```

**Problem**: Implementation detail before domain understanding.

**Fix**: Understand domain first, implement later.
```
Agent: "When customer cancels, what happens to the order record?
       A) Preserved for history (status=cancelled)
       B) Removed completely
       C) Archived to separate table"
       
       [After domain decision clear, THEN discuss implementation]
```

---

### ❌ Batch Question Dump

```
Agent: "Who can cancel, when, where, how, why, what if shipped,
       what if refunded, what about coupons, and fraud, and..."
```

**Problem**: Cognitive overload.

**Fix**: One question, wait for answer, next question.

---

### ❌ Not Updating Docs Inline

```
[30 minutes of grilling]
User: "Great, all clear!"
Agent: "I'll update CONTEXT.md now..."
User: [Session ends, disconnects]
→ Documentation lost
```

**Problem**: Batching updates loses context.

**Fix**: Update immediately when term is resolved.

---

## Verification Protocol

Before ending grilling session, verify:

### 1. Precision Check

```
Agent: "Let me summarize what we decided:
       
       - Customer (not Admin) can cancel
       - Only pending Orders (not shipped/delivered)
       - Cancel = full order, not partial
       - Refund automatic via original payment method
       - No cancel if >24 hours after placement
       
       Precise and complete?"

User: "Yes" → ✅ Done
User: "Well, actually..." → 🔄 Keep grilling
```

### 2. Edge Case Coverage

```
Agent: "We covered:
       - Normal cancel (pending order)
       - Late cancel (> 24 hours)
       - Cancel after shipment (blocked)
       - Refund mechanism (automatic)
       
       Any edge cases we missed?"
```

### 3. Documentation Check

```
Agent: "I updated:
       - CONTEXT.md: Added 'Cancellation' definition
       - ADR-0008: Allow order cancellation within 24 hours
       
       Documentation reflects our discussion?"
```

---

## The Bottom Line

```
Challenge assumptions
Probe boundaries
Invent scenarios
Check consistency
Force specificity

One question at a time
Provide recommendations
Cross-reference code
Update docs inline
Verify before ending
```

**Goal**: Convert "I think..." to "Yes, exactly that."

---

**Related**: [SKILL.md](./SKILL.md), [SCENARIO-TESTING.md](./SCENARIO-TESTING.md)  
**Source**: Matt Pocock grill-me philosophy + Prodige systematic approach  
**Version**: 2.0

