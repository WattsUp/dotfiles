---
name: sqlalchemy-orm
description: >
  SQLAlchemy ORM model patterns, session management, query helpers, custom
  types, and URI system for apps built on the flask-htmx-template. Use when
  writing or editing models, migrations, or database queries.
---

## Model definition

All models inherit from `Base` (which extends `orm.DeclarativeBase` and
`QueryMixIn`). Use the provided type aliases for columns:

```python
from flask_htmx_template.models.base import (
    Base,
    Decimal6,
    ORMInt, ORMIntOpt,
    ORMStr, ORMStrOpt,
    ORMReal, ORMRealOpt,
    ORMBool, ORMBoolOpt,
    string_column_args,
)

class Item(Base):
    __tablename__ = "item"
    __table_id__ = 0x00000000   # unique per model, used for URI encoding

    name: ORMStr = orm.mapped_column(unique=True)
    date_ord: ORMInt
    value: ORMReal = orm.mapped_column(Decimal6, default=Decimal())
    note: ORMStrOpt

    # String constraints (min length, no leading/trailing whitespace)
    __table_args__ = (
        *string_column_args("name"),
        *string_column_args("note"),
    )

    @orm.validates("name", "note")
    def validate_strings(self, key: str, field: str | None) -> str | None:
        return self.clean_strings(key, field)

    @orm.validates("value")
    def validate_decimals(self, key: str, field: Decimal | None) -> Decimal | None:
        return self.clean_decimals(key, field)
```

## Type aliases

| Alias        | Python type       | SQL type |
| ------------ | ----------------- | -------- |
| `ORMBool`    | `bool`            | Boolean  |
| `ORMBoolOpt` | `bool \| None`    | Boolean  |
| `ORMInt`     | `int`             | Integer  |
| `ORMIntOpt`  | `int \| None`     | Integer  |
| `ORMStr`     | `str`             | String   |
| `ORMStrOpt`  | `str \| None`     | String   |
| `ORMReal`    | `Decimal`         | Decimal6 |
| `ORMRealOpt` | `Decimal \| None` | Decimal6 |

## Custom column types

```python
# Fixed-point: stores as micro-integer (6 decimal places)
value: ORMReal = orm.mapped_column(Decimal6, default=Decimal())

# Fixed-point: stores as nano-integer (9 decimal places)
precise: ORMReal = orm.mapped_column(Decimal9)

# IntEnum: stores as integer
category: orm.Mapped[ItemCategory] = orm.mapped_column(SQLEnum(ItemCategory))
```

## String column constraints

```python
__table_args__ = (
    *string_column_args("name"),                         # min 2 chars, no whitespace
    *string_column_args("note"),
    *string_column_args("ticker", short_check=False),    # only no-whitespace check
    *string_column_args("email", lower_check=True),      # also enforce lower case
)
```

## URI system

Each model gets a unique `__table_id__` that is encoded into a short URI string.
URIs are the public identifier for objects (used in URLs, forms, etc.).

```python
# Get URI for an instance
uri = item.uri            # e.g. "abc123"

# Get URI for an ID
uri = Item.id_to_uri(42)

# Decode a URI back to ID (raises WrongURITypeError if wrong model)
id_ = Item.uri_to_id(uri)
```

`__table_id__` values must be unique across all models. They are assigned
automatically by alphabetical class name order if set to not `None` (use
`0x00000000`).

## Active record query interface (QueryMixIn)

Session must be active via `web.db.begin_session()` (or `Base.set_session()` in
tests) before calling any query methods.

```python
# Fetch all rows
items = Item.all()

# Fetch one (raises if not exactly one)
item = Item.one()

# Fetch first or None
item = Item.first()

# Count
n = Item.count()

# Build custom query
query = Item.query().where(Item.name == "foo").order_by(Item.date_ord)
items = list(sql.yield_(query))

# Query specific columns
query = Item.query(Item.id_, Item.name)

# Find by URI or property values
pair = Item.find(search_str, cache={})   # returns NamePair(id_, name)
```

## sql module helpers

```python
from flask_htmx_template import sql

# Yield results lazily (avoids loading all rows into memory)
for item in sql.yield_(query):
    ...

# Fetch exactly one (raises NoResultFound or MultipleResultsFound)
item = sql.one(query)

# Fetch one or None
item = sql.scalar(query)

# Check if any exist
exists = sql.any_(query)

# Count
n = sql.count(query)

# Convert two-column query to dict
mapping = sql.to_dict(Item.query(Item.id_, Item.name))
```

## Session management

Controllers open a session with a context manager:

```python
with web.db.begin_session():
    item = Item.query().where(Item.id_ == id_).one()
    # session auto-commits on clean exit, rolls back on exception
```

For nested transactions (to catch errors without rolling back the whole
session):

```python
with web.db.begin_session() as s:
    try:
        with s.begin_nested():
            Item.create(name=name, ...)
    except (exc.IntegrityError, exc.InvalidORMValueError) as e:
        return base.error(e)   # nested rolled back, outer still open
```

## Creating and mutating records

```python
# Create (auto-flush to get id_)
item = Item.create(name="foo", date_ord=today.toordinal(), value=Decimal("1.5"))

# Mutate (validated by @orm.validates)
item.name = "bar"
item.value = Decimal("2.0")

# Delete
item.delete()

# Refresh from DB
item.refresh()
```

## Enums

```python
class ItemCategory(BaseEnum):
    """Category of an item."""

    GENERAL = 0
    SPECIAL = 1

    @classmethod
    def lut(cls) -> Mapping[str, BaseEnum]:
        # Optional alternate string names
        return {"gen": cls.GENERAL, "spec": cls.SPECIAL}
```

`BaseEnum` supports string comparison (`category == "GENERAL"`), parsing from
strings case-insensitively, and a `.pretty` property (`"General"`).

## Migrations

Migrations live in `migrations/v*.py`. Each migration file defines a class
inheriting from the previous migration with an `upgrade()` method that uses raw
SQL to modify the schema.

## Supported databases

- SQLite (default, path-based)
- PostgreSQL (via `psycopg`, URL-based: `postgres://user:pass@host:port/db`)
- SQLCipher (encrypted SQLite, requires `encrypt` extra)

Database is selected by the `DB_PATH` environment variable (or `--database` CLI
flag). Encryption key via `DB_KEY` or `DB_KEY_PATH`.
