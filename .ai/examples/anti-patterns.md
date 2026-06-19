# Anti-Pattern Library

Learn from common AI coding mistakes. Each example shows what LLMs typically do wrong and how to fix it.

---

## Section 1: Think Before Coding

### Anti-Pattern 1.1: Silent Assumptions in /design

**Scenario:** User asks to "add authentication to the API"

**❌ What AI Does Wrong:**

```markdown
## Architecture Proposal

I'll implement JWT-based authentication with:
- OAuth2 authorization server
- Redis for session management
- Rate limiting on login endpoint
- Password complexity validation
- Email verification workflow
- 2FA support
- Password reset via email

Estimated: 2 weeks
```

**Problems:**
- Assumed JWT (could be sessions, API keys, OAuth)
- Assumed OAuth2 server needed (massive complexity)
- Assumed Redis (could be stateless JWT)
- Added features not requested (2FA, email verification)
- Never asked clarifying questions

**✅ What Should Happen:**

```markdown
Before proposing authentication architecture, I need clarification:

1. **Authentication method:**
   - Option A: JWT tokens (stateless, 100 lines)
   - Option B: Session-based (simpler, 50 lines)  
   - Option C: OAuth2 (if external apps need access, 500+ lines)

2. **Scope:**
   - Which endpoints need protection? All /api/* ?
   - Existing user system or new?

3. **Requirements:**
   - Password rules? (min length, complexity)
   - "Remember me" functionality?
   - Rate limiting needed?

My recommendation: Start with Option B (sessions) unless you need:
- Mobile app support → JWT
- External API consumers → OAuth2

Which fits your needs?
```

---

### Anti-Pattern 1.2: Multiple Interpretations Not Presented

**Scenario:** User says "make the search faster"

**❌ What AI Does Wrong:**

Immediately implements database indexes, query optimization, Redis caching, and async processing without asking WHAT kind of "faster" matters.

**✅ What Should Happen:**

```markdown
"Make the search faster" could mean:

1. **Faster response time** (< 100ms instead of 500ms)
   - Solution: Add database indexes
   - Effort: 2 hours
   - Risk: Low

2. **Handle more concurrent searches** (throughput)
   - Solution: Connection pooling + async
   - Effort: 4 hours
   - Risk: Medium

3. **Faster perceived speed** (UX)
   - Solution: Show partial results immediately
   - Effort: 3 hours
   - Risk: Low

Current search: 500ms for typical query, 10 concurrent users.
Which aspect matters most?
```

---

## Section 2: Simplicity First

### Anti-Pattern 2.1: Over-Abstraction in Architecture

**Scenario:** User wants "discount calculation" feature

**❌ What AI Does Wrong:**

```python
from abc import ABC, abstractmethod
from enum import Enum
from dataclasses import dataclass

class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, amount: float) -> float:
        pass

class PercentageDiscount(DiscountStrategy):
    def __init__(self, percentage: float):
        self.percentage = percentage
    def calculate(self, amount: float) -> float:
        return amount * (self.percentage / 100)

class FixedDiscount(DiscountStrategy):
    def __init__(self, fixed: float):
        self.fixed = fixed
    def calculate(self, amount: float) -> float:
        return min(self.fixed, amount)

class DiscountFactory:
    @staticmethod
    def create(type: str, value: float) -> DiscountStrategy:
        if type == "percentage":
            return PercentageDiscount(value)
        elif type == "fixed":
            return FixedDiscount(value)
        
# 100+ lines for simple math
```

**Problems:**
- Strategy pattern for single use case
- Abstract base class with 2 subclasses (could be function)
- Factory pattern unnecessarily complex
- 100+ lines when 10 would do

**✅ What Should Happen:**

```python
def calculate_discount(amount: float, percent: float) -> float:
    """Calculate percentage discount."""
    return amount * (percent / 100)

# Usage
discount = calculate_discount(100.0, 10.0)  # $10 off
```

**When to add complexity:**
- Wait until you have 3+ discount types actually being used
- Then refactor with pattern if needed
- Don't pre-optimize for hypothetical future

---

### Anti-Pattern 2.2: Speculative Features in /build

**Scenario:** User asks to "save user preferences"

**❌ What AI Does Wrong:**

```python
class PreferenceManager:
    def __init__(self, db, cache=None, validator=None, notifier=None):
        self.db = db
        self.cache = cache or InMemoryCache()
        self.validator = validator or DefaultValidator()
        self.notifier = notifier
    
    def save(self, user_id: int, prefs: dict,
             merge: bool = True,
             validate: bool = True, 
             notify: bool = False,
             backup: bool = False) -> bool:
        
        if validate:
            errors = self.validator.validate(prefs)
            if errors:
                raise ValidationError(errors)
        
        if merge:
            existing = self.get(user_id)
            existing.update(prefs)
            prefs = existing
        
        self.db.save(user_id, prefs)
        
        if self.cache:
            self.cache.set(f"prefs:{user_id}", prefs)
        
        if notify and self.notifier:
            self.notifier.send(user_id, "Preferences updated")
        
        if backup:
            self.backup_service.backup(prefs)
        
        return True

# 200+ lines for what should be 10
```

**Problems:**
- Caching system nobody asked for
- Merge functionality not requested
- Notification system not requested
- Backup system not requested
- Configuration options for hypothetical needs

**✅ What Should Happen:**

```python
def save_preferences(db, user_id: int, preferences: dict):
    """Save user preferences to database."""
    db.execute(
        "UPDATE users SET preferences = ? WHERE id = ?",
        (json.dumps(preferences), user_id)
    )

# Done. Add caching/notifications/merging LATER if needed.
```

---

## Section 3: Surgical Changes

### Anti-Pattern 3.1: Drive-by Refactoring in /build

**Scenario:** Task is "Fix empty email validation bug"

**❌ What AI Does Wrong:**

```diff
  def validate_user(user_data):
-     # Check email format
+     """Validate user data."""
+     
-     if not user_data.get('email'):
+     email = user_data.get('email', '').strip()
+     if not email:
          raise ValueError("Email required")
      
-     if '@' not in user_data['email']:
+     if '@' not in email or '.' not in email.split('@')[1]:
          raise ValueError("Invalid email")
      
-     # Check username
+     # Validate username
-     if not user_data.get('username'):
+     username = user_data.get('username', '').strip()
+     if not username:
          raise ValueError("Username required")
+     if len(username) < 3:
+         raise ValueError("Username too short")
+     if not username.isalnum():
+         raise ValueError("Username must be alphanumeric")
```

**Problems:**
- Added docstring (not part of bug fix)
- Enhanced email validation beyond bug fix
- Added username validation (not in task)
- Changed comments
- Reformatted code

**✅ What Should Happen:**

```diff
  def validate_user(user_data):
      # Check email format
-     if not user_data.get('email'):
+     email = user_data.get('email', '')
+     if not email or not email.strip():
          raise ValueError("Email required")
      
-     if '@' not in user_data['email']:
+     if '@' not in email:
          raise ValueError("Invalid email")
      
      # Check username
      if not user_data.get('username'):
          raise ValueError("Username required")
      
      return True
```

**Only changed:** Lines that fix empty email bug. Nothing else.

---

### Anti-Pattern 3.2: Style Drift

**Scenario:** Task is "Add logging to upload function"

**❌ What AI Does Wrong:**

```diff
- def upload_file(file_path, destination):
+ def upload_file(file_path: str, destination: str) -> bool:
+     """Upload file with logging."""
      try:
-         with open(file_path, 'rb') as f:
+         with open(file_path, "rb") as f:
              data = f.read()
          
-         response = requests.post(destination, files={'file': data})
+         response = requests.post(destination, files={"file": data})
          
          if response.status_code == 200:
+             logger.info(f"Upload successful: {file_path}")
              return True
          else:
+             logger.error(f"Upload failed: {file_path}")
              return False
      except Exception as e:
-         print(f"Error: {e}")
+         logger.exception(f"Upload error: {file_path}")
          return False
```

**Problems:**
- Changed quote style ('' to "")
- Added type hints (not requested)
- Added docstring
- Reformatted code structure

**✅ What Should Happen:**

```diff
+ import logging
+ logger = logging.getLogger(__name__)
+ 
  def upload_file(file_path, destination):
+     logger.info(f'Starting upload: {file_path}')
      try:
          with open(file_path, 'rb') as f:
              data = f.read()
          
          response = requests.post(destination, files={'file': data})
          
          if response.status_code == 200:
+             logger.info(f'Upload successful: {file_path}')
              return True
          else:
+             logger.error(f'Upload failed: {file_path}')
              return False
      except Exception as e:
-         print(f"Error: {e}")
+         logger.exception(f'Upload error: {file_path}')
          return False
```

**Matched:** Existing style (single quotes, no type hints, spacing)

---

## Section 4: Goal-Driven Execution

### Anti-Pattern 4.1: Vague Success Criteria

**Scenario:** User says "Fix the authentication system"

**❌ What AI Does Wrong:**

```markdown
I'll fix the authentication system by:
1. Reviewing the code
2. Identifying issues
3. Making improvements
4. Testing the changes

[Proceeds without clear definition of "done"]
```

**Problems:**
- No specific success criteria
- "Fix" is undefined
- No way to verify success
- Could mean anything

**✅ What Should Happen:**

```markdown
"Fix authentication" is vague. What specific issue are we solving?

If the issue is "users stay logged in after password change":

Plan:
1. Write test: Change password → old session invalidated
   Verify: Test fails (reproduces bug)

2. Implement: Invalidate sessions on password change
   Verify: Test passes

3. Test edge case: Multiple active sessions
   Verify: All sessions invalidated

4. Run full auth test suite
   Verify: No regressions (all tests green)

What's the specific auth issue you're seeing?
```

---

### Anti-Pattern 4.2: No Test-First Approach

**Scenario:** Bug report: "Sorting breaks with duplicate scores"

**❌ What AI Does Wrong:**

```python
# Immediately "fixes" without reproducing bug
def sort_scores(scores):
    return sorted(scores, key=lambda x: (-x['score'], x['name']))

# How do we know this fixes it?
```

**✅ What Should Happen:**

```python
# FIRST: Reproduce the bug with a test
def test_sort_with_duplicate_scores():
    """Test that duplicate scores are handled consistently."""
    scores = [
        {'name': 'Alice', 'score': 100},
        {'name': 'Bob', 'score': 100},
        {'name': 'Charlie', 'score': 90},
    ]
    
    # Run test 10 times - should be consistent
    results = [sort_scores(scores) for _ in range(10)]
    
    # Check all runs produced same order
    for result in results:
        assert result[0]['score'] == 100
        assert result[1]['score'] == 100
        assert result[2]['score'] == 90

# Verify: Test fails with current implementation (bug reproduced)

# THEN: Fix with stable sort
def sort_scores(scores):
    """Sort by score desc, then name asc for ties."""
    return sorted(scores, key=lambda x: (-x['score'], x['name']))

# Verify: Test now passes consistently
```

---

## Common Patterns Summary

| Anti-Pattern | Example | Fix |
|--------------|---------|-----|
| **Silent assumptions** | Implements JWT without asking | Present: JWT vs sessions vs OAuth |
| **Overcomplication** | Strategy pattern for 1 use | Simple function until 2nd use case |
| **Scope creep** | Adds password reset to "login" task | Only login, nothing else |
| **Drive-by refactoring** | Fixes bug + reformats file | Only fix the bug |
| **Style drift** | Changes quotes while adding feature | Match existing style |
| **Vague criteria** | "Make it work" | "Test X passes, curl Y returns 200" |

---

## Self-Check Before Submitting

Use this checklist:

**Think Before Coding:**
- [ ] Did I ask questions about ambiguities?
- [ ] Did I present multiple options?
- [ ] Did I state my assumptions explicitly?

**Simplicity First:**
- [ ] Is this the minimum code that solves the problem?
- [ ] Do all abstractions have 2+ use cases?
- [ ] Would a senior engineer call this overcomplicated?

**Surgical Changes:**
- [ ] Do all changed files relate to the task?
- [ ] Did I avoid reformatting or style changes?
- [ ] Did I only touch broken code, not adjacent code?

**Goal-Driven:**
- [ ] Are success criteria specific and verifiable?
- [ ] Can I prove each step worked?
- [ ] Did I actually run the verification steps?

If any answer is NO → Fix before submitting.

---

## Learning from Mistakes

When you catch yourself making these mistakes:

1. **Don't feel bad** - These are common AI patterns
2. **Learn the signal** - Recognize it next time
3. **Fix immediately** - Revert and do it right
4. **Update the pattern** - Add to your mental checklist

The goal: Build muscle memory for engineering principles until they're automatic.

---

**Remember:** Good code is simple code that solves today's problem, not tomorrow's problem prematurely.
