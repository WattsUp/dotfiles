---
name: python-docstrings
description:
  Python docstring conventions for projects using pytest. Use when writing or
  reviewing Python source files or tests.
---

## What to document in `source`

DO add docstrings to:

- Everything

MAY add docstrings to:

- Anonymous functions

## What to document in `tests`

DO add docstrings to:

- pytest fixtures
- Classes (including TypedDicts, enums, dataclasses)
- Regular helper functions

Do NOT add docstrings to:

- Test functions (`def test_*`)
- Module-level source files (no module docstrings)
