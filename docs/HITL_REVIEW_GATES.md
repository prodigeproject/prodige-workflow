# Human-in-the-loop Review Gates

AI must not jump from idea to code.

## Required gates

1. PRD Gate
2. Architecture Gate
3. Implementation Gate
4. Review Gate
5. Release Gate

## PRD Gate

Checks:
- problem is clear
- user flow is clear
- acceptance criteria exist
- scope and non-goals are clear

## Architecture Gate

Checks:
- data flow is clear
- affected systems are clear
- dependencies are clear
- risks are clear
- alternatives considered

## Implementation Gate

Checks:
- file plan exists
- modular split exists
- tests are planned
- rollback plan exists
- migration plan exists if needed

## Review Gate

Checks:
- code works
- tests pass
- no critical security issue
- no unnecessary rewrite
- docs/context updated

## Release Gate

Checks:
- changelog updated
- known issues recorded
- deployment notes ready
- rollback path known
