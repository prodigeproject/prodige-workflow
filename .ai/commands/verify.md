# /verify

Run automated verification checks on code quality.

Ensures code meets quality standards before considering work "done".

---

## What This Checks

✅ **Tests** - All tests pass  
✅ **Type Checking** - No type errors (if applicable)  
✅ **Linting** - Code style consistent  
✅ **Build** - Project builds successfully  

---

## Usage

```bash
# Run all checks
/verify

# After getting results, can auto-fix issues
# The command will offer to fix problems if any found
```

---

## Instructions

Invoke the **verification-runner** agent:

### Tasks

1. **Detect project type**:
   - Check for `package.json`, `requirements.txt`, `Cargo.toml`, etc.
   - Determine appropriate verification tools

2. **Run all applicable checks**:
   - Tests
   - Type checking
   - Linting
   - Build

3. **Report results clearly**:
   - Use the output format from verification-runner agent
   - Show pass/fail for each check
   - Display error details if failures

4. **Offer to fix issues**:
   - If failures detected, ask if should auto-fix
   - If approved, iterate up to 3 times
   - Report what was fixed

5. **Update status**:
   - Save verification results to `.ai/runtime/verification-status.json`
   - Update memory bank with results

### Output Format

Follow format in verification-runner agent:
- Clear table of check results
- Detailed error messages for failures
- Fix suggestions
- Offer to auto-fix

---

## When to Use

- Before completing any `/build` task
- Before git commit
- Before creating PR
- After refactoring
- Anytime you want quality check

---

## Integration

This command is automatically run by:
- `/magic` workflow (at completion)
- Pre-merge checklist
- Quality gates

---

**Remember**: Quality is non-negotiable, but we make it easy! 🔍
