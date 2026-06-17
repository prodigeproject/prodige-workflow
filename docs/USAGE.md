# Usage Guide

This guide explains how to use AI Engineering OS from zero to production.

## 1. For an existing repo

Prompt:

```text
/init from repo
```

The AI must inspect the repo and fill the context scaffold.

It should look at:
- README
- package.json / pyproject.toml / composer.json / requirements.txt
- source folders
- routes
- database schema
- tests
- docs
- env examples

It must not invent details.

## 2. For a new idea

Prompt:

```text
/init from idea: [describe idea]
```

The AI must create draft context documents and ask for human review.

## 3. Design a feature

Prompt:

```text
/design [feature]
```

The AI creates or updates:
- PRD
- Architecture
- Implementation Plan

It must ask for approval before coding.

## 4. Build after approval

Prompt:

```text
/build approved [feature]
```

The AI implements using the approved plan.

## 5. Use many windows

Prompt in main window:

```text
/parallel build [feature]
```

Then follow the generated window instructions.

## 6. Keep context fresh

Prompt:

```text
/sync
```

Use after:
- major code changes
- architecture changes
- database changes
- refactor
- integration changes
- release
