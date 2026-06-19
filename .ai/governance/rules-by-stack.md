# Code Quality Rules by Stack

Language-specific best practices to ensure consistent quality across different technology stacks.

---

## 🟨 JavaScript / TypeScript

### Type Safety (TypeScript)
- ✅ No `any` type (use `unknown` if truly dynamic)
- ✅ Strict mode enabled in `tsconfig.json`
- ✅ Exhaustive switch statements (`as const` + union types)
- ✅ No `@ts-ignore` without explanation comment
- ✅ Type imports/exports explicit (`import type`)

```typescript
// ❌ BAD
function process(data: any) { }

// ✅ GOOD
function process(data: unknown) {
  if (typeof data === 'string') {
    // Type-safe handling
  }
}
```

### Variables & Scoping
- ✅ Prefer `const` over `let`, never use `var`
- ✅ Destructure objects/arrays when accessing multiple properties
- ✅ Use optional chaining (`?.`) and nullish coalescing (`??`)
- ✅ No magic numbers (use named constants)

```typescript
// ❌ BAD
let user = data.user;
let name = user.name;

// ✅ GOOD
const { name, email } = data.user ?? {};
```

### Functions
- ✅ Async/await over raw Promises
- ✅ Arrow functions for callbacks
- ✅ Named exports over default exports
- ✅ Max 3 parameters (use object for more)
- ✅ Return early (avoid deep nesting)

```typescript
// ❌ BAD
export default function validateUser(name, email, age, role) {
  return new Promise((resolve, reject) => {
    // nested logic
  });
}

// ✅ GOOD
export async function validateUser(params: UserParams) {
  const { name, email, age, role } = params;
  if (!name) throw new Error('Name required');
  // early returns
}
```

### Error Handling
- ✅ Try-catch for async operations
- ✅ Custom error classes for different error types
- ✅ No silent failures (`catch` without logging)
- ✅ Error boundaries in React

### Code Organization
- ✅ No `console.log` in production code (use proper logging)
- ✅ Files <300 lines (split larger files)
- ✅ One component/class per file
- ✅ Barrel exports (`index.ts`) for clean imports

---

## 🐍 Python

### Type Hints
- ✅ Type hints on all function signatures
- ✅ Use `typing` module for complex types
- ✅ Run `mypy` for type checking
- ✅ No `# type: ignore` without explanation

```python
# ❌ BAD
def calculate(x, y):
    return x + y

# ✅ GOOD
def calculate(x: int, y: int) -> int:
    return x + y
```


### Error Handling
- ✅ No bare `except:` (always specify exception type)
- ✅ Use context managers (`with`) for resources
- ✅ Custom exception classes for domain errors
- ✅ Logging over print statements

```python
# ❌ BAD
try:
    file = open('data.txt')
    data = file.read()
except:
    pass

# ✅ GOOD
try:
    with open('data.txt') as file:
        data = file.read()
except FileNotFoundError as e:
    logger.error(f"File not found: {e}")
    raise
```

### Code Style
- ✅ Use `pathlib` over `os.path`
- ✅ List/dict comprehensions over loops (when readable)
- ✅ F-strings for string formatting
- ✅ Docstrings for all public APIs (Google/NumPy style)
- ✅ Max line length 88 (Black default)

```python
# ❌ BAD
result = []
for item in items:
    if item.active:
        result.append(item.name)

# ✅ GOOD
result = [item.name for item in items if item.active]
```

### Functions & Classes
- ✅ Max 3 positional args (use keyword-only args: `*,`)
- ✅ Dataclasses for data containers
- ✅ `@property` for computed attributes
- ✅ No mutable default arguments

```python
# ❌ BAD
def process(items=[]):  # Mutable default!
    items.append(1)

# ✅ GOOD
def process(items: list[int] | None = None) -> list[int]:
    if items is None:
        items = []
    items.append(1)
    return items
```

---

## 🦀 Rust

### Error Handling (RTK Patterns)
- ✅ No `unwrap()` or `expect()` in production code
- ✅ Use `?` operator with `.context()` (anyhow)
- ✅ Fallback pattern (graceful degradation)
- ✅ Custom error types with `thiserror`

```rust
// ❌ BAD
let config = read_config().unwrap();

// ✅ GOOD
let config = read_config()
    .context("Failed to read config file")?;
```

### Performance Patterns
- ✅ Lazy regex compilation (`lazy_static!` or `once_cell`)
- ✅ String borrowing (`&str`) over cloning (`String`)
- ✅ Avoid unnecessary allocations
- ✅ Zero-copy parsing when possible

```rust
// ❌ BAD
fn process(input: String) -> String {
    input.to_uppercase()
}

// ✅ GOOD (borrows input)
fn process(input: &str) -> String {
    input.to_uppercase()
}
```

### Pattern Matching
- ✅ Exhaustive matching (no `_` wildcard unless necessary)
- ✅ Use `match` over `if let` chains
- ✅ Destructure in match arms

```rust
// ❌ BAD
if let Some(x) = value {
    // ...
} else {
    // ...
}

// ✅ GOOD
match value {
    Some(x) => { /* ... */ },
    None => { /* ... */ },
}
```

### Code Organization
- ✅ Modules per file/folder
- ✅ Public API explicit (`pub`)
- ✅ Documentation comments (`///`) for public items
- ✅ Unit tests in same file (`#[cfg(test)]`)

### CLI-Specific (RTK Rules)
- ✅ Zero async (for <10ms startup)
- ✅ Exit code preservation
- ✅ No unnecessary dependencies (keep binary small)
- ✅ Graceful fallback on errors

---

## 🐹 Go

### Error Handling
- ✅ No naked returns
- ✅ Error checking on every error-returning call
- ✅ Wrap errors with context (`fmt.Errorf("%w", err)`)
- ✅ Custom error types for domain errors

```go
// ❌ BAD
func process() (result string, err error) {
    result = "value"
    return  // naked return
}

// ✅ GOOD
func process() (string, error) {
    result := "value"
    return result, nil
}
```

### Concurrency
- ✅ Channels for goroutine communication
- ✅ Context for cancellation
- ✅ `sync.WaitGroup` for waiting
- ✅ Avoid shared state (use message passing)

```go
// ✅ GOOD
func processItems(ctx context.Context, items []Item) error {
    for _, item := range items {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            process(item)
        }
    }
    return nil
}
```

### Testing
- ✅ Table-driven tests
- ✅ Test files named `*_test.go`
- ✅ Benchmark tests for performance-critical code
- ✅ Use `testify` for assertions

```go
func TestCalculate(t *testing.T) {
    tests := []struct {
        name     string
        input    int
        expected int
    }{
        {"zero", 0, 0},
        {"positive", 5, 25},
        {"negative", -3, 9},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := calculate(tt.input)
            assert.Equal(t, tt.expected, result)
        })
    }
}
```

### Code Style
- ✅ Interfaces in consumer package, not producer
- ✅ Accept interfaces, return structs
- ✅ Short variable names in small scopes
- ✅ `gofmt` formatted (automatic)

---

## ⚛️ React / Frontend

### Component Structure
- ✅ Functional components with hooks (no class components)
- ✅ One component per file
- ✅ Props interface/type defined
- ✅ Default props via destructuring

```typescript
// ✅ GOOD
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export function Button({ 
  label, 
  onClick, 
  variant = 'primary' 
}: ButtonProps) {
  return <button onClick={onClick}>{label}</button>;
}
```


### State Management
- ✅ No prop drilling >2 levels (use context/state management)
- ✅ `useState` for component state
- ✅ `useEffect` cleanup functions
- ✅ Custom hooks for reusable logic

```typescript
// ❌ BAD: Prop drilling
<Parent>
  <Child user={user}>
    <GrandChild user={user}>
      <GreatGrandChild user={user} />

// ✅ GOOD: Context
const UserContext = createContext<User | null>(null);

function Parent() {
  return (
    <UserContext.Provider value={user}>
      <Child />
    </UserContext.Provider>
  );
}
```

### Performance
- ✅ Memoization for expensive computations (`useMemo`)
- ✅ Callback memoization (`useCallback`)
- ✅ Code splitting for routes (`React.lazy`)
- ✅ Virtual scrolling for large lists

### Accessibility
- ✅ Semantic HTML (`<button>`, `<nav>`, `<main>`)
- ✅ ARIA labels where needed
- ✅ Keyboard navigation support
- ✅ Focus management
- ✅ Alt text for images

```tsx
// ✅ GOOD
<button 
  onClick={handleClick}
  aria-label="Close dialog"
  aria-pressed={isActive}
>
  <CloseIcon aria-hidden="true" />
</button>
```

### Styling
- ✅ No inline styles (use CSS modules/styled-components)
- ✅ Consistent naming (BEM or CSS-in-JS)
- ✅ Responsive design (mobile-first)
- ✅ Dark mode support

---

## 🗄️ SQL / Databases

### Query Performance
- ✅ Index foreign keys
- ✅ Index columns used in WHERE/JOIN
- ✅ Avoid SELECT * (specify columns)
- ✅ Use LIMIT for large result sets
- ✅ Eliminate N+1 queries (use JOIN or batch load)

```sql
-- ❌ BAD: N+1 query pattern
-- Code: for each user, SELECT * FROM orders WHERE user_id = ?

-- ✅ GOOD: Single query with JOIN
SELECT users.*, orders.*
FROM users
LEFT JOIN orders ON users.id = orders.user_id
WHERE users.active = true;
```

### Migrations
- ✅ Reversible (always provide DOWN migration)
- ✅ Incremental (small atomic changes)
- ✅ Timestamped naming
- ✅ Test on staging before production

### Security
- ✅ Parameterized queries (no string concatenation)
- ✅ Least privilege principle (app user != admin)
- ✅ Encrypt sensitive data at rest
- ✅ Audit logging for sensitive operations

```python
# ❌ BAD: SQL injection risk
query = f"SELECT * FROM users WHERE email = '{email}'"

# ✅ GOOD: Parameterized
query = "SELECT * FROM users WHERE email = ?"
cursor.execute(query, (email,))
```

---

## 🔒 Security (All Stacks)

### Input Validation
- ✅ Validate all user input (never trust client)
- ✅ Whitelist over blacklist
- ✅ Sanitize before storage/display
- ✅ Rate limiting on endpoints

### Authentication & Authorization
- ✅ Password hashing (bcrypt/argon2)
- ✅ JWT with expiration
- ✅ HTTPS only in production
- ✅ CSRF protection
- ✅ Check authorization on every request

### Secrets Management
- ✅ No hardcoded secrets
- ✅ Environment variables for config
- ✅ `.env` in `.gitignore`
- ✅ Secret rotation policy
- ✅ Vault/KMS for production secrets

```typescript
// ❌ BAD
const API_KEY = "sk_live_abc123xyz";

// ✅ GOOD
const API_KEY = process.env.API_KEY;
if (!API_KEY) throw new Error("API_KEY not configured");
```

---

## 📊 Performance (All Stacks)

### Response Times
- ✅ API endpoints p95 <200ms
- ✅ Database queries <50ms
- ✅ Frontend FCP <1.5s, TTI <3s
- ✅ CLI tools startup <100ms

### Optimization Techniques
- ✅ Caching (Redis, CDN)
- ✅ Connection pooling (databases)
- ✅ Lazy loading (images, components, modules)
- ✅ Compression (gzip, brotli)
- ✅ Pagination for large datasets

### Monitoring
- ✅ Performance benchmarks in tests
- ✅ APM in production (New Relic, Datadog)
- ✅ Alerting on degradation
- ✅ Regular performance audits

---

## 📝 Documentation

### Code Comments
- ✅ WHY, not WHAT (code shows what)
- ✅ Document non-obvious decisions
- ✅ Link to tickets/RFCs for context
- ✅ Update comments when code changes

```typescript
// ❌ BAD: Obvious comment
// Increment counter by 1
counter++;

// ✅ GOOD: Explains WHY
// Skip cache for admin users to always show fresh data
// See RFC-123 for security reasoning
if (user.role === 'admin') {
  return fetchFreshData();
}
```

### API Documentation
- ✅ OpenAPI/Swagger for REST APIs
- ✅ GraphQL schema documentation
- ✅ Request/response examples
- ✅ Error codes documented
- ✅ Authentication requirements clear

### README Requirements
- ✅ Installation instructions
- ✅ Quick start example
- ✅ Development setup
- ✅ Testing instructions
- ✅ Deployment guide

---

## 🎯 Stack Selection Guide

When starting a new project, choose stack based on:

### CLI Tools → Rust
- **Why:** Fast startup (<10ms), small binary, type safety
- **When:** Developer tools, system utilities, performance-critical tools

### Web APIs → Python (FastAPI) or TypeScript (Node.js)
- **Python:** Data science, ML integration, rapid prototyping
- **TypeScript:** Real-time features, ecosystem alignment with frontend

### Frontend → React + TypeScript
- **Why:** Strong ecosystem, type safety, developer experience
- **When:** SPAs, interactive UIs, complex state management

### Mobile → React Native or Flutter
- **React Native:** Code sharing with web
- **Flutter:** Performance, beautiful UIs

### Systems Programming → Rust or Go
- **Rust:** Maximum performance, memory safety
- **Go:** Concurrency, simplicity, fast compile times

---

## 🔧 Pre-Commit Configuration by Stack

### JavaScript/TypeScript
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run format && npm run lint && npm run typecheck && npm run test"
    }
  }
}
```

### Python
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.0.270
    hooks:
      - id: ruff
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest
        language: system
        pass_filenames: false
```

### Rust
```toml
# .cargo/config.toml
[alias]
precommit = "fmt --all && clippy --all-targets && test --all"
```

### Go
```makefile
# Makefile
.PHONY: precommit
precommit:
	gofmt -w .
	golangci-lint run
	go test ./...
```

---

## 📚 References

### Internal
- `.ai/context/DECISIONS.md` - Architecture and rule-change decisions (propose rule changes here)
- `.ai/SOUL.md` - Engineering philosophy
- `.ai/governance/quality-gates.md` - Quality standards
- `.ai/governance/rules.md` - General rules
- `.ai/skills/test-driven-development/SKILL.md` - Testing methodology

### General
- Clean Code (Robert C. Martin)
- Refactoring (Martin Fowler)
- Design Patterns (Gang of Four)

### JavaScript/TypeScript
- Effective TypeScript (Dan Vanderkam)
- You Don't Know JS (Kyle Simpson)

### Python
- Fluent Python (Luciano Ramalho)
- Python Testing with pytest (Brian Okken)

### Rust
- The Rust Book (official)
- Rust by Example
- RTK-develop patterns (this project)

### Go
- Effective Go (official)
- The Go Programming Language (Donovan & Kernighan)

---

**Version:** 1.0  
**Last Updated:** 2026-06-17  
**Adopted from:** RTK-develop + industry best practices  
**Maintained by:** Prodige Workflow Team
