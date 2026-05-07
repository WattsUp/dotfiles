---
name: python-data-types
description:
  Python conventions for tuples and dicts. Use when writing or reviewing Python
  code that uses tuples or dicts.
---

## Tuples

Use a plain `tuple` only when it is **trivial**: small and all items are the
same type (e.g. a 2D point as `tuple[int, int]`).

Use `NamedTuple` when the tuple is non-trivial — mixed types, more than ~2-3
fields, or when field names add clarity:

```python
# trivial — plain tuple is fine
rgb: tuple[int, int, int] = (255, 0, 128)

# non-trivial — use NamedTuple
class BoundingBox(NamedTuple):
    x: float
    y: float
    width: float
    height: float
```

## Dicts

Use a plain `dict` only when it is **trivial**: all keys and values are the same
type (e.g. `dict[str, int]`).

Use `TypedDict` when the dict is non-trivial — mixed value types or a fixed set
of known keys:

```python
# trivial — plain dict is fine
word_counts: dict[str, int] = {"foo": 1, "bar": 2}

# non-trivial — use TypedDict
class UserRecord(TypedDict):
    id: int
    name: str
    email: str
    active: bool
```
