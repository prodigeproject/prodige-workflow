# Review Gates

Review gates are quality checkpoints at each phase that ensure the output meets the
required standard before moving on to the next phase.

## Gate 1: PRD Gate
**Trigger**: After the PRD draft is complete
**Required Before**: Architecture design starts

### Checklist
- [ ] Problem statement is clear and validated
- [ ] User stories complete with acceptance criteria
- [ ] Success metrics defined
- [ ] Constraints and assumptions documented
- [ ] Stakeholder approval obtained

### Reviewer
- Product Owner or Architect
- At least 1 peer review

### Outputs
- Approved PRD document
- Go/No-go decision for the architecture phase

---

## Gate 2: Architecture Gate
**Trigger**: After the architecture design is complete
**Required Before**: Implementation plan starts

### Checklist
- [ ] System design diagram complete
- [ ] Component boundaries clear
- [ ] Data flow documented
- [ ] Technology stack justified
- [ ] Scalability considerations addressed
- [ ] Security considerations documented
- [ ] Integration points identified
- [ ] Trade-offs explicitly stated

### Reviewer
- Tech Lead or Senior Architect
- Security review (if applicable)

### Outputs
- Approved architecture document
- Technical specifications
- Risk assessment

---

## Gate 3: Implementation Gate
**Trigger**: After the implementation plan is complete
**Required Before**: Build/coding starts

### Checklist
- [ ] Task breakdown complete and realistic
- [ ] Dependencies identified
- [ ] Timeline estimated
- [ ] Resource allocation clear
- [ ] Testing strategy defined
- [ ] Rollback plan documented
- [ ] Monitoring strategy planned

### Reviewer
- Development Lead
- QA Lead (for the testing strategy)

### Outputs
- Approved implementation plan
- Task assignments
- Sprint/iteration plan

---

## Gate 4: Code Review Gate
**Trigger**: Before merging to the main branch
**Required Before**: Code merge

### Checklist
- [ ] Code follows the style guide
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] No critical security issues
- [ ] Performance acceptable
- [ ] Error handling proper
- [ ] Backwards compatibility checked
- [ ] No hardcoded secrets

### Reviewer
- At least 1 senior developer
- Automated checks passing

### Outputs
- Approved PR
- Merge to the main branch

---

## Gate 5: Release Gate
**Trigger**: Before production deployment
**Required Before**: Release to production

### Checklist
- [ ] All tests passing (unit, integration, e2e)
- [ ] Performance benchmarks met
- [ ] Security scan passed
- [ ] Documentation complete and updated
- [ ] Release notes prepared
- [ ] Rollback plan verified
- [ ] Monitoring dashboards ready
- [ ] Stakeholder notification sent

### Reviewer
- Release Manager
- Tech Lead approval
- Product Owner approval (for feature releases)

### Outputs
- Production deployment
- Release announcement
- Post-release monitoring plan

---

## Emergency Bypass

In an emergency (production down, critical security fix):

1. **Document**: Record the reason for the bypass
2. **Notify**: Inform stakeholders
3. **Fast-track**: At least 1 reviewer approval
4. **Follow-up**: Complete the full review after deployment

### Emergency Checklist
- [ ] Incident documented
- [ ] Quick review completed
- [ ] Deployment plan clear
- [ ] Rollback tested
- [ ] Post-mortem scheduled

---

## Gate Metrics

Track for continuous improvement:
- Average time spent at each gate
- Gate rejection rate
- Issues found at each gate
- Bypass frequency and reasons

## Best Practices

1. **Early Feedback**: Involve reviewers early, do not wait for the gate
2. **Async Reviews**: Use async communication for efficiency
3. **Clear Criteria**: Every checklist item must be objective
4. **Learn**: Update gates based on lessons learned

---

## Relationship to Quality Gates

These review gates and the quality gates in `.ai/governance/quality-gates.md` are two
views of one coherent system, not competing models:

- **Review gates (this file)** are *lifecycle / phase* checkpoints. They answer
  "is this phase complete enough to advance?" across the PRD -> Architecture ->
  Implementation -> Code Review -> Release flow. They are about process and approval.
- **Quality gates** are *content* checkpoints. They answer "is the work itself good?"
  across two axes: structural quality (correct, modular, tested, secure) and
  behavioral discipline (no silent assumptions, minimum complexity, surgical changes,
  verified completion), enforced at the `/design`, `/build`, and `/merge` stages.

### Mapping

| Review gate (phase) | Quality-gate stage that enforces content here |
|---------------------|-----------------------------------------------|
| Gate 1 PRD          | Pre-design discipline (clarify assumptions, simplest scope) |
| Gate 2 Architecture | `/design` stage gate (`/roastme design`: simplicity, tradeoffs surfaced) |
| Gate 3 Implementation | `/design` -> `/build` handoff (plan has verifiable success criteria) |
| Gate 4 Code Review  | `/build` stage gate + `/merge` stage gate (surgical diff, TDD evidence, structural + behavioral checks, debt + context synced) |
| Gate 5 Release      | Structural quality bar (all tests/build/security verified with evidence) |

In short: a phase does not pass its review gate until the matching quality-gate checks
pass. Use this file to decide *when* to advance; use `quality-gates.md` to decide
*whether the work is good enough* to advance.
