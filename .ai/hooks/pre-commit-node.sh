#!/bin/sh
# Pre-commit hook for Node.js/TypeScript projects
# Install: cp .ai/hooks/pre-commit-node.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "🔍 Running pre-commit quality checks..."

# 1. Format check
echo "📝 Checking code format..."
npm run format:check || {
  echo "❌ Format check failed. Run 'npm run format' to fix."
  exit 1
}

# 2. Lint check  
echo "🔎 Running linter..."
npm run lint || {
  echo "❌ Lint failed. Run 'npm run lint:fix' to fix."
  exit 1
}

# 3. Type check (if TypeScript)
if [ -f "tsconfig.json" ]; then
  echo "🔤 Type checking..."
  npx tsc --noEmit || {
    echo "❌ Type check failed."
    exit 1
  }
fi

# 4. Run tests (related to changed files)
echo "🧪 Running tests..."
npm test -- --findRelatedTests --passWithNoTests || {
  echo "❌ Tests failed."
  exit 1
}

echo "✅ All pre-commit checks passed!"
exit 0
