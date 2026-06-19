# Governance

Governance keeps speed from becoming chaos.

## Purpose
Provides a framework to ensure quality, security, and sustainability in the AI-assisted workflow.

## Structure

### 1. Review Gates (`review-gates.md`)
Quality checkpoints at each development phase to ensure output meets the standard before advancing to the next phase.

### 2. Quality Gates (`quality-gates.md`)
Structural and behavioral quality bars (TDD, verification before completion) enforced at the `/design`, `/build`, and merge stages.

### 3. Rules (`rules.md`)
General engineering rules and conventions that apply across the project.

### 4. Rules by Stack (`rules-by-stack.md`)
Language- and stack-specific best practices (JS/TS, Python, Rust, Go, React, SQL, security).

### 5. Risk Register (`risk-register.md`)
Proactive tracking and mitigation of project risks to avoid problems that could block progress.

### 6. Debt Management (`debt/`)
A tracking system for the various kinds of debt that need to be managed:
- **Technical Debt**: Code quality issues, refactoring needs
- **Architecture Debt**: Design decisions that need improvement
- **Documentation Debt**: Missing or outdated documentation
- **Knowledge Debt**: Knowledge gaps in the team or system

## How to Use

### Daily Workflow
1. Before starting a new task, check the relevant review gates
2. When you find debt, record it in the appropriate debt file
3. Update the risk register if you find a new risk

### Weekly Review
1. Review all open debt items
2. Prioritize debt items to resolve
3. Update the risk register status

### Before Major Milestones
1. Ensure all review gates are satisfied
2. Resolve critical debt items
3. Mitigate high-priority risks

## Integration with Workflow

Governance integrates with:
- **State Management**: Status tracking follows governance checkpoints
- **Memory System**: Decisions and learnings from governance issues
- **Agent System**: Agents enforce governance rules automatically

## Principles

1. **Preventive > Reactive**: Catch issues early
2. **Transparent**: All issues visible and tracked
3. **Actionable**: Every item has a clear action plan
4. **Balanced**: Governance does not block velocity
