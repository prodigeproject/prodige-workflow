---
name: dependency-review
description: "Audits project dependencies for security vulnerabilities, license compliance, version conflicts, unused packages, and lockfile integrity. Owns supply-chain analysis (security-review defers here)."
auto_load: [audit]
applies_to: [reviewer, backend, frontend]
---

# Skill: dependency-review

## Quick Protocol (your next action)
1. Read manifests + lockfiles and run the audit tool (npm audit / pip-audit / equivalent).
2. Classify each issue: Security, License, Version conflict, Unused, or Lockfile integrity.
3. Rate severity (security first) and name the exact fix (update/remove/replace/pin).
4. List affected manifest/lockfile files and the risk of inaction.
Base findings on real advisories, not guesses.

## Purpose

Audit project dependencies for security vulnerabilities, licensing issues, version conflicts, unused packages, and lockfile integrity to maintain a healthy and secure dependency graph.

## Description

The dependency-review skill performs comprehensive analysis of project dependencies including direct and transitive dependencies. It identifies security vulnerabilities, outdated packages, license compliance issues, version conflicts, and unused dependencies that bloat the project.

## When to use

- Before releasing new versions
- After adding new dependencies
- During regular security audits (monthly/quarterly)
- When CI/CD builds fail due to dependency issues
- Before major framework or language version upgrades
- When deployment bundle size is too large
- Automatically selected by orchestrator for health checks

## Input

- Package manifest files (package.json, requirements.txt, pom.xml, Cargo.toml)
- Lockfiles (package-lock.json, yarn.lock, Pipfile.lock, Cargo.lock)
- Security advisory databases (npm audit, Snyk, GitHub Dependabot)
- Dependency tree and import analysis
- License requirements and policies

## Output

### Standard format:
- **Findings**: Specific dependency issues with evidence
- **Issue type**: Security/License/Version/Unused/Conflict
- **Severity**: Critical/High/Medium/Low per issue
- **Recommended action**: Update, remove, or replace dependencies
- **Risks**: Security, legal, stability, or performance impacts
- **Files affected**: Package manifests and lockfiles

## Usage Examples

### Example 1: Security vulnerabilities
```
Task: Audit dependencies for security issues
Input: package.json, package-lock.json
Output:
  Findings:
    - lodash@4.17.15: Prototype pollution vulnerability (CVE-2020-8203)
    - axios@0.19.2: Server-Side Request Forgery (SSRF) (CVE-2021-3749)
    - 12 transitive vulnerabilities from express dependencies
  Issue type: Security
  Severity: Critical (2), High (5), Medium (7)
  Recommended action:
    - Update lodash to 4.17.21+
    - Update axios to 0.21.2+
    - Update express to 4.18+ (resolves transitive issues)
    - Run npm audit fix --force
  Risks: Remote code execution, data leakage, SSRF attacks
  Files affected: package.json, package-lock.json
```

### Example 2: Unused dependencies
```
Task: Identify unused packages
Input: package.json, src/ import analysis
Output:
  Findings:
    - moment (32KB): Not imported anywhere (use date-fns instead)
    - jquery: Imported once, can use vanilla JS
    - lodash: 90% unused, import only needed functions
    - 8 devDependencies listed as dependencies (wrong section)
  Issue type: Unused/Misconfigured
  Severity: Medium
  Recommended action:
    - Remove moment, save 32KB bundle size
    - Remove jquery, refactor single usage (20 lines)
    - Switch to lodash-es for tree-shaking
    - Move test tools to devDependencies
  Risks: Bundle size +40KB unnecessary, slower builds
  Files affected: package.json
```

### Example 3: Version conflicts
```
Task: Resolve dependency version conflicts
Input: package-lock.json, npm ls output
Output:
  Findings:
    - react@17.0.2 and react@18.1.0 both installed (peer dependency conflict)
    - TypeScript@4.5 required by A, TypeScript@4.9 required by B
    - 5 packages have version ranges too broad (^1.0.0 allows breaking changes)
  Issue type: Version conflict
  Severity: High
  Recommended action:
    - Standardize on react@18.2.0 (update all packages)
    - Update packages requiring old TypeScript versions
    - Pin versions or use tighter ranges (~1.0.0)
    - Use npm dedupe to flatten tree
  Risks: Runtime errors, type mismatches, unpredictable behavior
  Files affected: package.json, package-lock.json
```

### Example 4: Outdated packages
```
Task: Check for outdated dependencies
Input: package.json, npm outdated output
Output:
  Findings:
    - 15 packages have major updates available
    - next@12.0.0 current, next@14.0.0 available (2 major versions behind)
    - eslint@7.32.0 current, eslint@8.55.0 available
    - 23 minor/patch updates available
  Issue type: Outdated versions
  Severity: Medium
  Recommended action:
    - Update patch versions immediately (bug fixes)
    - Plan Next.js upgrade (breaking changes, 1-2 weeks)
    - Update ESLint (check for rule changes)
    - Set up Dependabot for automatic updates
  Risks: Missing security patches, bugs, incompatibility with new tools
  Files affected: package.json, package-lock.json
```

### Example 5: License compliance
```
Task: Audit dependency licenses
Input: package.json, license-checker output
Output:
  Findings:
    - 3 packages with GPL license (incompatible with proprietary software)
    - 5 packages with unknown/missing licenses
    - viral license risk from transitive dependency
  Issue type: License compliance
  Severity: Critical
  Recommended action:
    - Replace GPL packages with MIT/Apache alternatives
    - Contact maintainers for license clarification
    - Document license decisions for legal review
    - Add license checking to CI/CD pipeline
  Risks: Legal liability, cannot distribute product, lawsuits
  Files affected: package.json, LICENSE_AUDIT.md (new)
```

### Example 6: Lockfile health
```
Task: Validate lockfile integrity
Input: package-lock.json, package.json
Output:
  Findings:
    - Lockfile out of sync with package.json (3 packages)
    - 45 packages have integrity hashes missing
    - Lockfile version mismatch (npm 6 lock with npm 8)
  Issue type: Lockfile integrity
  Severity: High
  Recommended action:
    - Delete node_modules and lockfile
    - Run npm install with latest npm version
    - Commit new lockfile with all hashes
    - Add lockfile validation to CI
  Risks: Non-reproducible builds, supply chain attacks
  Files affected: package-lock.json
```

## Best Practices

### Dependency Selection
- Prefer well-maintained packages (recent commits, active issues)
- Check weekly downloads (popularity indicator)
- Review GitHub stars and community support
- Verify license compatibility before adding
- Consider package size impact on bundle

### Security Practices
- Run security audits weekly or on every PR
- Enable automated security updates (Dependabot, Renovate)
- Subscribe to security advisories for critical deps
- Use lock files to ensure reproducible builds
- Verify package integrity with checksums

### Version Management
- Use exact versions for critical dependencies
- Use tilde ranges (~) for patch updates
- Avoid caret ranges (^) for major version 0.x
- Document version pinning decisions
- Test updates in staging before production

### Dependency Hygiene
- Review dependencies quarterly
- Remove unused dependencies immediately
- Avoid dependencies with dependencies (prefer minimal)
- Use bundle analyzers to track size impact
- Consider vendoring small utilities vs. adding deps

### Update Strategy
- **Patch updates**: Apply immediately (bug fixes)
- **Minor updates**: Review changelog, test, apply weekly
- **Major updates**: Plan migration, allocate time, thorough testing
- **Breaking changes**: Read migration guides, update tests first

### Monitoring
- Set up alerts for new vulnerabilities
- Track dependency count trend (should be stable/decreasing)
- Monitor bundle size impact
- Review transitive dependency depth
- Audit license changes in updates

## Rules

- Be concise but comprehensive in findings
- Be evidence-based using npm audit, vulnerability databases
- Do not invent facts - use actual security advisories
- Prefer durable knowledge updates when patterns emerge
- Prioritize security issues over convenience
- Consider legal and compliance requirements
- Balance security with stability (not always bleeding edge)
- Document rationale for pinning specific versions
