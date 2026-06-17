# Mainstream Tools Only

Prodige Workflow only provides first-class integration for **mainstream, widely-adopted tools**. Requests to add support for niche, experimental, or single-vendor tools are out of scope.

## Why This Is Out of Scope

### 1. Maintenance Burden
Every tool integration is **permanent maintenance surface**:
- Tool CLIs evolve and break integrations
- Output formats change requiring parser updates
- Each integration must be tested across versions
- Bug reports require tool-specific expertise

This cost is only justified for tools used by a meaningful fraction of teams.

### 2. Feature Bloat
Supporting every tool would create:
- Configuration complexity (choose from 50 options?)
- Documentation overload
- Slower onboarding
- Higher cognitive load

### 3. Verification Complexity
`/verify` supports 8 project types. Adding more requires:
- Understanding tool semantics
- Error message parsing
- Auto-fix logic
- Edge case handling

This investment only makes sense for widely-used tools.

## What Qualifies as "Mainstream"

**Judgment call based on**:
- Industry recognition (would typical engineers recognize it?)
- Adoption breadth (used across companies/industries?)
- Stability (past experimental phase?)
- Longevity (likely to exist in 3+ years?)

**Examples of Mainstream**:
- ✅ Git, GitHub, GitLab (version control)
- ✅ npm, pip, cargo, maven (package managers)
- ✅ Jest, pytest, RSpec, Go test (test runners)
- ✅ ESLint, Pylint, Clippy, Checkstyle (linters)
- ✅ TypeScript, mypy, golangci-lint (type checkers)

**Examples of NOT Mainstream** (for now):
- ❌ Brand-new AI-focused tools with <6 months existence
- ❌ Single-company proprietary tools
- ❌ Tools with <1000 GitHub stars and <1 year age
- ❌ Experimental alpha/beta tools

**Gray Area** (case-by-case):
- Linear, Notion API (popular but niche)
- Deno, Bun (new but growing rapidly)
- Custom CI/CD tools (organization-specific)

## Escape Hatches

### For Niche Tools

**Option 1: Generic Integration**
Use generic command execution:
```markdown
/magic run custom-tool --arg value
```
Prodige treats it as bash command, captures output.

**Option 2: Custom Skill**
Create organization-specific skill:
```
.ai/skills/custom-tool/
├── SKILL.md
└── wrapper.sh
```

Load via `/init` to extend Prodige for your needs.

**Option 3: External Scripts**
Use Prodige for code quality, run niche tools separately:
```bash
/verify                    # Prodige quality checks
./scripts/custom-check.sh  # Your custom tooling
```

### For Experimental Tools

**Wait for Maturity**:
- If tool becomes mainstream (2+ years, wide adoption)
- Request integration again with evidence of longevity

**Contribute Integration**:
- Submit PR with integration code
- Must include: detection logic, execution, parsing, tests
- Must commit to maintenance for 1+ year

## What Prodige DOES Support

### Version Control
- ✅ Git (GitHub, GitLab, Bitbucket)
- ❌ Mercurial, SVN, Perforce (niche in modern dev)

### Languages (verified by `/verify`)
- ✅ JavaScript/TypeScript (Node.js, npm/yarn/pnpm)
- ✅ Python (pytest, pip)
- ✅ Go (go test, go vet)
- ✅ Rust (cargo test, clippy)
- ✅ Java (Maven, JUnit)
- ✅ C# (.NET, xUnit)
- ✅ Ruby (RSpec, bundler)
- ✅ PHP (PHPUnit, Composer)

### Testing Frameworks
- ✅ Jest, Vitest, Mocha (JavaScript)
- ✅ pytest, unittest (Python)
- ✅ go test (Go)
- ✅ cargo test (Rust)
- ✅ JUnit, TestNG (Java)
- ✅ xUnit, NUnit (C#)
- ✅ RSpec, Minitest (Ruby)
- ✅ PHPUnit (PHP)

### Linters
- ✅ ESLint, TSLint, Prettier (JavaScript/TypeScript)
- ✅ Pylint, Black, Flake8 (Python)
- ✅ golangci-lint, gofmt (Go)
- ✅ Clippy, rustfmt (Rust)
- ✅ Checkstyle, SpotBugs (Java)
- ✅ RuboCop (Ruby)
- ✅ PHP CodeSniffer (PHP)

## Philosophy Alignment

From SOUL.md:
> "Simple beats clever"

Supporting 100 tools is clever. Supporting 10 well is simple.

> "Speed is good only if it does not create chaos"

Adding every requested tool creates chaos in configuration, documentation, and maintenance.

## Prior Requests

- None yet (boundary established proactively)

## Decision Framework

When evaluating tool integration requests, ask:

1. **Recognition**: Would a typical engineer in this language recognize it?
2. **Adoption**: Is it used by 10+ organizations you know of?
3. **Stability**: Has it been stable for 2+ years?
4. **Maintenance**: Can we commit to supporting it for 3+ years?
5. **Alternatives**: Are mainstream alternatives sufficient?

If 4+ answers are YES → Consider integration  
If 3 or fewer YES → Decline, point to escape hatches

## Revisiting Decisions

Tools can move from niche → mainstream over time:
- Deno may become mainstream in 2-3 years
- Bun is growing rapidly
- New testing frameworks emerge

We revisit this list annually. Evidence needed:
- Adoption data (downloads, GitHub stars, surveys)
- Longevity (2+ years of stable releases)
- Industry momentum (conference talks, job postings)

Request recons ideration with data, not just preference.
