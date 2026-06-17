#!/bin/sh
# Pre-commit hook for Python projects
# Install: cp .ai/hooks/pre-commit-python.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "🔍 Running pre-commit quality checks..."

# 1. Format check (Black)
echo "📝 Checking code format..."
black --check . || {
  echo "❌ Format check failed. Run 'black .' to fix."
  exit 1
}

# 2. Lint check (Ruff)
echo "🔎 Running linter..."
ruff check . || {
  echo "❌ Lint failed. Run 'ruff check . --fix' to fix."
  exit 1
}

# 3. Type check (MyPy - if configured)
if [ -f "pyproject.toml" ] && grep -q "mypy" pyproject.toml; then
  echo "🔤 Type checking..."
  mypy . || {
    echo "❌ Type check failed."
    exit 1
  }
fi

# 4. Run tests
echo "🧪 Running tests..."
pytest || {
  echo "❌ Tests failed."
  exit 1
}

echo "✅ All pre-commit checks passed!"
exit 0
