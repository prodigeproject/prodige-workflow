# Engineering Anti-Pattern Library

Learn from common AI coding mistakes. Each example shows what AI typically does wrong and what should happen instead.

---

## 1. Think Before Coding - Anti-Patterns

### Anti-Pattern 1.1: Silent Assumptions in /design

**Scenario:** User says "Add authentication to the API"

**❌ What AI Does Wrong (Silent Assumptions):**

```markdown
## Architecture: Authentication System

I'll implement:
- JWT-based authentication
- Redis for token storage
- Refresh token mechanism
- OAuth2 providers (Google, GitHub)
- 2FA with TOTP
- Rate limiting
- Password reset flow
- Email verification

Tech stack:
- jsonwebtoken library
- Redis cluster
- Nodemailer for emails
- speakeasy for 2FA
```

**Problems:**
- Assumed JWT (could be sessions, OAuth, API keys)
- Assumed Redis (could be in-memory, database)
- Assumed OAuth providers (not requested)
- Assumed 2FA (not requested)
- Made it complex without asking if needed

---

**✅ What Should Happen (Surface Assumptions):**

```markdown
Before proposing authentication architecture, I need clarification:

**1. Authentication Method:**
- Option A: Session-based (cookies, simplest for web apps)
- Option B: JWT tokens (stateless, good for APIs/mobile)
- Option C: OAuth only (delegate to Google/GitHub)

**2. Scope:**
- Which endpoints need protection? All /api/* routes?
- New user management or integrate existing?

**3. Requirements:**
- Password requirements? (length, complexity)
- "Remember me" needed?
- 2FA required?
- Password reset flow needed now or later?

**4. Scale:**
- Expected concurrent users? (affects session storage choice)

**My recommendation:** Start with Option A (sessions) for MVP.
- Pros: Simple, 50 lines, secure, works immediately
- Cons: Requires sticky sessions if multi-server (not issue for MVP)

Can add JWT/OAuth later if needed for mobile or microservices.

Thoughts?
```

**Why this is better:**
- Lists assumptions explicitly
- Presents multiple options with tradeoffs
- Asks clarifying questions
- Recommends simplest approach
- Explains when complexity is justified

---

### Anti-Pattern 1.2: Multiple Interpretations, Silent Choice

**Scenario:** User says "Make the app faster"

**❌ What AI Does Wrong:**

Immediately implements:
- Redis caching layer
- Database query optimization
- CDN setup
- Code minification
- Image compression
- Lazy loading
- Service workers

(400+ lines changed, 2 days of work)

**Problems:**
- "Faster" could mean: response time, page load, perceived speed, throughput
- Didn't ask which part is slow
- Didn't measure current performance
- Optimized everything instead of bottleneck

---

**✅ What Should Happen:**

```markdown
"Make it faster" could mean different things:

**Option 1: Faster API response time**
- Current: How long do API calls take now?
- Target: What's acceptable? (<100ms? <500ms?)
- Solution: Add indexes, optimize queries, cache
- Effort: 2-4 hours

**Option 2: Faster page load**
- Current: What's the Time to Interactive now?
- Target: <3 seconds?
- Solution: Code splitting, image optimization, CDN
- Effort: 1 day

**Option 3: Faster perceived speed**
- Current: Users feel it's slow because no loading feedback
- Solution: Loading states, optimistic updates, skeleton screens
- Effort: 4-6 hours

**Option 4: Higher throughput**
- Current: How many requests/second can system handle?
- Target: Need to handle 10x more users?
- Solution: Horizontal scaling, load balancing
- Effort: 2-3 days

**Next steps:**
1. Can you measure current performance? (response times, page load)
2. Which specific area feels slow to users?
3. What's the target metric?

Once I know the bottleneck, I can optimize specifically instead of guessing.
```

**Why this is better:**
- Clarifies multiple interpretations
- Asks for current metrics
- Defines success criteria
- Avoids premature optimization
- Focuses effort on actual bottleneck

---

## 2. Simplicity First - Anti-Patterns

### Anti-Pattern 2.1: Over-Abstraction

**Scenario:** "Add a discount calculation to checkout"

**❌ What AI Does Wrong (Overengineered):**

```typescript
// Creates 8 files, 400+ lines

// discount/types.ts
interface DiscountStrategy {
  calculate(amount: number, context: DiscountContext): number;
}

interface DiscountContext {
  userId: string;
  cartTotal: number;
  itemCount: number;
  timestamp: Date;
}

// discount/strategies/PercentageDiscount.ts
class PercentageDiscount implements DiscountStrategy {
  constructor(private percentage: number) {}
  
  calculate(amount: number, context: DiscountContext): number {
    return amount * (this.percentage / 100);
  }
}

// discount/strategies/FixedDiscount.ts
class FixedDiscount implements DiscountStrategy {
  constructor(private fixedAmount: number) {}
  
  calculate(amount: number, context: DiscountContext): number {
    return Math.min(this.fixedAmount, amount);
  }
}

// discount/strategies/TieredDiscount.ts
class TieredDiscount implements DiscountStrategy {
  constructor(private tiers: DiscountTier[]) {}
  
  calculate(amount: number, context: DiscountContext): number {
    // 50 lines of tiered logic
  }
}

// discount/DiscountFactory.ts
class DiscountFactory {
  static createDiscount(type: string, config: any): DiscountStrategy {
    // Factory pattern for single use case
  }
}

// discount/DiscountManager.ts
class DiscountManager {
  constructor(
    private strategy: DiscountStrategy,
    private validator: DiscountValidator,
    private logger: DiscountLogger
  ) {}
  
  applyDiscount(amount: number, context: DiscountContext): number {
    // Dependency injection for simple calculation
  }
}
```

**Problems:**
- 8 files for one discount calculation
- Strategy pattern with 1 actual use case (percentage)
- Factory pattern unnecessary
- Dependency injection overkill
- 400 lines to do what 10 lines can do

---

**✅ What Should Happen (Simple):**

```typescript
// checkout.ts
function calculateDiscount(cartTotal: number, discountPercent: number): number {
  return cartTotal * (discountPercent / 100);
}

// Usage
const discount = calculateDiscount(100, 10); // $10 off
const finalAmount = cartTotal - discount;
```

**That's it. 3 lines.**

**When to add complexity:**
- When you have 2+ discount types actually being used
- When requirements explicitly ask for extensibility
- When current simple approach breaks

**Not before.**

---

### Anti-Pattern 2.2: Speculative Features

**Scenario:** "Save user preferences to database"

**❌ What AI Does Wrong:**

```typescript
class PreferenceManager {
  constructor(
    private db: Database,
    private cache?: CacheService,
    private validator?: PreferenceValidator,
    private eventBus?: EventBus
  ) {}
  
  async save(
    userId: string,
    prefs: Preferences,
    options: {
      merge?: boolean,        // Merge with existing prefs
      validate?: boolean,     // Validate before saving
      notify?: boolean,       // Send notification to user
      broadcast?: boolean,    // Broadcast to other sessions
      ttl?: number,          // Cache TTL
      backup?: boolean       // Backup old prefs
    } = {}
  ): Promise<SaveResult> {
    // 150 lines of speculative logic
    
    if (options.validate) {
      await this.validator.validate(prefs);
    }
    
    if (options.merge) {
      const existing = await this.get(userId);
      prefs = this.merge(existing, prefs);
    }
    
    if (options.backup) {
      await this.backupPreferences(userId);
    }
    
    await this.db.save(userId, prefs);
    
    if (this.cache) {
      await this.cache.set(`prefs:${userId}`, prefs, options.ttl);
    }
    
    if (options.notify) {
      await this.notifyUser(userId);
    }
    
    if (options.broadcast && this.eventBus) {
      await this.eventBus.emit('preferences:updated', { userId, prefs });
    }
    
    return { success: true, timestamp: new Date() };
  }
}
```

**Problems:**
- 6 optional features nobody requested
- Caching (needed for 10 users?)
- Validation (needed now?)
- Merge logic (needed now?)
- Event broadcasting (needed now?)
- Backup mechanism (needed now?)
- All speculative, none requested

---

**✅ What Should Happen:**

```typescript
async function savePreferences(db: Database, userId: string, prefs: object) {
  await db.query(
    'UPDATE users SET preferences = $1 WHERE id = $2',
    [JSON.stringify(prefs), userId]
  );
}

// Usage
await savePreferences(db, 'user123', { theme: 'dark', language: 'en' });
```

**Add complexity ONLY when:**
- Caching: When response time becomes an issue (measure first)
- Validation: When bad data causes problems (happens first)
- Merge: When users request merge behavior
- Broadcasting: When multi-session sync is needed

**Not before you have the problem.**

---

## 3. Surgical Changes - Anti-Patterns

### Anti-Pattern 3.1: Drive-by Refactoring

**Task:** "Fix bug where empty email crashes validator"

**❌ What AI Does Wrong:**

```diff
# File: validators/user.js

  function validateUser(user) {
-   // Check email format
+   /**
+    * Validates user object
+    * @param {Object} user - User data
+    * @returns {boolean} - Validation result
+    */
    
-   if (!user.email) {
+   const email = user.email?.trim() || '';
+   
+   if (!email) {
      throw new Error('Email required');
    }
    
-   if (!user.email.includes('@')) {
+   // Validate email format
+   const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
+   if (!emailRegex.test(email)) {
      throw new Error('Invalid email');
    }
    
-   // Check username
-   if (!user.username) {
+   // Validate username
+   const username = user.username?.trim() || '';
+   if (!username) {
      throw new Error('Username required');
    }
+   
+   // Additional username validation
+   if (username.length < 3) {
+     throw new Error('Username too short');
+   }
+   
+   if (!/^[a-zA-Z0-9_]+$/.test(username)) {
+     throw new Error('Username invalid characters');
+   }
+   
+   // Validate password if present
+   if (user.password && user.password.length < 8) {
+     throw new Error('Password too short');
+   }
    
    return true;
  }

# File: validators/email.js (NEW FILE, NOT IN TASK)
+ function isValidEmail(email) {
+   const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
+   return regex.test(email);
+ }

# File: utils/string.js (UNRELATED TO TASK)
- function trim(str) {
-   return str.replace(/^\s+|\s+$/g, '');
- }
+ // Modern implementation
+ const trim = (str) => str?.trim() ?? '';
```

**Problems:**
- Task was "fix empty email crash"
- Added docstring (not requested)
- Improved email validation (not requested)
- Added username validation (not in task!)
- Added password validation (not in task!)
- Created new email.js file (not needed)
- Refactored unrelated utils/string.js
- Changed code style (arrow functions)

**Git diff:** 87 additions, 23 deletions across 3 files
**Should be:** 3 additions, 1 deletion in 1 file

---

**✅ What Should Happen (Surgical):**

```diff
# File: validators/user.js

  function validateUser(user) {
    // Check email format
-   if (!user.email) {
+   const email = user.email || '';
+   if (!email || !email.trim()) {
      throw new Error('Email required');
    }
    
-   if (!user.email.includes('@')) {
+   if (!email.includes('@')) {
      throw new Error('Invalid email');
    }
    
    // Check username
    if (!user.username) {
      throw new Error('Username required');
    }
    
    return true;
  }
```

**Changes:** 3 additions, 1 deletion, 1 file
**Touches:** Only the code directly related to empty email crash
**Doesn't touch:** Username validation, email validation improvement, style, comments

---

### Anti-Pattern 3.2: Style Drift

**Task:** "Add logging to upload function"

**❌ What AI Does Wrong:**

```diff
- function uploadFile(filePath, destination) {
+ async function uploadFile(filePath: string, destination: string): Promise<boolean> {
+   const logger = getLogger('upload');
+   logger.info(`Uploading ${filePath} to ${destination}`);
+   
    try {
-     const data = fs.readFileSync(filePath);
-     const response = await api.post(destination, data);
+     const data = await fs.promises.readFile(filePath);
+     const response = await api.post(destination, { data });
+     
+     logger.info(`Upload successful: ${filePath}`);
      return response.ok;
    } catch (error) {
-     console.error(error);
+     logger.error(`Upload failed: ${filePath}`, error);
      return false;
    }
  }
```

**Problems:**
- Added TypeScript types (not in project)
- Changed sync to async fs (not requested)
- Changed console to logger everywhere (only asked for upload logging)
- Changed API call signature
- Made function async (changes caller contracts)

---

**✅ What Should Happen:**

```diff
+ const logger = require('./logger');
+ 
  function uploadFile(filePath, destination) {
+   logger.info('Upload started', { filePath, destination });
+   
    try {
      const data = fs.readFileSync(filePath);
      const response = await api.post(destination, data);
+     
+     if (response.ok) {
+       logger.info('Upload successful', { filePath });
+     }
+     
      return response.ok;
    } catch (error) {
-     console.error(error);
+     logger.error('Upload failed', { filePath, error });
      return false;
    }
  }
```

**Changes:** Added logging only, kept existing patterns

---

## 4. Goal-Driven Execution - Anti-Patterns

### Anti-Pattern 4.1: Vague Success Criteria

**Task:** "Add authentication to the API"

**❌ What AI Does Wrong:**

```
I'll implement authentication for the API.

Steps:
1. Create authentication system
2. Add security
3. Test it
4. Deploy

Starting implementation...
```

**Problems:**
- No specific definition of "done"
- Can't verify automatically
- "Test it" - how? what tests?
- No clear success criteria

---

**✅ What Should Happen:**

```
Plan for API authentication:

**Step 1: Implement login endpoint**
Verify:
- Command: curl -X POST /api/login -d '{"email":"test@example.com","password":"test123"}'
- Expected: Returns 200 with { "token": "..." }
- Test: npm test -- auth/login.test.js (3 tests)

**Step 2: Implement token validation middleware**
Verify:
- Command: curl /api/protected (no token)
- Expected: Returns 401 Unauthorized
- Command: curl -H "Authorization: Bearer <token>" /api/protected
- Expected: Returns 200 with data
- Test: npm test -- auth/middleware.test.js (5 tests)

**Step 3: Protect existing endpoints**
Verify:
- All /api/users/* endpoints require token
- All /api/posts/* endpoints require token
- Test: npm test -- integration/protected-routes.test.js (8 tests)

**Step 4: Add token expiration**
Verify:
- Expired token returns 401
- Valid token works
- Test: npm test -- auth/expiration.test.js (3 tests)

**Success Criteria:**
✓ All 19 tests passing
✓ Manual curl tests work as specified
✓ Postman collection updated with auth examples

Proceeding with Step 1...
```

**Why this is better:**
- Each step has specific verification
- Can run commands to verify
- Clear pass/fail criteria
- Automated tests
- Knows exactly when "done"

---

## Summary: Red Flags Checklist

Use this checklist to catch anti-patterns:

### Think Before Coding
- [ ] Did I assume something without asking?
- [ ] Did I pick one interpretation when multiple exist?
- [ ] Did I explain why I chose this approach?

### Simplicity First
- [ ] Is this the simplest solution that works?
- [ ] Am I using abstractions with only 1 use case?
- [ ] Am I adding features nobody requested?
- [ ] Could 200 lines be 50 lines?

### Surgical Changes
- [ ] Did I only touch files related to the task?
- [ ] Did I refactor code that wasn't broken?
- [ ] Did I change style, formatting, or comments?
- [ ] Is every change traceable to the request?

### Goal-Driven
- [ ] Can my success criteria be verified automatically?
- [ ] Is "done" clearly defined?
- [ ] Can someone else run my verification steps?

---

**Remember:** These anti-patterns are COMMON. AI agents naturally drift toward complexity. engineering principles keep you disciplined.
