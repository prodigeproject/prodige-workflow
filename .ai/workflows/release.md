# Workflow: Release

1. Load context and verify clean git status.
2. Run full verification suite (tests, lint, types, build).
3. Confirm all tests pass and no critical issues exist.
4. Review CHANGELOG.md for completeness and accuracy.
5. Determine version bump type (major, minor, patch).
6. Update version numbers in package files.
7. Generate or update release notes from CHANGELOG.
8. Review DECISIONS.md for any release-critical items.
9. Run pre-release checklist (dependencies, security, docs).
10. Verify build artifacts are production-ready.
11. Create git tag with version number.
12. Generate release summary with highlights and breaking changes.
13. Ask for approval before proceeding to deployment preparation.
14. Document release process and next steps.
15. Stop - do not execute deployment (boundary rule).
