#!/bin/sh
# Pre-commit hook for Rust projects
# Install: cp .ai/hooks/pre-commit-rust.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "🔍 Running pre-commit quality checks..."

# 1. Format check
echo "📝 Checking code format..."
cargo fmt --all -- --check || {
  echo "❌ Format check failed. Run 'cargo fmt --all' to fix."
  exit 1
}

# 2. Lint check (Clippy)
echo "🔎 Running clippy..."
cargo clippy --all-targets -- -D warnings || {
  echo "❌ Clippy failed."
  exit 1
}

# 3. Run tests
echo "🧪 Running tests..."
cargo test --all || {
  echo "❌ Tests failed."
  exit 1
}

echo "✅ All pre-commit checks passed!"
exit 0
