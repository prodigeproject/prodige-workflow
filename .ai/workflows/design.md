# Workflow: Design

## Purpose
Create or update comprehensive design documentation including PRD, Architecture, and Implementation Plan. Ensure design is well-grounded, simple, and validated before implementation begins.

**Core principle:** Think before coding. Design clarifies requirements, validates feasibility, and prevents costly rework during implementation.

---

## Steps

### 1. Load Context

**Gather necessary context:**
- Read `.ai/context/PROJECT.md` - Project vision and scope
- Read `.ai/context/CONTEXT.md` - Domain glossary and terminology
- Read `.ai/context/ARCHITECTURE.md` - Current system design (if exists)
- Read `.ai/context/DECISIONS.md` - Past design decisions
- Review existing `.ai/context/PRD.md` (if updating)
- Check technical debt in `.ai/governance/debt/`

**Checklist:** Work through `.ai/checklists/pre-design.md` before drafting the design.

**Understand:**
- What is the current state of the project?
- What domain constraints exist?
- What architectural patterns are in use?
- What decisions have already been made?

**Skill:** Context loading (baseline understanding)

### 2. Clarify Goal

**State the design goal explicitly:**

**For new features:**
```
Goal: Design [feature name]
Purpose: [why this feature exists]
Success criteria: [measurable outcomes]
Scope: [what's included/excluded]
```

**For updates:**
```
Goal: Update design for [feature/component]
Reason: [what changed, what problem exists]
Impact: [what parts of system are affected]
```

**Ask clarifying questions if needed:**
- What problem are we solving?
- Who are the users?
- What are the constraints?
- What are success criteria?
- What is explicitly out of scope?

**Wait for confirmation before proceeding.**

**Skill:** `clean-code` (State assumptions, clarify goal)

### 3. Draft/Update PRD (Product Requirements Document)

**Create or update `.ai/context/PRD.md`:**

**Core sections to complete:**

**Product Overview:**
- Summary of feature/product
- Product vision
- Target release information

**Goals:**
- Primary goals with success metrics
- Secondary goals
- Explicit non-goals

**User Stories:**
- Format: As a [role], I want [goal], so that [benefit]
- Include acceptance criteria
- Include definition of done

**Features:**
- Feature breakdown
- User flows
- Functional requirements
- Non-functional requirements (performance, security, accessibility)
- Edge cases and error handling
- Out of scope items
- Dependencies

**Metrics:**
- Key Performance Indicators (KPIs)
- Success definitions

**Technical Considerations:**
- API requirements
- Data requirements
- Integration points
- Security requirements

**Constraints & Assumptions:**
- Technical, business, regulatory constraints
- Assumptions documented

**Risks & Timeline:**
- Identified risks with mitigation
- Milestones and release plan

**Use template from:** `.ai/context/PRD.md`

**Key principle:** Be specific and testable. Every requirement should be verifiable.

### 4. Draft/Update Architecture

**Create or update `.ai/context/ARCHITECTURE.md`:**

**Core architectural decisions:**

**System Overview:**
- High-level architecture diagram (text-based)
- Component breakdown
- Technology stack

**Data Architecture:**
- Data models/schemas
- Database design
- Data flow diagrams

**API Design:**
- Endpoints
- Request/response formats
- Authentication/authorization

**Component Architecture:**
- Module structure
- Separation of concerns
- Dependencies between components

**Infrastructure:**
- Deployment architecture
- Scalability considerations
- Performance requirements

**Security Architecture:**
- Authentication flow
- Authorization model
- Data protection

**Integration Points:**
- External services
- Third-party APIs
- Internal service dependencies

**Design Principles:**
- Architectural patterns used
- Tradeoffs made
- Constraints followed

**Key principle:** Simplicity first. Avoid overengineering. Start with simplest solution that solves the problem.

**Skill:** `clean-code` (Simplicity, avoid premature optimization)

### 5. Draft/Update Implementation Plan

**Create or update `.ai/context/IMPLEMENTATION.md`:**

**Implementation strategy:**

**Implementation Phases:**
- Break work into logical phases
- Define dependencies between phases
- Estimate effort for each phase

**File Structure:**
- New files to create
- Existing files to modify
- Directory organization

**Implementation Steps:**
- Step-by-step plan for each phase
- Order of implementation (backend first, then frontend, etc.)
- Integration points

**Testing Strategy:**
- Unit test plan
- Integration test plan
- E2E test plan
- Test coverage targets

**Migration Plan:**
- Database migrations (if needed)
- Data migration (if needed)
- Backward compatibility

**Rollout Strategy:**
- Deployment approach
- Feature flags
- Rollback plan

**Success Verification:**
- How to verify each phase
- Acceptance criteria validation
- Performance validation

**Key principle:** Modular, incremental implementation. Each step should be independently testable.

### 6. Run RTK (Rust Token Killer)

**Execute RTK analysis:**

RTK is a token optimization tool that helps manage context efficiently.

**Run RTK commands:**
```bash
rtk analyze design
```

**RTK checks:**
- Token efficiency of design documents
- Context size optimization
- Redundancy detection
- Compression opportunities

**Purpose:** Ensure design documents are concise and token-efficient without losing essential information.

**If RTK suggests optimizations:**
- Review suggestions
- Simplify verbose sections
- Remove redundancy
- Keep essential information

**Skill:** Token efficiency and conciseness

### 7. Run RoastMe

**Execute self-critique for design quality:**

```
/roastme design
```

**RoastMe questions to ask yourself:**

**1. Hidden assumptions?**
- Are all assumptions stated explicitly?
- Are there multiple interpretations of requirements?
- Did you ask clarifying questions?

**2. Overcomplication?**
- Is the design simpler than it could be?
- Are abstractions justified by actual use cases (not speculative)?
- Is there premature optimization?
- Are there unnecessary layers or indirection?

**3. Missing details?**
- Are edge cases covered?
- Are error scenarios documented?
- Are security considerations addressed?
- Are performance requirements clear?

**4. Clear success criteria?**
- Can success be verified automatically?
- Are acceptance criteria specific and measurable?
- Are metrics well-defined?

**5. Feasibility?**
- Is the design technically feasible?
- Are there hidden complexities?
- Are dependencies realistic?
- Is the timeline reasonable?

**Rate each dimension:** PASS / NEEDS WORK / FAIL

**If NEEDS WORK or FAIL:** Revise design before proceeding.

**Skill:** `roastme` mental framework (deep behavioral check)

### 8. Explain in Simple Language

**Create plain-language explanation:**

Write a concise summary explaining:

**What:**
- What are we building? (1-2 sentences)

**Why:**
- Why does this solve the problem? (1-2 sentences)

**How:**
- How will it work at a high level? (2-3 sentences)

**Tradeoffs:**
- What tradeoffs were made and why? (bullet points)

**Risks:**
- What could go wrong? (bullet points)

**Success:**
- How will we know it works? (bullet points)

**Format:**
```markdown
## Design Explanation

**What:** [concise description]

**Why:** [problem solved]

**How:** [high-level approach]

**Tradeoffs:**
- [Tradeoff 1]: Chose X over Y because [reason]
- [Tradeoff 2]: Chose A over B because [reason]

**Risks:**
- [Risk 1]: [mitigation]
- [Risk 2]: [mitigation]

**Success Criteria:**
- [Criterion 1]
- [Criterion 2]
```

**Key principle:** If you can't explain it simply, you don't understand it well enough.

**Skill:** `clean-code` (Clear communication)

### 9. Ask for Approval (HITL Gate)

**Present complete design package for human approval:**

**Deliverables to present:**
- `.ai/context/PRD.md` - Complete PRD
- `.ai/context/ARCHITECTURE.md` - Architecture design
- `.ai/context/IMPLEMENTATION.md` - Implementation plan
- Plain-language explanation (from Step 8)
- RoastMe results (from Step 7)
- Any ADRs created (if applicable)

**Approval request format:**
```markdown
## Design Review Request

**Feature:** [name]
**Date:** [timestamp]

**Summary:** [2-3 sentence overview]

**Documents:**
- PRD: `.ai/context/PRD.md`
- Architecture: `.ai/context/ARCHITECTURE.md`
- Implementation: `.ai/context/IMPLEMENTATION.md`

**Key Decisions:**
1. [Decision 1] - [rationale]
2. [Decision 2] - [rationale]

**Tradeoffs:**
- [Tradeoff analysis]

**Risks:**
- [Risk analysis]

**RoastMe Results:**
- Assumptions: [PASS/NEEDS WORK/FAIL]
- Simplicity: [PASS/NEEDS WORK/FAIL]
- Completeness: [PASS/NEEDS WORK/FAIL]
- Feasibility: [PASS/NEEDS WORK/FAIL]

**Questions for Review:**
1. [Question 1]
2. [Question 2]

**Ready for approval?**
```

**Wait for explicit human approval before proceeding to implementation.**

**Possible outcomes:**
- ✅ **Approved** - Proceed to implementation
- 🔄 **Revisions Requested** - Address feedback and re-submit
- ❌ **Rejected** - Fundamental changes needed, restart design process

**Do not proceed without approval.**

**Skill:** Human-in-the-loop (HITL) gate

### 10. Stop

**Once approval is received or denied:**

**If approved:**
- Design phase is complete
- Implementation can begin using `/build` workflow
- All design documents are finalized and locked
- No coding has been done yet (design only)

**If revisions requested:**
- Return to relevant step (PRD, Architecture, or Implementation)
- Address feedback
- Re-run RTK and RoastMe
- Re-submit for approval

**If rejected:**
- Clarify requirements with stakeholder
- Restart design process from Step 2

**Mark design as complete:**
- Update status in PRD to "Approved"
- Update ARCHITECTURE.md status to "Approved"
- Update IMPLEMENTATION.md status to "Approved"
- Record approval date and approver

**DO NOT CODE.** Design workflow ends here.

Next workflow: `/build` (implementation)

---

## Key Principles

| Principle | Meaning | Test |
|-----------|---------|------|
| **Think before coding** | Complete design before implementation | No code written during design |
| **Simplicity first** | Avoid overengineering | Can explain design in 2-3 sentences |
| **Clear requirements** | Specific, testable, measurable | Every requirement has acceptance criteria |
| **Human approval** | Stakeholder sign-off required | Explicit approval received |

---

## Red Flags - STOP

- Starting to write implementation code
- Skipping human approval gate
- Design too complex to explain simply
- Requirements vague or untestable
- RoastMe showing multiple FAIL ratings
- Assumptions not explicitly stated
- Success criteria missing or unclear

**If you see these:** STOP. Fix issues before proceeding.

---

## Integration Points

**Context Files:**
- Reads: `PROJECT.md`, `CONTEXT.md`, `DECISIONS.md`
- Updates: `PRD.md`, `ARCHITECTURE.md`, `IMPLEMENTATION.md`

**Skills:**
- `clean-code` - Think before coding, simplicity, clarity (Steps 2, 4, 8)
- `roastme` - Self-critique framework (Step 7)

**Commands:**
- `/roastme design` - Design critique (Step 7)
- `rtk analyze design` - Token optimization (Step 6)

**Workflows:**
- **Next:** `/build` - Implementation workflow (after design approval)
- **Related:** `/review` - Design review by others
- **Related:** `/refactor` - Improve existing design
- **Related:** `/audit` - Validate design decisions

**Tools:**
- RTK (Rust Token Killer) - Context optimization

---

## Related Workflows

| Workflow | When to Use | Relationship |
|----------|------------|--------------|
| **[build.md](./build.md)** | After design is approved | Sequential - always follows design |
| **[review.md](./review.md)** | To get peer feedback on design | Parallel - can run during design |
| **[refactor.md](./refactor.md)** | To improve existing architecture | Alternative - when redesigning existing features |
| **[audit.md](./audit.md)** | To validate technical decisions | Supplementary - validates design choices |
| **[init.md](./init.md)** | Before first design | Prerequisite - creates project structure |

---

## Output Format

Design workflow produces three key documents:

**1. PRD.md** - Product requirements
**2. ARCHITECTURE.md** - System design  
**3. IMPLEMENTATION.md** - Implementation plan

Plus optional:
**4. ADRs** - Architecture Decision Records (in `.ai/context/docs/adr/`)
**5. Design explanation** - Plain-language summary

**Output format:** see `.ai/templates/DESIGN_REVIEW.md`

---

**Remember:** Design is about thinking, not coding. A well-designed system is simple to explain and straightforward to implement. Complexity in design leads to complexity in code.
