# Prodige + Karpathy Workflow

> **Workflow yang memudahkan bahkan vibe coder pemula untuk membuat aplikasi yang matang dengan kualitas almost perfect, sesuai standar, efektif, dan efisien.**

---

## 🎯 Apa Ini?

Ini adalah **Prodige Workflow** yang telah diintegrasikan dengan **Karpathy Behavioral Guidelines** - sebuah sistem development yang menggabungkan:

- ✅ **Prodige:** Structural governance (WHAT to build - stages, gates, context)
- ✅ **Karpathy:** Behavioral governance (HOW to code - simplicity, precision, verification)

**Hasil:** AI agents yang tidak hanya terstruktur, tapi juga disiplin dalam coding - tidak over-engineering, tidak nebak requirements, tidak bikin scope creep.

---

## 🚀 Quick Start

### Untuk Pemula (Vibe Coders)

```bash
# 1. Mulai project baru
/init from idea: "Aplikasi todo list dengan authentication"

# 2. AI akan bertanya (bukan langsung coding!)
# Jawab pertanyaannya atau approve rekomendasi AI

# 3. Design
/design

# AI akan present multiple options dengan tradeoffs
# Pilih yang paling simple

# 4. Self-check
/roastme design

# 5. Build
/build

# AI akan implement step-by-step dengan verification

# 6. Final check & merge
/roastme build
/merge

# 🎉 Done!
```

**📖 Baca:** [Panduan Lengkap untuk Vibe Coders](.ai/docs/VIBE_CODER_GUIDE.md)

---

### Untuk Developers

**New Commands:**
- `/roastme design` - Critique architecture before building
- `/roastme build` - Detect overcomplication and scope creep

**Enhanced Agents:**
All 7 agents now follow Karpathy principles:
- Think Before Coding (ask, don't assume)
- Simplicity First (minimum code)
- Surgical Changes (no drive-by refactoring)
- Goal-Driven (verifiable success criteria)

**Enhanced Gates:**
- Pre-design: Assumption clarity check
- Pre-build: Simplicity justification required
- Pre-merge: Surgical precision verification

**📖 Baca:** [Implementation Guide](../IMPLEMENTATION_GUIDE.md)

---

## 💡 Kenapa Ini Penting?

### Masalah Yang Dipecahkan

**❌ AI Biasa:**
```
User: "Add authentication"
AI: *implements JWT + OAuth + Redis + 2FA + email verification*
     *500 lines of code*
     *never asked what you actually need*
```

**✅ Prodige + Karpathy:**
```
User: "Add authentication"

AI: "Before implementing, I need clarification:

1. Auth method:
   - Simple login (50 lines) ← recommended for your use case
   - JWT tokens (100 lines)
   - OAuth (500 lines)

2. Requirements:
   - Which endpoints need protection?
   - Existing user system?

My recommendation: Simple login unless you need API/mobile.

Which approach?"
```

---

### Prinsip Karpathy (4 Behavioral Rules)

#### 1. Think Before Coding
**Aturan:** Don't assume. Ask questions. Present tradeoffs.

**Contoh:**
```
❌ BAD: Agent langsung implement tanpa tanya
✅ GOOD: Agent tanya 3-5 clarifying questions dulu
```

#### 2. Simplicity First
**Aturan:** Minimum code that solves the problem. No speculation.

**Contoh:**
```
❌ BAD: 500 lines dengan Strategy pattern untuk 1 use case
✅ GOOD: 50 lines simple function, add pattern nanti kalau butuh
```

#### 3. Surgical Changes
**Aturan:** Only touch what you must. No drive-by refactoring.

**Contoh:**
```
❌ BAD: Fix login bug + refactor register.js + change quote style
✅ GOOD: Fix login bug only. That's it.
```

#### 4. Goal-Driven Execution
**Aturan:** Define verifiable success criteria. Loop until verified.

**Contoh:**
```
❌ BAD: "Make it work" (vague)
✅ GOOD: "curl /api/login returns JWT token" (specific, testable)
```

---

## 📁 Struktur Files

```
Prodige workflow/
├── .ai/
│   ├── skills/
│   │   └── karpathy-behavioral.md       ← 🆕 Behavioral guidelines
│   ├── agents/
│   │   ├── architect.md                 ← ✨ Enhanced
│   │   ├── backend.md                   ← ✨ Enhanced
│   │   ├── frontend.md                  ← ✨ Enhanced
│   │   ├── qa.md                        ← ✨ Enhanced
│   │   ├── reviewer.md                  ← ✨ Enhanced (enforcement)
│   │   ├── docs.md                      ← ✨ Enhanced
│   │   └── orchestrator.md              ← ✨ Enhanced (auto-enforcement)
│   ├── commands/
│   │   └── roastme.md                   ← 🆕 Self-critique command
│   ├── checklists/
│   │   ├── pre-design.md                ← ✨ Behavioral gates added
│   │   ├── pre-build.md                 ← ✨ Behavioral gates added
│   │   └── pre-merge.md                 ← ✨ Behavioral gates added
│   ├── examples/
│   │   └── anti-patterns.md             ← 🆕 Real examples of mistakes
│   ├── docs/
│   │   └── VIBE_CODER_GUIDE.md          ← 🆕 Beginner guide (ID)
│   ├── boot/
│   │   └── BOOT.md                      ← ✨ Karpathy skill loading
│   ├── governance/
│   │   ├── rules.md                     ← ✨ Behavioral rules added
│   │   └── quality-gates.md             ← ✨ Enhanced
│   └── context/
│       └── manifest.json                ← ✨ Behavioral tracking
├── AUDIT_KARPATHY_TO_PRODIGE.md         ← 📊 Full audit report
├── IMPLEMENTATION_GUIDE.md              ← 📖 Implementation steps
├── IMPLEMENTATION_COMPLETE.md           ← ✅ Completion summary
└── README_KARPATHY_INTEGRATION.md       ← 📄 This file
```

**Legend:**
- 🆕 = New file created
- ✨ = Existing file enhanced
- 📊 = Audit/analysis document
- 📖 = Guide/documentation
- ✅ = Status document

---

## 🔍 Cara Kerja

### Workflow Integration

```
┌────────────────────────────────────────────────────────┐
│               PRODIGE WORKFLOW                         │
│                                                        │
│  Stage 1: /init                                        │
│    ↓                                                   │
│    Load Karpathy skill (BOOT.md)                      │
│    Ask clarifying questions                           │
│    Mark unknowns explicitly                           │
│                                                        │
│  Stage 2: /design                                      │
│    ↓                                                   │
│    Surface assumptions                                │
│    Present multiple options                           │
│    Choose simplest approach                           │
│    Run /roastme design ← AUTO                         │
│                                                        │
│  Stage 3: /build                                       │
│    ↓                                                   │
│    Load existing code first                           │
│    Surgical changes only                              │
│    Verify each step                                   │
│    Run /roastme build ← AUTO                          │
│                                                        │
│  Stage 4: /review & /merge                            │
│    ↓                                                   │
│    Reviewer enforces Karpathy principles              │
│    Check: overcomplication, scope creep, surgical     │
│    Block merge if violations found                    │
│                                                        │
│  ✅ Production-ready code                             │
└────────────────────────────────────────────────────────┘
```

### Enforcement Layers

**Layer 1: Agent Behavior (Automatic)**
- BOOT.md loads Karpathy skill for ALL agents
- Agents follow behavioral rules automatically
- Agents ask questions before coding

**Layer 2: Orchestrator (Automatic)**
- Auto-runs `/roastme` after design and build
- Enforces quality gates
- Blocks merge if violations found

**Layer 3: Reviewer (Manual + Automatic)**
- Enforces Karpathy principles in code review
- Checks git diffs for surgical precision
- Provides review comment templates

**Layer 4: Human (HITL Gates)**
- Approves design after RoastMe passes
- Approves build after verification completed
- Final merge decision

---

## 📊 Metrics & Tracking

### Automatic Tracking in manifest.json

```json
{
  "behavioral_compliance": {
    "karpathy_enabled": true,
    "last_roastme_design": "2026-06-17T10:30:00Z",
    "last_roastme_build": "2026-06-17T11:45:00Z",
    "simplicity_violations": 2,
    "assumption_clarity_score": 0.90,
    "surgical_precision_score": 0.95,
    "goal_verification_score": 0.88
  }
}
```

### Success Metrics

**Target Improvements:**
- ✅ 30-50% reduction in code complexity (LoC ratio)
- ✅ 70% reduction in scope creep incidents
- ✅ 90% of ambiguities clarified upfront
- ✅ 80%+ surgical precision score
- ✅ Faster code reviews (cleaner diffs)

---

## 📚 Documentation

### For Beginners
- **[Vibe Coder Guide](.ai/docs/VIBE_CODER_GUIDE.md)** - Panduan lengkap (Bahasa Indonesia)
- **[Anti-Patterns](.ai/examples/anti-patterns.md)** - Contoh kesalahan umum AI

### For Developers
- **[Implementation Guide](../IMPLEMENTATION_GUIDE.md)** - Step-by-step implementation
- **[Audit Report](../AUDIT_KARPATHY_TO_PRODIGE.md)** - Strategic analysis
- **[Karpathy Skill](.ai/skills/karpathy-behavioral.md)** - Full behavioral guidelines

### For Architects
- **[Agent Definitions](.ai/agents/)** - Enhanced agent specs
- **[Quality Gates](.ai/governance/quality-gates.md)** - Quality criteria
- **[RoastMe Command](.ai/commands/roastme.md)** - Self-critique system

---

## 🎓 Examples

### Example 1: Overcomplication Detected

```bash
$ /roastme design

## RoastMe Report - Design

🚨 Overcomplication Found: 3 issues

1. Architecture: Microservices for 50 users
   - Current: 6 services
   - Simpler: Monolith
   - Reduction: 2000 lines → 500 lines

2. Event sourcing for simple CRUD
   - Not needed for requirements
   - Use standard database queries

3. Custom OAuth server
   - Use JWT or sessions instead
   - Reduction: 800 lines → 100 lines

Verdict: MAJOR REVISION REQUIRED
Estimated fix time: 4 hours
```

---

### Example 2: Surgical Violation Caught

```bash
$ /roastme build

## RoastMe Report - Build

🚨 Non-Surgical Changes: 4 issues

1. routes/register.js modified
   - Not in task ("add login endpoint")
   - Action: Revert

2. utils/validation.js reformatted
   - Style changes not related to task
   - Action: Revert

3. middleware/logger.js added
   - Feature not requested
   - Action: Remove or separate PR

Verdict: NEEDS REVISION
Estimated fix time: 30 minutes
```

---

## ✅ Checklist: Apakah Implementasi Bekerja?

Tanda-tanda Karpathy integration berhasil:

- [ ] AI bertanya 2-5 questions sebelum mulai coding
- [ ] AI present multiple options dengan tradeoffs
- [ ] AI pilih approach paling simple
- [ ] `/roastme` command berfungsi
- [ ] Git diffs bersih (hanya file task-related)
- [ ] Tidak ada "surprise features" yang tidak diminta
- [ ] Success criteria specific dan verifiable
- [ ] Code lebih simple dari sebelumnya

Jika semua ✅, implementasi sukses!

---

## 🔧 Troubleshooting

### Problem: AI tidak bertanya, langsung coding

**Diagnosis:** BOOT.md tidak load Karpathy skill

**Fix:**
```bash
# Check BOOT.md contains:
5. Load behavioral skills (MANDATORY):
   - .ai/skills/karpathy-behavioral.md
```

---

### Problem: AI masih bikin code complex

**Diagnosis:** RoastMe not running automatically

**Fix:**
```bash
# Manually run after design/build
/roastme design
/roastme build

# Check orchestrator.md has auto-run enabled
```

---

### Problem: Git diff masih ada unrelated changes

**Diagnosis:** Pre-merge checklist not enforced

**Fix:**
- Use pre-merge.md checklist manually
- Check surgical precision section
- Reject PR if violations found

---

## 📈 Roadmap

### Completed ✅
- [x] Phase 1: Foundation (BOOT, rules, manifest)
- [x] Phase 2: All 7 agents enhanced
- [x] Phase 3: Checklists & quality gates
- [x] Phase 4: Documentation & examples

### Next Steps 🎯
- [ ] Collect metrics from real projects
- [ ] Refine thresholds based on data
- [ ] Add more anti-pattern examples
- [ ] Create video tutorials
- [ ] Build automation tools

---

## 🤝 Contributing

Menemukan bug atau punya ide improvement?

1. **Untuk Bug:** Dokumentasikan di `.ai/governance/debt/`
2. **Untuk Pattern Baru:** Tambahkan ke `.ai/examples/anti-patterns.md`
3. **Untuk Rules:** Update `.ai/governance/rules.md`
4. **Untuk Agent Behavior:** Edit `.ai/agents/[agent-name].md`

---

## 📄 License

**Prodige Workflow:** Original license
**Karpathy Guidelines:** MIT License
**This Integration:** MIT License

---

## 🙏 Credits

**Based on:**
- **Prodige Workflow** - Structural governance framework
- **Andrej Karpathy's Observations** - Behavioral coding principles
- **Kiro AI** - Integration and implementation

**Philosophy:**
> "Governance keeps speed from chaos."  
> "Good code solves today's problem simply, not tomorrow's prematurely."

---

## 📞 Support

**Questions?**
- Read: [Vibe Coder Guide](.ai/docs/VIBE_CODER_GUIDE.md)
- Check: [Anti-Patterns](.ai/examples/anti-patterns.md)
- Review: [Implementation Complete](./IMPLEMENTATION_COMPLETE.md)

**Issues?**
- Run: `/roastme` to self-diagnose
- Check: `.ai/governance/rules.md` for behavioral rules
- Review: `.ai/checklists/` for gate criteria

---

**Version:** 1.0  
**Status:** ✅ Production Ready  
**Last Updated:** June 17, 2026

---

**🚀 Selamat menggunakan Prodige + Karpathy Workflow!**

*Bangun aplikasi berkualitas tinggi dengan mudah, efektif, dan efisien.*

---

## Quick Links

- 📖 [Vibe Coder Guide (ID)](.ai/docs/VIBE_CODER_GUIDE.md)
- 🔍 [Anti-Pattern Library](.ai/examples/anti-patterns.md)
- 📊 [Full Audit Report](../AUDIT_KARPATHY_TO_PRODIGE.md)
- 📝 [Implementation Guide](../IMPLEMENTATION_GUIDE.md)
- ✅ [Implementation Status](./IMPLEMENTATION_COMPLETE.md)
- 🎯 [Karpathy Skill](.ai/skills/karpathy-behavioral.md)
- 🔧 [RoastMe Command](.ai/commands/roastme.md)
