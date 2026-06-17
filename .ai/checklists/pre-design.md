# Pre-Design Checklist

## Prodige Structural Gates
- [ ] Problem clear
- [ ] User clear
- [ ] Scope clear
- [ ] Unknowns listed

---

## Karpathy Behavioral Gates

### 1. Assumption Clarity
- [ ] All vague requirements identified
- [ ] Clarifying questions prepared
- [ ] No silent interpretation of ambiguous points

**Red Flags:**
- Requirements have "make it scalable" without metrics
- Terms like "fast", "secure", "user-friendly" without definition
- Missing context on users, scale, constraints

**Action if unclear:** STOP. Ask specific questions before proceeding.

### 2. Scope Boundaries
- [ ] What's IN scope explicitly listed
- [ ] What's OUT of scope explicitly listed
- [ ] No assumptions about unstated features

**Test:** Can you list exactly what will be built? If not, scope is unclear.

---

## Questions to Ask Before Proceeding

1. **Scale:** How many users/requests/records expected?
2. **Performance:** What response times are acceptable?
3. **Constraints:** Required technologies, budget, timeline?
4. **Success criteria:** How will we know this is done?

---

## Approval Decision

✅ **PROCEED** if:
- Problem, user, scope all clear
- Unknowns explicitly listed
- Clarifying questions prepared

⏸️ **PAUSE** if:
- Multiple interpretations possible
- Vague requirements without clarification
- Assumptions needed to proceed
