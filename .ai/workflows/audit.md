# Workflow: Audit

## Overview
Comprehensive codebase audit workflow to assess code quality, architecture, security, performance, and documentation. Produces actionable insights and prioritized recommendations.

## Prerequisites
- Active project repository access
- Existing codebase (not for new projects)
- Read permissions for all project files
- Understanding of project domain/goals
- Access to testing infrastructure (optional)

**Checklist:** Follow `.ai/checklists/audit.md` to ensure full coverage of audit areas.

## Step-by-Step Instructions

### 1. Build Repo Map
**Action**: Create a comprehensive map of the repository structure.
- Scan all directories and files
- Identify key modules and their relationships
- Document file organization patterns
- Note any unusual structures

**Output**: Repository structure diagram/document

### 2. Check Architecture
**Action**: Evaluate the overall system architecture.
- Review architectural patterns used
- Assess separation of concerns
- Check module boundaries
- Evaluate scalability considerations
- Verify architecture documentation accuracy

**Checkpoints**:
- Is the architecture well-documented?
- Are responsibilities clearly separated?
- Are there circular dependencies?

### 3. Check Code Quality
**Action**: Assess code maintainability and readability.
- Review code style consistency
- Check naming conventions
- Evaluate code complexity (cyclomatic complexity)
- Look for code smells (duplications, long methods)
- Review error handling patterns

**Tools**: Linters, complexity analyzers, duplicate detectors

### 4. Check Security
**Action**: Identify security vulnerabilities and risks.
- Scan for common vulnerabilities (SQL injection, XSS, CSRF)
- Review authentication/authorization mechanisms
- Check secrets management
- Evaluate input validation
- Review dependency vulnerabilities

**Critical Areas**: Auth flows, data validation, external API calls

### 5. Check Performance
**Action**: Identify performance bottlenecks.
- Review database queries (N+1 problems)
- Check caching strategies
- Evaluate algorithm efficiency
- Review resource management
- Analyze bundle sizes (frontend)

**Metrics**: Load times, response times, memory usage

### 6. Check Tests
**Action**: Evaluate test coverage and quality.
- Measure code coverage percentage
- Review test quality (unit, integration, e2e)
- Check test maintainability
- Verify CI/CD integration
- Assess test documentation

**Targets**: >80% coverage for critical paths

### 7. Check Docs
**Action**: Assess documentation completeness and accuracy.
- Review README quality
- Check API documentation
- Verify setup instructions
- Evaluate code comments
- Check architecture documentation

**User Perspective**: Can a new developer onboard easily?

### 8. Check Technical Debt
**Action**: Identify accumulated technical debt.
- Find TODO/FIXME comments
- Identify outdated dependencies
- Review deprecated code usage
- Find workarounds and hacks
- Assess refactoring needs

**Classify**: High/Medium/Low priority

### 9. Check Knowledge Debt
**Action**: Identify missing documentation and context.
- Find undocumented business logic
- Identify tribal knowledge areas
- Review onboarding documentation
- Check decision records (ADRs)
- Assess knowledge silos

**Risk**: What happens if key team members leave?

### 10. Prioritize Fixes
**Action**: Create prioritized action plan.
- Categorize issues by severity
- Estimate effort for each fix
- Consider business impact
- Balance quick wins vs. long-term improvements
- Create dependency graph for fixes

**Framework**: Impact vs. Effort matrix

### 11. Write Report
**Action**: Document findings and recommendations.
- Executive summary
- Detailed findings by category
- Prioritized action items
- Risk assessment
- Timeline estimates
- Resource requirements

**Format**: Clear, actionable, stakeholder-appropriate

**Output format:** see `.ai/templates/AUDIT_REPORT.md`

**Save the report:** Write the completed audit to `.ai/reports/audits/audit-<stamp>.md` (where `<stamp>` is an ISO 8601 / `YYYY-MM-DD-HHMM` timestamp). This is the canonical, persisted location for audit reports — do not leave the report only in chat or scratch space.

### 12. Record Technical Debt
**Action**: Record any new technical debt to `.ai/governance/debt/technical-debt.md`.
- Append (do not overwrite) debt items found during steps 8-9
- Classify each by priority (High/Medium/Low) with impact and remediation notes
- This keeps the canonical debt registry current after every audit

## Expected Outcomes

### Deliverables
1. **Audit Report**: Comprehensive document covering all assessment areas
2. **Repo Map**: Visual/textual repository structure
3. **Issue List**: Prioritized list of findings
4. **Action Plan**: Roadmap for addressing issues
5. **Metrics Dashboard**: Key quality indicators

### Success Criteria
- All critical security issues identified
- Technical debt quantified
- Clear prioritization of improvements
- Actionable recommendations
- Stakeholder buy-in on priorities

## Troubleshooting Tips

### Issue: Repository too large to analyze manually
**Solution**: 
- Use automated tools (SonarQube, CodeClimate)
- Sample representative modules
- Focus on high-risk areas first

### Issue: Conflicting priorities between stakeholders
**Solution**:
- Use objective metrics
- Present cost-benefit analysis
- Create multiple scenarios
- Facilitate stakeholder workshop

### Issue: Missing documentation makes understanding difficult
**Solution**:
- Interview team members
- Use code archaeology (git history)
- Run the application and observe behavior
- Create minimal documentation as you learn

### Issue: Too many findings to prioritize
**Solution**:
- Apply 80/20 rule (focus on 20% causing 80% of issues)
- Use severity scoring system
- Consider business impact first
- Create phases (immediate/short-term/long-term)

### Issue: Limited access to parts of the system
**Solution**:
- Document access limitations in report
- Request necessary permissions
- Use available documentation
- Note assumptions and risks

## Best Practices

1. **Stay Objective**: Base conclusions on evidence, not opinions
2. **Be Constructive**: Frame findings as opportunities for improvement
3. **Prioritize Ruthlessly**: Not everything can be fixed immediately
4. **Engage Team**: Include developers in the audit process
5. **Follow Up**: Plan for re-audits to track progress
6. **Automate**: Use tools to scale the audit process
7. **Document Context**: Explain why issues matter to the business

## Related Workflows
- **Design**: Use audit findings to inform redesign decisions
- **Fix**: Execute on identified issues
- **Sync**: Keep audit findings updated as code evolves
- **Cache**: Update cache with audit insights
