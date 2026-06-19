# Parallel Workflow Checklist

Use this checklist when running a parallel build to coordinate multi-agent development.

## Pre-Build Checklist

- [ ] **Snapshot Created**: Take a snapshot of the current state for rollback safety
  - Command: `/parallel build <feature-name>`
  - Verify the snapshot ID is saved

- [ ] **Sessions Created**: Ensure a separate session for each agent
  - Backend session: `checkout-backend`
  - Frontend session: `checkout-frontend`
  - QA session: `checkout-qa`
  - Docs session: `checkout-docs`

- [ ] **Locks Created**: File locks active to prevent conflicts
  - Check `.ai/runtime/locks/` for file assignments
  - Ensure there is no overlap between agents

- [ ] **Handoffs Assigned**: Each agent knows its task and dependencies
  - Review `.ai/runtime/handoffs/`
  - Confirm each agent has enough context

- [ ] **Reviewer Assigned**: Reviewer session ready for final integration
  - Session: `checkout-review`
  - Reviewer has access to all agent outputs

## Post-Build Checklist

- [ ] **Agent Tasks Complete**: All agents finished their assigned tasks
- [ ] **Tests Passing**: Unit and integration tests succeed in every session
- [ ] **Conflicts Resolved**: No merge conflicts or dependency issues
- [ ] **Review Complete**: Reviewer approves all changes
- [ ] **Merge Executed**: Run `/parallel merge <feature-name>` for final integration
