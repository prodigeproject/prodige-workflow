# Workflow: Docs

1. Load context and memory bank.
2. Dispatch the docs agent (`.ai/agents/docs.md`) to own the documentation work for this session.
3. Identify documentation scope (README, API, guides, decisions).
4. Read current documentation files.
5. Compare docs with current implementation.
6. Identify gaps and outdated sections.
7. Ask clarifying questions about audience and depth.
8. Draft documentation updates (surgical, not wholesale).
9. Include working code examples.
10. Verify all links and references.
11. Update CHANGELOG.md for user-facing changes.
12. Update DECISIONS.md if architectural choices are documented.
13. Run verification checks if applicable.
14. Self-check: beginner-friendly, examples work, quick start exists.
15. Request review if major documentation changes.
16. Update memory bank and handoff.

---

**Agents:**
- `docs` (`.ai/agents/docs.md`) - Dispatched in step 2 to perform the documentation work.
