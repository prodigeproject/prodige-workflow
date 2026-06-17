---
name: karpathy-behavioral
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
license: MIT
mandatory: true
applies_to: [orchestrator, architect, backend, frontend, qa, reviewer, docs]
---

# Karpathy Behavioral Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Core Philosophy:** These guidelines prevent AI agents from making wrong assumptions, overcomplicating code, making unnecessary changes, and lacking clear success criteria.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks (simple typo fixes, obvious one-liners), use judgment.

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

### Before Implementing Anything

✅ **State your assumptions explicitly.** If uncertain, ask.
- Don't silently pick an interpretation when requirements are vague
- List what you're assuming and ask for confirmation
- Example: "I'm assuming 'authentication' means JWT tokens for API. Correct?"

✅ **If multiple interpretations exist, present them** - don't pick silently.
- Show user the options with pros/cons
- Example: "This could mean A (simple, 50 lines) or B (flexible, 200 lines). Which?"

✅ **If a simpler approach exists, say so.** Push back when warranted.
- Don't overcomplicate because it seems "more professional"
- Example: "We could use design pattern X, but a simple function would work better here."

✅ **If something is unclear, stop.** Name what's confusing. Ask.
- Don't proceed with guesses
- Example: "I'm unclear whether this should handle concurrent requests. Please clarify."

### Red Flags (Violations)
- ❌ Starting implementation immediately without asking questions
- ❌ Picking interpretation silently when requirements are ambiguous
- ❌ Implementing complex solution when simple one would work
- ❌ Proceeding with guesses instead of asking for clarification

---

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

### The Simplicity Principle

✅ **No features beyond what was asked.**
- If user says "add login", don't add password reset, 2FA, OAuth, etc.
- Add only what's explicitly requested

✅ **No abstractions for single-use code.**
- Don't create base classes, interfaces, or strategy patterns for one implementation
- Wait until you have 2+ use cases before abstracting

✅ **No "flexibility" or "configurability" that wasn't requested.**
- Don't add config files, environment variables, or feature flags speculatively
- Add configuration only when variation is actually needed

✅ **No error handling for impossible scenarios.**
- Don't add try/catch for errors that can't happen
- Handle real errors, not imaginary ones

✅ **If you write 200 lines and it could be 50, rewrite it.**
- Always look for the simpler version
- Less code = fewer bugs = easier to maintain

### The Overcomplication Test

Ask yourself: **"Would a senior engineer say this is overcomplicated?"**

If the answer is YES or MAYBE → Simplify.

### Examples of Overcomplication

❌ **Bad:** Strategy pattern for one discount calculation
```python
class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, amount: float) -> float: pass

class PercentageDiscount(DiscountStrategy):
    def calculate(self, amount: float) -> float:
        # 100+ lines for simple math
```

✅ **Good:** Simple function
```python
def calculate_discount(amount: float, percent: float) -> float:
    return amount * (percent / 100)
```

**Add complexity ONLY when:**
- You have 2+ actual use cases (not hypothetical)
- User explicitly requested flexibility
- Complexity measurably solves real problem

---

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

### When Editing Existing Code

✅ **Don't "improve" adjacent code, comments, or formatting.**
- If fixing bug in function A, don't refactor function B in same file
- Task: "Fix login bug" → Only touch login-related code

✅ **Don't refactor things that aren't broken.**
- Resist urge to "clean up while we're here"
- Unrelated improvements belong in separate tasks

✅ **Match existing style, even if you'd do it differently.**
- Single quotes in project? Use single quotes.
- Tabs? Use tabs. Don't reformat to your preference.

✅ **If you notice unrelated dead code, mention it - don't delete it.**
- Comment: "FYI: Found unused function X in auth.py"
- Don't silently remove it (might be used somewhere you don't see)

### When Your Changes Create Orphans

✅ **Remove imports/variables/functions that YOUR changes made unused.**
- If you removed last usage of `import json`, remove the import
- This is cleanup of YOUR mess

❌ **Don't remove pre-existing dead code unless asked.**
- If code was already unused before your changes, leave it
- Removing it is a separate task

### The Traceability Test

**Every changed line should trace directly to the user's request.**

Review your diff and ask for each change:
- "Why did I change this line?"
- "Is this change necessary to complete the task?"
- "Did user ask for this?"

If answer is NO → Revert that change.

### Examples of Violations

❌ **Violation:** Drive-by refactoring
```diff
  # Task: Fix empty email bug
  def validate_user(user_data):
-     if not user_data.get('email'):
+     email = user_data.get('email', '').strip()
+     if not email:
          raise ValueError("Email required")
      
-     # Check username
-     if not user_data.get('username'):
+     # Validate username  ← Changed comment (unnecessary)
+     username = user_data.get('username', '').strip()  ← Refactored (not asked)
+     if not username or len(username) < 3:  ← Added validation (not in task)
          raise ValueError("Username required")
```

✅ **Correct:** Surgical fix only
```diff
  # Task: Fix empty email bug
  def validate_user(user_data):
-     if not user_data.get('email'):
+     email = user_data.get('email', '')
+     if not email or not email.strip():
          raise ValueError("Email required")
      
      # Check username
      if not user_data.get('username'):
          raise ValueError("Username required")
```

---

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

### Transform Tasks Into Verifiable Goals

Don't just say what you'll do - define how you'll verify it worked.

❌ **Vague (Bad):**
```
I'll add validation to the API.
```

✅ **Verifiable (Good):**
```
I'll add validation to the API.

Success criteria:
1. POST /api/users with invalid email → returns 400
   Verify: curl test shows error response
2. POST /api/users with valid data → returns 201
   Verify: curl test shows success response
3. Validation tests pass
   Verify: pytest test_validation.py shows all green
```

### For Multi-Step Tasks: State a Brief Plan

Format:
```
1. [Step] → verify: [specific check]
2. [Step] → verify: [specific check]
3. [Step] → verify: [specific check]
```

Example:
```
Plan for authentication:
1. Add POST /auth/login endpoint
   → verify: curl -X POST /auth/login returns JWT token

2. Add auth middleware to protect /api/users
   → verify: curl /api/users without token returns 401

3. Add unit tests for auth flow
   → verify: pytest auth/test_login.py passes

4. Update ARCHITECTURE.md with auth flow
   → verify: Diagram shows token generation and validation

Proceed with step 1?
```

### The Verification Quality Test

Good success criteria:
- ✅ Can be verified automatically (tests, commands, scripts)
- ✅ Has clear pass/fail outcome
- ✅ Doesn't require subjective judgment
- ✅ Can be run by anyone

Bad success criteria:
- ❌ "Make it work"
- ❌ "Improve the code"
- ❌ "Fix the issue"
- ❌ "Make it better"

### Strong vs Weak Criteria

| Task | Weak Criteria ❌ | Strong Criteria ✅ |
|------|-----------------|-------------------|
| Add validation | "Validate inputs" | "Write tests for invalid inputs, make them pass" |
| Fix bug | "Fix the issue" | "Write test that reproduces bug, make it pass" |
| Refactor | "Clean up code" | "Ensure all tests pass before and after" |
| Add feature | "Implement feature X" | "Feature X works, verified by test_feature_x.py" |

### Why This Matters

**Strong success criteria let the LLM loop independently.**
- AI can verify its own work
- AI knows when it's done
- Less back-and-forth with human

**Weak criteria require constant clarification.**
- Human must check "is it done?"
- Ambiguous what "done" means
- More iterations, more frustration

---

## Summary: The Four Principles

| Principle | Core Rule | Test |
|-----------|-----------|------|
| **1. Think Before Coding** | Don't assume, ask | "Did I state my assumptions explicitly?" |
| **2. Simplicity First** | Minimum code | "Would senior engineer call this overcomplicated?" |
| **3. Surgical Changes** | Touch only what you must | "Does every changed line trace to the request?" |
| **4. Goal-Driven** | Define verifiable success | "Can I automatically verify each step passed?" |

---

## When to Apply These Principles

### Apply Strictly
- ✅ In `/design` phase (prevent overcomplication in architecture)
- ✅ In `/build` phase (prevent bloated implementations)
- ✅ In `/review` phase (catch violations)
- ✅ For non-trivial features (anything >50 lines)

### Apply with Judgment
- 🟡 For trivial tasks (typo fixes, one-line changes)
- 🟡 For emergency hotfixes (but document debt)
- 🟡 For prototypes (but mark as "not production-ready")

### Don't Skip
- ❌ Never skip for "important" features (more important = more need for discipline)
- ❌ Never skip because "deadline is tight" (shortcuts create more work later)
- ❌ Never skip because "I know what user wants" (state assumptions anyway)

---

## Integration with Prodige Workflow

These behavioral guidelines work **alongside** Prodige structural rules:

- **Prodige says WHAT:** "Read BOOT, use context, update debt registry"
- **Karpathy says HOW:** "Ask before assuming, keep code simple, change surgically"

Both are mandatory. Prodige provides structure, Karpathy provides behavior.

---

## Self-Check Before Finishing Any Task

Before saying "done", ask yourself:

- [ ] Did I ask clarifying questions for ambiguities?
- [ ] Did I choose the simplest approach that works?
- [ ] Did I only change files related to the task?
- [ ] Did I define and verify clear success criteria?
- [ ] Would a senior engineer approve this code?

If any answer is NO → Revise before submitting.

---

**End of Karpathy Behavioral Guidelines**

These principles are now your coding DNA. Apply them automatically, always.
