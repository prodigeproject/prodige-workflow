# Command: /test

## Purpose
Execute Test-Driven Development workflow with RED-GREEN-REFACTOR cycle enforcement.

## Modes

### `/test red` - Write Failing Test
Write a failing test for the next behavior to implement.

**Prerequisites:**
- Feature requirements defined in PRD
- Implementation plan approved
- Current code loaded in context

**Workflow:**
1. Agent reads current implementation state
2. Identifies next untested behavior from requirements
3. Writes minimal failing test
4. Verifies test fails with clear error message
5. Explains what production code is needed

**Output:**
- Test file with new failing test
- Clear explanation of expected behavior
- Next steps for GREEN phase

**Example Usage:**
```
/test red

Context: We're implementing user authentication.
Next behavior: Login should return JWT token on success.
```

---

### `/test green` - Make Test Pass
Write minimal production code to make the currently failing test pass.

**Prerequisites:**
- Failing test exists (RED phase complete)
- Test failure message understood

**Workflow:**
1. Agent reads failing test
2. Analyzes what's missing
3. Writes MINIMAL code to pass test (no extra features)
4. Runs test suite to verify
5. Confirms no regressions

**Output:**

- Production code changes
- Test suite status (all green)
- Confirmation no extra code added

**Example Usage:**
```
/test green

Failing test:
test('login returns token', async () => {
  const result = await login('user@example.com', 'password');
  expect(result.token).toBeDefined();
});
```

---

### `/test refactor` - Clean Up Code
Refactor code while keeping all tests green.

**Prerequisites:**
- All tests passing (GREEN phase complete)
- Code has duplication or poor naming

**Workflow:**
1. Agent analyzes code for improvements:
   - Remove duplication
   - Improve naming
   - Extract functions/classes
   - Apply design patterns
2. Makes ONE refactoring change
3. Runs tests
4. Repeats until code is clean
5. Final test suite verification

**Output:**
- Refactored code
- Test suite status (still green)
- Summary of improvements made

**Example Usage:**
```
/test refactor

Current code has duplication in validation logic across 3 functions.
Extract common pattern.
```

---

### `/test coverage` - Check Coverage
Analyze test coverage and identify gaps.

**Prerequisites:**
- Test suite exists
- Coverage tool configured


**Workflow:**
1. Runs coverage report
2. Analyzes uncovered lines
3. Identifies critical gaps
4. Suggests tests to write
5. Reports coverage percentage

**Output:**
- Coverage report summary
- List of untested code paths
- Prioritized test recommendations
- Risk assessment for gaps

**Example Usage:**
```
/test coverage
```

**Sample Output:**
```
Coverage Report:
- Total: 78%
- src/auth/login.ts: 92%
- src/auth/register.ts: 65% ⚠️
- src/payments/process.ts: 45% 🚨

Critical Gaps:
1. register.ts Line 23-28: Email validation not tested
2. process.ts Line 15-42: Payment failure cases not tested

Recommended Tests:
1. test_register_with_invalid_email_format
2. test_process_payment_when_gateway_fails
```

---

### `/test watch` - Run Tests in Watch Mode
Start test watcher for rapid feedback during development.

**Prerequisites:**
- Test runner installed (Jest/Vitest/pytest/cargo)

**Workflow:**
1. Agent starts test watcher in background
2. Tests re-run on file changes
3. Reports failures immediately
4. Continues until stopped

**Command by Stack:**
```bash
# JavaScript/TypeScript
npm run test -- --watch

# Python
pytest --watch

# Rust

cargo watch -x test

# Go
gotestsum --watch
```

---

## Quality Gates

### Before `/test green`
- [ ] Test written and failing
- [ ] Failure message is clear
- [ ] Test is minimal (one behavior)
- [ ] Test is isolated (no dependencies)

### Before `/test refactor`
- [ ] All tests passing
- [ ] No failing tests
- [ ] Coverage baseline recorded

### Before Commit
- [ ] All tests passing
- [ ] Coverage ≥80% for new code
- [ ] No skipped/disabled tests without explanation
- [ ] Pre-commit hook passed

---

## Integration with Workflows

### In `/build` Workflow
After "Verify approved design":
1. Load implementation plan
2. For each task:
   - **Run `/test red`** - Write failing test
   - **Run `/test green`** - Implement code
   - **Run `/test refactor`** - Clean up
   - **Run `/test coverage`** - Verify coverage
3. Proceed to code review

### In `/fix` Workflow
After "Reproduce bug":
1. **Run `/test red`** - Write regression test
2. Verify test fails (reproduces bug)
3. **Run `/test green`** - Fix bug
4. Verify test passes
5. **Run `/test coverage`** - Check related paths

---

## Stack-Specific Configuration

### JavaScript/TypeScript (Jest/Vitest)
**Test File Pattern:** `*.test.ts`, `*.spec.ts`
**Command:** `npm run test`
**Coverage:** `npm run test -- --coverage`

**Configuration Check:**
```json
// package.json
{
  "scripts": {
    "test": "vitest",
    "test:coverage": "vitest --coverage"
  }
}
```

### Python (pytest)

**Test File Pattern:** `test_*.py`, `*_test.py`
**Command:** `pytest`
**Coverage:** `pytest --cov=src --cov-report=html`

**Configuration Check:**
```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
```

### Rust (cargo test)
**Test File Pattern:** `#[cfg(test)] mod tests`
**Command:** `cargo test`
**Coverage:** `cargo tarpaulin --out Html`

**Configuration Check:**
```toml
# Cargo.toml
[dev-dependencies]
insta = "1.34"  # For snapshot testing
```

### Go (go test)
**Test File Pattern:** `*_test.go`
**Command:** `go test ./...`
**Coverage:** `go test -cover ./...`

---

## Troubleshooting

### Issue: Tests not running
**Diagnosis:**
```bash
/diagnose
```

**Common Fixes:**
- Install test runner: `npm install -D vitest` / `pip install pytest`
- Check test file naming convention
- Verify test command in package.json/Makefile

### Issue: Coverage below 80%
**Solution:**
```
/test coverage
# Review gaps
# Write tests for critical paths first
/test red  # For each gap
```

### Issue: Tests passing locally but failing in CI
**Diagnosis:**
- Check for hardcoded paths (use relative paths)
- Check for timezone dependencies (use UTC)
- Check for race conditions (avoid `sleep`, use proper waits)
- Check for environment-specific configs

---

## Success Metrics
- 90%+ of features developed with TDD
- Average test coverage 85%

- Test suite runs <30s for unit tests
- Zero production bugs from untested paths
- 95%+ pre-commit gate pass rate

---

## Agent Behavior Rules

When executing `/test` command, agent MUST:
1. **Read BOOT first** (load context)
2. **Load test-driven-development skill** automatically
3. **Follow 3 Laws of TDD** strictly
4. **Run tests after every code change**
5. **Update context** if architecture changes
6. **Record debt** if tests skipped
7. **Ask for approval** before disabling tests

When in RED phase:
- Write ONE test only
- Verify test fails
- Do NOT write production code

When in GREEN phase:
- Write MINIMAL code only
- No refactoring
- Verify all tests pass

When in REFACTOR phase:
- No new features
- No breaking changes
- Run tests after EACH change
- Stop when clean

---

## Examples

### Example 1: New Feature (Login)
```
User: /test red - Implement login endpoint

Agent:
Loading context... PRD.md, ARCHITECTURE.md, IMPLEMENTATION.md
Skill: test-driven-development loaded

Next behavior to test: Login with valid credentials returns JWT token

Writing failing test:
```python
def test_login_with_valid_credentials_returns_token(client):
    response = client.post("/auth/login", json={
        "email": "user@example.com",
        "password": "correct_password"
    })
    assert response.status_code == 200
    assert "token" in response.json()
```

Test status: ❌ FAILING (endpoint does not exist)

Next step: Run `/test green` to implement minimal endpoint.
```

User: /test green

Agent:

Analyzing failing test...
Minimal code needed: Create /auth/login endpoint that returns token.

Implementing:
```python
@app.post("/auth/login")
def login(credentials: LoginRequest):
    # Minimal implementation - just return a token
    return {"token": "fake-jwt-token-123"}
```

Running tests...
✅ test_login_with_valid_credentials_returns_token PASSED
✅ All tests passed (1 passed, 0 failed)

Next step: Write next test for invalid credentials, or run `/test refactor` if code needs cleanup.
```

---

### Example 2: Bug Fix
```
User: /test red - Fix bug: Users can register with invalid email formats

Agent:
Loading context... Bug report #123
Creating regression test...

```python
def test_register_rejects_invalid_email_format():
    invalid_emails = ["notanemail", "@example.com", "user@", "user space@example.com"]
    for email in invalid_emails:
        response = client.post("/auth/register", json={"email": email})
        assert response.status_code == 400
        assert "Invalid email" in response.json()["detail"]
```

Test status: ❌ FAILING (currently accepts invalid emails)

This test reproduces the bug. Run `/test green` to fix.
```

---

## Related Commands
- `/build` - Full implementation workflow (includes TDD)
- `/fix` - Bug fix workflow (uses TDD for regression tests)
- `/review` - Verify tests exist and pass
- `/diagnose` - Check test environment setup

---

## References
- Skill: `test-driven-development/SKILL.md`
- Checklist: `testing.md`
- Quality Gates: `quality-gates.md`
- Governance: `rules.md`
