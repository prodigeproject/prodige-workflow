# Hypothesis Formation Guide

Generate 3-5 ranked hypotheses before testing any of them.

**Why**: Single-hypothesis generation anchors on first plausible idea. Multiple hypotheses force better thinking.

---

## The Rule

Each hypothesis must be **falsifiable**: state the prediction it makes.

### Format

```
IF <X> is the cause,
THEN <action Y> will make the bug disappear
  OR <action Z> will make it worse
  OR <observation W> will be present
```

**Can't state the prediction? → Not a hypothesis, just a vibe.**

---

## Good vs Bad Hypotheses

### ❌ Bad: Not Falsifiable

```
"I think it might be a race condition."
```

**Problem**: No prediction. How do you test this?

### ✅ Good: Falsifiable

```
IF it's a race condition between updateUser calls,
THEN adding a mutex/lock will make the bug disappear,
  OR running calls sequentially (no parallelism) will prevent it.
```

**Why good**: Clear test - serialize the calls and see if bug vanishes.

---

### ❌ Bad: Too Vague

```
"The database might be the problem."
```

**Problem**: What about the database? Can't design an experiment.

### ✅ Good: Specific

```
IF the database connection pool is exhausted,
THEN increasing pool size from 10→50 will reduce error rate,
  OR checking pool metrics will show all connections in use when bug occurs.
```

**Why good**: Specific test - check pool size at bug time.

---

### ❌ Bad: Multiple Causes

```
"It could be the cache, or the API, or async timing."
```

**Problem**: Three hypotheses disguised as one. Can't test atomically.

### ✅ Good: Single Cause

```
Hypothesis 1: IF stale cache returns old user data...
Hypothesis 2: IF API rate limit is hit...
Hypothesis 3: IF async read-after-write timing...
```

**Why good**: Three separate, testable hypotheses.

---

## Generating 3-5 Hypotheses

### Start with Evidence

From Phase 3, you have:
- Error messages
- Recent changes
- Data flow trace
- Multi-component logs

**For each piece of evidence, ask: What could cause this?**

### Example: Bug Report

```
User report: "Getting 500 error when trying to create account with email that already exists"

Evidence from Phase 3:
- Error: Database error code 23505 (unique_violation)
- Recent change: Added user creation endpoint 2 days ago
- Stack trace: Error thrown from db.users.insert()
- Logs: No try-catch visible in endpoint code
```

### Generate Hypotheses

**Hypothesis 1** (most likely):
```
IF the endpoint doesn't catch unique constraint violations,
THEN error code 23505 propagates uncaught to client as 500,
  AND adding try-catch will allow returning proper 409 response.

Evidence: Stack trace shows error from db.users.insert() with no catch.
```

**Hypothesis 2**:
```
IF the database unique constraint itself is missing,
THEN querying pg_constraint will show no unique index on email,
  AND the error is happening at application level, not DB level.

Evidence: Error code 23505 suggests constraint exists, but should verify.
```

**Hypothesis 3**:
```
IF validation middleware is being skipped,
THEN logs will show no validation call before insert,
  AND the duplicate is reaching database layer when it should be caught earlier.

Evidence: 500 suggests no proper validation; 409 would come from validator.
```

**Hypothesis 4**:
```
IF error serialization middleware is broken,
THEN raw database error object is being sent to client,
  AND fixing serializer will properly convert to 409.

Evidence: 500 errors should never reach client if serializer works.
```

**Hypothesis 5**:
```
IF the duplicate email check query has a race condition,
THEN running parallel requests will show intermittent unique violations,
  AND serializing requests will make bug disappear.

Evidence: Unlikely given consistent reproduction, but race is possible.
```

### Ranking

Rank by **likelihood** based on evidence:

```
1. Missing try-catch (HIGH) - Stack trace directly shows this
2. Database constraint missing (MEDIUM) - Code 23505 suggests exists
3. Validation skipped (MEDIUM) - Worth checking middleware chain
4. Serializer broken (LOW) - Would affect all errors, not just this
5. Race condition (LOW) - Bug is deterministic, not intermittent
```

---

## Checkpoint with User

**Before testing**, show ranked hypotheses to user:

```
Root cause analysis complete. I've identified 5 possible causes, ranked by likelihood:

1. Missing try-catch (HIGH): Endpoint doesn't catch DB unique violations
   Test: Add try-catch and check if error code 23505 is caught
   
2. Database constraint missing (MEDIUM): Unique constraint may not exist
   Test: Query pg_constraint to verify unique index exists
   
3. Validation skipped (MEDIUM): Middleware might be bypassed
   Test: Check logs for validation call before insert
   
4. [truncated for brevity]

I'll start testing #1 unless you have insights that change the ranking.
Proceeding in 30 seconds if no response.
```

### Why Checkpoint?

User may immediately know:
- **"#3 is impossible - we removed validation middleware yesterday"** → Jump to #1
- **"We just deployed a fix for serializer (#4)"** → Test #4 first
- **"Yeah, we see this under load"** → #5 moves to top

**Don't block** - if user is AFK, proceed with your ranking after brief wait.

---

## Testing Hypotheses

### One at a Time

Test **single hypothesis** before moving to next.

```
❌ WRONG:
Try: Add try-catch + check constraint + add logging
Result: Bug fixed
Problem: Don't know WHICH change fixed it

✅ RIGHT:
Try: Add try-catch only
Result: Bug fixed
Conclusion: Hypothesis 1 confirmed
```

### Change One Variable

Each test should change **one thing**:

```
Hypothesis: Missing try-catch causes 500 error

Minimal test:
try {
  const user = await db.users.insert(data);
  res.json(user);
} catch (error) {
  console.log('[DEBUG-h1] Caught error code:', error.code);
  throw error;  // Re-throw (don't fix yet)
}

Run: POST duplicate email
Expected: Log shows "Caught error code: 23505"
Result: ✓ Logged 23505

Conclusion: Hypothesis confirmed - error IS happening, not caught.
```

**Don't fix yet** - just confirm hypothesis.

---

## Falsifying vs Confirming

### Confirmed Hypothesis

```
Hypothesis: Missing try-catch causes 500

Test: Add try-catch, log error code
Result: Logs show error code 23505 caught
Conclusion: CONFIRMED - uncaught exception was cause

Next: Implement proper fix (Phase 5)
```

### Falsified Hypothesis

```
Hypothesis: Database constraint missing causes error

Test: Query pg_constraint for email unique index
Result: Unique index EXISTS on users(email)
Conclusion: FALSIFIED - constraint exists, not the cause

Next: Move to hypothesis #2
```

### Inconclusive Test

```
Hypothesis: Validation middleware skipped

Test: Check logs for validation call
Result: Logs empty (no validation logged)
Problem: Can't tell if skipped or just not logged

Next: Add explicit logging to validation middleware, re-test
```

If test is inconclusive, **redesign the test** before moving on.

---

## When Hypothesis is Confirmed

**DON'T immediately implement full fix.**

1. **Document** which hypothesis was correct
2. **Explain** why it's correct (evidence)
3. **Proceed** to Phase 5 (TDD fix)

### Example

```
ROOT CAUSE IDENTIFIED:

Hypothesis #1 CONFIRMED: Missing try-catch in user creation endpoint.

Evidence:
- Added try-catch with logging
- Log shows error code 23505 (unique_violation) is caught
- Error originates from db.users.insert() call
- No existing error handling in endpoint code

Root cause: Database unique constraint violation is not caught,
allowing raw error to propagate to client as 500 Internal Server Error.

Next: Phase 5 - Write failing test, implement proper error handling.
```

---

## Multiple Hypotheses True

Sometimes >1 hypothesis is correct:

```
Hypothesis 1: Missing try-catch → 500 error
Result: CONFIRMED

Hypothesis 2: Missing validation → Duplicate reaches DB
Result: ALSO CONFIRMED

Reality: TWO separate issues:
1. No validation prevents duplicate check before DB
2. No error handling converts DB error to proper status code

Both need fixing.
```

**Fix priority**:
1. Fix immediate bug (error handling)
2. Note secondary issue (validation)
3. Create separate task for validation

Don't bundle fixes - test each independently.

---

## Common Hypothesis Patterns

### Missing Error Handling

```
IF endpoint doesn't catch {specific error type},
THEN uncaught exception becomes 500 error,
  AND adding try-catch will show specific error code in logs.
```

### Race Condition

```
IF two requests race between check-then-act,
THEN running requests sequentially will prevent bug,
  OR adding transaction/lock will eliminate race.
```

### Configuration Issue

```
IF config value is wrong/missing,
THEN checking config at runtime will show incorrect value,
  AND setting correct value will fix bug.
```

### Dependency Version

```
IF library version X introduced breaking change,
THEN downgrading to version X-1 will make bug disappear,
  OR checking library changelog will document the breaking change.
```

### Missing Null Check

```
IF value can be null/undefined,
THEN adding null check will prevent crash,
  AND inspecting value at error point will show null/undefined.
```

---

## Ranking Criteria

### Rank by Likelihood

**HIGH**: Direct evidence points to this
- Stack trace shows exact location
- Recent change touched this code
- Error message explicitly mentions this

**MEDIUM**: Plausible but indirect
- Similar bugs were this cause
- Pattern matches known issue
- Circumstantial evidence

**LOW**: Possible but unlikely
- No evidence pointing here
- Would affect more than just this bug
- Seems too simple/complex

### Rank by Test Cost

If likelihoods are equal, rank by ease of testing:

```
Hypothesis A: 50% likely, 5 minutes to test
Hypothesis B: 50% likely, 2 hours to test

→ Test A first (cheaper)
```

---

## Anti-Patterns

### ❌ Testing Without Hypothesis

```
"Let me just try adding some logging everywhere and see..."
```

**Problem**: No prediction, can't interpret results.

**Fix**: Form hypothesis first - "IF X, THEN logs will show Y"

---

### ❌ Hypothesis Without Evidence

```
"Maybe it's a memory leak?"
```

**Problem**: No evidence suggests this. Just guessing.

**Fix**: Base hypotheses on Phase 3 evidence.

---

### ❌ Unfalsifiable Hypothesis

```
"The system is too complex and needs refactoring."
```

**Problem**: Not testable. No experiment can prove/disprove.

**Fix**: Make specific and testable.

---

### ❌ Skipping Ranking

```
"Here are 5 hypotheses. I'll test all of them."
```

**Problem**: Wasted effort if #1 is correct.

**Fix**: Rank and test highest-likelihood first.

---

## Verification

Phase 4 complete when:

- [ ] Generated 3-5 hypotheses (not 1, not 10)
- [ ] Each hypothesis is falsifiable (clear prediction)
- [ ] Hypotheses ranked by likelihood + evidence
- [ ] Showed ranked list to user (or proceeded after timeout)
- [ ] Tested highest-ranked hypothesis first
- [ ] Changed ONE variable per test
- [ ] Confirmed or falsified hypothesis before proceeding

**Can't check all boxes? Refine hypotheses before Phase 5.**

---

## The Bottom Line

```
Multiple hypotheses > single hypothesis
Falsifiable predictions > vague ideas
Test highest-likelihood first > test randomly

Form, rank, checkpoint, test.
```

---

**Related**: [SKILL.md](./SKILL.md), [PHASE1-FEEDBACK-LOOP.md](./PHASE1-FEEDBACK-LOOP.md), [INSTRUMENTATION.md](./INSTRUMENTATION.md)  
**Source**: Matt Pocock 3-5 ranked hypotheses + Prodige scientific method  
**Version**: 2.0

