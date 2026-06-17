# /parallel

Prepare or manage multi-window agent execution.

Examples:
- `/parallel build checkout`
- `/parallel merge checkout`
- `/parallel resolve checkout`

Rules:
- Create snapshot.
- Create sessions.
- Assign roles.
- Create locks if needed.
- Require handoff from every agent.
- Reviewer merges output.
