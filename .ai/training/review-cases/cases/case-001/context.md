# Task Context (case-001)

**Task:** Add a `/login` endpoint that authenticates a user by username + password.

**Scope:** Only the login endpoint. The password reset flow is explicitly OUT of scope.

**Notes:** The request body is validated by a zod schema in the route middleware
before the handler runs, so do not re-flag missing body validation in the handler.
