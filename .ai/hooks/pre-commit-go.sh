#!/bin/sh
# Pre-commit hook for Go projects
# Install: cp .ai/hooks/pre-commit-go.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "🔍 Running pre-commit quality checks..."

# 1. Format check
echo "📝 Checking code format..."
gofmt -l . | grep -q . && {
  echo "❌ Format check failed. Run 'gofmt -w .' to fix."
  exit 1
}

# 2. Lint check (golangci-lint)
if command -v golangci-lint &> /dev/null; then
  echo "🔎 Running golangci-lint..."
  golangci-lint run || {
    echo "❌ Lint failed."
    exit 1
  }
fi

# 3. Run tests
echo "🧪 Running tests..."
go test ./... || {
  echo "❌ Tests failed."
  exit 1
}

echo "✅ All pre-commit checks passed!"
exit 0
