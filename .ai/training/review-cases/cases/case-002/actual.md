# Code Review: Signup form

Reviewer Agent output captured for calibration. This case intentionally shows an
imperfect reviewer: it catches the validation gap, MISSES the accessibility issue
(false negative), and raises a magic-number flag on a self-documenting constant
(false positive against must_not_flag) - so the suite reports < 100% detection.

## Important

**Issue:** Missing input validation on the email field before the form submits
**Location:** `src/ui/SignupForm.jsx:41`

## Minor

**Issue:** Magic number used for the retry count
**Location:** `src/ui/SignupForm.jsx:12`

---
_Verdict: approved with changes._
