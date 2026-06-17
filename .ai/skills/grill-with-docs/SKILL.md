---
name: grill-with-docs
description: Design interview that challenges plans against domain model and documented decisions. Sharpens terminology, stress-tests scenarios, and updates CONTEXT.md and ADRs inline. Use before /design or /build to validate requirements and align on vocabulary.
triggers: [grill, grill-me, stress-test, challenge design, validate requirements]
auto_load: []
mandatory: false
applies_to: [architect, backend, frontend, qa]
---

# Grill-with-Docs

Interview relentlessly until shared understanding is reached.

**Core insight**: The #1 failure mode in software development is misalignment. You think you know what to build - then you see the result and realize the understanding was different.

**Fix**: Get grilled BEFORE coding. Walk every branch of the decision tree.

---

## The Iron Law

```
NEVER START CODING WITHOUT SHARED UNDERSTANDING
```

Fuzzy requirements → wasted implementation → rework.  
Sharp requirements → clean implementation → done right.

---

## When to Use

**Always use when**:
- About to start new feature (`/design` workflow)
- Requirements feel fuzzy or vague
- User says "I think..." or "maybe..." about requirements
- Multiple interpretations possible
- Domain concepts unclear

**Especially use when**:
- Modifying existing domain model
- Adding new domain concepts
- User uses unfamiliar terminology
- Conflicting terminology appears
- Architecture decision needed

**Don't use when**:
- Requirements crystal clear (rare)
- Fixing obvious bug with known cause
- Simple refactoring with no behavior change
- Implementing well-specified task

---

## The Protocol

### Phase 1: Initial Question

**User states intent**:
```
User: "I want to add partial order cancellation"
```

**Agent loads domain context**:
- Read `CONTEXT.md` (domain glossary)
- Read `docs/adr/*.md` (architecture decisions)
- Read relevant code (if exists)

### Phase 2: Challenge Against Domain

**Check for conflicts**:
```
Agent: "Your CONTEXT.md defines 'Cancellation' as
       'Fully cancelling an Order and refunding all items.'
       But you're saying 'partial' cancellation.
       
       Is this a NEW concept (PartialCancellation) or
       should we update the existing Cancellation definition?"
```

**Wait for answer. Resolve before continuing.**

### Phase 3: Sharpen Fuzzy Language

**Challenge vague terms**:
```
User: "The user can cancel items..."

Agent: "Clarify: You're using 'user' - but your CONTEXT.md has
       both 'Customer' (person who places orders) and 
       'Admin' (person who manages system).
       
       Which can cancel items? Both? Just Customer?"
```

**Propose precise canonical term**:
```
Agent: "I recommend: 'Customer can cancel LineItems from pending Orders'
       → Adds 'cancel' capability to Customer
       → Introduces 'LineItem' as cancellable unit
       → Constrains to 'pending' status only
       
       Agree?"
```

### Phase 4: Stress-Test with Scenarios

**Invent edge cases**:
```
Agent: "Scenario 1: Customer cancels 2 of 3 items.
       What happens to shipping cost? Still charged? Recalculated?
       
       Scenario 2: Customer cancels last item.
       Does the entire Order get cancelled? Or empty Order persists?
       
       Scenario 3: Item already shipped but Customer cancels it.
       Can they? Or is cancellation blocked after shipment starts?"
```

**Force precision on boundaries**:
```
Agent: "You said 'pending Orders' - define 'pending':
       - Payment not yet processed?
       - Payment processed but not shipped?
       - Payment processed but not delivered?
       
       Each has different cancellation implications."
```

### Phase 5: Cross-Reference with Code

**Check code vs stated behavior**:
```
Agent: *Reads OrderService.cancel()*

Agent: "Code shows Order.cancel() marks entire order as cancelled,
       no partial cancellation logic exists.
       
       You said 'partial cancellation is possible' - which is right?
       
       A) Code is wrong, needs update (partial cancellation is new feature)
       B) You misspoke, only full cancellation exists
       C) Partial happens differently (how?)"
```

### Phase 6: Update Documentation Inline

**When term is resolved, update immediately**:

```markdown
Agent: "Adding to CONTEXT.md:"

**LineItem**:
A single product within an Order, with quantity and price.
_Avoid_: OrderLine, CartItem, Product

**PartialCancellation**:
Cancelling some (not all) LineItems from a pending Order,
refunding only the cancelled items.
_Avoid_: Item cancellation, selective refund
```

**When ADR criteria met, create ADR**:

```markdown
Agent: "This meets ADR criteria:
       ✓ Hard to reverse (refund logic is complex)
       ✓ Surprising (most systems don't allow partial)
       ✓ Real trade-off (simplicity vs flexibility)
       
       Create ADR-0007-partial-cancellation?"

User: "Yes"

Agent: *Creates docs/adr/0007-partial-cancellation.md*

# Allow Partial Order Cancellation

Customers can cancel individual LineItems from pending Orders
instead of cancelling entire Order. Trade-off: more complex
refund logic, but better customer experience.
```

---

## Question Strategies

### 1. Challenge Assumptions

```
❌ Accept:    "OK, I'll add order cancellation"
✅ Challenge: "What triggers cancellation? Customer? Admin? Timeout?
             Can all Orders be cancelled or only certain states?"
```

### 2. Probe Boundaries

```
❌ Accept:    "Users can edit their profile"
✅ Probe:     "Edit which fields? Email? Password? Both?
             Can they edit payment methods? Addresses?
             Where's the boundary of 'profile'?"
```

### 3. Invent Scenarios

```
❌ Accept:    "Customers have a wishlist"
✅ Scenario:  "Customer adds 100 items to wishlist - is there a limit?
             Customer adds same item twice - duplicate or increment?
             Customer deletes account - wishlist deleted or preserved?"
```

### 4. Check Consistency

```
❌ Accept:    "Orders have status: pending, confirmed, shipped"
✅ Check:     "CONTEXT.md defines OrderStatus as: pending, paid, fulfilled.
             Your list uses different terms ('confirmed' vs 'paid').
             Which is correct?"
```

### 5. Force Specificity

```
❌ Accept:    "The system sends notifications"
✅ Force:     "Via email? SMS? Push notification? All three?
             Immediately or batched? Retries on failure?
             Who receives: Customer? Admin? Both?"
```

---

## Integration with Prodige

### Before `/design` Workflow

```
User: "I want to add feature X"
Agent: "Let me grill you first to clarify requirements"
Agent: *Runs grill-with-docs*
Agent: *Updates CONTEXT.md, creates ADRs*
Agent: "Requirements clear. Ready for /design?"
```

### During `/design` Workflow

```
Architect: "Requirement is fuzzy: 'users can manage stuff'"
Architect: *Runs grill-with-docs inline*
Architect: Clarifies "Customer can edit Addresses via ProfilePage"
Architect: *Updates CONTEXT.md*
Architect: *Continues with design*
```

### Standalone (User-Triggered)

```
User: "/grill-me on partial order cancellation"
Agent: *Runs full grilling session*
Agent: *Documents domain concepts*
Agent: *Creates ADRs if needed*
Agent: "Grilling complete. Proceed with /design?"
```

---

## Domain Awareness

### File Structure Detection

**Single context repo**:
```
/
├── CONTEXT.md            ← Load this
├── docs/adr/*.md         ← Check for ADRs
└── src/
```

**Multi-context repo** (has CONTEXT-MAP.md):
```
/
├── CONTEXT-MAP.md        ← Read to find contexts
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md    ← Load relevant context
│   │   └── docs/adr/*.md
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/*.md
```

**Action**: Read CONTEXT-MAP.md → Identify relevant context → Load that CONTEXT.md

### Lazy Creation

**Don't create files upfront.**

Create when needed:
- `CONTEXT.md` → When first term needs definition
- `docs/adr/` → When first ADR needed
- `CONTEXT-MAP.md` → When second bounded context identified

---

## Documentation Updates

### Update CONTEXT.md Inline

**DON'T batch**:
```
❌ "I'll update docs at the end of the session"
→ Risk: Forget, or user stops session early
```

**DO immediately**:
```
✅ "Resolved: LineItem = single product in Order"
✅ "Adding to CONTEXT.md now..."
✅ *Updates file*
✅ "Next question..."
```

**Format** (from CONTEXT-FORMAT.md):
```markdown
**TermName**:
One or two sentence definition.
_Avoid_: Alternative1, Alternative2
```

**What belongs**: Domain-specific terms only (not general programming)

### Create ADRs Sparingly

**3 criteria (ALL must be true)**:
1. **Hard to reverse** - Meaningful cost to change later
2. **Surprising** - Future reader will wonder "why?"
3. **Real trade-off** - Genuine alternatives existed

**Example that qualifies**:
```
Decision: Partial cancellation allowed (NOT full-only)
→ Hard to reverse: Refund logic, accounting complexity
→ Surprising: Most systems only allow full cancellation
→ Trade-off: Flexibility vs simplicity
→ CREATE ADR
```

**Example that doesn't qualify**:
```
Decision: Use POST for create endpoint
→ Not surprising: Standard REST practice
→ No trade-off: HTTP semantics dictate this
→ SKIP ADR
```

**Format** (from ADR-FORMAT.md):
```markdown
# {Decision Title}

{1-3 sentences: context, decision, why, trade-off}
```

**File**: `docs/adr/NNNN-slug.md` (sequential numbering)

→ See [SCENARIO-TESTING.md](./SCENARIO-TESTING.md) for edge case strategies

---

## Agent-Specific Guidelines

### Architect (Primary User)

**When**: Before `/design`, during requirements gathering

**Focus**:
- Domain model clarity
- Architecture decisions (ADR candidates)
- Cross-context boundaries (if multi-context)

**Output**: Updated CONTEXT.md, ADRs created, clear requirements

### Backend Agent

**When**: Clarifying API design or business logic

**Focus**:
- Data model terminology
- Business rule edge cases
- Integration patterns

**Output**: Sharp API contracts, edge cases documented

### Frontend Agent

**When**: Clarifying UI terminology or user flows

**Focus**:
- User-facing terminology (Customer vs User vs Admin)
- User action boundaries (what can they do?)
- State transitions

**Output**: Consistent UI terminology, clear user capabilities

### QA Agent

**When**: Writing test scenarios

**Focus**:
- Edge case scenarios (grilling uncovers these)
- Boundary conditions
- Error cases

**Output**: Comprehensive test scenarios from grilling

---

## Deep Dive Resources

**Interview Protocol** - Question strategies and techniques  
→ See [INTERVIEW-PROTOCOL.md](./INTERVIEW-PROTOCOL.md)

**Scenario Testing** - Edge case invention and stress-testing  
→ See [SCENARIO-TESTING.md](./SCENARIO-TESTING.md)

---

## Verification Checklist

Before ending grilling session:

- [ ] All fuzzy terms clarified
- [ ] Domain concepts have precise definitions
- [ ] Edge cases discussed (at least 3 scenarios)
- [ ] Code cross-referenced (if exists)
- [ ] CONTEXT.md updated (if new terms resolved)
- [ ] ADRs created (if criteria met)
- [ ] User says "Yes, that's clear" (not "I think so...")

**If user still says "maybe" or "probably" → Keep grilling.**

---

## Red Flags - Keep Grilling

User says:
- "I think..." → Not certain, probe deeper
- "Maybe..." → Multiple interpretations, clarify
- "Probably..." → Assumptions, verify
- "Something like..." → Vague, force specificity
- "The usual way..." → What usual? Be explicit
- "You know what I mean..." → Don't assume, confirm

**Agent should not accept vague language. Challenge everything.**

---

## When to Stop

Stop when:
- User gives precise, confident answers
- Domain concepts clearly defined
- Edge cases resolved
- No more "maybe" or "I think"
- User says "Yes, that's exactly right"

**Test**: Can you implement this RIGHT NOW without asking more questions?
- If YES → Grilling complete
- If NO → Keep grilling

---

## Final Rule

```
Fuzzy in → fuzzy out
Sharp in → sharp out

Your job: Convert fuzzy → sharp BEFORE coding
```

No exceptions. Misalignment is expensive. Grilling is cheap.

---

**Related Skills**: design, verification-before-completion, context-sync  
**Enforcement**: Recommended before all `/design` workflows  
**Version**: 2.0 (Synthesized: Matt Pocock grill-with-docs + Prodige workflow)

