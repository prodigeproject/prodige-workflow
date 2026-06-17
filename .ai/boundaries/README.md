# Boundaries

Out-of-scope items for Prodige Workflow. These define what the workflow **will not** do to prevent scope creep and set clear expectations.

## Purpose

Boundaries documentation serves to:
- **Prevent repeat requests** for features that don't fit the philosophy
- **Clarify capabilities** vs what should be done manually or differently
- **Set expectations** upfront for users and contributors
- **Reduce maintenance burden** by explicitly rejecting certain paths

## How to Use

1. **Review boundaries** before requesting new features
2. **Reference boundaries** when explaining why something isn't supported
3. **Update boundaries** when new rejection patterns emerge
4. **Link from issues** when closing requests that hit boundaries

## Current Boundaries

1. [**No Production Deploys**](./no-production-deploys.md) - Deployment is manual/external
2. [**Mainstream Tools Only**](./mainstream-tools-only.md) - No niche/experimental integrations
3. [**Human Approval Gates**](./human-approval-gates.md) - Critical decisions require HITL
4. [**No Magic Abstractions**](./no-magic-abstractions.md) - Explicit over clever
5. [**Context Size Limits**](./context-size-limits.md) - Practical limits on project size

## Adding New Boundaries

When adding a new boundary:

1. Create `{boundary-name}.md` file
2. Use template structure (see existing files)
3. Document **why** it's out of scope
4. Provide **escape hatches** for edge cases
5. Link **prior requests** if any exist
6. Update this README

## Template

```markdown
# {Boundary Title}

{Clear statement of what's out of scope}

## Why This Is Out of Scope

{Reasoning - maintenance burden, complexity, risk, philosophy mismatch}

## Escape Hatches

{Alternative approaches for legitimate edge cases}

## Philosophy Alignment

{How this boundary aligns with SOUL.md principles}

## Prior Requests

{Link to issues/discussions where this was requested before}
```
