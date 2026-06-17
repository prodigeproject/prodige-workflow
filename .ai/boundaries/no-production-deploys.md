# No Production Deploys

Prodige Workflow **does not** automate production deployments or directly interact with production infrastructure.

## Why This Is Out of Scope

### 1. Risk Management
- Production deploys require human oversight and rollback judgment
- Automated deployments can cause irreversible damage at scale
- AI agents cannot assess business impact of failed deploys

### 2. Environment Complexity
- Each organization has unique deployment pipelines
- Security requirements vary widely (RBAC, approvals, audit trails)
- Integration with CD tools is organization-specific

### 3. Maintenance Burden
- Supporting every CD tool (GitHub Actions, GitLab CI, Jenkins, Spinnaker, etc.) is unsustainable
- Breaking changes in CD tools would constantly break Prodige

### 4. Compliance & Audit
- Many industries require human approval for production changes
- Audit trails must show WHO approved, not just what was deployed
- SOC2/ISO compliance often mandates separation of duties

## Escape Hatches

### For Development/Staging Deploys
Use `/build` workflow with local testing:
```bash
/build feature-name
/verify                 # Run all quality checks
# Manual: Deploy to staging
# Manual: Test in staging
# Manual: Approve for production
```

### For CI/CD Configuration
Prodige CAN help with:
- Writing CI/CD configuration files (`.github/workflows`, `.gitlab-ci.yml`)
- Setting up deployment scripts
- Creating release checklists

Prodige CANNOT:
- Execute deployments
- Trigger production pipelines
- Manage secrets/credentials

### For Release Management
Use `/release` workflow:
- Generates release notes
- Updates CHANGELOG.md
- Bumps version numbers
- Creates git tags

Then manually:
- Push tags
- Trigger CD pipeline
- Monitor deployment
- Rollback if needed

## What Prodige DOES Do

✅ **Prepare for Deploy**:
- Code quality verification (`/verify`)
- Test coverage
- Build validation
- Release documentation

✅ **Deploy Artifacts**:
- CI/CD configuration generation
- Deployment scripts
- Infrastructure-as-code templates
- Release checklists

❌ **Execute Deploy**:
- Trigger CD pipelines
- Apply infrastructure changes
- Manage production secrets
- Monitor production

## Philosophy Alignment

From SOUL.md Principle 9:
> "Human approval before irreversible changes"

Production deployments are the MOST irreversible change. They must remain human-controlled.

From rules.md:
> "Never: Do not silently change architecture"

Deploying to production IS changing the live architecture. This requires explicit human decision.

## Prior Requests

- None yet (boundary established proactively)

## Recommended Workflow

```
1. /design feature
2. /build feature
3. /verify
4. Human: Review code
5. Human: Merge to main
6. CI: Run automated tests
7. Human: Approve staging deploy
8. CD: Deploy to staging
9. Human: Test in staging
10. Human: Approve production deploy
11. CD: Deploy to production
12. Human: Monitor & validate
```

**Prodige handles**: Steps 1-3  
**Humans + Tools handle**: Steps 4-12

This separation ensures safety, compliance, and organizational control.
