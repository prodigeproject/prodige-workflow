# Pre-Build Checklist

## Prodige Structural Gates
- [ ] PRD approved by human
- [ ] Architecture approved by human
- [ ] Implementation plan approved by human
- [ ] Snapshot created
- [ ] Cache updated

---

## Superpowers Quality Gates

### 1. TDD Readiness
- [ ] Agent understands TDD requirement (RED-GREEN-REFACTOR)
- [ ] Test framework available and working
- [ ] Agent knows: Test FIRST, code SECOND (no exceptions)
- [ ] Agent knows: Code before test = DELETE code

**Verification:**
Ask agent: "Explain TDD process for this task."
Expected: "Write failing test → verify it fails → write minimal code → verify it passes → refactor"

### 2. Verification Protocol Understanding
- [ ] Agent understands verification requirement
- [ ] Agent knows: No "done" without evidence
- [ ] Agent knows: Must provide command + output + result

**Verification:**
Ask agent: "What evidence will you provide for completion?"
Expected: Specific command, expected output, success criteria

---

## Karpathy Behavioral Gates

### 1. Assumptions Surfaced
- [ ] Agent has listed all assumptions explicitly
- [ ] Agent has asked clarifying questions for ambiguities
- [ ] No "silent interpretation" of vague requirements

**Red Flags:**
- Agent immediately starts implementing without questions
- PRD has vague sections and agent didn't ask about them
- Multiple valid interpretations exist but agent didn't present them

### 2. Simplicity Justified
- [ ] Implementation plan uses minimum code approach
- [ ] Any abstractions have 2+ use cases OR clear future need
- [ ] No speculative features ("might need this later")

**Red Flags:**
- Strategy pattern for single use case
- Configuration system with 1 config value
- Abstract base classes with 1 implementation
- Microservices for 3-table app

**Test:** Can senior engineer look at plan and say "this is appropriately simple"?

### 3. Success Criteria Defined
- [ ] Each implementation step has clear verification method
- [ ] Success can be verified automatically (tests, commands)
- [ ] No vague criteria like "make it work" or "improve code"

**Good Example:**
```
Step 1: Add login endpoint
Verify: curl -X POST /auth/login returns JWT

Step 2: Add auth middleware
Verify: Test test_protected_endpoint.py passes
```

**Bad Example:**
```
Step 1: Implement authentication
Verify: It works
```

### 4. Scope is Clear
- [ ] Implementation plan only includes requested features
- [ ] No "nice to have" additions
- [ ] No "while we're at it" refactoring

---

## Questions to Ask Before Approving

1. **Assumption Check:** Has agent asked at least 2-3 clarifying questions?
2. **Simplicity Check:** Could this be done simpler? Ask agent: "Show me simpler version."
3. **Scope Check:** Point to each feature in plan and ask: "Was this requested?"
4. **Verification Check:** Can you actually run the verification steps and see pass/fail?

---

## What to Do If Gates Fail

| Failed Gate | Action |
|-------------|--------|
| No questions asked | Ask agent: "What assumptions are you making?" |
| Plan looks complex | Ask agent: "Show me version with 50% less code." |
| Vague success criteria | Ask agent: "How do I verify Step X passed?" |
| Scope creep | Point out unrequested features, ask to remove. |

---

## Approval Decision

✅ **APPROVE** if:
- All structural gates passed
- All behavioral gates passed
- You understand exactly what will be built and how to verify it

⏸️ **PAUSE** if:
- Any behavioral gate failed
- You're not confident in approach
- Agent seems to be guessing

❌ **REJECT** if:
- Multiple behavioral gates failed
- Obvious overcomplication
- Agent refuses to simplify when asked
