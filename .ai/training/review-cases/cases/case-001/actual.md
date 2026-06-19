# Code Review: Login endpoint

Reviewer Agent output captured for calibration. Format mirrors a real `/review`
report so `calibrate-reviewer.js` can parse it (severity headings + Issue/Location).

## Critical

**Issue:** SQL injection - the login query interpolates the username directly into a SELECT
**Location:** `src/auth/login.js:24`

## Important

**Issue:** Scope creep - this change also refactors the password reset flow, which was not requested by the task
**Location:** `src/auth/reset.js:5`

---
_Verdict: rejected - fix the injection before merge._
