# Rules

## Always (Prodige Structural)

- Read BOOT first.
- Use context before coding.
- Search existing code before writing new code.
- Prefer reuse before rebuild.
- Keep files modular.
- Update context after major changes.
- Update debt registry when debt is found.

## Always (TDD & Quality Enforcement)

- **Write failing test FIRST** before any implementation code (no exceptions)
- **Verify test fails** for the right reason before implementing
- **Run verification commands** before claiming "done" (provide evidence)
- **Follow systematic debugging** when fixing bugs (4-phase protocol)
- **Provide evidence** for all completion claims (command + output + result)

## Always (Behavioral)

- **Ask before assuming:** If requirements are vague, ask clarifying questions.
- **Present tradeoffs:** If multiple approaches exist, show options with pros/cons.
- **Choose simplicity:** Start with minimum code that solves the problem.
- **Verify each step:** Define clear success criteria and check them.
- **Match existing style:** Don't reformat code to your preference.
- **State your reasoning:** Explain why you chose approach X over Y.

## Never (Prodige Structural)

- Do not invent project facts.
- Do not silently change architecture.
- Do not rewrite large modules without approval.
- Do not ignore stale context.
- Do not skip handoff in parallel mode.

## Never (TDD & Quality Enforcement)

- **Do not write code before test:** Code before test = DELETE code and start over
- **Do not claim completion without evidence:** No "done" without fresh verification
- **Do not guess at bug fixes:** Find root cause first (4-phase debugging)
- **Do not skip verification steps:** Every completion needs evidence (command output)
- **Do not attempt 4th fix:** After 3 failed fixes, escalate to Architect

## Never (Behavioral)

- **Do not assume silently:** Don't pick an interpretation without asking.
- **Do not overcomplicate:** No abstractions for single use cases.
- **Do not add unrequested features:** Only implement what was asked.
- **Do not refactor adjacent code:** No drive-by improvements unrelated to task.
- **Do not proceed with confusion:** If unclear, stop and ask.
- **Do not use vague success criteria:** "Make it work" is not verifiable.

## The Overcomplication Test

Before finalizing any design or implementation, ask:

**"Would a senior engineer say this is overcomplicated?"**

If YES or MAYBE → Simplify.

Signals of overcomplication:
- Strategy pattern with one implementation
- Abstract base class with one subclass
- Configuration system with one config value
- 200+ lines for something that could be 50 lines
- Flexibility nobody requested

## The Surgical Test

Before submitting any code changes, ask:

**"Does every changed line trace directly to the user's request?"**

If NO → Revert unnecessary changes.

Signals of non-surgical changes:
- Files changed that weren't mentioned in task
- Style changes (quote style, spacing, formatting)
- Comment changes unrelated to task
- Refactoring of code that wasn't broken
- "Improvements" nobody asked for
