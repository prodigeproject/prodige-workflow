# Git Hooks for Prodige Workflow

## Purpose

Automated quality gates enforced at git commit/push level, ensuring no code bypasses quality checks.

---

## Available Hooks

### 1. pre-commit (Quality Gate)
**Trigger:** Before `git commit`  
**Purpose:** Enforce code quality before committing  
**Checks:**
- Format (prettier/black/rustfmt/gofmt)
- Lint (eslint/ruff/clippy/golangci-lint)  
- Tests (run related tests)
- Type check (tsc/mypy if applicable)

**Result:**
- ✅ All pass → Commit allowed
- ❌ Any fail → Commit blocked with error report

### 2. pre-push (Verification Gate)
**Trigger:** Before `git push`  
**Purpose:** Final verification before sharing code  
**Checks:**
- All tests pass (full suite)
- Build succeeds
- No skipped tests
- Coverage meets threshold (if configured)

### 3. commit-msg (Convention Check)
**Trigger:** After commit message entered  
**Purpose:** Enforce commit message convention  
**Format:** Conventional Commits
```
feat: add user authentication
fix: resolve login bug
docs: update README
test: add payment tests
refactor: simplify validation logic
```

---

## Installation

### Quick Install (All Projects)
```bash
cd your-project-root
cp .ai/hooks/install.sh .
./install.sh
```

### Manual Install (Per Stack)

#### JavaScript/TypeScript (Husky + lint-staged)
```bash
npm install -D husky lint-staged
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
```

Add to `package.json`:
```json
{
  "lint-staged": {
    "*.{js,ts,jsx,tsx}": [
      "prettier --write",
      "eslint --fix",
      "npm test -- --findRelatedTests --passWithNoTests"
    ]
  }
}
```

#### Python (pre-commit framework)
```bash
pip install pre-commit
```

Create `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.1.9
    hooks:
      - id: ruff
        args: [--fix]
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest
        language: system
        pass_filenames: false
```

Install:
```bash
pre-commit install
```

#### Rust (Manual hook)
Create `.git/hooks/pre-commit`:
```bash
#!/bin/sh
set -e

echo "Running cargo fmt..."
cargo fmt --all --check

echo "Running cargo clippy..."
cargo clippy --all-targets -- -D warnings

echo "Running cargo test..."
cargo test --all

echo "✅ All checks passed!"
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

#### Go (Manual hook)
Create `.git/hooks/pre-commit`:
```bash
#!/bin/sh
set -e

echo "Running gofmt..."
gofmt -l -w .

echo "Running golangci-lint..."
golangci-lint run

echo "Running go test..."
go test ./...

echo "✅ All checks passed!"
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## Hook Templates

See individual template files in this folder:
- `pre-commit-node.sh` - Node.js/TypeScript
- `pre-commit-python.sh` - Python
- `pre-commit-rust.sh` - Rust
- `pre-commit-go.sh` - Go
- `pre-push.sh` - Universal pre-push
- `commit-msg.sh` - Universal commit message check

---

## Configuration

### Enable/Disable Per Project
Create `.ai/hooks/config.json`:
```json
{
  "enabled": true,
  "hooks": {
    "pre-commit": true,
    "pre-push": true,
    "commit-msg": false
  },
  "coverage": {
    "enabled": true,
    "threshold": 80
  }
}
```

### Bypass Hook (Emergency Only)
```bash
git commit --no-verify -m "emergency hotfix"
```

**Note:** Should be rare - bypassing hooks is technical debt!

---

## Integration with /verify

Hooks use `/verify` command internally:
```bash
# pre-commit hook calls:
/verify --mode=pre-commit --files=<changed-files>

# pre-push hook calls:
/verify --mode=pre-push --all
```

This ensures consistency between:
- Local git hooks
- Manual `/verify` runs
- CI/CD pipelines

---

## CI/CD Integration

GitHub Actions example (`.github/workflows/quality.yml`):
```yaml
name: Quality Gates

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
      - name: Install
        run: npm ci
      - name: Run Quality Checks
        run: |
          npm run format
          npm run lint
          npm test
          npm run build
```

---

## Troubleshooting

### Issue: Hook not running
**Diagnosis:**
```bash
ls -la .git/hooks/pre-commit
```

**Fix:**
```bash
chmod +x .git/hooks/pre-commit
# Or reinstall hooks
```

### Issue: Tests take too long
**Solution:** Run only related tests in pre-commit
```json
{
  "lint-staged": {
    "*.js": ["npm test -- --findRelatedTests"]
  }
}
```

### Issue: False positives
**Solution:** Configure linter to skip rule
```javascript
// eslint-disable-next-line rule-name
const validException = ...;
```

---

## Best Practices

✅ DO:
- Keep hooks fast (<10s for pre-commit)
- Run full suite in CI, not just hooks
- Document bypass reasons when used
- Update hooks when adding new tools

❌ DON'T:
- Bypass hooks regularly
- Run slow tests in pre-commit
- Forget to install hooks on clone
- Make hooks overly strict (devs will bypass)

---

## References

- Husky: https://typicode.github.io/husky/
- pre-commit: https://pre-commit.com/
- Conventional Commits: https://www.conventionalcommits.org/

---

**Version:** 2.0.0  
**Last Updated:** 2026-06-17  
**Status:** Production Ready
