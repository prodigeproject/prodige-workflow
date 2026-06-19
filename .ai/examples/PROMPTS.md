# Example Prompts

Koleksi contoh prompts untuk berbagai scenarios dalam Prodige Workflow.

---

## 1. Project Initialization

### Start dari Idea
```text
/init from idea: Build a simple CRM for small agencies
```
**Kapan digunakan:** Memulai project baru dari high-level concept

### Start dari Existing Codebase
```text
/init from codebase
```
**Kapan digunakan:** Adopt Prodige workflow untuk existing project

---

## 2. Design Phase

### Design New Module
```text
/design contact management module
```
**Output:** Architecture diagram, data models, API contracts

### Design with Context
```text
/design payment processing module with Stripe integration
```
**Kapan digunakan:** Saat perlu specific technology atau constraints

### Review Existing Design
```text
/audit design for user authentication module
```
**Kapan digunakan:** Verify design quality sebelum implementation

---

## 3. Implementation Phase

### Single Agent Build
```text
/build approved contact management module
```
**Kapan digunakan:** Feature kecil yang bisa dikerjakan satu agent

### Build with Specific Agent
```text
/agent backend build user authentication API
```
**Kapan digunakan:** Task specific untuk backend, frontend, etc.

### Parallel Build (Multi-Agent)
```text
/parallel build dashboard
```
**Kapan digunakan:** Feature kompleks yang perlu backend + frontend + tests + docs

---

## 4. Quality Assurance

### Run Tests
```text
/agent qa verify checkout flow
```
**Output:** Test results, coverage report, issues found

### Audit Code Quality
```text
/audit security for payment module
```
**Kapan digunakan:** Pre-deployment verification

---

## 5. Documentation

### Generate Docs
```text
/agent docs generate API documentation
```
**Output:** API reference, usage examples, deployment guides

### Update Existing Docs
```text
/agent docs update README with new authentication flow
```
**Kapan digunakan:** After major feature changes

---

## 6. Sync & Recovery

### Sync State
```text
/sync
```
**Kapan digunakan:** 
- Setelah manual file changes
- Before starting new task
- Recovery dari interrupted session

### Resume Work
```text
/session-start
```
**Kapan digunakan:** Continue dari previous session

---

## 7. Collaboration Commands

### Delegate to an Agent
```text
/agent backend Implement user authentication endpoints
```
**Kapan digunakan:** Delegate task ke specific agent

### Review Request
```text
/agent reviewer check payment integration
```
**Kapan digunakan:** Need peer review before merge

---

## 8. Advanced Workflows

### Multi-Phase Build
```text
/parallel build e-commerce-platform
```
Kemudian di worker windows:
```text
/agent backend resume e-commerce-platform-backend
/agent frontend resume e-commerce-platform-frontend
/agent qa resume e-commerce-platform-qa
```

### Emergency Rollback
```text
/rollback to snapshot-20240115-1430
```
**Kapan digunakan:** Critical bug found setelah merge

---

## Tips Menulis Prompts yang Efektif

1. **Be Specific**: Jelaskan context dan requirements dengan jelas
2. **Include Constraints**: Mention technology stack, performance requirements, etc.
3. **State Expected Output**: Apa yang ingin dihasilkan
4. **Reference Prior Work**: Link ke design docs atau related modules
5. **Use Natural Language**: Tidak perlu format khusus, tulis seperti bicara ke developer lain

### Contoh Good vs Bad Prompts

❌ **Bad:**
```text
/build login
```

✅ **Good:**
```text
/build user authentication module with JWT tokens, email/password login, password reset flow, and session management
```

❌ **Bad:**
```text
/design database
```

✅ **Good:**
```text
/design database schema for e-commerce platform including users, products, orders, and inventory tracking with PostgreSQL
```
