---
name: avoid-type-ignore
description: >
  How to avoid type: ignore comments by using proper typing techniques. Use when
  encountering type errors from basedpyright instead of suppressing them with
  type: ignore.
---

## Golden rule

`# type: ignore` is a last resort. Always try the techniques below first. If you
do use it, always include a specific error code:
`# type: ignore[reportArgumentType]`.

---

## Technique 1: Write a typing stub for an untyped package

Use this for `# type: ignore[import-untyped]` on third-party libraries.

Project stubs live in `typings/<package_name>/__init__.pyi`. Basedpyright
automatically discovers the `typings/` directory as a stub root.

**Steps:**

1. Inspect the real signatures at runtime:
   ```python
   import inspect, msal
   print(inspect.signature(msal.ConfidentialClientApplication.__init__))
   ```
2. Create a minimal `.pyi` file that covers only the symbols used in the
   project:
   ```
   typings/msal/__init__.pyi
   ```
3. Type only what you use — leave everything else out.
4. Remove the `# type: ignore[import-untyped]` import comment.

**Example** (`typings/msal/__init__.pyi`):

```python
from typing import Any
from collections.abc import Mapping

class ConfidentialClientApplication:
    def __init__(
        self,
        client_id: str | None,
        client_credential: dict[str, str] | str | None = None,
        authority: str | None = None,
        **kwargs: Any,
    ) -> None: ...
    def initiate_auth_code_flow(
        self,
        scopes: list[str],
        redirect_uri: str | None = None,
        **kwargs: Any,
    ) -> dict[str, Any]: ...
```

---

## Technique 2: Move type-annotation-only imports to TYPE_CHECKING

Ruff TC001/TC002 fires when an import is only used in annotations. Fix:

```python
# Before
import pytest

def test_foo(caplog: pytest.LogCaptureFixture) -> None: ...

# After
from __future__ import annotations
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import pytest

def test_foo(caplog: pytest.LogCaptureFixture) -> None: ...
```

`from __future__ import annotations` is required — it makes annotations lazy, so
the `pytest` name is never evaluated at runtime.

---

## Technique 3: Use cast() for invariant container mismatches

When passing a `dict[SubType, ...]` where `dict[BaseType, ...]` is expected,
dicts are invariant in Python's type system. Fix with `cast`:

```python
from typing import cast
from sqlalchemy import orm

cases: dict[orm.InstrumentedAttribute[str], dict[int, str]] = {col: {1: "a"}}
typed = cast("dict[orm.QueryableAttribute[object], dict[int, object]]", cases)
fn(typed)
```

Use a string literal in `cast()` to avoid importing heavy types at runtime when
`from __future__ import annotations` is active.

---

## Technique 4: Add `# type: ignore` on monkeypatch calls with classmethod()

When monkeypatching a classmethod in tests, `classmethod(fn)` returns
`classmethod[Unknown, ...]` which basedpyright can't verify:

```python
monkeypatch.setattr(Model, "clean_strings", classmethod(fail_fn))  # type: ignore[reportUnknownArgumentType]
```

This is one of the few cases where `type: ignore` is acceptable because there is
no cleaner alternative — the monkeypatch API does not accept typed descriptors.

---

## Technique 5: Use @overload for functions with multiple return shapes

When a function returns different types based on input, `overload` eliminates
the need for `type: ignore` at call sites:

```python
from typing import overload

@overload
def get(key: str, default: str) -> str: ...
@overload
def get(key: str, default: None = None) -> str | None: ...
def get(key: str, default: str | None = None) -> str | None:
    ...
```

---

## When type: ignore is acceptable

Use it only after exhausting all techniques above. Always add an error code:

| Situation                                              | Code                        |
| ------------------------------------------------------ | --------------------------- |
| monkeypatch + classmethod                              | `reportUnknownArgumentType` |
| Invariant container mismatch with no cleaner cast site | `reportArgumentType`        |
| Third-party return type is wrong (upstream bug)        | `reportReturnType`          |

Never use bare `# type: ignore` without a code.
