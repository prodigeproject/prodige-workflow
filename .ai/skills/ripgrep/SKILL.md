---
name: ripgrep
description: "Enforces search-before-coding discipline: never create new implementation before checking existing code patterns and utilities."
---

# Search Before Coding (ripgrep)

Systematically search existing code before implementing anything new to prevent duplication and ensure consistency.

## Purpose

Prevent wasted effort and inconsistency by:
- Searching for existing implementations before coding
- Finding similar patterns to follow
- Discovering reusable utilities and helpers
- Maintaining consistency with established patterns
- Avoiding duplicate functionality

## When to Use

This skill is automatically selected by the orchestrator when:
- Planning to implement new features
- Creating new utilities or helpers
- Adding new API endpoints or routes
- Implementing design patterns
- Making architectural decisions

**Critical rule:** This skill MUST be invoked before ANY new implementation.

## Process

### 1. Identify Search Targets

Before implementing, identify what to search for:
- Similar functionality (e.g., "other API endpoints", "date formatters")
- Utilities that might help (e.g., "validation", "error handling")
- Patterns to follow (e.g., "how we handle auth", "component structure")
- Dependencies to reuse (e.g., "database queries", "API clients")

### 2. Execute Searches

Use ripgrep (rg) to search efficiently:

**By functionality:**
```bash
rg "format.*date" --type ts
rg "validate.*email" --type ts
rg "fetch.*user" --type ts
```

**By pattern:**
```bash
rg "export.*function.*Api" --type ts
rg "class.*Service.*extends" --type ts
rg "const.*Schema.*=.*z\." --type ts
```

**By imports (find what uses a library):**
```bash
rg "from 'zod'" --type ts
rg "import.*React.*useState" --type tsx
```

**By file patterns:**
```bash
rg ".*" --type ts --files | grep -i "user"
rg ".*" --type ts --files | grep -i "api"
```

### 3. Analyze Results

For each finding:
- **Relevance:** Does this solve my problem?
- **Quality:** Is this code we want to emulate?
- **Reusability:** Can I use this directly or adapt it?
- **Pattern:** What patterns does this follow?

### 4. Make Decisions

Based on search results:
- **Found exact match:** Reuse it
- **Found similar:** Adapt the pattern
- **Found utility:** Use it as dependency
- **Found pattern:** Follow the same pattern
- **Found nothing:** Okay to create, but document the pattern

## Output Format

**Search Queries Executed:**
```
🔍 Searches performed:
  1. rg "validate.*email" --type ts
  2. rg "from 'zod'" --type ts
  3. rg "export.*Schema" --type ts
  4. Find files: rg --files | grep -i validation
```

**Findings:**
```
📦 Existing implementations found:

lib/validators.ts:
  ✓ validateEmail(email: string): boolean
  ✓ validatePhone(phone: string): boolean
  ✓ validateUrl(url: string): boolean
  → Can reuse validateEmail directly

lib/schemas/user.ts:
  ✓ Uses Zod for validation
  ✓ Pattern: export const UserSchema = z.object({...})
  → Follow this pattern for new schemas

components/forms/ContactForm.tsx:
  ✓ Example of form validation with Zod
  ✓ Uses react-hook-form + Zod resolver
  → Follow this pattern for new forms
```

**Recommendations:**
```
✅ REUSE:
  - lib/validators.ts → validateEmail()
  - Follow Zod schema pattern from lib/schemas/

🔧 ADAPT:
  - Use ContactForm.tsx as template for new form
  - Follow same validation approach

🆕 CREATE (nothing found):
  - validatePostalCode() - no existing implementation
  - Document pattern in lib/validators.ts for consistency
```

**Code Examples to Follow:**
```typescript
// Pattern found in lib/schemas/user.ts
export const NewSchema = z.object({
  field: z.string().email(),
  // ... following established pattern
});

// Pattern found in components/forms/ContactForm.tsx
const form = useForm({
  resolver: zodResolver(NewSchema),
  // ... following established pattern
});
```

## Rules

- **Always search first:** Never write code before searching for existing implementations
- **Search comprehensively:** Look for functionality, patterns, and utilities
- **Document findings:** Show what was searched and what was found
- **Follow patterns:** When creating something new, follow established patterns
- **Avoid duplication:** If it exists, reuse it rather than recreate it
- **Be systematic:** Use multiple search strategies to ensure thorough coverage
- **Outline before reading large files:** For any file >100 lines, grep its signatures first and read only the needed symbol — never read a full large file to find one symbol

## Outline Before Read

Ripgrep is the natural tool for cheap structure-first exploration. For any code file larger than ~100 lines, outline its **symbols/signatures** before reading it in full, then open only the region for the symbol you need.

```bash
# Outline a file's symbols (portable, no AST/runtime dependency)
rg -n "^(export\s+)?(async\s+)?(function|class|const|interface|type|def|enum)\b" path/to/file
```

The `-n` flag gives line numbers so you can jump straight to the symbol's body. Reading an entire large file just to find one function is the anti-pattern to eliminate.

### Token Economics

Pick the cheapest path that answers the question:

| Approach | Tokens | Use case |
| --- | --- | --- |
| Outline (rg signatures) | ~200–600 | "What's in this file?" |
| Read one symbol/region | ~300–1,500 | "Show me this function" |
| Read full file | ~6,000–12,000+ | "I truly need everything" |

## Search Strategies

### 1. Functionality Search
Look for existing implementations of what you need:
```bash
rg "function.*formatDate" --type ts
rg "export.*parseJson" --type ts
rg "class.*UserService" --type ts
```

### 2. Pattern Search
Find how similar things are done:
```bash
rg "\.post\('/api/" --type ts    # How we define POST endpoints
rg "useState<.*>" --type tsx      # How we use state
rg "try.*catch.*finally" --type ts # How we handle errors
```

### 3. Library Usage Search
See how libraries are used:
```bash
rg "from 'prisma'" --type ts
rg "import.*axios" --type ts
rg "import.*'next/navigation'" --type ts
```

### 4. File Discovery
Find relevant files:
```bash
rg --files | grep -i auth
rg --files | grep -i "user"
rg --files --type ts | grep "\.test\."
```

### 5. Type/Interface Search
Find existing types:
```bash
rg "interface.*User" --type ts
rg "type.*Props.*=" --type ts
rg "export type.*Response" --type ts
```

### 6. Configuration Search
Find configuration patterns:
```bash
rg "export.*config" --type ts
rg "process\.env\." --type ts
```

## Integration Points

- Works with **reuse-rebuild** to inform reuse decisions
- Feeds into **implementation-planning** with found patterns
- Used by **clean-code** to ensure consistency
- Supports **documentation** with pattern examples

## Anti-Patterns

- ❌ **Code first, search later:** Writing implementation before searching
- ❌ **Single search:** One quick search instead of comprehensive search
- ❌ **Ignoring results:** Finding existing code but writing new anyway
- ❌ **Not following patterns:** Finding patterns but inventing your own
- ❌ **Shallow search:** Not searching for related utilities and dependencies
- ❌ **Read full large file to find one symbol:** Opening an entire >100-line file instead of grepping signatures and reading only the needed region

## Search Quality Checklist

Before claiming "nothing exists", ensure you searched for:
- [ ] Exact functionality by name
- [ ] Similar functionality by behavior
- [ ] Related utilities and helpers
- [ ] Patterns in similar code
- [ ] Library usage examples
- [ ] Type definitions and interfaces
- [ ] Configuration and setup patterns
- [ ] Test examples (how features are tested)

## Example Workflow

**Task:** Implement email validation for registration form

**Step 1 - Search for existing validation:**
```bash
rg "validate.*email" --type ts
# Found: lib/validators.ts has validateEmail()
```

**Step 2 - Search for form patterns:**
```bash
rg "useForm" --type tsx
# Found: Multiple forms use react-hook-form with Zod
```

**Step 3 - Search for registration-specific code:**
```bash
rg "register" --type ts | grep -i "form\|component"
# Found: components/auth/LoginForm.tsx (similar pattern)
```

**Decision:**
- ✅ Reuse lib/validators.ts → validateEmail()
- ✅ Follow LoginForm.tsx pattern for form structure
- ✅ Use Zod schema pattern like other forms
- 🆕 Create RegisterForm.tsx following established patterns

**Result:** Consistent implementation, no duplication, follows existing patterns

## Common Search Patterns

**Authentication/Authorization:**
```bash
rg "auth" --type ts | grep -i "middleware\|guard\|check"
rg "isAuthenticated\|requireAuth" --type ts
```

**Database Operations:**
```bash
rg "prisma\." --type ts
rg "\.findMany\|\.findUnique\|\.create" --type ts
```

**API Endpoints:**
```bash
rg "route\.(ts|js)" --files
rg "export.*GET.*POST.*PUT.*DELETE" --type ts
```

**Error Handling:**
```bash
rg "try.*catch" --type ts -A 3
rg "throw new.*Error" --type ts
```

**State Management:**
```bash
rg "useState\|useReducer\|useContext" --type tsx
rg "create.*store" --type ts
```

## Benefits

**Consistency:**
- Code follows established patterns
- Similar problems solved similarly
- Easier for team to understand

**Efficiency:**
- Reuse instead of recreate
- Learn from existing implementations
- Avoid reinventing the wheel

**Quality:**
- Build on tested code
- Follow proven patterns
- Maintain architectural coherence

**Knowledge Transfer:**
- Discover how things are done
- Learn codebase conventions
- Find undocumented patterns
