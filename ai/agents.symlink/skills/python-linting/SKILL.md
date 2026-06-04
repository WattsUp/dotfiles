---
name: python-linting
description: >
  Python linter and type-checker conventions for all repos. Use when running or
  configuring linters, fixing lint errors, or choosing type-checking tools.
---

## Tools

| Tool           | Purpose                       | Command                |
| -------------- | ----------------------------- | ---------------------- |
| `ruff`         | Linter + formatter            | `ruff check <path>`    |
| `basedpyright` | Type checker (NOT pyright)    | `basedpyright <path>`  |
| `djlint`       | Jinja/HTML linter + formatter | `djlint <path> --lint` |

**Always use `basedpyright`.** Never use `pyright`. All repos are configured for
basedpyright.

## Typical lint workflow

```bash
ruff check path/to/module.py
basedpyright path/to/module.py
```

Apply auto-fixes with `ruff check --fix`. For unsafe fixes (e.g. COM812 trailing
comma): `ruff check --fix --unsafe-fixes`.

## Common ruff rules to know

- **N806** — variable in function must be lowercase (don't use `_UPPER` locals)
- **RUF052** — local dummy variable accessed (remove leading underscore or
  rename)
- **COM812** — trailing comma missing in multi-line collection
- **TC001** — import only used in type annotations should be in `TYPE_CHECKING`
  block
- **PLR2004** — magic value in comparison; extract to a named constant
- **DOC201** — missing `Returns:` section in docstring

## Module-level constants vs local constants

Use module-level constants (all-caps) for values shared across functions. Inside
a function body, use lowercase variable names — ruff N806 flags uppercase
locals.

```python
# Good
_LOG_DISPLAY_LINES = 50  # module level

def parse(line: str) -> list[str]:
    parts_log = 3  # lowercase local
    return line.split(" ", parts_log - 1)
```
