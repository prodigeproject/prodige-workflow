# Multi-Window Agent Guide

This guide is for using many AI coding windows at the same time.

## Why multi-window?

One AI window is good for focus.
Many AI windows are good for speed.

But parallel AI work can create chaos if not coordinated.

This OS prevents that using:
- sessions
- snapshots
- locks
- handoffs
- cache
- review gates

---

## Simple mode for non-technical users

Use only this:

```text
/parallel build dashboard
```

The AI should output something like:

```text
Open 4 windows:

Window A:
Role: Backend Agent
Prompt: /agent backend resume session dashboard-backend

Window B:
Role: Frontend Agent
Prompt: /agent frontend resume session dashboard-frontend

Window C:
Role: QA Agent
Prompt: /agent qa resume session dashboard-qa

Window D:
Role: Review Agent
Prompt: /agent reviewer resume session dashboard-review
```

You copy each prompt into a new AI coding window.

---

## Multi-window lifecycle

```text
1. Main window creates plan
2. Main window creates snapshot
3. Main window creates sessions
4. Each worker window reads its session file
5. Each worker updates handoff file
6. Reviewer window reviews all handoffs
7. Main window merges and syncs context
```

---

## Important rules

### Rule 1: Same snapshot

Every window must use the same snapshot.

Example:

```text
snapshot: context-v12
```

### Rule 2: No silent architecture change

Worker agents cannot change architecture without approval.

### Rule 3: No overlapping files without lock

If two agents edit the same files, one must wait.

### Rule 4: Every worker writes handoff

Each worker must write:

```text
.ai/runtime/handoffs/[session-name].md
```

### Rule 5: Reviewer merges

Do not blindly merge all agent output.

---

## Example: Building checkout with 5 windows

Main window:

```text
/parallel build checkout
```

AI creates:

```text
.ai/runtime/snapshots/context-v12/
.ai/runtime/sessions/checkout-backend.json
.ai/runtime/sessions/checkout-frontend.json
.ai/runtime/sessions/checkout-qa.json
.ai/runtime/sessions/checkout-docs.json
.ai/runtime/sessions/checkout-review.json
```

Then open windows:

### Window 1 Backend

```text
/agent backend resume checkout-backend
```

### Window 2 Frontend

```text
/agent frontend resume checkout-frontend
```

### Window 3 QA

```text
/agent qa resume checkout-qa
```

### Window 4 Docs

```text
/agent docs resume checkout-docs
```

### Window 5 Review

```text
/agent reviewer resume checkout-review
```

Final main window:

```text
/parallel merge checkout
```

---

## Conflict handling

If conflicts happen:

```text
/parallel resolve checkout
```

AI should:
- inspect handoffs
- inspect changed files
- identify overlapping edits
- decide merge order
- ask human approval if architecture or product behavior changes
