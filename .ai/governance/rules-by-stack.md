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
```


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
```


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
```

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
```
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
try:
    with open('data.txt') as file:
        data = file.read()
except FileNotFoundError as e:
    logger.error(f"File not found: {e}")
except IOError as e:
    logger.error(f"IO error: {e}")
```

### Code Organization
- ✅ Use `pathlib` over `os.path`
- ✅ List/dict comprehensions over loops (when readable)
- ✅ Docstrings for all public APIs (Google/NumPy style)
- ✅ No wildcard imports (`from module import *`)
- ✅ Max 300 lines per file

```python
# ❌ BAD
from os.path import join, exists
files = []
for item in items:
    if item.active:
        files.append(item.name)

# ✅ GOOD
from pathlib import Path
files = [item.name for item in items if item.active]
```

### Naming
- ✅ snake_case for functions/variables
- ✅ PascalCase for classes
- ✅ UPPER_CASE for constants
- ✅ Private methods start with `_`

---

## 🦀 Rust

### Error Handling
- ✅ No `unwrap()` or `expect()` in production code
- ✅ Use `?` operator with `.context()` (anyhow crate)
- ✅ Custom error types for domain errors
- ✅ Result<T, E> for fallible operations

```rust
// ❌ BAD
fn read_config() -> Config {
    let content = fs::read_to_string("config.toml").unwrap();
    toml::from_str(&content).unwrap()
}

// ✅ GOOD
use anyhow::{Context, Result};

fn read_config() -> Result<Config> {
    let content = fs::read_to_string("config.toml")
        .context("Failed to read config.toml")?;
    toml::from_str(&content)
        .context("Failed to parse config")
}
```

### Performance Patterns
- ✅ Lazy regex compilation (`lazy_static!` or `once_cell`)
- ✅ String borrowing (`&str`) over cloning (`String`)
- ✅ Iterators over for loops (when idiomatic)
- ✅ Zero-copy parsing where possible
- ✅ Avoid allocations in hot paths

```rust
// ❌ BAD
fn count_words(text: String) -> usize {
    text.split(" ").collect::<Vec<_>>().len()
}

// ✅ GOOD
fn count_words(text: &str) -> usize {
    text.split_whitespace().count()
}
```

### Pattern Matching
- ✅ Exhaustive pattern matching (no `_` wildcard unless justified)
- ✅ Use `match` over long if-else chains
- ✅ Destructure in patterns
- ✅ Use `if let` for single variant

```rust
// ❌ BAD
fn process(cmd: Command) {
    match cmd {
        Command::Build => build(),
        _ => {}
    }
}

// ✅ GOOD
fn process(cmd: Command) {
    match cmd {
        Command::Build => build(),
        Command::Test => test(),
        Command::Deploy => deploy(),
        Command::Help => show_help(),
    }
}
```

### Code Organization
- ✅ Small modules (<500 lines)
- ✅ Public API at top of file
- ✅ Tests in `#[cfg(test)] mod tests`
- ✅ Doc comments for public items (`///`)
- ✅ Examples in doc comments

---

## 🐹 Go

### Error Handling
- ✅ Check errors on every error-returning call
- ✅ Wrap errors with context (`fmt.Errorf("context: %w", err)`)
- ✅ Return early on errors
- ✅ No naked returns

```go
// ❌ BAD
func ReadConfig() (Config, error) {
    data, _ := os.ReadFile("config.json")
    var cfg Config
    json.Unmarshal(data, &cfg)
    return cfg, nil
}

// ✅ GOOD
func ReadConfig() (Config, error) {
    data, err := os.ReadFile("config.json")
    if err != nil {
        return Config{}, fmt.Errorf("read config: %w", err)
    }
    
    var cfg Config
    if err := json.Unmarshal(data, &cfg); err != nil {
        return Config{}, fmt.Errorf("parse config: %w", err)
    }
    
    return cfg, nil
}
```

### Concurrency
- ✅ Channels for goroutine communication
- ✅ Context for cancellation/timeouts
- ✅ WaitGroups for synchronization
- ✅ Mutexes for shared state (minimize usage)
- ✅ Always signal channel closure

```go
// ✅ GOOD
func processItems(ctx context.Context, items []Item) error {
    results := make(chan Result, len(items))
    defer close(results)
    
    var wg sync.WaitGroup
    for _, item := range items {
        wg.Add(1)
        go func(item Item) {
            defer wg.Done()
            select {
            case <-ctx.Done():
                return
            case results <- process(item):
            }
        }(item)
    }
    
    wg.Wait()
    return nil
}
```

### Interfaces
- ✅ Interfaces in consumer package, not producer
- ✅ Small interfaces (1-3 methods)
- ✅ Accept interfaces, return structs
- ✅ Name single-method interfaces with -er suffix

```go
// ✅ GOOD: Consumer defines interface
package handler

type UserStore interface {
    Get(id string) (User, error)
}

func NewHandler(store UserStore) *Handler {
    return &Handler{store: store}
}
```

### Testing
- ✅ Table-driven tests
- ✅ Subtests with `t.Run()`
- ✅ Test helpers (separate from test functions)
- ✅ Test fixtures in `testdata/` folder

---

## ⚛️ React / Frontend

### Component Design
- ✅ No prop drilling >2 levels (use context/state management)
- ✅ Functional components over class components
- ✅ Custom hooks for reusable logic
- ✅ Memoization for expensive computations (`useMemo`, `useCallback`)
- ✅ One component per file

```typescript
// ❌ BAD: Prop drilling
<Parent>
  <Child user={user} theme={theme}>
    <GrandChild user={user} theme={theme}>
      <GreatGrandChild user={user} theme={theme} />
    </GrandChild>
  </Child>
</Parent>

// ✅ GOOD: Context
const UserContext = createContext<User | null>(null);
const ThemeContext = createContext<Theme>(defaultTheme);

<UserContext.Provider value={user}>
  <ThemeContext.Provider value={theme}>
    <Parent>
      <Child>
        <GrandChild>
          <GreatGrandChild />
        </GrandChild>
      </Child>
    </Parent>
  </ThemeContext.Provider>
</UserContext.Provider>
```

### State Management
- ✅ Local state first, global state when needed
- ✅ Lift state up only when necessary
- ✅ Derive values, don't store them
- ✅ Single source of truth

### Accessibility
- ✅ Semantic HTML (`<button>`, `<nav>`, `<main>`, not `<div>`)
- ✅ ARIA labels for screen readers
- ✅ Keyboard navigation support
- ✅ Focus management
- ✅ Color contrast ≥4.5:1

```tsx
// ❌ BAD
<div onClick={handleClick}>Click me</div>

// ✅ GOOD
<button onClick={handleClick} aria-label="Submit form">
  Click me
</button>
```

### Performance
- ✅ Code splitting for routes
- ✅ Lazy loading for heavy components
- ✅ Virtual scrolling for long lists
- ✅ Debounce/throttle for frequent events
- ✅ Image optimization (WebP, lazy loading, responsive)

### Error Boundaries
- ✅ Error boundaries for component trees
- ✅ Fallback UI for errors
- ✅ Error logging/reporting

---

## 🗄️ SQL / Databases

### Query Optimization
- ✅ Indexes on foreign keys and frequently queried columns
- ✅ Avoid SELECT * (specify columns)
- ✅ Use EXPLAIN to analyze query plans
- ✅ Batch operations over loops
- ✅ Pagination for large result sets

```sql
-- ❌ BAD
SELECT * FROM users WHERE email LIKE '%@gmail.com';

-- ✅ GOOD (if domain search is required, use full-text search or index)
SELECT id, name, email FROM users 
WHERE email_domain = 'gmail.com'
LIMIT 100 OFFSET 0;
```

### Data Integrity
- ✅ Foreign key constraints
- ✅ NOT NULL on required columns
- ✅ CHECK constraints for validation
- ✅ Unique constraints on natural keys
- ✅ Transactions for multi-step operations

### Migrations
- ✅ Reversible migrations (up and down)
- ✅ No data loss in migrations
- ✅ Test migrations on staging first
- ✅ Idempotent migrations (can run multiple times)

---

## 🔐 Security (All Stacks)

### Authentication & Authorization
- ✅ No passwords in code/config/logs
- ✅ Hash passwords with bcrypt/argon2
- ✅ Use environment variables for secrets
- ✅ JWT/OAuth for API authentication
- ✅ HTTPS only in production

### Input Validation
- ✅ Validate all user input
- ✅ Sanitize HTML/SQL/shell input
- ✅ Parameterized queries (no string concatenation)
- ✅ Rate limiting on APIs
- ✅ CSRF protection

```python
# ❌ BAD: SQL Injection vulnerability
query = f"SELECT * FROM users WHERE email = '{email}'"

# ✅ GOOD: Parameterized query
query = "SELECT * FROM users WHERE email = ?"
cursor.execute(query, (email,))
```

### Data Protection
- ✅ Encrypt sensitive data at rest
- ✅ TLS for data in transit
- ✅ No PII in logs
- ✅ Secure session management
- ✅ Regular security audits

---

## 🎨 Code Style (General)

### Naming Conventions
- ✅ Clear, descriptive names (no abbreviations)
- ✅ Boolean variables start with `is`/`has`/`can`
- ✅ Functions are verbs, classes are nouns
- ✅ Constants describe what, not how

```typescript
// ❌ BAD
const d = new Date();
const flg = true;
function proc(x) { }

// ✅ GOOD
const currentDate = new Date();
const isAuthenticated = true;
function processPayment(order) { }
```

### Comments
- ✅ Explain WHY, not WHAT (code explains what)
- ✅ Update comments when code changes
- ✅ No commented-out code (use git history)
- ✅ TODO comments include ticket number

```typescript
// ❌ BAD
// Increment i by 1
i++;

// ✅ GOOD
// Retry count starts at 1 because first attempt is not a retry
let retryCount = 1;
```

### Magic Numbers
- ✅ Use named constants
- ✅ Constants explain meaning

```typescript
// ❌ BAD
if (age < 18) { }
setTimeout(callback, 3600000);

// ✅ GOOD
const LEGAL_AGE = 18;
const ONE_HOUR_MS = 60 * 60 * 1000;

if (age < LEGAL_AGE) { }
setTimeout(callback, ONE_HOUR_MS);
```

---

## 📏 File Size Limits

- **JavaScript/TypeScript:** <300 lines per file
- **Python:** <300 lines per file
- **Rust:** <500 lines per module
- **Go:** <500 lines per file
- **React Components:** <200 lines per component

**When to split:**
- Extract helper functions to utils
- Split large components into smaller ones
- Create separate modules for related functionality
- Use barrel exports (`index.ts`) for clean imports

---

## 🚫 Anti-Patterns (All Stacks)

### Code Smells
- ❌ God classes (>500 lines)
- ❌ Long parameter lists (>3-4 params)
- ❌ Deep nesting (>3 levels)
- ❌ Duplicate code
- ❌ Premature optimization
- ❌ Feature envy (class uses another class's methods more than its own)

### Testing Smells
- ❌ Tests that don't fail when they should
- ❌ Flaky tests (sometimes pass, sometimes fail)
- ❌ Tests that take >1s (unit tests)
- ❌ Tests with sleep/wait statements
- ❌ Tests that depend on execution order

### Architecture Smells
- ❌ Circular dependencies
- ❌ Tight coupling
- ❌ Missing abstraction layers
- ❌ Hardcoded configuration
- ❌ Global state

---

## ⚡ Performance Guidelines

### General
- ✅ Profile before optimizing
- ✅ Benchmark critical paths
- ✅ Cache expensive computations
- ✅ Lazy load heavy resources
- ✅ Use appropriate data structures

### Targets by Application Type

**CLI Tools:**
- Startup time: <100ms
- Memory: <50MB
- Response time: <50ms

**Web APIs:**
- Response time p95: <200ms
- Throughput: 1000+ req/s
- Memory: <500MB per instance

**Frontend:**
- FCP (First Contentful Paint): <1.5s
- TTI (Time to Interactive): <3s
- Lighthouse score: ≥90
- Bundle size: <200KB initial (gzipped)

---

## 🧪 Testing Requirements

### Coverage Targets
- New code: ≥80%
- Critical paths: ≥95% (auth, payments, data mutations)
- Bug fixes: 100% (regression test required)

### Test Types Required
- ✅ Unit tests for all business logic
- ✅ Integration tests for module interactions
- ✅ E2E tests for critical user flows
- ✅ Performance tests for bottlenecks

---

## 📚 Documentation Requirements

### Code Documentation
- ✅ README with setup instructions
- ✅ API documentation (OpenAPI/JSDoc/docstrings)
- ✅ Architecture diagrams (C4 model)
- ✅ Inline comments for complex logic

### When to Document
- Public APIs
- Complex algorithms
- Non-obvious decisions
- Workarounds for bugs
- Performance-critical code

---

## 🔄 Continuous Improvement

### Regular Reviews
- Weekly: Review new TODO/FIXME comments
- Monthly: Review and update rules
- Quarterly: Architecture review
- Annually: Technology stack evaluation

### Learning Resources
- **JavaScript:** https://javascript.info
- **Python:** https://docs.python.org/3/tutorial/
- **Rust:** https://doc.rust-lang.org/book/
- **Go:** https://go.dev/tour/
- **React:** https://react.dev

---

## 🎯 Enforcement

### Pre-Commit Checks
All stacks must pass:
1. **Format** (prettier/black/rustfmt/gofmt)
2. **Lint** (eslint/ruff/clippy/golangci-lint)
3. **Test** (all tests pass)
4. **Type Check** (if applicable)

### Code Review Checklist
- [ ] Follows stack-specific rules
- [ ] Tests included and passing
- [ ] No security vulnerabilities
- [ ] Performance acceptable
- [ ] Documentation updated
- [ ] No anti-patterns introduced

---

## 📞 Questions?

If a rule doesn't make sense for your use case:
1. Document the exception in code comments
2. Propose rule change in `.ai/governance/DECISIONS.md`
3. Discuss with team before merging

**Remember:** These rules exist to maintain quality and consistency. They should enable speed, not slow it down. If a rule is consistently blocking productivity, it should be revisited.

---

**Version:** 1.0  
**Last Updated:** 2026-06-17  
**Adopted from:** RTK-develop patterns + industry best practices  
**Next Review:** 2026-09-17 (quarterly)

---

## 🔗 References

### Internal
- `.ai/SOUL.md` - Engineering philosophy
- `.ai/governance/quality-gates.md` - Quality standards
- `.ai/governance/rules.md` - General rules
- `.ai/skills/tdd-workflow.md` - Testing methodology

### External
- **Clean Code** by Robert C. Martin
- **The Pragmatic Programmer** by Hunt & Thomas
- **Effective [Language]** series (Effective TypeScript, Effective Python, etc.)
- **Rust API Guidelines:** https://rust-lang.github.io/api-guidelines/
- **Go Code Review Comments:** https://go.dev/wiki/CodeReviewComments
- **Airbnb JavaScript Style Guide:** https://github.com/airbnb/javascript
- **PEP 8** (Python): https://peps.python.org/pep-0008/
- **Google Style Guides:** https://google.github.io/styleguide/
