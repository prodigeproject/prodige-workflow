# Testing Checklist

Use this checklist to ensure comprehensive test coverage and quality.

---

## 📝 Before Writing Code (RED Phase)

### Test Design
- [ ] Acceptance criteria identified from PRD
- [ ] Test cases listed (happy path + edge cases + errors)
- [ ] Test data prepared (realistic, not synthetic)
- [ ] Test isolation strategy defined (mocks, fixtures, test DB)

### First Failing Test
- [ ] Test describes ONE specific behavior
- [ ] Test is minimal (no unnecessary assertions)
- [ ] Test uses clear naming (`test_what_when_expected`)
- [ ] Test failure message is clear and actionable

### Verification
- [ ] Test runs and FAILS as expected
- [ ] Failure is due to missing production code (not test bug)
- [ ] No other tests broken by this new test
- [ ] Test is committed (RED state is valid state)

---

## ✅ After Writing Code (GREEN Phase)

### Implementation
- [ ] MINIMAL code written (just enough to pass)
- [ ] No premature optimization
- [ ] No extra features added
- [ ] Error handling included (if test requires it)

### Verification
- [ ] New test PASSES
- [ ] All existing tests still PASS
- [ ] No test skipped or disabled
- [ ] Build succeeds (no compilation errors)

---

## 🔧 Before Refactoring (REFACTOR Phase)

### Code Quality Check
- [ ] Duplication identified
- [ ] Naming improvements identified
- [ ] Extraction opportunities identified (functions, classes, modules)
- [ ] Design pattern opportunities identified

### Safety
- [ ] All tests are GREEN before refactoring
- [ ] Tests run automatically during refactoring
- [ ] Small incremental changes (test after each)
- [ ] No new functionality added during refactor

### After Refactoring
- [ ] All tests still GREEN
- [ ] Code is more readable than before
- [ ] No duplication remains
- [ ] Single Responsibility Principle followed

---

## 🎯 Test Coverage Requirements

### Minimum Coverage
- [ ] New code: ≥80% line coverage
- [ ] Critical paths: ≥95% coverage (auth, payments, data mutations)
- [ ] Bug fixes: 100% coverage (regression test required)
- [ ] Legacy code: No coverage decrease

### Coverage Analysis
- [ ] Coverage report generated (`npm run test:coverage`)
- [ ] Uncovered lines reviewed
- [ ] Critical gaps identified
- [ ] Additional tests written for gaps

---

## 🧪 Test Categories Coverage

### Unit Tests
- [ ] All public functions tested
- [ ] Edge cases covered (empty input, null, zero, negative)
- [ ] Error conditions tested (invalid input, exceptions)
- [ ] Boundary values tested (min, max, off-by-one)

### Integration Tests
- [ ] Module interactions tested
- [ ] Database operations tested (if applicable)
- [ ] External API calls tested (with mocks)
- [ ] File I/O tested (if applicable)

### E2E Tests (if applicable)
- [ ] Happy path user flow tested
- [ ] Authentication flow tested
- [ ] Error recovery tested
- [ ] Cross-browser tested (if web app)

---

## 🔒 Test Quality Standards (FIRST Principles)

### Fast
- [ ] Unit test suite runs <10s
- [ ] Individual tests run <100ms
- [ ] No unnecessary sleeps or waits
- [ ] Database tests use in-memory DB or fixtures

### Isolated
- [ ] Tests can run in any order
- [ ] No shared state between tests
- [ ] Each test sets up own data
- [ ] Each test cleans up after itself

### Repeatable
- [ ] Tests produce same result every run
- [ ] No dependence on current time (use fixed dates in tests)
- [ ] No dependence on random data
- [ ] No dependence on external services (use mocks)

### Self-Validating
- [ ] Test passes or fails automatically (no manual inspection)
- [ ] Clear pass/fail assertions
- [ ] No console.log debugging needed
- [ ] Test output is deterministic

### Timely
- [ ] Tests written before/with production code (TDD)
- [ ] No "we'll add tests later"
- [ ] Tests reviewed in code review
- [ ] Tests maintained alongside code

---

## 🐛 Bug Fix Testing

### Regression Test Required
- [ ] Bug reproduced with failing test
- [ ] Test fails on old code (confirms bug)
- [ ] Test passes on fixed code
- [ ] Test committed with fix

### Verification
- [ ] Bug cannot reoccur without test failing
- [ ] Related edge cases also tested
- [ ] Root cause identified and documented
- [ ] Similar bugs checked in codebase

---

## 🚀 Pre-Commit Verification

### Local Checks
- [ ] All tests pass (`npm test` / `pytest` / `cargo test`)
- [ ] Coverage ≥80% for new code
- [ ] No skipped/disabled tests
- [ ] Test output clean (no warnings)
- [ ] Pre-commit hook passes

### Stack-Specific
**JavaScript/TypeScript:**
- [ ] `npm run test` passes
- [ ] `npm run test:coverage` ≥80%
- [ ] Type checking passes (`tsc --noEmit`)
- [ ] ESLint passes on test files

**Python:**
- [ ] `pytest` passes
- [ ] `pytest --cov=src --cov-report=term` ≥80%
- [ ] `mypy` passes on test files
- [ ] Test files follow naming convention (`test_*.py`)

**Rust:**
- [ ] `cargo test` passes
- [ ] `cargo test --doc` passes (doc tests)
- [ ] `cargo tarpaulin` ≥80% (if installed)
- [ ] Snapshot tests updated (`cargo insta review`)

**Go:**
- [ ] `go test ./...` passes
- [ ] `go test -cover ./...` ≥80%
- [ ] `go test -race ./...` passes (race detector)
- [ ] Benchmark tests included (`_test.go`)

---

## 📊 Test Review Checklist

### Code Review Items
- [ ] Tests exist for new functionality
- [ ] Tests follow TDD (written first)
- [ ] Tests are clear and readable
- [ ] Tests use meaningful names
- [ ] No commented-out tests
- [ ] No flaky tests (intermittent failures)

### Test Code Quality
- [ ] Test setup/teardown clear
- [ ] Helper functions extracted (DRY)
- [ ] Fixtures/factories used for test data
- [ ] Assertions are specific (not just `assert True`)
- [ ] Error messages helpful for debugging

---

## 🎭 Test Smells to Avoid

### Anti-Patterns
- [ ] ❌ No tests for complex logic
- [ ] ❌ Tests written after code (not TDD)
- [ ] ❌ Testing implementation details (instead of behavior)
- [ ] ❌ Over-mocking (mocking everything)
- [ ] ❌ Too many assertions per test (>3-5)
- [ ] ❌ Fragile tests (break on minor refactoring)
- [ ] ❌ Slow tests (>1s for unit test)
- [ ] ❌ Flaky tests (sometimes pass, sometimes fail)
- [ ] ❌ Tests depend on execution order
- [ ] ❌ Hardcoded test data (not maintainable)

### Red Flags
- [ ] 🚩 Coverage dropped below 80%
- [ ] 🚩 Tests disabled with `skip` or `xfail`
- [ ] 🚩 Tests pass but don't test anything meaningful
- [ ] 🚩 No integration tests (only unit tests)
- [ ] 🚩 No E2E tests for critical flows
- [ ] 🚩 Test suite takes >5 minutes

---

## 🔄 Continuous Testing

### Local Development
- [ ] Test watcher running (`/test watch`)
- [ ] Tests run on file save
- [ ] Fast feedback loop (<3s)
- [ ] Only related tests run (watch mode filter)

### CI/CD Pipeline
- [ ] Tests run on every PR
- [ ] Tests run on every commit to main
- [ ] Coverage report published
- [ ] Tests block merge if failing
- [ ] Notifications on test failures

---

## 📚 Test Documentation

### Test File Organization
- [ ] Tests colocated with code or in `tests/` folder
- [ ] Test files mirror source file structure
- [ ] Test files named consistently (`*.test.ts`, `test_*.py`)
- [ ] Test suites organized by feature/module

### Test Comments
- [ ] Complex test logic explained
- [ ] Test purpose clear from name (not relying on comments)
- [ ] Fixtures/factories documented
- [ ] Setup/teardown logic explained

---

## 🎯 Success Criteria

### Feature Complete When:
- [ ] All acceptance criteria have passing tests
- [ ] Coverage ≥80% for feature code
- [ ] All tests pass locally
- [ ] All tests pass in CI
- [ ] No skipped tests
- [ ] Code reviewed and approved
- [ ] Tests reviewed and approved

### Ready to Merge When:
- [ ] All quality gates passed (format, lint, test, type check)
- [ ] Coverage maintained or improved
- [ ] No flaky tests introduced
- [ ] Test suite still fast (<30s for unit tests)
- [ ] Documentation updated
- [ ] CHANGELOG updated

---

## 🧰 Testing Tools by Stack

### JavaScript/TypeScript
- **Test Runner:** Jest, Vitest, Mocha
- **Assertions:** expect (Jest/Vitest), chai
- **Mocking:** jest.fn(), vi.fn(), sinon
- **E2E:** Playwright, Cypress, Puppeteer
- **Coverage:** istanbul (nyc), c8

### Python
- **Test Runner:** pytest, unittest
- **Assertions:** assert (pytest), unittest.assert*
- **Mocking:** unittest.mock, pytest-mock
- **Fixtures:** pytest fixtures, factory_boy
- **Coverage:** pytest-cov, coverage.py

### Rust
- **Test Runner:** cargo test
- **Assertions:** assert!, assert_eq!, assert_ne!
- **Mocking:** mockall, mockito
- **Snapshot:** insta
- **Coverage:** cargo-tarpaulin, cargo-llvm-cov

### Go
- **Test Runner:** go test
- **Assertions:** testing.T, testify/assert
- **Mocking:** gomock, testify/mock
- **Table Tests:** Built-in (slice of test cases)
- **Coverage:** go test -cover

---

## 📖 References

### Internal
- Skill: `test-driven-development/SKILL.md` - TDD methodology
- Command: `/test` - Testing commands
- Governance: `quality-gates.md` - Quality requirements
- Workflow: `build.md` - Integration with build process

### External
- Kent Beck: "Test-Driven Development by Example"
- Martin Fowler: "Refactoring" & "Mocks Aren't Stubs"
- Uncle Bob: "Clean Code" Chapter 9 (Unit Tests)
- xUnit Test Patterns: http://xunitpatterns.com/

---

## ✅ Quick Reference

### TDD Cycle
1. 🔴 RED: Write failing test
2. 🟢 GREEN: Make it pass (minimal code)
3. 🔵 REFACTOR: Clean up
4. Repeat

### 3 Laws of TDD
1. No production code without failing test
2. Write minimal test to fail
3. Write minimal code to pass

### FIRST Principles
- **F**ast: <10s unit test suite
- **I**solated: No shared state
- **R**epeatable: Same result every time
- **S**elf-validating: Pass/fail, no manual check
- **T**imely: Written before/with code

### Coverage Targets
- New code: ≥80%
- Critical paths: ≥95%
- Bug fixes: 100% (regression test)

---

**Version:** 1.0  
**Last Updated:** 2026-06-17  
**Adopted from:** RTK-develop testing patterns + TDD best practices
