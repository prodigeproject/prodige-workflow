# Conventions & Patterns

Learned coding patterns, best practices, and anti-patterns discovered during development.

---

## Code Style

### General Principles
- **Clarity over cleverness** - Write code that's easy to understand
- **Consistency** - Follow established patterns in the codebase
- **Modularity** - Keep functions and modules focused and small
- **DRY** (Don't Repeat Yourself) - Extract common patterns

### Language-Specific
#### JavaScript/TypeScript
- Use `const` by default, `let` when reassignment needed
- Prefer arrow functions for callbacks
- Use destructuring for cleaner code
- Async/await over promise chains

#### Python
- Follow PEP 8 style guide
- Use type hints for public APIs
- Prefer list comprehensions for simple transformations
- Use context managers (with statements)

#### [Other Languages]
[Add as discovered]

---

## File Naming

### Conventions
- **Components**: `PascalCase` (e.g., `UserProfile.tsx`)
- **Utilities**: `camelCase` (e.g., `formatDate.js`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `API_ENDPOINTS.js`)
- **Files**: `kebab-case` for general files (e.g., `user-service.js`)
- **Tests**: Same as source with `.test` or `.spec` suffix

### Directory Structure
```
src/
├── components/     # UI components
├── lib/            # Shared utilities
├── services/       # Business logic
├── types/          # Type definitions
├── hooks/          # Custom hooks (if React)
└── utils/          # Helper functions
```

---

## Component Patterns

### Pattern: [Pattern Name]
**When to use**: [Context]

**Structure**:
```javascript
// Example code showing pattern
```

**Why it works**: [Explanation]

---

## Testing Approach

### Test Structure (AAA Pattern)
```javascript
// Arrange - Setup test data and conditions
const user = createTestUser();

// Act - Execute the code being tested
const result = processUser(user);

// Assert - Verify the results
expect(result.status).toBe('active');
```

### What to Test
✅ **Do test**:
- Public API functions
- Edge cases and error conditions
- Business logic
- Critical user paths

❌ **Don't test**:
- Implementation details
- Third-party library internals
- Trivial getters/setters

### Mocking Strategy
- Mock external dependencies (APIs, databases)
- Use real implementations for our code when possible
- Keep mocks simple and close to real behavior

---

## Common Mistakes to Avoid ⚠️

### ❌ Anti-Pattern 1: [Name]
**Problem**: [What's wrong]

**Why it's bad**: [Consequences]

**Example**:
```javascript
// BAD
[Bad code example]
```

**Do instead**:
```javascript
// GOOD
[Good code example]
```

---

### ❌ Anti-Pattern 2: Premature Optimization
**Problem**: Optimizing before knowing where the bottleneck is

**Why it's bad**: 
- Wastes time
- Makes code more complex
- May optimize the wrong thing

**Do instead**: 
- Write clear code first
- Profile to find actual bottlenecks
- Optimize what matters

---

### ❌ Anti-Pattern 3: God Objects/Functions
**Problem**: One function/object doing too many things

**Why it's bad**:
- Hard to test
- Hard to understand
- Hard to change

**Do instead**:
- Single Responsibility Principle
- Extract smaller focused functions
- Use composition

---

### ❌ Anti-Pattern 4: Silent Failures
**Problem**: Catching errors but not handling them

**Why it's bad**:
- Bugs hide in production
- Hard to debug
- Bad user experience

**Do instead**:
```javascript
// BAD
try {
  doSomething();
} catch (e) {
  // Silent failure
}

// GOOD
try {
  doSomething();
} catch (error) {
  logger.error('Failed to do something', error);
  notifyUser('Operation failed');
  // Or rethrow if can't handle
  throw error;
}
```

---

## Proven Patterns ✅

### ✅ Pattern 1: Early Returns
**Context**: Complex conditional logic

**Pattern**:
```javascript
// GOOD - Early returns make logic clearer
function processUser(user) {
  if (!user) return null;
  if (!user.isActive) return null;
  if (!user.hasPermission) return null;
  
  // Main logic here
  return processActiveUser(user);
}

// vs nested ifs
```

**Why it works**: Reduces nesting, makes happy path clear

---

### ✅ Pattern 2: Guard Clauses
**Context**: Validating inputs

**Pattern**:
```javascript
function calculateDiscount(user, purchase) {
  // Guard clauses at the top
  if (!user) throw new Error('User required');
  if (!purchase) throw new Error('Purchase required');
  if (purchase.amount <= 0) throw new Error('Invalid amount');
  
  // Main logic
  return purchase.amount * user.discountRate;
}
```

**Why it works**: Fail fast, clear requirements

---

### ✅ Pattern 3: Composition Over Inheritance
**Context**: Code reuse

**Pattern**:
```javascript
// GOOD - Composition
const withLogging = (fn) => (...args) => {
  console.log('Calling', fn.name);
  return fn(...args);
};

const withErrorHandling = (fn) => (...args) => {
  try {
    return fn(...args);
  } catch (error) {
    handleError(error);
  }
};

// vs deep inheritance hierarchies
```

**Why it works**: More flexible, easier to understand

---

### ✅ Pattern 4: Configuration Objects
**Context**: Functions with many parameters

**Pattern**:
```javascript
// GOOD - Configuration object
function createUser({
  name,
  email,
  role = 'user',
  isActive = true,
  permissions = []
}) {
  // Implementation
}

// vs many positional parameters
// createUser(name, email, role, isActive, permissions)
```

**Why it works**: Self-documenting, optional parameters easy

---

## Git Commit Conventions

### Format
```
type(scope): subject

body

footer
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes bug nor adds feature
- `test`: Adding tests
- `chore`: Maintain, dependencies, etc.

### Examples
```
feat(auth): add OAuth login support

Implements Google OAuth 2.0 authentication flow.
Users can now login with their Google accounts.

Closes #123
```

---

## API Design Principles

### RESTful Conventions
- Use nouns for resources: `/users`, `/posts`
- Use HTTP methods appropriately: GET, POST, PUT, DELETE
- Return appropriate status codes
- Use pagination for large collections

### Error Responses
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "field": "email"
  }
}
```

---

## Performance Guidelines

### Do
- Lazy load when possible
- Cache expensive computations
- Use appropriate data structures
- Profile before optimizing

### Don't
- Premature optimization
- Micro-optimize without measuring
- Load all data upfront
- Ignore memory leaks

---

## Security Best Practices

### Always
- Validate and sanitize input
- Use parameterized queries
- Implement proper authentication
- Use HTTPS in production
- Keep dependencies updated

### Never
- Trust user input
- Store passwords in plain text
- Expose sensitive data in logs
- Use hardcoded secrets

---

## Documentation Guidelines

### When to Document
- Public APIs
- Complex algorithms
- Non-obvious decisions
- Setup/configuration steps

### When Not to Document
- Obvious code
- Self-explanatory functions
- Redundant comments

### Good Documentation
```javascript
/**
 * Calculates compound interest using the formula: A = P(1 + r/n)^(nt)
 * 
 * @param {number} principal - Initial amount (P)
 * @param {number} rate - Annual interest rate as decimal (r)
 * @param {number} compounds - Times interest compounds per year (n)
 * @param {number} years - Investment duration in years (t)
 * @returns {number} Final amount (A)
 * 
 * @example
 * calculateCompoundInterest(1000, 0.05, 4, 10)
 * // Returns: 1643.62
 */
function calculateCompoundInterest(principal, rate, compounds, years) {
  return principal * Math.pow(1 + rate / compounds, compounds * years);
}
```

---

## Project-Specific Patterns

[Add patterns specific to this project as they're discovered]

---

## Learning Log

### [Date] - [What We Learned]
[Description of learning]

**Context**: [When/why this came up]

**Lesson**: [What to do/not do]

**Impact**: [How this affects our work]

---

**Last Updated**: [Date]  
**Update Frequency**: As new patterns discovered or mistakes made
