# Mocking Guidelines: When and How

Mocking is a tool. Use it sparingly and strategically.

**Golden Rule**: Mock at system boundaries only. Don't mock your own code.

---

## When to Mock

### ✅ DO Mock These (System Boundaries)

**1. External APIs**
```typescript
// Mock Stripe payment API
const mockStripe = {
  charge: jest.fn().mockResolvedValue({
    id: 'ch_123',
    status: 'succeeded'
  })
};

await processPayment(order, mockStripe);
```

**Why**: You don't control external services. They're slow, cost money, have rate limits.

**2. Third-Party Services**
```typescript
// Mock SendGrid email service
const mockEmailService = {
  send: jest.fn().mockResolvedValue({ messageId: 'msg_123' })
};

await sendWelcomeEmail(user, mockEmailService);
```

**Why**: External dependencies shouldn't block your tests.

**3. Time/Randomness**
```typescript
// Mock Date.now for deterministic tests
jest.spyOn(Date, 'now').mockReturnValue(1234567890);

// Mock Math.random
jest.spyOn(Math, 'random').mockReturnValue(0.5);
```

**Why**: Non-deterministic behavior makes tests flaky.

**4. File System (Sometimes)**
```typescript
// Mock fs for file operations
const mockFs = {
  readFile: jest.fn().mockResolvedValue('file content'),
  writeFile: jest.fn().mockResolvedValue(undefined)
};
```

**Why**: File I/O is slow. But consider using temp directories for integration tests.

**5. Databases (Sometimes)**

**Prefer**: Test database (best)
```typescript
// Use real test database
beforeEach(async () => {
  await testDb.migrate.latest();
  await testDb.seed.run();
});
```

**Acceptable**: Mock when test DB unavailable
```typescript
const mockDb = {
  query: jest.fn().mockResolvedValue([{ id: 1, name: 'Test' }])
};
```

---

## When NOT to Mock

### ❌ DON'T Mock These

**1. Your Own Modules**
```typescript
// BAD: Mocking your own OrderService
const mockOrderService = jest.mock('./OrderService');
await checkout(cart, mockOrderService);

// GOOD: Test with real OrderService
await checkout(cart);  // Uses real OrderService internally
```

**Why**: You want to test that your code actually works together.

**2. Internal Collaborators**
```typescript
// BAD: Mocking internal calculation
const mockCalculator = { calculate: jest.fn().mockReturnValue(100) };
const order = new Order(items, mockCalculator);

// GOOD: Use real calculation
const order = new Order(items);  // Uses real internal calculator
```

**Why**: Internal collaboration is part of the behavior you're testing.

**3. Simple Data Structures**
```typescript
// BAD: Mocking a plain object
const mockUser = { getId: jest.fn().mockReturnValue('123') };

// GOOD: Use real object
const user = { id: '123', name: 'Test' };
```

**Why**: Plain data doesn't need mocking. Just create it.

**4. Pure Functions**
```typescript
// BAD: Mocking a pure calculation
const mockCalculateTax = jest.fn().mockReturnValue(10);

// GOOD: Use real calculation
const tax = calculateTax(100, 0.1);  // Returns 10
```

**Why**: Pure functions are fast and deterministic. No reason to mock.

---

## Designing for Mockability

Make external dependencies easy to mock without affecting internal code.

### Pattern 1: Dependency Injection

**Bad Design** (Hard to Mock):
```typescript
// Creates dependency internally
function processPayment(order) {
  const stripe = new StripeClient(process.env.STRIPE_KEY);
  return stripe.charge(order.total);
}

// Test is stuck with real Stripe
```

**Good Design** (Easy to Mock):
```typescript
// Accepts dependency as parameter
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Test can inject mock
test('processes payment', async () => {
  const mockClient = { charge: jest.fn().mockResolvedValue({ success: true }) };
  const result = await processPayment(order, mockClient);
  expect(result.success).toBe(true);
});
```

### Pattern 2: Interface Segregation

**Bad Design** (Generic):
```typescript
// Generic fetch function - hard to mock specific endpoints
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options)
};

// Mock requires conditional logic
const mockApi = {
  fetch: jest.fn((endpoint) => {
    if (endpoint === '/users/123') return { id: 123 };
    if (endpoint === '/orders') return [];
    // ... more conditions
  })
};
```

**Good Design** (Specific Functions):
```typescript
// Specific function per operation
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data })
};

// Each mock is simple
const mockApi = {
  getUser: jest.fn().mockResolvedValue({ id: 123, name: 'Test' }),
  getOrders: jest.fn().mockResolvedValue([]),
  createOrder: jest.fn().mockResolvedValue({ id: 456 })
};
```

**Benefits**:
- Each function independently mockable
- No conditional logic in mocks
- Clear which endpoints test exercises
- Type safety per endpoint

### Pattern 3: Configuration Layer

**Good Design**:
```typescript
// Configuration provides mockable dependencies
class OrderService {
  constructor(config) {
    this.db = config.db;
    this.emailService = config.emailService;
    this.paymentService = config.paymentService;
  }
  
  async createOrder(orderData) {
    // Uses injected dependencies
    await this.db.insert(orderData);
    await this.emailService.send(confirmation);
    return await this.paymentService.process(payment);
  }
}

// Production
const service = new OrderService({
  db: productionDatabase,
  emailService: sendgridClient,
  paymentService: stripeClient
});

// Test
const service = new OrderService({
  db: testDatabase,
  emailService: mockEmailService,
  paymentService: mockPaymentService
});
```

---

## Mock Patterns

### Pattern: Simple Return Value

```typescript
const mock = {
  method: jest.fn().mockReturnValue(42)
};

expect(mock.method()).toBe(42);
```

### Pattern: Async Return Value

```typescript
const mock = {
  method: jest.fn().mockResolvedValue({ success: true })
};

const result = await mock.method();
expect(result.success).toBe(true);
```

### Pattern: Sequential Returns

```typescript
const mock = {
  method: jest.fn()
    .mockReturnValueOnce('first')
    .mockReturnValueOnce('second')
    .mockReturnValue('default')
};

expect(mock.method()).toBe('first');
expect(mock.method()).toBe('second');
expect(mock.method()).toBe('default');
expect(mock.method()).toBe('default');
```

### Pattern: Conditional Returns

```typescript
const mock = {
  getUser: jest.fn().mockImplementation((id) => {
    if (id === 1) return { id: 1, name: 'Alice' };
    if (id === 2) return { id: 2, name: 'Bob' };
    return null;
  })
};
```

### Pattern: Error Simulation

```typescript
const mock = {
  method: jest.fn().mockRejectedValue(new Error('Network error'))
};

await expect(mock.method()).rejects.toThrow('Network error');
```

---

## Testing with Mocks

### Verify Behavior, Not Mocks

```typescript
// ❌ BAD: Testing that mock was called
test('creates order', async () => {
  const mockDb = { insert: jest.fn() };
  await orderService.createOrder(data, mockDb);
  expect(mockDb.insert).toHaveBeenCalled();  // Tests nothing about behavior
});

// ✅ GOOD: Testing actual result
test('creates order and returns ID', async () => {
  const mockDb = {
    insert: jest.fn().mockResolvedValue({ id: 123 })
  };
  
  const order = await orderService.createOrder(data, mockDb);
  expect(order.id).toBe(123);  // Tests behavior
});
```

### Keep Mocks Simple

```typescript
// ❌ BAD: Complex mock logic
const mockService = {
  process: jest.fn().mockImplementation((data) => {
    if (data.type === 'A') {
      if (data.priority === 'high') {
        return { status: 'urgent', ...complexLogic() };
      } else {
        return { status: 'normal', ...moreLogic() };
      }
    }
    // ... 50 more lines of mock logic
  })
};

// ✅ GOOD: Simple mock returns
const mockService = {
  process: jest.fn().mockResolvedValue({ status: 'complete' })
};
```

If your mock is complex, you're probably mocking too much.

---

## Integration vs Unit Tests

### Unit Test (More Mocks)

```typescript
// Tests function in isolation
test('checkout processes payment', async () => {
  const mockPayment = { charge: jest.fn().mockResolvedValue({ success: true }) };
  const mockEmail = { send: jest.fn() };
  
  const result = await checkout(cart, mockPayment, mockEmail);
  expect(result.confirmed).toBe(true);
});
```

**When**: Testing complex logic in isolation.

### Integration Test (Fewer Mocks)

```typescript
// Tests real integration
test('checkout completes order', async () => {
  const mockStripe = { charge: jest.fn().mockResolvedValue({ success: true }) };
  
  // Uses real database, real email queue, real order service
  const order = await checkout(cart, mockStripe);
  
  const saved = await db.orders.findById(order.id);
  expect(saved.status).toBe('confirmed');
});
```

**When**: Testing that system parts work together.

**Prefer integration tests** when possible. They catch more real bugs.

---

## Common Pitfalls

### Pitfall 1: Over-Mocking

```typescript
// ❌ Everything mocked - tests nothing
const mockA = jest.fn();
const mockB = jest.fn();
const mockC = jest.fn();
// ... mock everything
```

**Fix**: Only mock external boundaries.

### Pitfall 2: Mock Leakage

```typescript
// ❌ Mock affects other tests
const mockApi = { get: jest.fn() };

test('test 1', () => {
  mockApi.get.mockReturnValue({ data: 'A' });
  // ...
});

test('test 2', () => {
  // Still has mock from test 1!
  // ...
});
```

**Fix**: Reset mocks between tests.
```typescript
afterEach(() => {
  jest.clearAllMocks();
});
```

### Pitfall 3: Testing Mock Configuration

```typescript
// ❌ Test verifies mock was configured, not behavior
test('handles error', async () => {
  mockApi.get.mockRejectedValue(new Error('Fail'));
  expect(mockApi.get).rejects.toThrow();  // Tests mock, not code
});

// ✅ Test verifies code handles error
test('shows error message when API fails', async () => {
  mockApi.get.mockRejectedValue(new Error('Fail'));
  const result = await loadData();
  expect(result.error).toBe('Failed to load data');
});
```

---

## Summary

**Mock**:
- External APIs (Stripe, SendGrid, etc.)
- Third-party services
- Time, randomness
- File system (sometimes)
- Databases (prefer test DB)

**Don't Mock**:
- Your own code
- Internal collaborators
- Plain data structures
- Pure functions

**Design for Mockability**:
- Dependency injection
- Specific functions (not generic)
- Configuration layers

**Test Behavior, Not Mocks**:
- Verify results, not that mocks were called
- Keep mocks simple
- Prefer integration tests

**Golden Rule**: Mock at system boundaries only.

---

**See Also**:
- [PHILOSOPHY.md](./PHILOSOPHY.md) - Behavior vs implementation
- [EXAMPLES.md](./EXAMPLES.md) - Good vs bad test patterns
- [ANTI-PATTERNS.md](./ANTI-PATTERNS.md) - Over-mocking pitfall
