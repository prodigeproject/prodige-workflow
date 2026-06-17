# Phase 1: Build Feedback Loop

**This is THE skill.** Master this, and debugging becomes mechanical.

---

## Why Phase 1 is 90% of Debugging

Without fast feedback:
- Bisection = impossible (can't automate test)
- Hypothesis testing = slow (manual verification)
- Instrumentation = guesswork (can't iterate)

With fast feedback:
- Bisection = `git bisect run ./test.sh` (automatic)
- Hypothesis testing = seconds per test
- Instrumentation = rapid iteration

**Invest disproportionate effort here.**

---

## The Goal

Agent-runnable script that:

```
✅ Runs in < 5 seconds (ideally < 2 seconds)
✅ Returns clear exit code: 0 = pass, non-zero = fail
✅ Reproduces bug reliably (100% or high %)
✅ Requires zero human interaction
✅ Can run in CI/local/agent environment
```

### Good Feedback Loop

```bash
#!/bin/bash
# test-bug.sh
npm test -- users.duplicate-email.test.ts
exit $?
```

**Run**: `./test-bug.sh`  
**Output**: Exit 1 (fail) when bug present, exit 0 (pass) when fixed  
**Speed**: 1.2 seconds  
**Deterministic**: 100%

### Bad Feedback Loop

```
"Open browser, click login, fill form, check if it crashes"
```

**Problems**:
- Requires human
- Takes 30+ seconds
- Can't automate
- Can't iterate quickly

---

## The 10 Ways (Try in Order)

### 1. Failing Test

**Best option if possible.** Framework already provides loop.

```typescript
// users.test.ts
describe('User creation', () => {
  it('returns 409 on duplicate email', async () => {
    await createUser({ email: 'test@example.com' });
    
    const result = await createUser({ email: 'test@example.com' });
    
    expect(result.status).toBe(409); // Currently fails with 500
  });
});
```

**Run**: `npm test -- users.test.ts`  
**Result**: Clear fail message, exit code 1  
**Speed**: Fast (isolated test)

**Write test at ANY seam that reaches the bug**:
- Unit test (single function)
- Integration test (service layer)
- E2E test (full flow)

Don't wait for "perfect" seam - ANY seam that triggers bug works.

---

### 2. Curl / HTTP Script

**For API bugs.** Script HTTP requests.

```bash
#!/bin/bash
# test-duplicate-email.sh

# Setup: Create first user
curl -s -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test"}'

# Test: Try duplicate
response=$(curl -s -w "%{http_code}" -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test2"}')

# Check: Should be 409, currently 500
if echo "$response" | grep -q "409"; then
  echo "PASS: Returns 409"
  exit 0
else
  echo "FAIL: Expected 409, got $response"
  exit 1
fi
```

**Run**: `./test-duplicate-email.sh`  
**Result**: Pass/fail based on status code  
**Speed**: ~1 second (HTTP round-trip)

**Pro**: Works without test framework  
**Con**: Requires server running

---

### 3. CLI Invocation

**For CLI tools.** Run with fixture, diff output.

```bash
#!/bin/bash
# test-cli-bug.sh

# Run tool with known-bad input
./my-tool process < fixtures/bad-input.json > actual-output.json

# Compare against known-good output
if diff -q actual-output.json expected-output.json > /dev/null; then
  echo "PASS"
  exit 0
else
  echo "FAIL"
  diff actual-output.json expected-output.json
  exit 1
fi
```

**Run**: `./test-cli-bug.sh`  
**Result**: Diff shows exact discrepancy  
**Speed**: Fast (file I/O only)

**Pro**: Fully deterministic  
**Con**: Requires fixture creation

---

### 4. Headless Browser

**For frontend bugs.** Automate browser interactions.

```typescript
// test-login-bug.ts (Playwright)
import { test, expect } from '@playwright/test';

test('login button works on mobile', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 });
  await page.goto('http://localhost:3000/login');
  
  await page.fill('[name="email"]', 'user@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('button[type="submit"]');
  
  // Should redirect to dashboard
  await expect(page).toHaveURL('http://localhost:3000/dashboard');
  // Currently fails - no redirect
});
```

**Run**: `npx playwright test test-login-bug.ts`  
**Result**: Screenshot on failure, clear assertion  
**Speed**: 3-5 seconds (browser startup)

**Pro**: Full UI testing  
**Con**: Slower than unit tests

---

### 5. Replay Captured Trace

**For production bugs.** Capture and replay request/event.

```typescript
// replay-bug.ts
import fs from 'fs';
import { processRequest } from './api';

const capturedRequest = JSON.parse(fs.readFileSync('bug-request.json', 'utf8'));

// Replay exact request that caused bug in production
try {
  const result = await processRequest(capturedRequest);
  console.log('PASS: No error');
  process.exit(0);
} catch (error) {
  console.log('FAIL:', error.message);
  process.exit(1);
}
```

**Run**: `node replay-bug.ts`  
**Result**: Reproduces production bug locally  
**Speed**: Very fast (direct function call)

**Pro**: Exact production scenario  
**Con**: Requires capturing real request

---

### 6. Throwaway Harness

**For integration bugs.** Minimal system subset.

```typescript
// harness.ts - Minimal reproduction
import { Database } from './db';
import { UserService } from './services/users';

async function testBug() {
  const db = new Database('sqlite::memory:');
  await db.migrate();
  
  const service = new UserService(db);
  
  // Setup: Create user
  await service.createUser({ email: 'test@example.com' });
  
  // Test: Duplicate should return 409
  try {
    await service.createUser({ email: 'test@example.com' });
    console.log('FAIL: Should have thrown');
    process.exit(1);
  } catch (error) {
    if (error.status === 409) {
      console.log('PASS: Correct error');
      process.exit(0);
    } else {
      console.log('FAIL: Wrong error:', error.status);
      process.exit(1);
    }
  }
}

testBug();
```

**Run**: `node harness.ts`  
**Result**: Isolated reproduction  
**Speed**: Fast (no full system boot)

**Pro**: Minimal dependencies, fast setup  
**Con**: Requires harness code

---

### 7. Property / Fuzz Loop

**For "sometimes wrong" bugs.** Run many random inputs.

```typescript
// fuzz-test.ts
import { validateEmail } from './validate';

// Generate 1000 random email-like strings
for (let i = 0; i < 1000; i++) {
  const randomEmail = generateRandomEmailLike();
  
  try {
    const result = validateEmail(randomEmail);
    // Check for invariant violation
    if (result.valid && !result.email.includes('@')) {
      console.log('FAIL: Accepted invalid email:', result.email);
      process.exit(1);
    }
  } catch (error) {
    // Expected for invalid emails
  }
}

console.log('PASS: All 1000 inputs handled correctly');
process.exit(0);
```

**Run**: `node fuzz-test.ts`  
**Result**: Finds edge cases  
**Speed**: Medium (1000 iterations)

**Pro**: Finds unexpected inputs  
**Con**: May not find specific bug

---

### 8. Bisection Harness

**For "which commit broke it" bugs.** Automate git bisect.

```bash
#!/bin/bash
# bisect-test.sh

# Install deps (might change between commits)
npm install --silent

# Run test that passes on good commit, fails on bad
npm test -- users.test.ts 2>&1 | grep -q "1 passed"

# Exit 0 = good commit, 1 = bad commit
exit $?
```

**Use with git bisect**:
```bash
git bisect start
git bisect bad HEAD           # Current commit is bad
git bisect good v1.2.0        # v1.2.0 was good
git bisect run ./bisect-test.sh
# Automatically finds introducing commit
```

**Result**: Exact commit that introduced bug  
**Speed**: log₂(n) checkouts

**Pro**: Finds exact cause automatically  
**Con**: Requires known-good commit

---

### 9. Differential Loop

**For "new version broke it" bugs.** Compare old vs new.

```bash
#!/bin/bash
# differential-test.sh

INPUT="fixtures/test-case.json"

# Run with old version
docker run app:v1.0 process < "$INPUT" > old-output.json

# Run with new version
docker run app:v2.0 process < "$INPUT" > new-output.json

# Compare outputs
if diff -q old-output.json new-output.json > /dev/null; then
  echo "PASS: Outputs match"
  exit 0
else
  echo "FAIL: Outputs differ"
  diff old-output.json new-output.json
  exit 1
fi
```

**Run**: `./differential-test.sh`  
**Result**: Shows exact behavior change  
**Speed**: Medium (2× execution)

**Pro**: Clear before/after comparison  
**Con**: Requires running both versions

---

### 10. HITL Bash Script (Last Resort)

**When human must be in loop.** Structure the manual steps.

```bash
#!/bin/bash
# hitl-loop.sh

echo "=== Manual Test Loop ==="
echo "1. Open http://localhost:3000/login"
echo "2. Set viewport to 375px (mobile)"
echo "3. Fill email: test@example.com"
echo "4. Fill password: password123"
echo "5. Click login button"
echo ""
read -p "Did it redirect to dashboard? (y/n): " response

if [ "$response" = "y" ]; then
  echo "PASS"
  exit 0
else
  echo "FAIL"
  exit 1
fi
```

**Run**: `./hitl-loop.sh`  
**Result**: Human provides pass/fail signal  
**Speed**: Slow (human in loop)

**Pro**: Works when automation impossible  
**Con**: Can't iterate quickly

**Use only as absolute last resort.**

---

## Iterating the Loop

Once you have **a** loop (any of the 10 ways), improve it:

### Make It Faster

**Cache setup**:
```bash
# SLOW: Install deps every run
npm install
npm test

# FAST: Install once, reuse
if [ ! -d "node_modules" ]; then
  npm install
fi
npm test
```

**Skip unrelated init**:
```typescript
// SLOW: Full app startup
await app.start();  // Loads all routes, middleware
await testUserEndpoint();

// FAST: Minimal startup
await db.connect();  // Only what's needed
await testUserEndpoint();
```

**Narrow scope**:
```bash
# SLOW: Full test suite
npm test  # 147 tests, 30 seconds

# FAST: Single test
npm test -- users.duplicate-email.test.ts  # 1 test, 1 second
```

### Make Signal Sharper

**Assert specific symptom**:
```typescript
// VAGUE: Test didn't crash
expect(result).toBeDefined();  // What does this prove?

// SHARP: Exact expected behavior
expect(result.status).toBe(409);
expect(result.error).toBe('Email already exists');
```

**Capture exact error**:
```bash
# VAGUE: Something failed
npm test 2>&1 | grep -q "FAIL"

# SHARP: Specific error
npm test 2>&1 | grep -q "Expected 409, received 500"
```

### Make It More Deterministic

**Pin time**:
```typescript
// FLAKY: Uses real time
const timestamp = Date.now();

// DETERMINISTIC: Mock time
jest.useFakeTimers();
jest.setSystemTime(new Date('2024-01-01'));
const timestamp = Date.now();  // Always same value
```

**Seed RNG**:
```typescript
// FLAKY: Random values
const randomData = Math.random();

// DETERMINISTIC: Seeded
const randomData = seedrandom('fixed-seed')();
```

**Isolate filesystem**:
```bash
# FLAKY: Uses real files (might conflict)
./test.sh

# DETERMINISTIC: Temp directory per run
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
./test.sh
rm -rf "$TMPDIR"
```

---

## Non-Deterministic Bugs

Goal: Raise reproduction rate from low → debuggable.

### Techniques

**Loop the trigger**:
```bash
# Single run: 1% reproduction
./trigger-bug.sh

# 100 runs: 63% chance of seeing it once
for i in {1..100}; do
  ./trigger-bug.sh && echo "BUG REPRODUCED" && break
done
```

**Parallelize**:
```bash
# Run 10 parallel instances
for i in {1..10}; do
  ./trigger-bug.sh &
done
wait
```

**Add stress**:
```typescript
// Race condition more likely under load
await Promise.all([
  triggerBug(),
  triggerBug(),
  triggerBug(),
  // ... 100 parallel calls
]);
```

**Narrow timing windows**:
```typescript
// Make race condition more likely
async function stressTest() {
  // Reduce sleep to 0 (maximize race window)
  await Promise.all([
    updateUser(1),
    updateUser(1),  // Intentional duplicate to trigger race
  ]);
}
```

**Inject sleeps**:
```typescript
// Slow down to expose race
async function updateUser(id) {
  const user = await db.get(id);
  await sleep(100);  // ← Inject delay to expose race
  user.count += 1;
  await db.update(id, user);
}
```

### Target Reproduction Rate

```
1% flake    → Can't debug reliably
10% flake   → Might see in 20 runs
50% flake   → Debuggable! 2-3 runs each test
90% flake   → Nearly deterministic
100% flake  → Perfect (not always achievable)
```

**Aim for at least 50%.** Lower = too slow to iterate.

---

## When You Cannot Build a Loop

Sometimes it's genuinely impossible (production-only, rare race condition, requires specific hardware).

### Stop and Document

```
FEEDBACK LOOP: Unable to construct

Attempted:
1. Unit test - Cannot reproduce (needs production data)
2. Curl script - No dev environment access
3. Bisection - Cannot narrow down (flake rate < 1%)

Blockers:
- Bug only appears with production dataset (1M+ records)
- Cannot replicate dataset locally (data privacy)
- Reproduction rate too low to iterate (< 1%)

Request from user:
□ Access to staging environment with prod-like data
□ Captured HAR file from prod when bug occurred
□ Permission to add instrumentation to prod temporarily
□ Core dump from prod instance

Cannot proceed to Phase 2 without feedback loop.
```

### What to Ask For

**Access**:
- Staging with prod-like data
- Read-only prod access
- Prod logs with correlation IDs

**Artifacts**:
- HAR file (network capture)
- Screen recording with DevTools
- Core dump / heap dump
- Log dump with timestamps

**Permission**:
- Temporary prod instrumentation
- Increased log verbosity
- Feature flag for diagnostics

**Do NOT guess without feedback loop.** Phase 1 is non-negotiable.

---

## Examples by Bug Type

### API Bug
**Best**: Failing integration test  
**Fallback**: Curl script against dev server

### Frontend Bug
**Best**: Headless browser test (Playwright)  
**Fallback**: Manual HITL loop (structured)

### Database Bug
**Best**: Unit test with in-memory DB  
**Fallback**: Throwaway harness with test DB

### Performance Regression
**Best**: Benchmark script (before/after timing)  
**Fallback**: Profiler with differential analysis

### Race Condition
**Best**: Fuzz loop (1000 parallel runs)  
**Fallback**: Stress test with injected delays

### Build Failure
**Best**: Minimal reproduction in fresh directory  
**Fallback**: Bisection harness

---

## Verification

Phase 1 complete when you have:

- [ ] Agent-runnable script/command
- [ ] Clear pass/fail exit code
- [ ] Runs in < 5 seconds (ideally < 2)
- [ ] Reproduction rate > 50% (or 100% if deterministic)
- [ ] No human interaction required
- [ ] Confirms exact bug user reported

**Can't check all boxes?** Keep iterating the loop or escalate blockers.

---

## The Bottom Line

```
Fast feedback loop = 90% of debugging solved
Everything else = mechanical

Invest here. Be aggressive. Refuse to give up.
```

Don't proceed to Phase 2 until you have a loop you believe in.

---

**Related**: [SKILL.md](./SKILL.md), [HYPOTHESIS-GUIDE.md](./HYPOTHESIS-GUIDE.md), [INSTRUMENTATION.md](./INSTRUMENTATION.md)  
**Source**: Matt Pocock "THE SKILL" philosophy + Prodige systematic approach  
**Version**: 2.0

