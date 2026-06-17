---
name: tdd
description: Test-driven development with red-green-refactor discipline. Tests verify behavior through public interfaces, not implementation. Use when building features, fixing bugs, or refactoring code. Mandatory for all production code.
triggers: [tdd, test-driven, red-green-refactor, test-first, behavior testing]
auto_load: [build, fix, refactor]
mandatory: true
applies_to: [backend, frontend, qa]
---

# Test-Driven Development (TDD)

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle**: If you didn't watch the test fail, you don't know if it tests the right thing.

---

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

---

## Red-Green-Refactor Cycle

```
1. RED:      Write failing test
2. Verify:   Test fails for RIGHT reason
3. GREEN:    Write minimal code to pass
4. Verify:   Test passes, all tests green
5. REFACTOR: Clean up while staying green
6. Verify:   Tests still green
7. REPEAT:   Next test for next behavior
```

### Quick Example

```typescript
// RED: Write test
test('validates email format', () => {
  expect(isValidEmail('user@example.com')).toBe(true);
});
// → Fails (function doesn't exist)

// GREEN: Minimal code
function isValidEmail(email) {
  return email.includes('@');
}
// → Passes

// REFACTOR: Improve
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
// → Still passes
```

---

## When to Use

**Always:**
- New features
- Bug fixes
- Refactoring
- API implementations
- Component creation

**Exceptions** (ask human first):
- Throwaway prototypes
- Generated code
- Configuration files
- Documentation

Thinking "skip TDD just this once"? **Stop. That's rationalization.**

---

## Integration with Prodige

### Auto-loaded By
- `/build` workflow
- `/fix` workflow (with systematic-debugging)
- `/refactor` workflow

### Works With
- `systematic-debugging` - For bug fix testing
- `verification-before-completion` - Enforces TDD compliance
- `karpathy-behavioral` - Simplicity principles align

### Updates
- `.ai/context/IMPLEMENTATION.md` - Records TDD compliance
- Test files - Creates/updates

### Enforced By
- Quality gates - No merge without tests
- Verification workflow - Checks test coverage

---

## Deep Dive Resources

**Philosophy** - Why TDD works  
→ See [PHILOSOPHY.md](./PHILOSOPHY.md) - Behavior vs implementation testing

**Examples** - Good vs bad tests  
→ See [EXAMPLES.md](./EXAMPLES.md) - Concrete code samples

**Anti-Patterns** - What NOT to do  
→ See [ANTI-PATTERNS.md](./ANTI-PATTERNS.md) - Horizontal slicing pitfall

**Mocking** - When and how  
→ See [MOCKING.md](./MOCKING.md) - System boundaries only

**Refactoring** - Clean up safely  
→ See [REFACTORING.md](./REFACTORING.md) - Only after GREEN

---

## Quick Reference

### RED Phase
- Write ONE test for ONE behavior
- Use descriptive name
- Test through public interface
- **Run and watch it FAIL**
- Confirm failure reason is correct

### GREEN Phase
- Write **minimal** code to pass
- Don't add untested features
- Don't refactor yet
- **Run and watch it PASS**
- Confirm all tests still pass

### REFACTOR Phase
- **Only after GREEN**
- Remove duplication
- Improve names
- Simplify logic
- **Run tests after each change**

### Red Flags
If you catch yourself:
- Writing code before test → **DELETE, start over**
- Test passes immediately → **Not testing new behavior**
- Can't explain why test failed → **Clarify what you're testing**
- Planning to test "later" → **That's not TDD**

---

## Agent-Specific Quick Guides

### Backend
**Framework**: Jest, Mocha, or project standard  
**Focus**: API endpoints, business logic, database operations  
**Example**:
```typescript
describe('UserService', () => {
  it('creates user with valid data', async () => {
    // RED → GREEN → REFACTOR
  });
});
```

### Frontend
**Framework**: Jest + React Testing Library  
**Focus**: Component behavior, user interactions, state management  
**Example**:
```typescript
describe('LoginButton', () => {
  it('calls onLogin when clicked with credentials', () => {
    // RED → GREEN → REFACTOR
  });
});
```

### QA
**Framework**: Playwright, Cypress  
**Focus**: End-to-end flows, cross-browser, accessibility  
**Example**:
```typescript
test('user can complete checkout', async () => {
  // RED → GREEN → REFACTOR
});
```

---

## Verification Checklist

Before claiming task complete:

- [ ] Every new function/method/component has tests
- [ ] Watched each test **fail** before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests **pass** (run full suite)
- [ ] No errors, warnings, or flaky tests
- [ ] Tests use real code paths (minimize mocks)

Can't check all boxes? You skipped TDD. **Start over.**

---

## Final Rule

```
Production code exists → test exists and failed first
Otherwise → not TDD → not acceptable
```

No exceptions without human approval.

---

**Related Skills**: systematic-debugging, verification-before-completion, karpathy-behavioral  
**Enforcement**: Mandatory via quality gates  
**Version**: 2.0 (Synthesized: Prodige + Matt Pocock)
