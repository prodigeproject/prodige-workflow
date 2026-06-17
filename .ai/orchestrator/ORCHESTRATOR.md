# Orchestrator

The orchestrator maps simple user commands to workflows, skills, agents, cache, and review gates.

Users should not manually invoke skills.

## Responsibilities

- Interpret command intent
- Select workflow
- Select skills
- Select agent roles
- Decide whether HITL is required
- Decide whether task can run in parallel
- Manage snapshots
- Manage cache
- Manage locks
- Require handoffs
- Enforce quality gates
- Trigger context sync

## Command routing

- `/init` -> initialization workflow
- `/design` -> design workflow
- `/build` -> build workflow
- `/fix` -> bugfix workflow
- `/review` -> code review workflow
- `/audit` -> audit workflow
- `/refactor` -> refactor workflow
- `/docs` -> documentation workflow
- `/release` -> release workflow
- `/sync` -> context sync workflow
- `/parallel` -> multi-agent planning workflow
- `/cache` -> cache workflow
- `/status` -> status workflow
- `/agent` -> worker session workflow

## Skill selection is automatic

Example:

`/build login`

Auto-load:
- repomap
- ripgrep
- reuse-rebuild
- rtk
- clean-code
- roastme
- context-sync

Example:

`/audit repo`

Auto-load:
- repomap
- ripgrep
- roastme
- security-review
- dependency-review
- debt-detection
- context-sync

Example:

`/parallel build checkout`

Auto-load:
- parallel-planner
- snapshot-manager
- cache-manager
- lock-manager
- handoff-manager
- repomap
- clean-code
- review-gate
