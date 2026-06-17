# Regression Testing Guide

Write the regression test **before** the fix, but only at the **correct seam**.

---

## The Goal

Lock down the bug so it can't come back.

**Good regression test**:
- Fails when bug present
- Passes when bug fixed
- At correct abstraction level
- Tests real bug pattern (not simpler version)

---

## Finding the Correct Seam

### What is a Seam?

**Seam** = The boundary where you write the test.

Examples:
- Unit test seam: Single function
- Integration test seam: Service layer
- E2E test seam: Full user flow
- API test seam: HTTP endpoint

### Correct Seam Criteria

A seam is **correct** if the test:

1. **Exercises real bug pattern** as it occurs at call site
2. **Requires minimal mocking** (tests real code paths)
3. **Would fail** if bug is re-introduced
4. **Doesn't test more** than necessary (narrowest seam that works)

---

## Examples: Choosing Seams

### Bug: API Returns 500 on Duplicate Email

**Option 1: Unit test on database layer**
```typescript
// ❌ WRONG SEAM: Too shallow
test('db.users.insert throws on duplicate', async () => {
  await db.users.insert({ email: 'test@example.com' });
  
  await expect(
    db.users.insert({ email: 'test@example.com' })
  ).rejects.toThrow();
});
```

**Problem**: This tests that database throws error, but bug was **uncaught error in endpoint**. This test doesn't verify the error is caught and converted to 409.

**Option 2: Integration test on API endpoint**
```typescript
// ✅ RIGHT SEAM: Tests real bug pattern
test('POST /api/users returns 409 on duplicate email', async () => {
  await request(app)
    .post('/api/users')
    .send({ email: 'test@example.com', name: 'Test' });
  
  const response = await request(app)
    .post('/api/users')
    .send({ email: 'test@example.com', name: 'Test2' });
  
  expect(response.status).toBe(409);
  expect(response.body.error).toBe('Email already exists');
});
```

**Why correct**: Tests the exact scenario user experiences (API call), verifies proper error handling, would fail if we remove try-catch.

---

### Bug: Component Crashes on Undefined Data

**Option 1: E2E test**
```typescript
// ❌ WRONG SEAM: Too broad
test('full user flow works', async () => {
  await page.goto('/');
  await page.click('Login');
  await page.fill('[name="email"]', 'user@example.com');
  await page.click('Submit');
  await page.waitForSelector('.user-list');
  // ... 20 more steps
  expect(await page.textContent('.user-list')).toContain('User');
});
```

**Problem**: Tests too much. If this fails, could be any of 20 steps. Doesn't isolate the bug (component crashing on undefined).

**Option 2: Component test**
```typescript
// ✅ RIGHT SEAM: Isolates bug
test('UserList handles undefined data gracefully', () => {
  const { container } = render(<UserList users={undefined} />);
  
  expect(container.textContent).toContain('No users');
  // Should NOT crash
});
```

**Why correct**: Tests exact bug condition (undefined prop), minimal setup, would fail if we remove null check.

---

### Bug: Race Condition in Parallel Updates

**Option 1: Unit test on single function**
```typescript
// ❌ WRONG SEAM: Doesn't reproduce race
test('updateUser increments count', async () => {
  await updateUser(1);
  const user = await getUser(1);
  expect(user.count).toBe(1);
});
```

**Problem**: Race needs **parallel** calls. This test calls function once, can't reproduce race condition.

**Option 2: Integration test with parallelism**
```typescript
// ✅ RIGHT SEAM: Reproduces race pattern
test('concurrent updates dont lose data', async () => {
  const userId = 1;
  await createUser({ id: userId, count: 0 });
  
  // Parallel updates (triggers race)
  await Promise.all([
    updateUser(userId),  // count++
    updateUser(userId),  // count++
    updateUser(userId),  // count++
  ]);
  
  const user = await getUser(userId);
  expect(user.count).toBe(3);  // Not 1 or 2
});
```

**Why correct**: Reproduces exact race pattern (parallel calls), would fail without transaction/lock, tests real bug scenario.

---

## When No Correct Seam Exists

Sometimes the seam **doesn't exist**:

### Example: Bug Needs Multiple Callers

```
Bug: Shared state corruption when both ComponentA and ComponentB
     call updateGlobalState() simultaneously.

Problem: No test seam that naturally calls from both components.

Options:
1. Write E2E test (slow, brittle)
2. Refactor architecture to make testable
3. Document absence of test, note as tech debt
```

### What to Do

```typescript
// Document why no regression test
// TODO: No regression test for this bug
// Reason: Bug requires parallel calls from ComponentA + ComponentB,
//         but no integration test seam exists for this pattern.
// Fix: Added mutex to prevent race condition.
// Architecture debt: Global state not designed for concurrent access.
//                    See ADR-0015 for refactor plan.
```

**Then escalate to architect**:

```
Bug fixed with mutex, but absence of test seam indicates
architectural issue: global shared state not designed for
concurrent access.

Recommendation: Refactor to eliminate shared state or add
proper concurrency primitives.

See: /improve-codebase-architecture skill
```

---

## Writing the Regression Test

### TDD Approach

```
1. RED:    Write test that reproduces bug
2. Verify: Test FAILS (confirms bug exists)
3. GREEN:  Apply fix from Phase 4
4. Verify: Test PASSES (confirms fix works)
```

### Example: Complete Flow

**Step 1: RED - Write failing test**

```typescript
describe('POST /api/users', () => {
  it('returns 409 on duplicate email', async () => {
    // Setup: Create first user
    await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });
    
    // Test: Try duplicate
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test2' });
    
    // Assert: Should be 409
    expect(response.status).toBe(409);
    expect(response.body.error).toBe('Email already exists');
  });
});
```

**Step 2: Verify RED**

```bash
npm test -- users.duplicate-email.test.ts

Result:
FAIL  users.duplicate-email.test.ts
  × returns 409 on duplicate email (45ms)
    Expected: 409
    Received: 500

✓ Test FAILS - confirms bug exists
```

**Step 3: GREEN - Apply fix**

```typescript
app.post('/api/users', async (req, res) => {
  try {
    const user = await db.users.insert(req.body);
    res.status(201).json(user);
  } catch (error) {
    // NEW: Catch unique constraint violation
    if (error.code === '23505') {
      return res.status(409).json({
        error: 'Email already exists'
      });
    }
    throw error;
  }
});
```

**Step 4: Verify GREEN**

```bash
npm test -- users.duplicate-email.test.ts

Result:
PASS  users.duplicate-email.test.ts
  ✓ returns 409 on duplicate email (32ms)

✓ Test PASSES - fix works
```

**Step 5: Verify no regressions**

```bash
npm test

Result: 147/147 tests passed

✓ No regressions
```

---

## Test Naming

Name test after the **bug symptom**, not implementation:

```typescript
// ❌ BAD: Implementation detail
test('catch block handles error code 23505', ...)

// ✅ GOOD: User-facing symptom
test('returns 409 when email already exists', ...)
```

**Why**: If implementation changes (different error code, different DB), test name still makes sense.

---

## Test Isolation

Ensure test is **isolated** (doesn't depend on other tests):

```typescript
// ✅ GOOD: Self-contained
beforeEach(async () => {
  await db.migrate.latest();
  await db.seed.run();
});

afterEach(async () => {
  await db.migrate.rollback();
});

test('duplicate email returns 409', async () => {
  // Test has clean database, no dependencies
});
```

**Avoid**:
- Shared global state
- Tests that must run in order
- Leaving data behind for next test

---

## Minimal Reproduction

Test should be **minimal** (only what's needed to trigger bug):

```typescript
// ❌ BAD: Too much setup
test('duplicate email returns 409', async () => {
  // Create organization
  const org = await createOrganization();
  // Create admin user
  const admin = await createAdmin(org);
  // Create department
  const dept = await createDepartment(org, admin);
  // NOW test duplicate user in department
  await createUser({ departmentId: dept.id, email: 'test@example.com' });
  const response = await createUser({ departmentId: dept.id, email: 'test@example.com' });
  expect(response.status).toBe(409);
});

// ✅ GOOD: Minimal
test('duplicate email returns 409', async () => {
  await createUser({ email: 'test@example.com' });
  const response = await createUser({ email: 'test@example.com' });
  expect(response.status).toBe(409);
});
```

**Why minimal**:
- Faster execution
- Clearer intent
- Easier to maintain

---

## Don't Test Implementation

Test **behavior**, not implementation:

```typescript
// ❌ BAD: Tests implementation
test('try-catch block is present in endpoint', () => {
  const code = fs.readFileSync('users.controller.js', 'utf8');
  expect(code).toContain('try {');
  expect(code).toContain('catch (error) {');
});

// ✅ GOOD: Tests behavior
test('duplicate email returns 409', async () => {
  await createUser({ email: 'test@example.com' });
  const response = await createUser({ email: 'test@example.com' });
  expect(response.status).toBe(409);
});
```

**Why**: Implementation can change (try-catch → promise.catch), but behavior should stay same.

---

## Regression Test Checklist

Before claiming Phase 5 complete:

- [ ] Test written at **correct seam** (exercises real bug pattern)
- [ ] Test **failed** when bug present (verified RED)
- [ ] Test **passes** after fix (verified GREEN)
- [ ] Test is **isolated** (no dependencies on other tests)
- [ ] Test is **minimal** (only what's needed)
- [ ] Test name describes **symptom** (not implementation)
- [ ] Tests **behavior** (not implementation details)
- [ ] Full suite still passes (no regressions)

**Can't check all boxes?** Fix test before proceeding.

---

## When Test Seam Doesn't Exist

**Document explicitly**:

```typescript
// No regression test for this bug
// 
// Bug: Race condition between ComponentA and ComponentB calling
//      updateGlobalState() simultaneously.
// 
// Fix: Added mutex to serialize access.
// 
// Why no test:
// - Bug requires parallel access from 2 specific components
// - No integration test seam covers this scenario
// - E2E test would be flaky and slow
// - Unit test can't reproduce (needs 2 call sites)
// 
// Architecture issue:
// - Global state not designed for concurrent access
// - Recommend refactor: Eliminate global state or add proper
//   concurrency primitives
// 
// See: ADR-0023 for refactor plan
// See: .ai/governance/debt/architecture-debt.md for tracking
```

**Then escalate to architect** for architectural solution.

---

## Examples by Bug Type

### API Error Bug

**Seam**: Integration test on API endpoint

```typescript
test('POST /api/users handles duplicate email', async () => {
  await request(app).post('/api/users').send({ email: 'test@example.com' });
  const res = await request(app).post('/api/users').send({ email: 'test@example.com' });
  expect(res.status).toBe(409);
});
```

### Frontend Component Bug

**Seam**: Component test

```typescript
test('UserList shows empty state when users undefined', () => {
  const { container } = render(<UserList users={undefined} />);
  expect(container.textContent).toContain('No users');
});
```

### Race Condition Bug

**Seam**: Integration test with parallelism

```typescript
test('concurrent updates preserve all changes', async () => {
  await Promise.all([
    updateUser(1),
    updateUser(1),
    updateUser(1),
  ]);
  const user = await getUser(1);
  expect(user.count).toBe(3);
});
```

### Performance Regression

**Seam**: Performance test

```typescript
test('query completes in < 100ms', async () => {
  const start = performance.now();
  await getUsersWithPosts();
  const duration = performance.now() - start;
  expect(duration).toBeLessThan(100);
});
```

---

## The Bottom Line

```
Test at correct seam (exercises real bug pattern)
Write test BEFORE fix (TDD)
If no correct seam exists → Architecture issue
```

Absence of seam is itself a finding.

---

**Related**: [SKILL.md](./SKILL.md), [HYPOTHESIS-GUIDE.md](./HYPOTHESIS-GUIDE.md), [../tdd/SKILL.md](../tdd/SKILL.md)  
**Source**: Matt Pocock "correct seam" philosophy + Prodige TDD discipline  
**Version**: 2.0

