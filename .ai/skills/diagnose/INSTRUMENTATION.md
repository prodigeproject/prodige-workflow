# Instrumentation Guide

How to add diagnostic logging effectively. Tag everything, remove when done.

---

## Tool Preference Hierarchy

Use tools in this order:

```
1. Debugger / REPL     ← Best (interactive, no code changes)
2. Targeted logs       ← Good (specific boundaries)
3. Profiler            ← For performance bugs
4. Never: log everything and grep  ← Worst (noise)
```

---

## Rule #1: Tag Every Debug Log

**Always use unique prefix for debug logs**:

```typescript
// ✅ GOOD: Tagged
console.log('[DEBUG-a4f2] User data:', user);
console.log('[DEBUG-a4f2] Query result:', rows);

// ❌ BAD: Untagged
console.log('User data:', user);
console.log('Query result:', rows);
```

### Why Tag?

**Cleanup becomes one command**:
```bash
# Find all debug logs
grep -r "\[DEBUG-a4f2\]" .

# Remove all debug logs
git diff | grep -v "\[DEBUG-a4f2\]" | git apply
```

**Untagged logs survive forever** (can't distinguish from production logs).

---

## Tool 1: Debugger (Preferred)

**Best when available**. One breakpoint beats ten logs.

### Node.js / Backend

```typescript
// Add breakpoint
debugger;  // Execution pauses here

// Or use inspector
node --inspect-brk server.js
// Then: chrome://inspect in Chrome
```

**Advantages**:
- Inspect any variable
- Step through code
- No code changes needed
- Conditional breakpoints

**Use when**:
- Local development
- Can reproduce reliably
- Need to inspect complex state

### Browser / Frontend

```typescript
// In Chrome DevTools
debugger;  // Execution pauses

// Or: Set breakpoint in Sources tab
```

**Advantages**:
- See DOM state
- Network tab shows requests
- Console shows errors
- Time-travel debugging (React DevTools)

### REPL Inspection

```bash
# Node.js REPL
node
> const db = require('./db')
> db.users.findByEmail('test@example.com')
> // Inspect result interactively
```

**Use when**: Testing queries, exploring API

---

## Tool 2: Targeted Logs

**When debugger unavailable** (CI, production, async code).

### Principle: Log at Boundaries

```typescript
// ✅ GOOD: Log at component boundaries
app.post('/api/users', async (req, res) => {
  console.log('[DEBUG-a4f2] Request received:', req.body);
  
  const result = await UserService.create(req.body);
  console.log('[DEBUG-a4f2] Service returned:', result);
  
  res.json(result);
});

// ❌ BAD: Log inside implementation
function createUser(data) {
  console.log('[DEBUG] Starting');
  const validated = validate(data);
  console.log('[DEBUG] Validated');
  const user = db.insert(validated);
  console.log('[DEBUG] Inserted');
  return user;
}
```

**Why boundary logs?**
- Fewer logs = less noise
- Shows data flow between components
- Easier to trace requests

### Multi-Layer Systems

**Log at EACH layer boundary**:

```typescript
// Frontend: Component boundary
function UserList({ users }) {
  console.log('[DEBUG-a4f2-FE] Received users:', users);
  return users.map(u => <User key={u.id} data={u} />);
}

// Backend: API boundary
app.get('/api/users', async (req, res) => {
  console.log('[DEBUG-a4f2-API] Request received');
  const users = await UserService.getAll();
  console.log('[DEBUG-a4f2-API] Service returned:', users);
  res.json(users);
});

// Service: Business logic boundary
class UserService {
  async getAll() {
    console.log('[DEBUG-a4f2-SVC] Fetching users');
    const users = await db.users.findAll();
    console.log('[DEBUG-a4f2-SVC] DB returned:', users);
    return users;
  }
}

// Database: Data layer boundary
class UserRepository {
  async findAll() {
    console.log('[DEBUG-a4f2-DB] Executing query');
    const result = await this.query('SELECT * FROM users');
    console.log('[DEBUG-a4f2-DB] Query result:', result.rows);
    return result.rows;
  }
}
```

**Run once, analyze logs**:
```
[DEBUG-a4f2-API] Request received
[DEBUG-a4f2-SVC] Fetching users
[DEBUG-a4f2-DB] Executing query
[DEBUG-a4f2-DB] Query result: []     ← AHA! Database returned empty
[DEBUG-a4f2-SVC] DB returned: []
[DEBUG-a4f2-API] Service returned: []
[DEBUG-a4f2-FE] Received users: []
```

**Diagnosis**: DB layer returns empty. Check query, migrations, seed data.

---

## Structured Logging

**Log objects, not primitives**:

```typescript
// ❌ BAD: Hard to parse
console.log('[DEBUG-a4f2] User email test@example.com id 123 status active');

// ✅ GOOD: Structured
console.log('[DEBUG-a4f2] User:', {
  email: 'test@example.com',
  id: 123,
  status: 'active'
});
```

**Advantages**:
- Easy to read
- Can copy-paste values
- JSON parseable if needed

---

## Hypothesis-Driven Logging

**Each log maps to specific hypothesis**:

```typescript
// Hypothesis: Cache returns stale data after update

// Log cache state BEFORE update
console.log('[DEBUG-a4f2] Cache before update:', cache.get(userId));

await updateUser(userId, newData);

// Log cache state AFTER update
console.log('[DEBUG-a4f2] Cache after update:', cache.get(userId));

// Expected: Different values
// Actual: Same value → Hypothesis confirmed (cache not invalidated)
```

**Don't log everything hoping to find something.** Log what **tests the hypothesis**.

---

## Conditional Logging

**Add guards to prevent log spam**:

```typescript
// ❌ BAD: Logs every loop iteration (1000x)
for (const user of users) {
  console.log('[DEBUG-a4f2] Processing user:', user.id);
  // ...
}

// ✅ GOOD: Log only failing case
for (const user of users) {
  if (user.email === duplicateEmail) {
    console.log('[DEBUG-a4f2] Found duplicate:', user);
  }
}
```

---

## Timing / Performance Logs

**For performance bugs**:

```typescript
// Measure specific operation
const start = performance.now();

const result = await expensiveQuery();

const duration = performance.now() - start;
console.log('[DEBUG-a4f2] Query took:', duration, 'ms');
```

**Profile instead of guessing**:
```bash
# Node.js profiler
node --prof server.js
# Generate flamegraph

# Chrome DevTools Performance tab
# Record → Analyze flamegraph
```

---

## Tool 3: Profiler (Performance Bugs)

### When to Use

- Performance regression (something got slower)
- Unknown bottleneck (can't guess which function)
- CPU vs I/O bound (is it compute or network?)

### Node.js Profiler

```bash
# Generate profile
node --prof app.js

# Process profile
node --prof-process isolate-0x*.log > profile.txt

# Read profile.txt
# Shows % time in each function
```

**Look for**:
- High % time in unexpected function
- Excessive calls to cheap function

### Chrome DevTools

```
1. Open DevTools
2. Performance tab
3. Click Record
4. Trigger slow operation
5. Stop recording
6. Analyze flamegraph
```

**Look for**:
- Long bars (slow functions)
- Deep stacks (excessive nesting)
- Network waterfall (slow requests)

### Profiler > Logs for Performance

```
❌ DON'T:
console.log('[DEBUG] Function A took 5ms');
console.log('[DEBUG] Function B took 2ms');
// Which one is called 1000x?

✅ DO:
Run profiler → See Function A called 1000x = actual bottleneck
```

---

## Anti-Patterns

### ❌ Log Everything and Grep

```typescript
// WRONG: Spray logs everywhere
function processOrder(order) {
  console.log('Starting processOrder');
  console.log('Order:', order);
  const validated = validateOrder(order);
  console.log('Validated:', validated);
  const calculated = calculateTotal(order);
  console.log('Calculated:', calculated);
  // ... 50 more logs
}
```

**Problem**:
- 100+ log lines
- Can't see signal in noise
- Slow to analyze

**Fix**: Log at boundaries only (start/end of function, success/error).

---

### ❌ Untagged Debug Logs

```typescript
// WRONG: No tag
console.log('Debug: User data:', user);

// 6 months later: Still in codebase
// Can't tell debug from production logs
```

**Fix**: Always tag with unique prefix.

---

### ❌ Logging Sensitive Data

```typescript
// WRONG: Logging passwords, tokens
console.log('[DEBUG-a4f2] Login attempt:', {
  email: user.email,
  password: user.password  // ← NEVER LOG THIS
});

console.log('[DEBUG-a4f2] Auth header:', req.headers.authorization);  // ← Contains token
```

**Fix**: Redact sensitive fields.

```typescript
// RIGHT: Redact sensitive data
console.log('[DEBUG-a4f2] Login attempt:', {
  email: user.email,
  password: '[REDACTED]'
});

console.log('[DEBUG-a4f2] Auth header:', req.headers.authorization.substring(0, 10) + '...');
```

---

### ❌ Logging Without Hypothesis

```typescript
// WRONG: Hope to find something
console.log('[DEBUG] Value:', x);
console.log('[DEBUG] Another value:', y);
console.log('[DEBUG] Maybe this?:', z);
```

**Problem**: Don't know what you're looking for.

**Fix**: Form hypothesis first, then log to test it.

---

## Cleanup Checklist

Before Phase 6 complete:

```bash
# 1. Find all debug logs
grep -rn "\[DEBUG-" .

# 2. Verify each is temporary
# Remove anything with your debug tag

# 3. Run tests to ensure nothing breaks
npm test

# 4. Grep again to confirm
grep -rn "\[DEBUG-" .
# Should return 0 results
```

---

## Quick Reference

### Adding Logs

```typescript
// 1. Choose unique tag
const TAG = '[DEBUG-a4f2]';

// 2. Log at boundaries
console.log(TAG, 'Input:', input);
const result = processData(input);
console.log(TAG, 'Output:', result);

// 3. Structure data
console.log(TAG, 'User:', { id, email, status });

// 4. Map to hypothesis
// Hypothesis: Cache not invalidated
console.log(TAG, 'Cache before:', cache.get(key));
console.log(TAG, 'Cache after:', cache.get(key));
```

### Removing Logs

```bash
# 1. Find
grep -r "\[DEBUG-a4f2\]" .

# 2. Remove manually or:
# (Be careful with automated removal)

# 3. Verify
npm test
grep -r "\[DEBUG-a4f2\]" .
```

---

## Examples by Bug Type

### API Error

```typescript
// Log request/response at endpoint
app.post('/api/users', async (req, res) => {
  console.log('[DEBUG-a4f2] Request:', req.body);
  
  try {
    const user = await UserService.create(req.body);
    console.log('[DEBUG-a4f2] Success:', user);
    res.json(user);
  } catch (error) {
    console.log('[DEBUG-a4f2] Error:', error.code, error.message);
    res.status(500).json({ error: error.message });
  }
});
```

### Race Condition

```typescript
// Log timing to expose race
console.log('[DEBUG-a4f2] READ start:', Date.now());
const value = await cache.get(key);
console.log('[DEBUG-a4f2] READ end:', Date.now(), 'value:', value);

console.log('[DEBUG-a4f2] WRITE start:', Date.now());
await cache.set(key, newValue);
console.log('[DEBUG-a4f2] WRITE end:', Date.now());

// Parallel logs will show interleaved operations
```

### State Management Bug

```typescript
// Log state transitions
useEffect(() => {
  console.log('[DEBUG-a4f2] State changed:', {
    users: users?.length,
    loading,
    error
  });
}, [users, loading, error]);

// Shows unexpected state transitions
```

---

## The Bottom Line

```
Debugger > Targeted logs > Profiler > Log everything

Always tag debug logs: [DEBUG-{unique}]
Log at boundaries, not inside implementations
Clean up in Phase 6
```

---

**Related**: [SKILL.md](./SKILL.md), [HYPOTHESIS-GUIDE.md](./HYPOTHESIS-GUIDE.md), [PHASE1-FEEDBACK-LOOP.md](./PHASE1-FEEDBACK-LOOP.md)  
**Source**: Matt Pocock instrumentation preference + Prodige multi-layer logging  
**Version**: 2.0

