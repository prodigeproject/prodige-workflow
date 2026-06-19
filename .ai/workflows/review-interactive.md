# Workflow: Interactive Review (Dialogue Mode)

## Purpose
For complex PRs where the reviewer needs to understand *intent* before judging, this
workflow opens a structured back-and-forth between the Reviewer Agent and the
implementing agent — instead of guessing and producing wrong findings.

**Core principle:** Ask before flagging. A clarification is cheaper than a wrong
Critical that triggers needless rework.

---

## When to Use

Use interactive mode (not the default async review) when:
- The PR contains non-obvious logic the reviewer can't fully trace
- The change spans multiple subsystems with unclear coupling
- The reviewer's first pass produced **"unclear"** rather than pass/fail on key items
- Explicitly requested: `/review --interactive`

Do **not** use it for simple/small PRs — it adds turns for no benefit.

---

## Steps

### 1. Pre-Review Gate
Run the automated gate (`pre-review-check`) as usual. Interactive mode is about
*understanding*, not skipping checks.

### 2. First Pass → Identify Unclear Areas
The Reviewer Agent does a normal first pass but, instead of guessing on anything
ambiguous, collects **clarification questions**:

```markdown
## Clarification Needed (3 items)
1. src/payment/processor.js:45-78 — Refund logic branches on `splitCount`. What is
   the intended behavior for 3+ split payments? Spec only mentions 2.
2. src/payment/processor.js:92 — Is the retry meant to be idempotent? I don't see a
   dedupe key.
3. Why is `legacyRefund()` still called at line 120 — backward-compat or oversight?
```

### 3. Dialogue (bounded)
The implementing agent answers each question with **evidence** (spec line, decision
record, code, test). Cap at a small number of rounds (default 2) to avoid loops —
if still unclear after 2 rounds, the item becomes a finding ("intent undocumented").

```markdown
## Implementer Responses
1. 3+ splits: refund proportionally to each source. (Spec PRD.md §4.2, added yesterday.)
2. Retry idempotent via `paymentIntentId` as dedupe key (line 88). Will add a comment.
3. `legacyRefund()` is backward-compat for pre-2024 orders. DECISIONS.md #31.
```

### 4. Resolve to Findings
With intent understood, each item resolves to one of:
- **No issue** (intent was sound, maybe suggest a clarifying comment → Minor)
- **Finding** (intent is wrong, or undocumented after 2 rounds → Important/Critical)

### 5. Standard Verdict
Produce the normal review report (using the change-type template), with a
**Dialogue Summary** section appended so the reasoning is auditable.

---

## Anti-Loop Rules

- **Max 2 dialogue rounds per item.** Unresolved after that → finding, not infinite Q&A.
- **Questions must be specific** (file:line + concrete ambiguity), never "explain this file".
- **Implementer answers with evidence**, not assertion. "It works" is not an answer;
  a passing test or spec line is.
- The Reviewer must not use the dialogue to *negotiate down* a real Critical. Intent
  doesn't make SQL injection safe.

## Report Addendum Format

```markdown
## Dialogue Summary
| # | Location | Question | Resolution |
|---|----------|----------|------------|
| 1 | processor.js:45 | 3+ split refund behavior? | No issue — matches PRD §4.2 |
| 2 | processor.js:92 | Idempotent retry? | Minor — add dedupe-key comment |
| 3 | processor.js:120 | legacyRefund still used? | No issue — DECISIONS.md #31 |

**Rounds used:** 1
**Net effect:** 0 Critical, 0 Important, 1 Minor (comment)
```

## Integration

- **Command:** `/review --interactive`
- **Builds on:** `.ai/workflows/review.md` (same gates, templates, severity)
- **Skill alignment:** mirrors `receiving-code-review` ("verify before implementing"),
  applied in the *asking* direction
- **Falls back to:** standard async review when no clarifications are needed
