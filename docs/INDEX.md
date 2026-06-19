# Prodige Workflow Documentation Index

Complete guide to Prodige Workflow documentation, organized by user journey and experience level.

---

## 🚀 Quick Navigation

**New to Prodige?** → Start with [SETUP.md](./SETUP.md) then [NEWBIE_MODE.md](./NEWBIE_MODE.md)  
**Using a specific AI tool/agent?** → [COMPATIBILITY.md](./COMPATIBILITY.md) (Claude, Cursor, Copilot, Codex, Gemini, Hermes, OpenClaw, …)  
**Ready to build?** → Read [USAGE.md](./USAGE.md) then [DEVELOPMENT.md](./DEVELOPMENT.md)  
**Deploying to production?** → Follow [RELEASE.md](./RELEASE.md) and [DEPLOYMENT.md](./DEPLOYMENT.md)  
**Working with teams?** → Check [MULTI_WINDOW_AGENT_GUIDE.md](./MULTI_WINDOW_AGENT_GUIDE.md)

---

## 📚 Documentation by Category

### Getting Started (Beginners)

| Document | Purpose | Time Required |
|----------|---------|---------------|
| **[SETUP.md](./SETUP.md)** | Initial installation and configuration | 10-30 min |
| **[COMPATIBILITY.md](./COMPATIBILITY.md)** | Run Prodige in any AI tool/agent (install + matrix) | 5 min read |
| **[NEWBIE_MODE.md](./NEWBIE_MODE.md)** | Simplified commands for beginners | 5 min read |
| **[USAGE.md](./USAGE.md)** | Complete workflow guide from start to finish | 20 min read |

**Recommended Flow:**
1. SETUP.md - Get Prodige running
2. NEWBIE_MODE.md - Learn simplified commands
3. USAGE.md - Understand the full workflow

---

### Development (Intermediate)

| Document | Purpose | Audience |
|----------|---------|----------|
| **[DEVELOPMENT.md](./DEVELOPMENT.md)** | Development best practices and patterns | Developers |
| **[CACHE_STRATEGY.md](./CACHE_STRATEGY.md)** | Performance optimization techniques | Performance-focused devs |
| **[API.md](./API.md)** | API documentation generation | Backend developers |
| **[HITL_REVIEW_GATES.md](./HITL_REVIEW_GATES.md)** | Quality gates and human approval process | Teams with quality requirements |

**Use When:**
- Building features with `/build`
- Optimizing for large codebases
- Documenting APIs
- Enforcing code quality standards

---

### Collaboration (Teams)

| Document | Purpose | Key Features |
|----------|---------|--------------|
| **[MULTI_WINDOW_AGENT_GUIDE.md](./MULTI_WINDOW_AGENT_GUIDE.md)** | Parallel agent execution | Snapshots, locks, handoffs |
| **[HITL_REVIEW_GATES.md](./HITL_REVIEW_GATES.md)** | Human-in-the-loop approval gates | Pre-design, pre-build, pre-merge |

**Use Cases:**
- Multiple developers working simultaneously
- Complex features requiring parallel workstreams
- Team code review processes

---

### Production (Advanced)

| Document | Purpose | Critical For |
|----------|---------|--------------|
| **[RELEASE.md](./RELEASE.md)** | Safe release process | Production deployments |
| **[DEPLOYMENT.md](./DEPLOYMENT.md)** | Deployment strategies and automation | DevOps teams |

**Process:**
1. Complete feature development
2. Run `/verify` to ensure quality
3. Follow RELEASE.md checklist
4. Execute DEPLOYMENT.md procedures

---

## 📖 Documentation by User Journey

### Journey 1: Solo Developer - New Project

```
1. SETUP.md → Install Prodige
2. USAGE.md (Section: "For New Projects") → Initialize
3. DEVELOPMENT.md → Learn patterns
4. RELEASE.md → Ship features
```

### Journey 2: Solo Developer - Existing Project

```
1. SETUP.md → Install Prodige
2. USAGE.md (Section: "For Existing Projects") → Integrate
3. CACHE_STRATEGY.md → Optimize for your codebase
4. DEVELOPMENT.md → Adopt patterns gradually
```

### Journey 3: Team Lead - Team Adoption

```
1. SETUP.md → Install for team
2. NEWBIE_MODE.md → Train team members
3. MULTI_WINDOW_AGENT_GUIDE.md → Enable parallel work
4. HITL_REVIEW_GATES.md → Enforce quality gates
5. RELEASE.md → Standardize deployments
```

### Journey 4: DevOps Engineer - CI/CD Integration

```
1. DEPLOYMENT.md → Understand deployment model
2. CACHE_STRATEGY.md → Optimize build performance
3. HITL_REVIEW_GATES.md → Automate quality checks
4. RELEASE.md → Integrate with release pipeline
```

---

## 🎯 Quick Reference by Task

### "I want to..."

**...set up Prodige for the first time**
→ [SETUP.md](./SETUP.md)

**...use Prodige in my AI tool of choice (or an agentic framework)**
→ [COMPATIBILITY.md](./COMPATIBILITY.md)

**...understand basic commands**
→ [NEWBIE_MODE.md](./NEWBIE_MODE.md)

**...build a new feature**
→ [USAGE.md](./USAGE.md) + [DEVELOPMENT.md](./DEVELOPMENT.md)

**...work in parallel with teammates**
→ [MULTI_WINDOW_AGENT_GUIDE.md](./MULTI_WINDOW_AGENT_GUIDE.md)

**...speed up Prodige in large codebases**
→ [CACHE_STRATEGY.md](./CACHE_STRATEGY.md)

**...document my API**
→ [API.md](./API.md)

**...enforce code review before merging**
→ [HITL_REVIEW_GATES.md](./HITL_REVIEW_GATES.md)

**...release to production**
→ [RELEASE.md](./RELEASE.md) + [DEPLOYMENT.md](./DEPLOYMENT.md)

---

## 📋 Documentation Checklist

### For New Users
- [ ] Read SETUP.md
- [ ] Complete first `/init from repo`
- [ ] Try commands in NEWBIE_MODE.md
- [ ] Build first feature using USAGE.md

### For Teams
- [ ] Set up team workspace (SETUP.md)
- [ ] Configure review gates (HITL_REVIEW_GATES.md)
- [ ] Enable parallel workflows (MULTI_WINDOW_AGENT_GUIDE.md)
- [ ] Standardize release process (RELEASE.md)

### For Production
- [ ] Optimize cache strategy (CACHE_STRATEGY.md)
- [ ] Document APIs (API.md)
- [ ] Automate deployment (DEPLOYMENT.md)
- [ ] Establish release checklist (RELEASE.md)

---

## 🔗 Related Documentation

### In `.ai/` Directory
- `.ai/boot/BOOT.md` - Startup sequence
- `.ai/orchestrator/ORCHESTRATOR.md` - Command routing
- `.ai/workflows/` - Workflow definitions
- `.ai/skills/` - Skill implementations
- `.ai/agents/` - Agent role definitions

### Root Level
- `AGENTS.md` - Universal entry point (bootstraps Prodige in any AI tool)
- `install.sh` / `install.ps1` - Wire up tool-specific pointer files
- `README.md` - Project overview
- `PRODIGE.md` - Complete user guide
- `QUICK_START.md` - 5-minute tutorial
- `QUICK_REFERENCE.md` - Command cheat sheet
- `CHANGELOG.md` - Version history

---

## 🆘 Getting Help

### Documentation Issues
- **Unclear instructions?** Open an issue with doc name + section
- **Missing information?** Suggest additions via PR
- **Broken links?** Report in issues

### Usage Questions
- Read relevant doc sections first
- Check QUICK_REFERENCE.md for commands
- Review examples in USAGE.md

### Bugs or Feature Requests
- Not documentation issues
- Use project issue tracker

---

## 📊 Documentation Maintenance

### Document Status

| Document | Last Updated | Status |
|----------|-------------|--------|
| SETUP.md | Current | ✅ Maintained |
| USAGE.md | Current | ✅ Maintained |
| DEVELOPMENT.md | Current | ✅ Maintained |
| RELEASE.md | Current | ✅ Maintained |
| DEPLOYMENT.md | Current | ✅ Maintained |
| API.md | Current | ✅ Maintained |
| CACHE_STRATEGY.md | Current | ✅ Maintained |
| HITL_REVIEW_GATES.md | Current | ✅ Maintained |
| MULTI_WINDOW_AGENT_GUIDE.md | Current | ✅ Maintained |
| NEWBIE_MODE.md | Current | ✅ Maintained |

---

**Last Updated:** June 17, 2026  
**Version:** 2.0  
**Maintained By:** Prodige Workflow Team
