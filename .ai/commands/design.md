# /design

Create or update PRD, Architecture, and Implementation Plan.

Rules:
- No coding.
- Explain decisions in plain language.
- Ask for human approval.
- Update context drafts.
- Grill the design (challenge against domain model).
- Run RoastMe critique on the design.

## Workflow

### 1. Create Initial Design
- Draft PRD (Product Requirements Document)
- Draft Architecture
- Draft Implementation Plan
- Explain all decisions in plain language

### 2. Grill the Design
Challenge the design against domain model and system constraints:
- Load `.ai/context/CONTEXT.md` (domain glossary)
- Interview the design using scenario testing
- Challenge assumptions against domain expertise
- Test edge cases and boundary conditions
- Identify missing constraints or invariants

**Note**: Grill-with-docs skill planned for future integration.  
For now: Manual domain model review and scenario testing.

### 3. Update Documentation Inline
During grilling, update documentation to reflect discoveries:
- **CONTEXT.md**: Add/refine domain terms found during interview
- **Architecture Decision Records (ADRs)**: Create for surprising decisions
  - Location: `.ai/context/docs/adr/NNNN-title.md`
  - Trigger: Hard-to-reverse + surprising + involves trade-offs
  - Format: Tight (1-3 sentences per section)
  - See: `.ai/context/docs/adr/ADR-FORMAT.md` for template

### 4. Human Approval (HITL Gate)
Present design with:
- Design rationale
- Trade-offs identified
- Grilling results
- ADRs created (if any)

Wait for human approval before proceeding.

### 5. Update Context
- Finalize `.ai/context/ARCHITECTURE.md`
- Finalize `.ai/context/DECISIONS.md`
- Finalize `.ai/context/IMPLEMENTATION.md`
- Update `.ai/context/CONTEXT.md` with new domain terms

### 6. Run RoastMe
Final critique to catch issues missed during grilling.

---

**Integration Points**:
- Uses: `.ai/context/CONTEXT.md` (domain glossary)
- Creates: `.ai/context/docs/adr/*.md` (architecture decisions)
- Updates: `.ai/context/*.md` (all context files)
- Future: `.ai/skills/grill-with-docs/SKILL.md` (when created)
