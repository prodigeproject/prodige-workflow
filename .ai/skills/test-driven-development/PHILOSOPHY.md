# TDD Philosophy: Behavior vs Implementation

**Core Principle**: Tests should verify behavior through public interfaces, not implementation details.

Code can change entirely; tests shouldn't.

---

## Good Tests: Integration-Style

**Good tests** exercise real code paths through public APIs.

They describe **WHAT** the system does, not **HOW** it does it.

### Characteristics

✅ **Test behavior users/callers care about**
```typescript
// User cares: "Can I checkout with valid cart?"
test('user can checkout with valid cart', async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe('confirmed');
});
```

✅ **Use public API only**
- Call functions/methods as users would
- Don't access private methods or internal state
- Don't mock internal collaborators

✅ **Survive internal refactors**
```typescript
// You refactor checkout() internals:
// - Change from function to class
// - Split into multiple internal functions  
// - Rewrite algorithm entirely

// Test still passes! It only cares about behavior.
```

✅ **Read like specifications**
```
"user can checkout with valid cart"
"user sees error for invalid payment"
"order total includes tax and shipping"
```

These tell you exactly what capabilities exist.

---

## Bad Tests: Implementation-Coupled

**Bad tests** are coupled to internal structure.

### Warning Signs

❌ **Mocking internal collaborators**
```typescript
// BAD: Testing HOW, not WHAT
test('checkout calls paymentService.process', async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Problem: Refactoring checkout breaks test even if behavior unchanged.

❌ **Testing private methods**
```typescript
// BAD: Testing internals
test('_calculateTax returns correct value', () => {
  const order = new Order();
  expect(order._calculateTax(100)).toBe(10);
});
```

Problem: Private methods are implementation details.

❌ **Verifying through external means**
```typescript
// BAD: Bypassing interface
test('createUser saves to database', async () => {
  await createUser({ name: 'Alice' });
  const row = await db.query('SELECT * FROM users WHERE name = ?', ['Alice']);
  expect(row).toBeDefined();
});

// GOOD: Verifying through interface
test('createUser makes user retrievable', async () => {
  const user = await createUser({ name: 'Alice' });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe('Alice');
});
```

❌ **Test breaks when refactoring without behavior change**
```typescript
// You rename internal function
// Tests fail even though behavior identical
// → Tests were testing implementation
```

---

## The Test Resilience Test

Ask: **"If I rename an internal function, does this test break?"**

- **YES** → Test is coupled to implementation
- **NO** → Test verifies behavior ✓

---

## Why This Matters

### Implementation-Coupled Tests
```
Refactor code → Tests break → Rewrite tests → Wasted time
False confidence (tests pass but behavior broken)
High maintenance burden
```

### Behavior-Focused Tests
```
Refactor code → Tests still pass → Confidence
True safety net (tests fail when behavior breaks)
Low maintenance burden
```

---

## Practical Guidelines

### 1. Test Through Public Interfaces

```typescript
// Your module exports
export class UserService {
  async createUser(data) { ... }
  async getUser(id) { ... }
  private async _validateEmail(email) { ... }  // Private!
}

// Test only public methods
test('creates user with valid data', async () => {
  const service = new UserService();
  const user = await service.createUser({ email: 'test@example.com' });
  expect(user).toBeDefined();
});

// Don't test private methods
// test('_validateEmail ...') ← NO!
```

### 2. Minimize Mocks

Mock only at **system boundaries**:
- External APIs (Stripe, SendGrid)
- Databases (or use test database)
- Time/randomness
- File system

Don't mock your own code.

```typescript
// GOOD: Mock external service
const mockStripe = {
  charge: jest.fn().mockResolvedValue({ success: true })
};

await processPayment(order, mockStripe);

// BAD: Mock your internal service
const mockOrderService = jest.mock('./OrderService');
```

### 3. One Logical Assertion Per Test

```typescript
// GOOD: One behavior tested
test('checkout succeeds with valid cart', async () => {
  const result = await checkout(validCart);
  expect(result.status).toBe('confirmed');
});

// GOOD: Another behavior
test('checkout returns order ID', async () => {
  const result = await checkout(validCart);
  expect(result.orderId).toBeDefined();
});

// AVOID: Multiple unrelated assertions
test('checkout works', async () => {
  const result = await checkout(validCart);
  expect(result.status).toBe('confirmed');  // Behavior 1
  expect(result.orderId).toBeDefined();     // Behavior 2
  expect(result.timestamp).toBeInstanceOf(Date);  // Behavior 3
});
```

### 4. Test Names Describe WHAT, Not HOW

```typescript
// GOOD: Describes behavior
test('user can login with valid credentials')
test('shows error for invalid email format')
test('calculates total including tax')

// BAD: Describes implementation
test('calls validateEmail method')
test('sets isLoggedIn flag to true')
test('updates user.lastLogin timestamp')
```

---

## The Philosophy in Practice

### Scenario: Refactoring Checkout

**Before**:
```typescript
function checkout(cart, payment) {
  const total = cart.items.reduce((sum, item) => sum + item.price, 0);
  return processPayment(total, payment);
}
```

**After** (Major refactor):
```typescript
class CheckoutService {
  constructor(private cartCalculator: CartCalculator,
              private paymentProcessor: PaymentProcessor) {}
              
  async checkout(cart: Cart, payment: PaymentMethod) {
    const total = this.cartCalculator.calculateTotal(cart);
    return this.paymentProcessor.process(total, payment);
  }
}
```

**Behavior-focused test** (unchanged, still passes):
```typescript
test('user can checkout with valid cart', async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe('confirmed');
});
```

**Implementation-coupled test** (breaks, needs rewrite):
```typescript
test('checkout calls processPayment with total', () => {
  const mockProcess = jest.fn();
  checkout(cart, payment, mockProcess);
  expect(mockProcess).toHaveBeenCalledWith(100, payment);
  // → Breaks! checkout() signature changed
});
```

---

## Summary

**Good TDD tests**:
- Verify WHAT (behavior)
- Use public interfaces
- Survive refactors
- Read like specs
- Give true confidence

**Bad tests**:
- Verify HOW (implementation)
- Use mocks of internal code
- Break on refactors
- Obscure intent
- Give false confidence

**Golden Rule**: 
> If your test breaks when you refactor without changing behavior, 
> your test was testing implementation, not behavior.

---

**See Also**:
- [EXAMPLES.md](./EXAMPLES.md) - Concrete good vs bad test samples
- [MOCKING.md](./MOCKING.md) - When and how to mock
- [ANTI-PATTERNS.md](./ANTI-PATTERNS.md) - Common TDD mistakes
