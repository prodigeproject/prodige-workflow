# TDD Anti-Patterns: What NOT to Do

Common TDD mistakes that produce bad tests and waste time.

---

## Anti-Pattern #1: Horizontal Slicing

**THE BIG ONE. DO NOT DO THIS.**

### ❌ The Wrong Way (Horizontal)

```
RED Phase:   Write ALL tests for the feature
             test1, test2, test3, test4, test5

GREEN Phase: Write ALL implementation
             impl1, impl2, impl3, impl4, impl5
```

Treating RED as "write all tests" and GREEN as "write all code."

### Why This Produces Crap Tests

**1. Tests Written in Bulk Test Imagined Behavior**

You're writing tests for code that doesn't exist yet. You're guessing at:
- What the implementation will look like
- What interfaces will exist
- What edge cases matter

Tests become **shape tests** - they verify structure, not behavior.

**2. You Outrun Your Headlights**

You commit to test structure before understanding the problem.

```typescript
// You write 10 tests imagining the API
test('user.activate() sets status to active')
test('user.activate() sends email')
test('user.activate() logs event')
// ...

// Then discover: activation is async, needs confirmation, has rate limits
// All 10 tests need rewrite before you even start implementing!
```

**3. Tests Become Insensitive**

Tests pass when behavior breaks, fail when behavior is fine.

```typescript
// Horizontal test checks return type
test('getUser returns object with id property', () => {
  const user = getUser(1);
  expect(user).toHaveProperty('id');
});

// Passes even if getUser returns WRONG user!
// Fails if you rename 'id' to 'userId'!
```

### ✅ The Right Way (Vertical)

```
Cycle 1: RED → GREEN for feature1 (test1 → impl1)
Cycle 2: RED → GREEN for feature2 (test2 → impl2)
Cycle 3: RED → GREEN for feature3 (test3 → impl3)
...
```

**Vertical Slicing = Tracer Bullets**

One test → One implementation → Repeat.

Each cycle responds to what you learned from the previous cycle.

### Why Vertical Works

**1. You Test Actual Behavior**

You just wrote the code. You know exactly:
- What interface works
- What behavior matters
- What edge cases exist

**2. Each Test Informs the Next**

```typescript
// Cycle 1: Happy path
test('creates user with valid data', async () => {
  const user = await createUser({ email: 'test@example.com' });
  expect(user.id).toBeDefined();
});
// Implementation: Basic creation

// Cycle 2: Learn validation needed
test('rejects invalid email', async () => {
  await expect(createUser({ email: 'not-email' }))
    .rejects.toThrow('Invalid email');
});
// Implementation: Add validation

// Cycle 3: Learn duplicate check needed
test('rejects duplicate email', async () => {
  await createUser({ email: 'test@example.com' });
  await expect(createUser({ email: 'test@example.com' }))
    .rejects.toThrow('Email already exists');
});
// Implementation: Add duplicate check
```

Each cycle builds on previous learning.

**3. Tests Stay Relevant**

Tests written against working code remain accurate. No guesswork.

### Visual Comparison

```
HORIZONTAL (WRONG):
Time →
Tests:  [████████████████████] All tests written
Code:   [                    ] No code yet
        ↓ Start implementing
Tests:  [████████████████████] Tests exist but...
Code:   [████                ] Code doesn't match tests
        ↓ Rewrite tests to match code
Tests:  [████████████████████] Tests rewritten
Code:   [████████████████████] Code complete
Result: Wasted time writing + rewriting tests

VERTICAL (RIGHT):
Time →
Test 1: [██] Write test → [  ] Fail → Implement → [██] Pass
Test 2: [  ]                [██] Write → Fail → Implement → [██] Pass
Test 3: [  ]                [  ]                [██] Write → Fail → Impl → [██]
Result: Each test written once, against real behavior
```

---

## Anti-Pattern #2: Testing Implementation Details

See [PHILOSOPHY.md](./PHILOSOPHY.md) and [EXAMPLES.md](./EXAMPLES.md) for detailed coverage.

**Quick check**: If you refactor without changing behavior, do tests break?
- **YES** → You're testing implementation
- **NO** → You're testing behavior ✓

---

## Anti-Pattern #3: Skipping RED Verification

### ❌ The Mistake

```typescript
// Write test
test('calculates total', () => {
  expect(calculateTotal([10, 20])).toBe(30);
});

// Implement immediately
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item, 0);
}

// Run test → Passes
```

**Problem**: You never saw the test fail. How do you know it tests the right thing?

### ✅ The Fix

```typescript
// 1. Write test
test('calculates total', () => {
  expect(calculateTotal([10, 20])).toBe(30);
});

// 2. Run test → MUST FAIL
// Error: calculateTotal is not defined ✓

// 3. Implement
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item, 0);
}

// 4. Run test → Now passes ✓
```

**Why It Matters**: 

Seeing the test fail proves:
- Test is connected to the code
- Test will catch bugs
- Failure message is clear

Without RED verification, you might have:
```typescript
// Typo in test - would pass even if implementation broken!
test('calculates total', () => {
  expect(calcTota([10, 20])).toBe(30);  // typo: calcTota
});
```

---

## Anti-Pattern #4: Testing After Coding

### ❌ The Rationalization

> "I'll just sketch out the implementation first, then write tests."

**This is NOT TDD.**

### Why It Fails

**1. Tests Pass Immediately**

You didn't see them fail, so they prove nothing.

**2. Tests Biased by Implementation**

You write tests that happen to pass with your specific implementation, not tests that verify behavior.

```typescript
// You implemented with array.reduce
// So you write test that assumes reduce behavior
test('sums using reduce', () => {
  const spy = jest.spyOn(Array.prototype, 'reduce');
  calculateTotal([10, 20]);
  expect(spy).toHaveBeenCalled();
});

// Should have written behavior test
test('calculates correct total', () => {
  expect(calculateTotal([10, 20])).toBe(30);
});
```

**3. Temptation to Skip Tests**

> "Implementation works, tests would just repeat the code..."

### ✅ The Fix

**Delete the code. Start over with test first.**

No exceptions. The exploration was valuable for learning, but untested code must go.

```
1. Write code to explore → Learn how to solve it
2. DELETE the code
3. Write test first
4. Implement fresh from tests
```

---

## Anti-Pattern #5: Writing Tests for Everything At Once

### ❌ The Mistake

```typescript
// Trying to test everything in one test
test('user registration works', async () => {
  const user = await register({
    email: 'test@example.com',
    password: 'pass123',
    name: 'Test User'
  });
  
  expect(user.id).toBeDefined();                    // Behavior 1
  expect(user.email).toBe('test@example.com');      // Behavior 2
  expect(user.name).toBe('Test User');              // Behavior 3
  expect(user.password).toBeUndefined();            // Behavior 4
  expect(user.createdAt).toBeInstanceOf(Date);      // Behavior 5
  
  const email = await getLastEmail();
  expect(email.to).toBe('test@example.com');        // Behavior 6
  
  const dbUser = await findUserByEmail('test@example.com');
  expect(dbUser).toBeDefined();                     // Behavior 7
});
```

**Problems**:
- First assertion fails → You don't see other failures
- Hard to understand what broke
- Mixes multiple concerns

### ✅ The Fix

**One test per behavior:**

```typescript
test('registration creates user with ID', async () => {
  const user = await register(validData);
  expect(user.id).toBeDefined();
});

test('registration returns user email', async () => {
  const user = await register(validData);
  expect(user.email).toBe('test@example.com');
});

test('registration does not expose password', async () => {
  const user = await register(validData);
  expect(user.password).toBeUndefined();
});

test('registration sends confirmation email', async () => {
  await register(validData);
  const email = await getLastEmail();
  expect(email.to).toBe('test@example.com');
});
```

**Benefits**:
- Clear failure messages
- Tests independent
- Can run subset
- Easy to understand what's tested

---

## Anti-Pattern #6: Over-Mocking

### ❌ The Mistake

```typescript
// Mocking everything
test('order service creates order', async () => {
  const mockDb = { insert: jest.fn() };
  const mockEmail = { send: jest.fn() };
  const mockInventory = { reserve: jest.fn() };
  const mockPayment = { process: jest.fn() };
  const mockLogger = { log: jest.fn() };
  
  const service = new OrderService(mockDb, mockEmail, mockInventory, mockPayment, mockLogger);
  await service.createOrder(orderData);
  
  expect(mockDb.insert).toHaveBeenCalled();
  // ... more expects ...
});
```

**Problems**:
- Tests that functions are called, not that behavior works
- Would pass even if order creation is completely broken
- Mocking your own code defeats purpose of testing

### ✅ The Fix

**Mock only system boundaries:**

```typescript
// Integration test with real database (test DB)
test('order service creates order', async () => {
  const mockPaymentAPI = { charge: jest.fn().mockResolvedValue({ success: true }) };
  
  const order = await orderService.createOrder(
    orderData,
    mockPaymentAPI  // Only mock external payment API
  );
  
  expect(order.id).toBeDefined();
  
  // Verify through real database
  const retrieved = await orderService.getOrder(order.id);
  expect(retrieved.status).toBe('confirmed');
});
```

See [MOCKING.md](./MOCKING.md) for detailed guidance.

---

## Anti-Pattern #7: Refactoring While RED

### ❌ The Mistake

```
1. Write test → FAILS
2. Notice code could be cleaner
3. Refactor code
4. Implement fix
5. Test passes
```

**Problem**: You refactored when tests were red. If test still fails, is it because:
- Your refactor broke something?
- Your new implementation is wrong?
- Both?

### ✅ The Fix

**Get to GREEN first, then refactor:**

```
1. Write test → FAILS (RED)
2. Minimal code to pass → PASSES (GREEN)
3. Now refactor (stay GREEN)
4. Tests still pass ✓
```

**RED-GREEN-Refactor**, not RED-Refactor-GREEN.

---

## Anti-Pattern #8: Adding Features Not Tested

### ❌ The Mistake

```typescript
// Test only tests email validation
test('validates email format', () => {
  expect(validateUser({ email: 'test@example.com' })).toBe(true);
});

// But implementation adds password validation too
function validateUser(user) {
  const emailValid = /\S+@\S+\.\S+/.test(user.email);
  const passwordValid = user.password && user.password.length >= 8;  // Not tested!
  return emailValid && passwordValid;
}
```

**Problem**: Password validation is untested. Test would pass even if password logic is broken.

### ✅ The Fix

**Only implement what's tested:**

```typescript
// Test 1: Email validation
test('validates email format', () => {
  const result = validateEmail('test@example.com');
  expect(result).toBe(true);
});

function validateEmail(email) {
  return /\S+@\S+\.\S+/.test(email);  // Only this
}

// Test 2: Password validation (separate test)
test('validates password length', () => {
  const result = validatePassword('password123');
  expect(result).toBe(true);
});

function validatePassword(password) {
  return password && password.length >= 8;  // Only this
}
```

---

## Summary of Anti-Patterns

| Anti-Pattern | The Wrong Way | The Right Way |
|--------------|---------------|---------------|
| **Horizontal Slicing** | All tests → All code | One test → One impl → Repeat |
| **Implementation Testing** | Test internal details | Test behavior through public API |
| **Skipping RED** | Write code immediately | Watch test FAIL first |
| **Testing After** | Code first, tests after | Test first, always |
| **One Big Test** | 10 assertions per test | One behavior per test |
| **Over-Mocking** | Mock everything | Mock system boundaries only |
| **Refactor While RED** | Refactor then implement | GREEN first, then refactor |
| **Untested Features** | Add "nice to haves" | Only implement what's tested |

---

## The Golden Rules

1. **Vertical slicing** - One test → one implementation → repeat
2. **Watch it fail** - Always see RED before GREEN
3. **Test behavior** - Not implementation details
4. **Minimal code** - Only enough to pass current test
5. **GREEN before refactor** - Never refactor while RED
6. **Delete untested code** - If you wrote code first, delete it

**Remember**: If you're not following these rules, you're not doing TDD. You're writing tests after the fact, which is completely different.

---

**See Also**:
- [PHILOSOPHY.md](./PHILOSOPHY.md) - Why behavior vs implementation matters
- [EXAMPLES.md](./EXAMPLES.md) - Concrete good vs bad test patterns
- [SKILL.md](./SKILL.md) - Back to TDD workflow
