# Scenario Testing Guide

How to invent edge cases that expose fuzzy requirements.

---

## Why Scenarios?

**Abstract reasoning hides problems. Concrete scenarios expose them.**

```
❌ Abstract:
User: "Customers can cancel orders"
Agent: "OK, sounds good"
→ Problem: Didn't discover edge cases

✅ Concrete:
Agent: "Scenario: Customer cancels after item already shipped.
       What happens?"
User: "Oh... good question. I guess... uh..."
→ Exposed: Edge case not considered
```

**Scenarios force precision** where abstract discussion allows vagueness.

---

## The 8 Dimensions

Create scenarios along these dimensions:

### 1. Timing (Before/During/After)

**Test**: Critical state transitions

```
Feature: "Customer can cancel order"

Scenario A (Before): Customer cancels before payment processed
→ Expected: Cancel succeeds, no charges, order marked cancelled

Scenario B (During): Customer cancels while payment processing
→ Expected: ??? (Race condition - which wins?)

Scenario C (After payment): Customer cancels after payment confirmed
→ Expected: Refund issued automatically? Or manual approval?

Scenario D (After shipment): Customer cancels after item shipped
→ Expected: Block cancel? Allow with return flow? Partial refund?

Scenario E (After delivery): Customer cancels after item delivered
→ Expected: Block? Treat as return instead of cancel?
```

**Pattern**: Identify critical states → Test transitions between them

---

### 2. Volume (Zero, One, Many, Max)

**Test**: Boundary conditions

```
Feature: "Orders contain items"

Scenario A (Zero): Order with 0 items
→ Allowed? Or minimum 1 item enforced?

Scenario B (One): Order with exactly 1 item
→ Normal case, should work

Scenario C (Few): Order with 3 items
→ Normal case

Scenario D (Many): Order with 100 items
→ UI handles? Shipping cost calculation?

Scenario E (Maximum): Order with 10,000 items
→ Performance? Database limits? UI breakdown?
```

**Pattern**: Test boundaries: 0, 1, typical, large, maximum

---

### 3. State Conflicts (Concurrent Actions)

**Test**: Multiple actors, race conditions

```
Feature: "Customer can update address"

Scenario A: Customer updates address while order is processing
→ Which address ships to? Old or new?

Scenario B: Customer updates address twice in 1 second
→ Race condition? Last write wins? Both saved?

Scenario C: Admin updates customer address, customer updates simultaneously
→ Which wins? Admin? Customer? Conflict error?

Scenario D: Customer deletes address while order references it
→ Order blocked? Address soft-deleted? Copied into order?
```

**Pattern**: Two actors → overlapping timeframes → what happens?

---

### 4. Failure Modes (System Failures)

**Test**: External dependencies fail

```
Feature: "System charges customer payment"

Scenario A: Payment gateway timeout
→ Retry? How many times? Give up? User notification?

Scenario B: Payment declined
→ Order cancelled? Hold for retry? User notification?

Scenario C: Payment succeeded but webhook fails
→ Order stuck in "processing"? Manual reconciliation?

Scenario D: Partial refund fails (charged $100, refund $50 fails)
→ Retry refund? Manual intervention? Notify admin?

Scenario E: Database write succeeds, email send fails
→ Order created but customer unaware? Retry email?
```

**Pattern**: External call → simulate failure → recovery strategy?

---

### 5. Boundary Conditions (Min/Max/Edges)

**Test**: Limits and ranges

```
Feature: "Customer enters quantity"

Scenario A: Quantity = 0
→ Validation error? Or allowed (remove item)?

Scenario B: Quantity = 1
→ Minimum valid, should work

Scenario C: Quantity = 999
→ Within stock? Shipping implications?

Scenario D: Quantity = 10,000
→ Bulk order discount? Stock availability? Fraud check?

Scenario E: Quantity = -5
→ Validation blocks negative? Or backend crashes?

Scenario F: Quantity = 3.5
→ Decimal allowed? Or integers only?
```

**Pattern**: Test min, max, negative, decimal, zero, huge

---

### 6. Data Validity (Valid/Invalid/Missing)

**Test**: Input validation

```
Feature: "Customer enters email"

Scenario A (Valid): user@example.com
→ Accepts, normalizes?

Scenario B (Invalid format): notanemail
→ Validation error with message?

Scenario C (Missing @): userexample.com
→ Validation catches?

Scenario D (Multiple @): user@@example.com
→ Validation catches?

Scenario E (Empty): ""
→ Required field error?

Scenario F (Null): null
→ Backend crashes? Or handled gracefully?

Scenario G (SQL injection): admin'--
→ Sanitized? Or vulnerability?

Scenario H (XSS): <script>alert(1)</script>
→ Escaped? Or XSS vulnerability?
```

**Pattern**: Valid, invalid format, missing, malicious

---

### 7. Permissions (Who Can Do What)

**Test**: Authorization boundaries

```
Feature: "Users can view orders"

Scenario A: Customer views own order
→ Allowed, shows order

Scenario B: Customer views another customer's order
→ Blocked with 403? Or 404 (hide existence)?

Scenario C: Admin views any order
→ Allowed? Audit logged?

Scenario D: Guest (not logged in) views order
→ Blocked? Or public orders exist?

Scenario E: Customer views order after account deletion
→ Order data preserved? Or deleted with account?

Scenario F: Suspended customer views order
→ Allowed (historical data)? Or blocked (suspended=no access)?
```

**Pattern**: Actor matrix → resource → expected access level

---

### 8. Time-Based (Expiry/Delays/Scheduling)

**Test**: Temporal constraints

```
Feature: "Cart expires after 30 minutes"

Scenario A: Customer checks out at 29 minutes
→ Succeeds, cart converted to order

Scenario B: Customer checks out at 31 minutes
→ Blocked? Cart cleared? Or grace period?

Scenario C: Customer adds item at 29:59, checks out at 30:01
→ Recent activity extends expiry? Or still expires?

Scenario D: Customer has cart, goes offline 60 minutes, returns
→ Cart cleared? Or persisted indefinitely?

Scenario E: Promo code expires while cart active
→ Remove promo? Keep it (was valid when added)?

Scenario F: Product goes out of stock while in cart
→ Cart item blocked at checkout? Or removed automatically?
```

**Pattern**: Time-based rule → test before/at/after threshold

---

## Scenario Invention Process

### Step 1: Identify Feature

```
User statement: "Customers can add items to wishlist"
```

### Step 2: Pick 3-5 Dimensions

```
Most relevant for wishlists:
1. Volume (how many items?)
2. Duplicates (same item twice?)
3. Permissions (who can view wishlist?)
4. Persistence (delete account → wishlist?)
5. Item state changes (out of stock item in wishlist?)
```

### Step 3: Create Scenario Per Dimension

```
Scenario 1 (Volume): Customer adds 1000 items to wishlist
→ Limit? Performance? UI pagination?

Scenario 2 (Duplicates): Customer adds same item twice
→ Duplicate entry? Or increment quantity?

Scenario 3 (Permissions): Customer views another's wishlist
→ Public? Private? Shareable link?

Scenario 4 (Persistence): Customer deletes account
→ Wishlist deleted? Preserved? Anonymized?

Scenario 5 (Item state): Wishlist item goes out of stock
→ Remove from wishlist? Mark unavailable? Keep?
```

### Step 4: Present and Probe

```
Agent: "Let's test edge cases:

Scenario 1: Customer adds 500 items to wishlist.
Is there a limit? If not, how does UI handle?

[Wait for answer, note decision]

Scenario 2: Customer adds same book twice.
Duplicate wishlist entry? Or quantity field?

[Continue...]"
```

---

## Scenario Templates

### Template 1: State Machine

```
Feature: {Entity} has states {A, B, C}

Scenario: Trigger {action} while in each state
- State A → Action → Expected?
- State B → Action → Expected?
- State C → Action → Expected?
```

**Example**:
```
Feature: Order has states (pending, paid, shipped)

Scenario: Customer cancels while in each state
- Pending → Cancel → Allowed, refund not needed
- Paid → Cancel → Allowed, refund issued
- Shipped → Cancel → Blocked, must request return
```

---

### Template 2: Multi-Actor

```
Feature: {Action} by {Actor}

Scenario: Different actors attempt {action}
- Actor A → Expected behavior?
- Actor B → Expected behavior?
- Actor C → Blocked? Allowed? Partial?
```

**Example**:
```
Feature: Edit order

Scenario: Different actors edit order
- Customer → Can edit address before shipment
- Admin → Can edit any field, audit logged
- Guest → Blocked, not authenticated
- Deleted account → Blocked, account gone
```

---

### Template 3: Time-Based

```
Feature: {Rule} applies for {duration}

Scenario: Test before, during, after threshold
- Before deadline → Expected?
- At exact deadline → Edge case handling?
- After deadline → Expected?
- Way after deadline → Cleanup/archival?
```

**Example**:
```
Feature: Order cancellable for 24 hours

Scenario: Cancel at different times
- Cancel at 23 hours → Succeeds
- Cancel at 24 hours exactly → Edge case (succeeds or fails?)
- Cancel at 25 hours → Blocked
- Cancel at 30 days → Order archived, block with message?
```

---

### Template 4: Failure Recovery

```
Feature: {Action} requires {external dependency}

Scenario: Dependency fails at different stages
- Before call → Preventable? Graceful error?
- During call → Timeout handling?
- After call (partial) → Rollback? Retry?
- Webhook miss → Reconciliation?
```

**Example**:
```
Feature: Payment processing

Scenario: Payment gateway failures
- Gateway down before call → Show error, save cart
- Timeout during call → Retry? Give up after 3?
- Payment succeeds, webhook fails → Reconcile via polling?
- Refund call fails → Queue for retry? Alert admin?
```

---

## Presenting Scenarios

### Format

```
Agent: "Scenario {N}: {Brief description}

Setup:
- {Initial state}
- {Actor + action}

Question:
- What happens?
- What's the expected outcome?

[If relevant]
Alternatives:
A) {Option 1}
B) {Option 2}
C) {Option 3}

Recommendation: {Your pick} because {reason}

Agree?"
```

### Example

```
Agent: "Scenario 3: Customer cancels order after shipment

Setup:
- Order status: Shipped (tracking number assigned)
- Customer clicks 'Cancel Order' button

Question:
- Is cancellation allowed at this point?

Alternatives:
A) Block cancel, show message: 'Cannot cancel shipped orders'
B) Allow cancel, trigger return flow instead
C) Allow cancel, shipping continues but refund issued

Recommendation: Option A (block) because:
- Shipped orders can't be recalled from carrier
- Return flow is separate process (with different rules)
- Prevents confusion between cancel and return

Agree?"
```

---

## Scenario Clustering

**Group related scenarios** to avoid repetition:

### Cluster 1: Permission Variations

```
Feature: View order details

Scenarios (permission matrix):
- Own order → Allow
- Other's order → Block (403)
- Admin viewing any → Allow (with audit)
- Deleted account → Block (410 Gone)
```

**Present as table**:
```
Actor          | Own Order | Other's Order | Result
---------------|-----------|---------------|--------
Customer       | ✓ Allow   | ✗ Block       | 200 / 403
Admin          | ✓ Allow   | ✓ Allow       | 200 (audit)
Deleted Acct   | ✗ Block   | ✗ Block       | 410
```

### Cluster 2: Time Progression

```
Feature: Cart expiry after 30 minutes

Scenarios (time progression):
T=0min  → Add item, cart active
T=29min → Still active, can checkout
T=30min → Expiry threshold (edge case!)
T=31min → Expired, cart cleared
T=60min → Way past expiry, definitely cleared
```

**Present as timeline**:
```
0 ----29---- [30] ----31---------60--> minutes
|      |       |       |          |
Add   Active  Edge?  Expired   Cleared
```

---

## Red Flags in Responses

### User Says "I Don't Know"

```
Agent: "Scenario: Cancel after shipment?"
User: "I don't know..."

Action: Flag as decision point
Agent: "This is critical - affects customer satisfaction + costs.
       We need to decide before implementing.
       
       Options:
       A) Research how competitors handle it
       B) Design both paths (block vs allow)
       C) Escalate to product owner
       
       Which?"
```

### User Says "It Depends"

```
Agent: "Scenario: Customer edits address after order placed?"
User: "It depends on the order status..."

Action: Probe the dependency
Agent: "OK, let's map it:
       - Pending orders → Address editable? (Y/N)
       - Paid orders → Address editable? (Y/N)
       - Shipped orders → Address editable? (Y/N)
       
       For each Yes, what validation/constraints?"
```

### User Gives Conflicting Answers

```
Earlier: "Orders are immutable after payment"
Now: "Customers can change addresses after paying"

Action: Surface conflict
Agent: "CONFLICT:
       Earlier you said 'orders immutable after payment'
       Now you said 'address editable after paying'
       
       Address is part of order - which rule wins?
       A) Address is exception to immutability
       B) Original statement was too broad
       C) Different timing (paid ≠ processed)"
```

---

## Coverage Checklist

Before ending scenario testing:

- [ ] **Timing**: Before/during/after critical states
- [ ] **Volume**: Zero, one, many, maximum cases
- [ ] **Permissions**: Different actor access levels
- [ ] **Failures**: External dependencies fail
- [ ] **Boundaries**: Min/max/invalid data
- [ ] **Conflicts**: Concurrent actions, races
- [ ] **Time-based**: Expiry, delays, scheduling
- [ ] **State changes**: All state transitions tested

**Don't need ALL dimensions** for every feature. Pick 3-5 most relevant.

---

## Integration with Grilling

### Phase 1: Understand Feature (Abstract)

```
User: "Customers can cancel orders"
Agent: Clarifies WHO, WHAT, WHEN (abstract discussion)
```

### Phase 2: Stress-Test with Scenarios (Concrete)

```
Agent: Now introduces 5 concrete scenarios to expose edge cases
→ Cancel after payment?
→ Cancel after shipment?
→ Cancel with promo code?
→ Cancel 100 orders in 1 day?
→ Cancel order with custom item?
```

### Phase 3: Document Decisions

```
Agent: Updates CONTEXT.md with clarified terms
Agent: Creates ADR if scenario revealed hard-to-reverse decision
```

**Scenarios bridge abstract → concrete → documented.**

---

## Common Mistakes

### ❌ Too Many Scenarios

```
Agent: "Here are 50 scenarios to consider..."
User: *Overwhelmed*
```

**Fix**: 3-5 scenarios per feature, most critical dimensions only.

---

### ❌ Irrelevant Scenarios

```
Feature: "Customer adds item to cart"
Agent: "Scenario: What if database catches fire?"
```

**Fix**: Realistic edge cases, not absurd ones.

---

### ❌ Not Waiting for Answers

```
Agent: "Scenario 1: X?  Scenario 2: Y?  Scenario 3: Z?"
User: *Can't process all at once*
```

**Fix**: One scenario, wait for answer, next scenario.

---

### ❌ Accepting "I'll Figure It Out Later"

```
Agent: "Scenario: Cancel after shipment?"
User: "I'll decide that during implementation"
❌ Agent: "OK, moving on"
```

**Fix**: Flag as blocker.
```
✅ Agent: "This affects refund logic and customer support flow.
         We need decision NOW, or it becomes technical debt.
         Can we decide this in next 5 minutes?"
```

---

## The Bottom Line

```
8 Dimensions: Timing, Volume, Conflicts, Failures, Boundaries,
             Data validity, Permissions, Time-based

Pick 3-5 most relevant
Invent concrete scenarios
Present one at a time
Wait for answers
Document decisions

Scenarios expose fuzzy requirements before they become bugs.
```

---

**Related**: [SKILL.md](./SKILL.md), [INTERVIEW-PROTOCOL.md](./INTERVIEW-PROTOCOL.md)  
**Source**: Matt Pocock stress-testing approach + Prodige systematic validation  
**Version**: 2.0

