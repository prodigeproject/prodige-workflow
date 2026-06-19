# Panduan untuk Vibe Coders Pemula

## Selamat Datang! 🎉

Anda tidak perlu jadi expert untuk membuat aplikasi berkualitas dengan **Prodige Workflow**.

Workflow ini akan:
- ✅ Memandu Anda step-by-step dari ide ke production
- ✅ Mencegah AI membuat code yang terlalu complex
- ✅ Memastikan code yang dihasilkan simple dan maintainable
- ✅ Meminta AI bertanya jika sesuatu tidak jelas (tidak asal nebak)

---

## 5 Menit Quick Start

### 1. Mulai Project Baru

```bash
/init from idea: "Aplikasi todo list dengan authentication"
```

**AI akan:**
- Membuat struktur project
- Bertanya tentang hal-hal yang tidak jelas
- TIDAK akan langsung coding

**Contoh pertanyaan AI:**
```
Before creating project structure, I need clarification:

1. User scale: Single user or multi-user?
2. Authentication: Simple login or social auth (Google/GitHub)?
3. Database: SQLite (simple) or PostgreSQL (scalable)?
4. Frontend: Web app, mobile, or both?

My recommendation: Single user + simple login + SQLite + web app
(can upgrade later if needed)

Agree?
```

**Anda:** Jawab pertanyaannya, atau ketik "yes" kalau setuju dengan rekomendasi AI.

---

### 2. Design Phase

```bash
/design
```

**AI akan:**
- Membuat PRD (Product Requirements Document)
- Membuat Architecture diagram
- Membuat Implementation plan
- Bertanya tentang tradeoffs (pilihan trade-off)

**Contoh output:**
```
## Architecture Options

**Option A: Simple (Recommended)**
- Monolith app (single codebase)
- SQLite database
- Session-based auth
- Pros: Fast to build (1 week), easy to understand
- Cons: Need refactoring if >1000 users

**Option B: Scalable**
- Microservices architecture
- PostgreSQL + Redis
- JWT authentication
- Pros: Scales to millions
- Cons: 3x development time, complex to debug

Recommendation: Start with Option A. Refactor to B only if you hit 1000 users.

Agree?
```

**Anda:** Review dan approve. Jika ada yang tidak jelas, tanya!

---

### 3. Self-Critique (RoastMe)

```bash
/roastme design
```

**AI akan self-critique:**
- Apakah design terlalu complex?
- Apakah ada assumptions yang tidak ditanya?
- Apakah ada fitur yang tidak diminta?

**Contoh output:**
```
## RoastMe Report - Design

✅ Good Practices:
- Asked clarifying questions before designing
- Presented multiple options with tradeoffs
- Chose simplest architecture

🚨 Issues Found: 1

1. Architecture includes "analytics service" not mentioned in requirements
   - Action: Remove analytics, add only if requested later

Verdict: APPROVED with minor revision
```

---

### 4. Build Phase

```bash
/build
```

**AI akan:**
- Implement sesuai design yang sudah diapprove
- Membuat code yang simple (tidak over-engineered)
- Hanya mengubah file yang relevan
- Verify setiap step dengan tests

**Contoh progress:**
```
Plan for todo app:

1. Create database schema
   → Verify: SQLite file created, tables exist

2. Add POST /todos endpoint
   → Verify: curl -X POST /todos returns 201

3. Add GET /todos endpoint
   → Verify: curl /todos returns todo list

4. Add user authentication
   → Verify: Login works, protected endpoints check auth

5. Add frontend UI
   → Verify: Navigate to / shows todo list

Proceeding with Step 1...

✓ Step 1 complete: Database created
✓ Step 2 complete: POST endpoint works
...
```

**Anda:** Tunggu sampai selesai, atau monitor progress.

---

### 5. Review & Merge

```bash
/roastme build
```

**AI self-critique implementation:**
```
## RoastMe Report - Build

📊 Metrics:
- Lines of code: 487 (estimated: 500) ✅
- Files changed: 8 (all related to task) ✅
- Abstractions: 2 (both used 2+ times) ✅
- Success criteria: All verified ✅

✅ All checks passed!

Verdict: APPROVED - Ready to merge
```

```bash
/release
```

**Jika semua checks pass, code ready untuk production!**

---

## Yang Membuat Workflow Ini Berbeda

### 1. AI Akan Bertanya, Tidak Nebak

**❌ AI Biasa:**
```
User: "Add authentication"
AI: *langsung implement JWT + Redis + OAuth + 2FA*
```

**✅ Prodige:**
```
User: "Add authentication"

AI: "Before implementing, I need clarification:

1. Auth method:
   - Simple login (username + password) → 50 lines
   - Social auth (Google/GitHub) → 200 lines
   - JWT tokens for API → 100 lines

2. Requirements:
   - Password rules (min length)?
   - "Remember me" functionality?
   - Email verification needed?

My recommendation: Simple login unless you need mobile app or API.

Which approach?"
```

**Benefit untuk Anda:** Tidak ada surprises. Anda tahu persis apa yang akan dibangun.

---

### 2. AI Akan Bikin Code Simple, Bukan Complex

**❌ AI Biasa:**
```python
# 300 lines dengan Strategy pattern, Factory, Abstract classes
# untuk fitur yang bisa 50 lines

class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, amount: float) -> float:
        pass

class PercentageDiscount(DiscountStrategy):
    # ... 100 lines of boilerplate
```

**✅ Prodige:**
```python
# 10 lines, simple function

def calculate_discount(amount: float, percent: float) -> float:
    """Calculate percentage discount."""
    return amount * (percent / 100)

# If you need more discount types LATER, refactor then.
# Not now.
```

**Benefit untuk Anda:** Code lebih mudah dibaca dan di-maintain.

---

### 3. AI Hanya Ubah Yang Diminta

**❌ AI Biasa:**
- Fix bug di login.py
- *Sekalian refactor register.py* (tidak diminta)
- *Sekalian ubah quote style* (tidak diminta)
- *Sekalian tambah type hints* (tidak diminta)

**✅ Prodige:**
- Fix bug di login.py
- Done. (Cuma itu.)

**Benefit untuk Anda:** Git diffs bersih, easy to review, tidak ada surprises.

---

## Common Questions

### Q: "Saya tidak ngerti coding, bisa pakai ini?"

**A: Ya!** Workflow ini specifically designed untuk non-expert.

AI akan:
- Explain tradeoffs in plain language
- Ask you questions to clarify requirements
- Create simple code (easier to understand)
- Show you exactly what it's doing at each step

Anda hanya perlu:
- Jawab pertanyaan AI (pilih option A atau B)
- Review high-level design (not code details)
- Approve when ready

---

### Q: "Apakah workflow ini memperlambat development?"

**A: Short term:** Sedikit lebih lambat (karena AI bertanya dulu, tidak langsung coding)

**Long term:** JAUH lebih cepat karena:
- Tidak perlu rework code yang overcomplex
- Tidak perlu fix bugs dari assumptions yang salah
- Tidak perlu refactor code yang bloated
- Code simple = easier to extend later

**Real example:**
- AI biasa: 2 hari coding + 3 hari debugging + 2 hari refactoring = **7 hari**
- Prodige: 1 hari planning + 3 hari coding clean = **4 hari**

---

### Q: "Bagaimana jika AI salah?"

**A:** Workflow ini punya multiple checkpoints:

1. **Pre-design checklist** (before coding starts)
2. **Pre-build checklist** (before implementing)
3. **RoastMe self-critique** (AI checks its own work)
4. **Pre-merge checklist** (before deploying)

Mistakes akan ketahuan di salah satu checkpoint, tidak sampai production.

---

### Q: "Bisa customize workflow?"

**A: Ya!** Semua rules ada di `.ai/` folder.

Edit sesuai kebutuhan:
- `.ai/governance/rules.md` - Atur behavioral rules
- `.ai/checklists/` - Customize quality gates
- `.ai/agents/` - Modify agent behavior

---

## Workflow Diagram (Visual)

```
┌─────────────────────────────────────────────────────────┐
│  YOU: "Saya mau bikin todo app dengan authentication"  │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
         ┌───────────────┐
         │   /init       │  ← AI bertanya: Single/multi user?
         │               │                  Database choice?
         └───────┬───────┘                  Auth method?
                 │
                 ▼
         YOU: Jawab pertanyaan AI
                 │
                 ▼
         ┌───────────────┐
         │   /design     │  ← AI bikin PRD + Architecture
         │               │    AI present options with tradeoffs
         └───────┬───────┘    AI recommend simplest approach
                 │
                 ▼
         ┌───────────────┐
         │ /roastme      │  ← AI self-check: "Am I overcomplicating?"
         │   design      │
         └───────┬───────┘
                 │
                 ▼
         YOU: Review & Approve design
                 │
                 ▼
         ┌───────────────┐
         │   /build      │  ← AI implement step-by-step
         │               │    AI verify each step with tests
         └───────┬───────┘    AI keep code simple
                 │
                 ▼
         ┌───────────────┐
         │ /roastme      │  ← AI self-check: "Did I add scope creep?"
         │   build       │                  "Is code too complex?"
         └───────┬───────┘
                 │
                 ▼
         ┌───────────────┐
         │   /release    │  ← Final checks, tests, deploy!
         └───────────────┘

                 ▼
         
         🎉 App is LIVE!
```

---

## Tips untuk Sukses

### Tip 1: Jangan Takut Bertanya

Jika AI menjelaskan sesuatu dan Anda tidak ngerti, **TANYA!**

**Contoh:**
```
AI: "I recommend microservices architecture with event-driven patterns..."

YOU: "Explain in simple terms. What's microservices? Why do I need it?"

AI: "Microservices means splitting your app into smaller pieces. 
     For your use case (50 users), you DON'T need it. 
     Simple single app is better. Sorry for overcomplicating!"
```

---

### Tip 2: Selalu Review RoastMe Report

Setelah `/roastme`, baca reportnya:

```
🚨 Overcomplication detected: Using Redis for 10 users
   → Action: Remove Redis, use in-memory cache
```

Jika Anda lihat "overcomplication", itu good sign - AI catching its own mistakes!

---

### Tip 3: Start Small

Jangan langsung bikin app besar. Start dengan:

1. **Week 1:** Basic CRUD (Create, Read, Update, Delete)
2. **Week 2:** Add authentication
3. **Week 3:** Add features one by one

Slow and steady > fast and broken.

---

### Tip 4: Trust the Process

Workflow ini might feel slow at first (banyak questions, checklists).

**This is GOOD!**

Questions = AI understanding requirements correctly
Checklists = Catching mistakes early

After 2-3 iterations, you'll appreciate the quality of code produced.

---

## Next Steps

**Ready to start?**

1. **Try Tutorial:** [Usage Guide](../../docs/USAGE.md)
2. **Read Examples:** [Anti-Patterns to Avoid](../examples/anti-patterns.md)
3. **Understand Workflow:** [Compatibility & Commands](../../docs/COMPATIBILITY.md)

**Need Help?**

- 📖 Read: `.ai/examples/anti-patterns.md` (common mistakes)
- 🎯 Check: `.ai/governance/rules.md` (what AI should do)
- ❓ Ask: Use `/status` command to see where you are

---

## Success Stories

### Example 1: Todo App (Beginner)

**User:** Never coded before
**Timeline:** 2 weeks
**Result:** Production-ready todo app with auth, deployed to Vercel

**Quote:**
> "I was scared at first, but AI walked me through everything. 
> When I didn't understand something, I just asked. The app works perfectly!"

---

### Example 2: E-commerce MVP (Intermediate)

**User:** Junior developer
**Timeline:** 4 weeks
**Result:** Full e-commerce with products, cart, checkout, Stripe integration

**Quote:**
> "The workflow prevented me from overengineering. AI wanted to add 
> microservices, but RoastMe caught it. We went simple monolith instead. 
> Saved 2 weeks of work!"

---

### Example 3: SaaS Platform (Advanced)

**User:** Senior developer
**Timeline:** 8 weeks
**Result:** Multi-tenant SaaS with auth, billing, admin panel

**Quote:**
> "Even as a senior dev, the behavioral checks caught my bad habits. 
> I was adding abstractions I didn't need. The final code is SO much cleaner 
> than what I usually write."

---

## Remember

**The goal:** High-quality apps with minimal frustration.

**The workflow:** Guides both you and AI to success.

**The outcome:** Code you understand, can maintain, and can be proud of.

---

**Selamat coding! 🚀**

You got this. The workflow has your back.
