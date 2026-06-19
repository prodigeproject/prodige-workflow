---
name: test-planning
description: "Identifies comprehensive test cases, regression scenarios, and edge cases to ensure thorough test coverage and prevent bugs."
---

# Test Planning

Design comprehensive test strategies by identifying test cases, regression scenarios, and edge cases before implementation.

## Quick Protocol (your next action)
1. Understand the requirements and acceptance criteria for what needs testing.
2. List happy-path cases, then edge/boundary cases, then negative/error cases.
3. Add regression tests for existing features the change could affect.
4. Organize by layer (unit/integration/E2E) and prioritize by risk (Critical/Important/Nice).
5. Specify test data needs. Think adversarially: how would you break this?

## Purpose

Ensure thorough testing by:
- Identifying all test cases that need coverage
- Planning regression tests for existing functionality
- Discovering edge cases and boundary conditions
- Defining test data and scenarios
- Organizing tests by type and priority

## When to Use

This skill is automatically selected by the orchestrator when:
- Planning implementation for new features
- Designing test strategy for complex functionality
- Reviewing test coverage for existing code
- User explicitly requests test planning
- Before implementing TDD workflow

## Process

### 1. Understand Requirements
Analyze what needs testing:
- Feature requirements and acceptance criteria
- User workflows and use cases
- Business rules and constraints
- Integration points with other systems
- Non-functional requirements (performance, security)

### 2. Identify Test Cases
Determine positive (happy path) test cases:
- **Normal operation:** Feature works as expected
- **Common workflows:** Typical user paths
- **Valid inputs:** Correct data produces correct output
- **Expected integrations:** Systems work together properly

### 3. Discover Edge Cases
Find boundary conditions and unusual scenarios:
- **Boundary values:** Min/max values, empty/full
- **Null/undefined:** Missing or optional data
- **Large datasets:** Performance with volume
- **Concurrent access:** Race conditions, conflicts
- **Unusual but valid:** Rare but legitimate cases

### 4. Plan Negative Tests
Test error handling and invalid inputs:
- **Invalid inputs:** Wrong data types, formats
- **Constraint violations:** Business rule violations
- **Unauthorized access:** Security boundary tests
- **System failures:** Database down, API timeout
- **User errors:** Typos, wrong actions

### 5. Regression Testing
Ensure existing functionality stays working:
- Features that interact with new code
- Related functionality that could break
- Common user workflows through changed areas
- Integration points that might be affected

### 6. Organize Test Strategy
Structure tests for clarity and maintenance:
- **Unit tests:** Individual functions and components
- **Integration tests:** Interactions between modules
- **E2E tests:** Complete user workflows
- **Performance tests:** Speed and scalability
- **Security tests:** Authentication, authorization, injection

## Output Format

**Test Cases:**
```
🧪 Unit Tests (Component Level)

formatUserName(user):
  ✓ Should format first and last name with space
  ✓ Should handle user with only first name
  ✓ Should handle user with middle name
  ✓ Should return empty string for null/undefined
  ✓ Should trim whitespace from names

validateEmail(email):
  ✓ Should accept valid email formats
  ✓ Should reject email without @
  ✓ Should reject email without domain
  ✓ Should reject email with spaces
  ✓ Should handle email with subdomains
  ✓ Should reject empty string
```

**Integration Tests:**
```
🔗 Integration Tests (Module Interaction)

User Registration Flow:
  ✓ Should create user with valid data
  ✓ Should hash password before storage
  ✓ Should send welcome email
  ✓ Should reject duplicate email
  ✓ Should validate email format
  ✓ Should enforce password requirements
  ✓ Should log registration event

API Authentication:
  ✓ Should accept valid JWT token
  ✓ Should reject expired token
  ✓ Should reject invalid signature
  ✓ Should refresh token before expiry
  ✓ Should handle missing token
```

**E2E Tests:**
```
🚀 End-to-End Tests (User Workflows)

Complete Registration Journey:
  ✓ User navigates to signup page
  ✓ User fills registration form
  ✓ User submits form
  ✓ System validates and creates account
  ✓ User receives welcome email
  ✓ User can log in with new credentials
  ✓ User sees onboarding dashboard

Purchase Flow:
  ✓ User browses products
  ✓ User adds items to cart
  ✓ User proceeds to checkout
  ✓ User enters payment information
  ✓ Payment processed successfully
  ✓ Order confirmation displayed
  ✓ Confirmation email sent
```

**Edge Cases:**
```
🎯 Edge Cases and Boundary Conditions

Input Boundaries:
  ✓ Empty string input
  ✓ Very long input (10,000 characters)
  ✓ Unicode and special characters
  ✓ SQL injection attempts in input
  ✓ XSS attempts in input

Data Boundaries:
  ✓ Zero items in list
  ✓ One item in list
  ✓ Maximum items (10,000)
  ✓ Pagination at boundaries
  ✓ Sorting with duplicate values

State Boundaries:
  ✓ First user registration (empty database)
  ✓ Concurrent user registrations
  ✓ Registration during database migration
  ✓ Registration when email service down

Time-Based Edge Cases:
  ✓ Token expires during request
  ✓ User session expires mid-action
  ✓ Midnight boundary (date changes)
  ✓ Daylight saving time transitions
```

**Error Scenarios:**
```
❌ Error Handling Tests

Network Failures:
  ✓ API timeout
  ✓ API returns 500 error
  ✓ Network disconnected mid-request
  ✓ Slow network (performance degradation)

Database Failures:
  ✓ Database connection lost
  ✓ Query timeout
  ✓ Unique constraint violation
  ✓ Foreign key constraint violation

Validation Failures:
  ✓ Invalid email format
  ✓ Password too short
  ✓ Required field missing
  ✓ Data type mismatch

Authorization Failures:
  ✓ No authentication token
  ✓ Invalid authentication token
  ✓ Insufficient permissions
  ✓ Accessing other user's resources
```

**Regression Tests:**
```
🔄 Regression Test Suite

Areas Affected by Changes:
  ✓ User login still works
  ✓ Password reset still works
  ✓ User profile update still works
  ✓ Email sending still works
  ✓ Admin user management still works

Critical Paths:
  ✓ Purchase flow end-to-end
  ✓ User onboarding flow
  ✓ Payment processing
  ✓ Data export functionality
```

**Test Data Requirements:**
```
📊 Test Data Setup

Users:
  - Valid user (standard case)
  - Admin user (elevated permissions)
  - User with no data (edge case)
  - User with maximum data (boundary)
  - Suspended user (error case)

Products:
  - In-stock product
  - Out-of-stock product
  - Discontinued product
  - Product with special characters in name
  - Product at price boundaries ($0, $999,999)

Orders:
  - Completed order
  - Pending order
  - Cancelled order
  - Refunded order
  - Partially shipped order
```

## Test Prioritization

**🔴 Critical (Must Test):**
- Security: Authentication, authorization, injection
- Data integrity: Database operations, validation
- Core workflows: Purchase, signup, critical features
- Payment processing
- Data privacy

**🟡 Important (Should Test):**
- User-facing features
- Common workflows
- Integration points
- Error handling
- Performance on key paths

**🟢 Nice to Have (Can Test):**
- Rare edge cases
- Admin-only features used infrequently
- Features with low usage
- Minor UI refinements

## Rules

- **Be comprehensive:** Cover happy path, edge cases, and errors
- **Be specific:** Each test case clearly defined
- **Be organized:** Group tests logically by type and scope
- **Be practical:** Prioritize tests by risk and likelihood
- **Be maintainable:** Design tests that are easy to update
- **Think adversarially:** How would you break this?

## Key Principles

**Test Pyramid:**
```
       /\
      /E2E\      Few comprehensive end-to-end tests
     /------\
    /Integr.\   More integration tests
   /----------\
  /   Unit     \ Many fast unit tests
 /--------------\
```

**Coverage Goals:**
- Unit tests: Fast feedback, test individual functions
- Integration tests: Test module interactions
- E2E tests: Validate complete user workflows
- Each layer has different purpose and value

**Risk-Based Testing:**
Focus on:
- High-impact features (payment, data loss)
- Frequently used features (core workflows)
- Recently changed code (regression risk)
- Complex logic (high bug probability)
- Security-sensitive code (authentication, authorization)

## Integration Points

- Works with **brainstorming** to define acceptance criteria
- Informs **implementation-planning** about testability
- Used by **test-driven-development** for TDD workflow
- Feeds **qa** agent with test execution plans

## Common Test Patterns

**Given-When-Then:**
```
Given a registered user
When the user attempts to log in with correct credentials
Then the user should be authenticated and redirected to dashboard
```

**Arrange-Act-Assert:**
```typescript
test('should format user name correctly', () => {
  // Arrange
  const user = { firstName: 'John', lastName: 'Doe' };
  
  // Act
  const result = formatUserName(user);
  
  // Assert
  expect(result).toBe('John Doe');
});
```

**Input/Output Tables:**
```
Input               | Expected Output
--------------------|------------------
"test@example.com"  | true
"invalid"           | false
"test@"             | false
""                  | false
null                | false
```

## Anti-Patterns

- ❌ **Only happy path:** Ignoring error and edge cases
- ❌ **Vague test cases:** "Test should work correctly"
- ❌ **No negative tests:** Not testing invalid inputs
- ❌ **Missing regression:** Not testing affected existing features
- ❌ **Untestable design:** Implementation that can't be tested
- ❌ **Testing implementation:** Tests coupled to internal details

## Test Coverage Checklist

Before finalizing test plan:
- [ ] All requirements have corresponding tests
- [ ] Edge cases and boundaries identified
- [ ] Error scenarios covered
- [ ] Regression tests for affected features
- [ ] Integration points tested
- [ ] Security checks included
- [ ] Performance tests defined (if needed)
- [ ] Test data requirements specified
- [ ] Tests organized by type and priority

## Example Test Plan

**Feature:** User password reset

**Requirements:**
- User can request password reset via email
- Reset link expires after 1 hour
- User can set new password using valid link
- Old passwords cannot be reused (last 5)

**Test Cases:**

```
🧪 Unit Tests:
  generateResetToken():
    ✓ Should generate unique token
    ✓ Should set expiration to 1 hour from now
    ✓ Should hash token before storage
  
  validateResetToken():
    ✓ Should accept valid, non-expired token
    ✓ Should reject expired token
    ✓ Should reject invalid token
    ✓ Should reject already-used token
  
  isPasswordReused():
    ✓ Should reject if password in last 5
    ✓ Should accept if password not in history
    ✓ Should handle user with <5 passwords

🔗 Integration Tests:
  Password Reset Flow:
    ✓ Request → generate token → send email
    ✓ Click link → validate token → show form
    ✓ Submit new password → validate → update
    ✓ Email confirmation sent after reset

🚀 E2E Tests:
  Complete Password Reset Journey:
    ✓ User clicks "Forgot Password"
    ✓ User enters email
    ✓ User receives reset email
    ✓ User clicks link in email
    ✓ User sets new password
    ✓ User can log in with new password
    ✓ Old password no longer works

🎯 Edge Cases:
  ✓ Multiple reset requests → only latest token valid
  ✓ Token used after expiration → rejected
  ✓ Invalid email address → graceful handling
  ✓ Reset for non-existent user → no info disclosure
  ✓ Password reset during active session

❌ Error Scenarios:
  ✓ Email service down → graceful error, retry
  ✓ Database error during token generation
  ✓ Network timeout on reset link click
  ✓ Token tampered with → rejected

🔄 Regression:
  ✓ Normal login still works
  ✓ Account lockout still works
  ✓ Session management unaffected
  ✓ Password validation rules still enforced
```

**Test Data:**
- User with no reset requests
- User with expired reset token
- User with valid reset token
- User with 5+ password history
- Non-existent email addresses

**Priority:**
- 🔴 Security: Token validation, password history
- 🔴 Core flow: Email → reset → login
- 🟡 Edge cases: Multiple requests, expiration
- 🟢 Error messages: User-friendly wording
