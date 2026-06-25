# Commands

User-facing commands for interacting with the Prodige Workflow AI System.

## Overview

Commands are the primary interface for accessing AI system capabilities. Each command maps to a workflow or skill defined in the registry.

## Available Commands

### Core Commands

| Command | Purpose | Documentation |
|---------|---------|---------------|
| `/init` | Initialize project brain | [init.md](./init.md) |
| `/cache` | Manage token-saving cache | [cache.md](./cache.md) |
| `/sync` | Detect context drift | [sync.md](./sync.md) |
| `/parallel` | Multi-window agent execution | [parallel.md](./parallel.md) |

### Command Structure

```bash
/<command> <action> [parameters] [options]
```

**Examples:**
```bash
/init from repo
/cache update
/sync
/parallel build feature-auth
```

## Usage Guidelines

### 1. Direct Command Invocation
Commands are the primary interface for users. Invoke directly from chat or CLI.

```bash
# Correct usage
/init from repo
/cache status
```

### 2. Do NOT Manually Invoke Skills
Skills are internal implementation details. Users interact with commands, not skills.

```bash
# ❌ INCORRECT - Don't do this
@skill initialize-brain

# ✓ CORRECT - Use command instead
/init from repo
```

**Exception:** Manual skill invocation only for debugging or OS development.

### 3. Command-to-Workflow Mapping
Commands map to workflows via `registry.json`. The system handles routing automatically.

```json
{
  "commands": {
    "/init": {
      "workflow": "initialize-brain",
      "skills": ["scan-repo", "build-knowledge-graph", "warm-cache"]
    },
    "/cache": {
      "workflow": "cache-management",
      "skills": ["update-cache", "invalidate-cache"]
    }
  }
}
```

## Command Design Principles

### Simple & Intuitive
```bash
# Clear, verb-based actions
/cache update
/sync
/parallel build workspace-name
```

### Composable
```bash
# Commands work together
/init from repo
/cache update
/sync
```

### Safe by Default
```bash
# Destructive actions require confirmation
/cache clear
# Prompt: "This will delete all cache. Continue? (yes/no)"
```

### Self-Documenting
```bash
# Help available for all commands
/init --help
/cache --help
```

## Adding New Commands

### 1. Define Command Specification
Create new file in `.ai/commands/`:

```markdown
# /mycommand

Brief description.

## Syntax
...

## Examples
...
```

### 2. Register in registry.json
```json
{
  "commands": {
    "/mycommand": {
      "workflow": "my-workflow",
      "skills": ["skill1", "skill2"],
      "description": "Brief description",
      "version": "1.0.0"
    }
  }
}
```

### 3. Implement Workflow
Create workflow in `.ai/workflows/my-workflow.md`

### 4. Test Command
```bash
/mycommand test-param
```

## Command Categories

### Project Initialization
- `/init` - Setup project brain and context

### State Management
- `/sync` - Detect and fix context drift
- `/cache` - Manage performance cache

### Collaboration
- `/parallel` - Coordinate multi-agent work

### Development
- Coming: `/dev`, `/test`, `/deploy`

### Documentation
- Coming: `/docs`, `/readme`

## Error Handling

### Command Not Found
```bash
/unknowncommand
# Error: Command '/unknowncommand' not found
# Did you mean: /init, /cache, /sync?
```

### Invalid Syntax
```bash
/init
# Error: Missing required parameter 'source'
# Usage: /init from <repo|idea|notes>
```

### Execution Error
```bash
/cache update
# Error: Failed to update cache: Insufficient disk space
# Solution: Free up space and retry
```

## Best Practices

### 1. Use Commands, Not Skills
```bash
# ✓ CORRECT
/init from repo

# ❌ WRONG
@skill scan-repository
```

### 2. Check Command Help
```bash
# Before using new command
/newcommand --help
```

### 3. Validate with /sync
```bash
# After state-changing commands
/init from repo
/sync
```

### 4. Chain Commands Logically
```bash
# Good workflow
/init from repo      # Initialize
/cache update       # Optimize
/sync              # Verify
```

### 5. Handle Errors Gracefully
```bash
# If command fails, check status
/sync              # Verify system state
# Then retry
```

## Command Lifecycle

```
User Input → Command Parser → Registry Lookup → Workflow Executor → Skill Orchestrator → Result
     ↓
Error Handler
     ↓
Response to User
```

## Integration Points

### With Skills
Commands invoke skills via registry mapping. Skills are not directly exposed.

### With Agents
Commands can trigger agent workflows for complex operations.

```bash
/parallel build checkout
# → orchestrator agent
# → multiple specialist agents
# → reviewer agent
```

### With State
Commands read from and write to `.ai/state/`.

### With Cache
Commands can trigger cache updates or invalidation.

## Performance Considerations

### Command Latency
- Simple commands: < 1s
- Cache operations: 1-5s
- Initialization: 10-60s
- Parallel workflows: 5-30min

### Resource Usage
- Commands are lightweight
- Heavy lifting in skills/workflows
- Monitor via `/cache status`

## Security

### Command Validation
- Input sanitization
- Parameter validation
- Authorization checks (if applicable)

### Safe Defaults
- Non-destructive operations default
- Confirmation prompts for dangerous actions
- Audit logging for state changes

## Troubleshooting

### Command Hangs
```bash
# Cancel with Ctrl+C
# Check system status
/sync

# Retry or report bug
```

### Unexpected Behavior
```bash
# Verify system state
/sync

# Clear cache if needed
/cache clear
/cache update

# Retry command
```

### Registry Issues
```bash
# If commands not found
# Check registry.json exists and valid
# Verify command registered correctly
```

## Documentation Standards

All command documentation must include:

1. **Clear Syntax** - Exact command format
2. **Parameters** - All parameters with descriptions
3. **Examples** - Real-world usage examples
4. **Error Handling** - Common errors and solutions
5. **Best Practices** - Recommended usage patterns
6. **Integration** - How it works with other commands

## Related Documentation

- `.ai/workflows/` - Workflow implementations
- `.ai/skills/` - Skill implementations
- `registry.json` - Command-to-workflow mappings
- `.ai/state/` - System state that commands interact with

## Version History

- v1.0.0 - Initial command set: init, cache, sync, parallel
- v1.1.0 - Coming: dev, test, deploy commands
- v1.2.0 - Coming: docs, readme generation commands

## Support

For command issues:
1. Check command documentation
2. Run `/sync` to verify state
3. Check `.ai/logs/` for errors
4. Refer to troubleshooting section

---

**Remember:** Commands are the user interface. Keep them simple, powerful, and well-documented.
