# Refactoring in TDD

**The Golden Rule**: Only refactor after GREEN. Never refactor on RED.

---

## Why Wait for GREEN?

Red → Green → **Refactor**

Refactoring without passing tests = changing broken code. You can't tell if your "improvement" broke something or if it was already broken.

**Discipline**: If you see ugly code while on RED, make a note and wait. Fix the test first.

---

## The Refactoring Window

```
✅ Safe Zone:     Tests pass, all green
❌ Danger Zone:   Tests fail, red or yellow
```

### Safe Refactoring Cycle

```
1. All tests GREEN
2. Make ONE refactoring change
3. Run tests immediately
4. Still GREEN? Continue
5. Turned RED? Undo and try smaller
```

**Key insight**: Refactor in tiny steps. Each step keeps tests green.

---

## What to Refactor

### 1. Duplication

**Smell**: Same logic in multiple places

```typescript
// BEFORE: Duplication
function validateUserEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validateAdminEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// AFTER: Extract common
function isValidEmailFormat(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validateUserEmail(email) {
  return isValidEmailFormat(email);
}

function validateAdminEmail(email) {
  return isValidEmailFormat(email) && email.endsWith('@company.com');
}
```

**Action**: Extract function/class/constant

---

### 2. Long Methods

**Smell**: Function does too many things

```typescript
// BEFORE: Long method
function processOrder(order) {
  // Validate order (10 lines)
  if (!order.items || order.items.length === 0) {
    throw new Error('Empty order');
  }
  // Calculate totals (15 lines)
  let subtotal = 0;
  for (const item of order.items) {
    subtotal += item.price * item.quantity;
  }
  // Apply discounts (20 lines)
  let discount = 0;
  if (order.coupon) {
    // complex discount logic
  }
  // Save to database (10 lines)
  // ... more code
}

// AFTER: Break into helpers
function processOrder(order) {
  validateOrder(order);
  const subtotal = calculateSubtotal(order.items);
  const discount = applyDiscounts(order);
  const total = subtotal - discount;
  return saveOrder({ ...order, total });
}

// Private helpers (test through public interface)
function validateOrder(order) { /* ... */ }
function calculateSubtotal(items) { /* ... */ }
function applyDiscounts(order) { /* ... */ }
```

**Action**: Break into private helpers. Keep tests on public interface.

**Important**: Don't test private helpers directly. They're implementation details.

---

### 3. Shallow Modules

**Smell**: Class/module that's just a thin wrapper

```typescript
// BEFORE: Shallow
class EmailValidator {
  validate(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}

// AFTER: Inline if it's just one line
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// OR: Deepen if it needs real logic
class EmailValidator {
  constructor(private allowedDomains: string[]) {}
  
  validate(email) {
    const validFormat = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    const domain = email.split('@')[1];
    const allowedDomain = this.allowedDomains.includes(domain);
    return validFormat && allowedDomain;
  }
}
```

**Action**: Combine shallow modules or deepen them with real functionality.

---

### 4. Feature Envy

**Smell**: Function uses data from another class more than its own

```typescript
// BEFORE: Feature envy
class OrderService {
  calculateTotal(order) {
    let total = 0;
    for (const item of order.items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}

// AFTER: Move to where data lives
class Order {
  calculateTotal() {
    return this.items.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );
  }
}

class OrderService {
  processOrder(order) {
    const total = order.calculateTotal(); // Delegate
    // ... rest of processing
  }
}
```

**Action**: Move logic to where the data lives.

---

### 5. Primitive Obsession

**Smell**: Using primitive types for domain concepts

```typescript
// BEFORE: Primitives
function createUser(email: string, age: number) {
  if (!email.includes('@')) throw new Error('Invalid email');
  if (age < 0) throw new Error('Invalid age');
  // ... create user
}

// AFTER: Value objects
class Email {
  constructor(private value: string) {
    if (!value.includes('@')) throw new Error('Invalid email');
  }
  toString() { return this.value; }
}

class Age {
  constructor(private value: number) {
    if (value < 0) throw new Error('Invalid age');
  }
  toNumber() { return this.value; }
}

function createUser(email: Email, age: Age) {
  // Validation already done in value objects
  // ... create user
}
```

**Action**: Introduce value objects for domain concepts.

---

### 6. Existing Code Problems

**Smell**: New code reveals problems in old code

```typescript
// NEW code you just wrote
function scheduleAppointment(doctor, patient, time) {
  if (!isAvailable(doctor, time)) {
    throw new Error('Doctor not available');
  }
  // ... schedule logic
}

// REVEALS: Existing code has same pattern
function scheduleConsultation(doctor, patient, time) {
  if (!isAvailable(doctor, time)) {
    throw new Error('Doctor not available');
  }
  // ... similar logic
}

// REFACTOR: Extract shared behavior
function createBooking(type, doctor, patient, time) {
  ensureDoctorAvailable(doctor, time);
  return saveBooking({ type, doctor, patient, time });
}

function scheduleAppointment(doctor, patient, time) {
  return createBooking('appointment', doctor, patient, time);
}

function scheduleConsultation(doctor, patient, time) {
  return createBooking('consultation', doctor, patient, time);
}
```

**Action**: When new code exposes duplication, refactor both old and new together.

---

## Refactoring Safety Rules

### Rule 1: Keep Tests GREEN
Run tests after **every** refactoring change. If red, undo immediately.

### Rule 2: One Thing at a Time
Change ONE thing. Test. Change next thing. Test.

Don't:
```
Extract function + rename variables + reorder code
```

Do:
```
Extract function → test → rename → test → reorder → test
```

### Rule 3: No Behavior Changes
Refactoring changes structure, not behavior. If behavior changes, that's a new feature (needs new test).

### Rule 4: Don't Test Private Helpers
Refactored private functions? Don't add tests for them. Test through public interface.

```typescript
// WRONG: Testing private helper
test('_calculateSubtotal returns correct sum', () => {
  expect(service._calculateSubtotal([...])).toBe(100);
});

// RIGHT: Test through public interface
test('processOrder calculates correct total', () => {
  const result = service.processOrder({ items: [...] });
  expect(result.total).toBe(100);
});
```

### Rule 5: Commit After Each Refactor
Small, green commits. Easy to rollback if needed.

---

## When NOT to Refactor

### Skip If:
- **Tests are RED** → Fix failing test first
- **No tests exist** → Write tests first (TDD)
- **About to ship** → Risk is too high
- **Unclear improvement** → Leave it alone

### "It bothers me" ≠ needs refactoring

Refactor when:
- Code is hard to understand
- Changes are hard to make
- Bugs keep appearing

Don't refactor just because you would have written it differently.

---

## Refactoring Workflow

```
┌─────────────────────────────────────┐
│ 1. All tests GREEN                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 2. Identify refactor candidate      │
│    • Duplication                    │
│    • Long method                    │
│    • Feature envy                   │
│    • etc.                           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 3. Make ONE small change            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 4. Run tests immediately            │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
    ┌─────┐        ┌──────┐
    │GREEN│        │ RED  │
    └──┬──┘        └──┬───┘
       │              │
       │              ▼
       │         ┌─────────┐
       │         │ UNDO    │
       │         │ change  │
       │         └─────────┘
       │
       ▼
┌─────────────────────────────────────┐
│ 5. Commit or continue next change   │
└─────────────────────────────────────┘
```

---

## Common Refactoring Moves

### Extract Function
```typescript
// BEFORE
function analyze(data) {
  // 50 lines of code
}

// AFTER
function analyze(data) {
  const cleaned = cleanData(data);
  const validated = validateData(cleaned);
  return processData(validated);
}
```

### Inline Function
```typescript
// BEFORE
function getRating() { return this.rating; }
function moreThanFiveLateDeliveries() {
  return this.getLateDeliveries() > 5;
}

// AFTER
function moreThanFiveLateDeliveries() {
  return this.rating > 5; // Inline if trivial
}
```

### Extract Variable
```typescript
// BEFORE
return order.quantity * order.itemPrice - 
  Math.max(0, order.quantity - 500) * order.itemPrice * 0.05;

// AFTER
const basePrice = order.quantity * order.itemPrice;
const quantityDiscount = Math.max(0, order.quantity - 500) * order.itemPrice * 0.05;
return basePrice - quantityDiscount;
```

### Rename Variable/Function
```typescript
// BEFORE
function calc(d) {
  return d * 0.9;
}

// AFTER
function calculateDiscountedPrice(originalPrice) {
  return originalPrice * 0.9;
}
```

### Move Function
```typescript
// BEFORE
class Order {
  get discountedPrice() {
    return this.basePrice * this.getDiscountRate();
  }
  getDiscountRate() {
    return this.customer.loyaltyYears > 5 ? 0.1 : 0;
  }
}

// AFTER
class Customer {
  getDiscountRate() {
    return this.loyaltyYears > 5 ? 0.1 : 0;
  }
}

class Order {
  get discountedPrice() {
    return this.basePrice * this.customer.getDiscountRate();
  }
}
```

---

## Integration with TDD Cycle

```
RED → GREEN → [REFACTOR] → RED → GREEN → [REFACTOR] → ...
             ↑                          ↑
         Do it here               And here
```

### Timing

**After GREEN**:
1. Look at code you just wrote
2. Look for refactor candidates (above list)
3. If found, refactor now
4. Run tests after each change
5. Commit when satisfied

**Before next RED**:
- Clean slate for next test
- No technical debt carried forward

### Skipping Refactoring

Sometimes it's OK to skip refactoring:
- Code is already clean
- Can't see obvious improvement
- Time-boxed and need to move on

But **never skip** if:
- Duplication is obvious
- Next test will be harder without cleanup
- You're about to copy-paste

---

## Agent Guidelines

### When You Spot Refactor Candidate

**During RED phase**:
```
❌ DON'T refactor now
✅ Make note: "After GREEN, extract validateEmail function"
```

**During GREEN phase**:
```
❌ DON'T refactor while writing minimal code
✅ Focus on passing test
```

**After GREEN phase**:
```
✅ NOW refactor
✅ Check your notes
✅ Run tests after each change
```

### Communicating Refactorings

To human:
```
"Tests passing. Refactoring to extract duplicate validation logic.
Running tests after each change."
```

In commit message:
```
refactor: extract email validation into reusable function

All tests still green. No behavior changes.
```

---

## Anti-Pattern: Refactoring on RED

```
❌ WRONG SEQUENCE:
1. Write failing test
2. "While I'm here, let me clean up..."
3. Now test fails for 2 reasons

✅ RIGHT SEQUENCE:
1. Write failing test
2. Make it pass (even ugly)
3. Clean up now that it's green
```

**Why this matters**: If test fails after refactoring, you don't know if bug is in new code or refactoring.

---

## Verification

Before claiming refactoring complete:

- [ ] All tests still GREEN
- [ ] No behavior changes
- [ ] Code is more maintainable than before
- [ ] Didn't add tests for private helpers
- [ ] Each change was tested immediately
- [ ] Can explain what improved

---

## Final Rule

```
Refactor only after GREEN
Test after every change
If RED appears → undo immediately
```

Always be ready to throw away a refactoring if it breaks tests.

---

**Related**: [SKILL.md](./SKILL.md), [PHILOSOPHY.md](./PHILOSOPHY.md), [ANTI-PATTERNS.md](./ANTI-PATTERNS.md)  
**Source**: Matt Pocock TDD philosophy + Prodige discipline  
**Version**: 2.0

