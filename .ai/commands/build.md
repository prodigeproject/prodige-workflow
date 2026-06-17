# /build

Implement approved design using Test-Driven Development.

## Preconditions
- PRD approved
- Architecture approved
- Implementation approved

## Skills Auto-Loaded
- `.ai/skills/tdd/SKILL.md` (MANDATORY)
- `.ai/skills/verification-before-completion.md`

## Workflow

### 1. Load Context
- Read `.ai/context/ARCHITECTURE.md`
- Read `.ai/context/IMPLEMENTATION.md`
- Read `.ai/context/CONTEXT.md` (domain glossary)
- Load `.ai/cache/` (reusable patterns)

### 2. Search and Reuse
- Search existing codebase for similar patterns
- Identify reusable components
- **Reuse before rebuild** (prevent duplication)

### 3. Create Modular File Plan
Break implementation into vertical slices:
- Each slice = complete user-facing feature
- Avoid horizontal slicing (backend-only or frontend-only)
- See: `.ai/skills/tdd/ANTI-PATTERNS.md` (horizontal slicing danger)

### 4. Implement with TDD
For each feature slice:

**RED Phase**:
- Write failing test first
- Run and watch it FAIL
- Confirm failure reason is correct

**GREEN Phase**:
- Write minimal code to pass
- Run and watch it PASS
- Verify all tests still pass

**REFACTOR Phase**:
- Clean up code (only after GREEN)
- Remove duplication
- Improve names
- Run tests after each change

**Reference**: `.ai/skills/tdd/SKILL.md`

**Progressive Disclosure**: Load additional TDD resources as needed:
- `PHILOSOPHY.md` - Behavior vs implementation testing
- `EXAMPLES.md` - Good vs bad test examples
- `MOCKING.md` - When/how to mock (system boundaries only)
- `REFACTORING.md` - Refactor patterns and safety
- `ANTI-PATTERNS.md` - Horizontal slicing warning

### 5. TDD Mode Selection
Choose based on project phase:

**Strict Mode** (default):
- Every function/method/component has tests
- Watch every test FAIL before implementing
- No code without failing test first
- Use for: Production features, critical paths

**Pragmatic Mode** (with approval):
- Focus tests on complex logic and public APIs
- Skip trivial getters/setters
- Skip generated code
- Use for: Prototypes, throwaway code (with human approval)

**Always ask human if unsure which mode to use.**

### 6. Review
- Check against implementation plan
- Verify all acceptance criteria met
- Run full test suite
- Check for regressions

### 7. Test
- Unit tests (via TDD)
- Integration tests (key flows)
- E2E tests (critical paths)
- All tests must pass

### 8. Sync Context
Update if implementation diverged from plan:
- `.ai/context/IMPLEMENTATION.md`
- `.ai/context/DECISIONS.md` (if trade-offs made)
- `.ai/context/CHANGELOG.md`

Run `/sync` to verify context accuracy.

---

## Quality Gates

Before claiming build complete:
- [ ] Every new function/method/component has tests
- [ ] Watched each test **fail** before implementing
- [ ] All tests **pass** (run full suite)
- [ ] No horizontal slices (incomplete features)
- [ ] Context updated (if needed)
- [ ] Verification complete

**Can't check all boxes? Build incomplete.**

---

**Integration Points**:
- Uses: `.ai/skills/tdd/SKILL.md` (main TDD workflow)
- Uses: `.ai/skills/tdd/ANTI-PATTERNS.md` (horizontal slicing warning)
- Uses: `.ai/skills/verification-before-completion.md`
- Updates: `.ai/context/*.md` (if needed)
