# Git Hooks for Prodige Workflow

## Purpose

Automated quality gates enforced at git commit level, ensuring no code bypasses
basic format / lint / type / test checks before it lands.

---

## What Ships In This Folder

This folder contains per-stack `pre-commit` hook templates only. There is no
installer script and no other hook type bundled here.

| File | Stack | What it runs |
|------|-------|--------------|
| `pre-commit-node.sh` | Node.js / TypeScript | format check, lint, `tsc --noEmit` (if `tsconfig.json`), related tests |
| `pre-commit-python.sh` | Python | `black --check`, `ruff check`, `mypy` (if configured), `pytest` |
| `pre-commit-rust.sh` | Rust | `cargo fmt --check`, `cargo clippy`, `cargo test` |
| `pre-commit-go.sh` | Go | `gofmt`, `golangci-lint`, `go test` |
| `auto-memory-capture.md` | (doc) | Notes on capturing memory entries during work |

Each `pre-commit-*.sh` is a self-contained POSIX `sh` script that exits non-zero
on the first failing check, which blocks the commit.

---

## Installation (Manual, Per Stack)

There is no `install.sh`. Copy the template for your stack into `.git/hooks/pre-commit`
and mark it executable. Pick the one matching your project:

```bash
# Node.js / TypeScript
cp .ai/hooks/pre-commit-node.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

# Python
cp .ai/hooks/pre-commit-python.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

# Rust
cp .ai/hooks/pre-commit-rust.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

# Go
cp .ai/hooks/pre-commit-go.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
```

The install line is also documented at the top of each template file.

> Each template assumes the matching toolchain is available (npm scripts, black/ruff,
> cargo, gofmt/golangci-lint). Adjust the script to match the scripts your project
> actually defines.

---

## Bypass (Emergency Only)

```bash
git commit --no-verify -m "emergency hotfix"
```

Bypassing the hook is technical debt. If you do it, document why and follow up.

---

## Relationship to `/verify`

The `/verify` command and these hooks cover the same ground (tests, lint, types,
build) but are independent: `/verify` is an agent-driven command run on demand, while
the hook is a git-level gate. There is no `/verify --mode=... --files=...` interface;
`/verify` takes no such flags. Run it simply as:

```bash
/verify
```

Conceptually the pre-commit hook is the "always-on" enforcement of the same quality
bar that `/verify` checks interactively. Keep them aligned by running the same tools
in both, but the hook does not call `/verify` internally.

---

## CI/CD Integration

Hooks are a fast local gate, not a replacement for CI. Run the full suite in CI.
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
          npm run format:check
          npm run lint
          npm test
          npm run build
```

---

## Troubleshooting

### Hook not running
Confirm the file exists and is executable:
```bash
ls -la .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Tests take too long
Keep the pre-commit gate fast by running only related tests (the Node template
already uses `--findRelatedTests`). Run the full suite in CI instead.

### False positives
Configure the linter to skip a specific rule with an inline disable comment, and
record the reason.

---

## Best Practices

DO:
- Keep the hook fast (target under 10s for pre-commit).
- Run the full suite in CI, not just in the hook.
- Document any bypass and follow up.
- Update the template when you add new tooling.

DON'T:
- Bypass the hook routinely.
- Run slow end-to-end tests in pre-commit.
- Forget to install the hook after cloning (it is not version-controlled in `.git/`).
- Make the hook so strict that developers reflexively bypass it.

---

## References

- Conventional Commits: https://www.conventionalcommits.org/
- pre-commit framework (alternative manager): https://pre-commit.com/
- Husky (Node alternative manager): https://typicode.github.io/husky/

---

**Version:** 3.0.0
**Last Updated:** 2026-06-17
**Status:** Matches shipped hooks (per-stack pre-commit templates only)
