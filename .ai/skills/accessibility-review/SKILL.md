---
name: accessibility-review
description: Use when reviewing or building UI components - ensures keyboard, screen-reader, and visual accessibility (WCAG 2.1 AA) so a11y is built in, not retrofitted.
auto_load: ["/review"]
applies_to: [reviewer, frontend, qa]
mandatory_when: ["UI components", "forms", "interactive elements", "navigation", "modals/dialogs"]
---

# Accessibility (A11y) Review

Accessibility is far cheaper to build in than to retrofit. This skill enforces a
WCAG 2.1 AA baseline at review time for any UI change.

> **Honesty note:** Full WCAG compliance requires manual testing with real assistive
> technology and expert review. This skill catches the common, mechanically- and
> visually-detectable violations — it does not certify full compliance.

## Prodige Severity Alignment

| Condition | Severity |
|-----------|----------|
| Feature unusable without a mouse; content invisible to screen readers; form with no labels | 🚫 **Critical** |
| Missing focus management, low contrast, missing alt text, improper ARIA | ⚠️ **Important** |
| Minor semantic improvements, nice-to-have enhancements | 💡 **Minor** |

## When to Use

- New or changed UI components
- Forms and inputs
- Interactive elements (buttons, menus, tabs, modals)
- Navigation and routing changes
- Anything with dynamic/async content updates

## Review Checklist (WCAG 2.1 AA baseline)

### 1. Keyboard operability (Critical gate)
- [ ] All interactive elements reachable and operable by keyboard (Tab/Enter/Space/Esc/arrows)
- [ ] Logical tab order; no keyboard traps
- [ ] Visible focus indicator on every focusable element
- [ ] 🚫 Critical if any core action is mouse-only

### 2. Semantic HTML
- [ ] Native elements used (`<button>`, `<a>`, `<nav>`, `<main>`) over `<div onClick>`
- [ ] One `<h1>`, logical heading hierarchy (no skipped levels)
- [ ] Lists use `<ul>/<ol>`, tables use `<th>` with scope
- [ ] ⚠️ Important: clickable `<div>`/`<span>` with no role/keyboard handling

### 3. Screen-reader support
- [ ] All images have meaningful `alt` (or `alt=""` if decorative)
- [ ] Icon-only buttons have `aria-label`
- [ ] Form inputs have associated `<label>` (or `aria-label`/`aria-labelledby`)
- [ ] Dynamic updates announced via `aria-live` where relevant
- [ ] 🚫 Critical: form fields with no programmatic label

### 4. ARIA (only when native won't do)
- [ ] ARIA roles/states valid and not contradicting native semantics
- [ ] `aria-expanded`/`aria-selected`/`aria-checked` reflect actual state
- [ ] No `role` that duplicates a native element's implicit role
- [ ] ⚠️ Important: incorrect/again-misused ARIA (worse than none)

### 5. Focus management
- [ ] Opening a modal moves focus into it; closing returns focus to trigger
- [ ] Focus trapped within open modal/dialog
- [ ] Route changes move focus to a sensible landmark/heading
- [ ] ⚠️ Important if modal focus not handled

### 6. Visual / color
- [ ] Text contrast ≥ 4.5:1 (≥ 3:1 for large text) — WCAG AA
- [ ] Information not conveyed by color alone (icon/text too)
- [ ] UI usable at 200% zoom without loss of content/function
- [ ] Respects `prefers-reduced-motion` for animation

## Common Violations & Fixes

```jsx
// ❌ Critical: div as button — not keyboard/SR accessible
<div onClick={save}>Save</div>
// ✅
<button onClick={save}>Save</button>

// ❌ Critical: icon button with no accessible name
<button onClick={close}><XIcon /></button>
// ✅
<button onClick={close} aria-label="Close dialog"><XIcon /></button>

// ❌ Critical: input with no label
<input type="email" placeholder="Email" />
// ✅ (placeholder is NOT a label)
<label htmlFor="email">Email</label>
<input id="email" type="email" />

// ❌ Important: status update not announced
<div>{message}</div>
// ✅
<div role="status" aria-live="polite">{message}</div>

// ❌ Important: info by color only
<span style={{color:'red'}}>Failed</span>
// ✅
<span style={{color:'red'}}>❌ Failed</span>
```

## Recommended Tooling (suggest in review, not a substitute for judgment)

- **axe-core / @axe-core/react** — automated rule scan in dev
- **eslint-plugin-jsx-a11y** — catches many issues at lint time
- **Lighthouse** accessibility audit — CI-friendly score
- **Manual:** Tab through the whole flow with no mouse; test with a screen reader
  (NVDA/VoiceOver) for anything Critical.

## Output Format

```
### Accessibility: {Title}
**Severity:** {Critical/Important/Minor}
**WCAG:** {e.g. 1.4.3 Contrast, 2.1.1 Keyboard, 4.1.2 Name/Role/Value}
**Location:** {file:line}
**Problem:** {who is excluded and how}
**Fix:** {concrete change}
```

## Integration

- **Auto-loaded:** `/review` (frontend changes)
- **Feeds:** Feature review template for UI work
- **Works with:** `clean-code`, `documentation`
- **Recommend adding:** `eslint-plugin-jsx-a11y` to the project for shift-left detection
