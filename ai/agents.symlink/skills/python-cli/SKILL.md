---
name: python-cli
description: >
  Python command-line tool conventions using argparse and argcomplete, with
  deferred imports for fast time-to-main. Use when writing CLI entry points,
  subcommands, or any Python program invoked repeatedly from the shell (e.g.
  tab-completion calls the program on every keystroke).
---

## Why defer imports

Shell tab-completion (argcomplete) calls the program on every tab press. Slow
top-level imports make every completion feel sluggish. The rule:

- `main.py` and `Command.__init__` — only import stdlib and lightweight deps at
  the top level
- `Command.run()` — import heavy deps (database drivers, numpy, etc.) here,
  since this path is only taken when the command actually executes
- Stdlib modules that are only used in one code path (`getpass`, `tarfile`,
  `json`, etc.) should also be deferred into the function that needs them

## Entry point structure

```python
# PYTHON_ARGCOMPLETE_OK   ← magic comment must be on line 1 or 2

from __future__ import annotations

import argparse
import sys

import argcomplete

from myapp.commands.create import Create
from myapp.commands.migrate import Migrate


def main(command_line: list[str] | None = None) -> int:
    """Execute main program.

    Args:
        command_line: command line arguments, None for sys.argv

    Returns:
        0 on success, non-zero on failure

    """
    parser = argparse.ArgumentParser(prog="myapp", description="My application.")
    parser.add_argument("--version", action="version", version=__version__)
    parser.add_argument(
        "--database",
        "-d",
        dest="path_db",
        metavar="PATH",
        default="~/.myapp/database.db",
        help="path to database",
    )

    subparsers = parser.add_subparsers(dest="cmd", metavar="<command>", required=True)

    cmds = [Create, Migrate]
    for cmd_class in cmds:
        sub = subparsers.add_parser(
            cmd_class.NAME,
            help=cmd_class.HELP,
            description=cmd_class.DESCRIPTION,
        )
        cmd_class.setup_args(sub)

    argcomplete.autocomplete(parser)   # must be called before parse_args
    args = parser.parse_args(args=command_line)

    args_d = vars(args)
    cmd: str = args_d.pop("cmd")
    c = next(c for c in cmds if cmd == c.NAME)(**args_d)
    return c.run()


if __name__ == "__main__":
    sys.exit(main())
```

Register in `pyproject.toml`:

```toml
[project.scripts]
myapp = "myapp.main:main"
```

Activate tab-completion (add to shell rc, or use `register-python-argcomplete`):

```bash
eval "$(register-python-argcomplete myapp)"
```

## Command base class

```python
# commands/base.py
from __future__ import annotations

import sys
from abc import ABC, abstractmethod
from typing import TYPE_CHECKING

import colorama
from colorama import Fore

if TYPE_CHECKING:
    import argparse


class Command(ABC):
    """Base command interface."""

    NAME: str = ""
    HELP: str = ""
    DESCRIPTION: str = ""

    def __init__(self, path_db: str, ...) -> None:
        colorama.init(autoreset=True)

        # Defer heavy imports — this runs on every tab-completion
        from myapp import database

        self._db = database.open(path_db)

    @classmethod
    @abstractmethod
    def setup_args(cls, parser: argparse.ArgumentParser) -> None:
        """Register subcommand arguments."""
        raise NotImplementedError

    @abstractmethod
    def run(self) -> int:
        """Execute command; return 0 on success."""
        raise NotImplementedError
```

## Subcommand with deferred run imports

```python
# commands/export.py
from __future__ import annotations

import sys
from typing import override, TYPE_CHECKING

from colorama import Fore

from myapp.commands.base import Command

if TYPE_CHECKING:
    import argparse
    from pathlib import Path


class Export(Command):
    NAME = "export"
    HELP = "export data to CSV"
    DESCRIPTION = "Export all records to a CSV file"

    def __init__(self, path_db: str, output: Path) -> None:
        super().__init__(path_db)
        self._output = output

    @override
    @classmethod
    def setup_args(cls, parser: argparse.ArgumentParser) -> None:
        parser.add_argument(
            "output",
            metavar="FILE",
            type=Path,
            help="output CSV path",
        )

    @override
    def run(self) -> int:
        # Defer: only runs when user actually calls `myapp export ...`
        import csv

        from myapp import queries

        rows = queries.all_records(self._db)
        with self._output.open("w", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=["id", "name", "value"])
            writer.writeheader()
            writer.writerows(rows)

        print(f"{Fore.GREEN}Exported {len(rows)} rows to {self._output}")
        return 0
```

## What to defer vs. keep at top level

| Keep at top level                              | Defer to `run()`                              |
| ---------------------------------------------- | --------------------------------------------- |
| `argparse`, `sys`, `pathlib.Path`              | Database drivers (`psycopg`, `sqlcipher3`)    |
| `colorama` (used in `__init__` for errors)     | `numpy`, `pandas`, scipy                      |
| `abc`, `typing`, `TYPE_CHECKING` blocks        | `json`, `csv`, `tarfile`, `zipfile`           |
| Lightweight intra-package imports (base class) | Heavy intra-package modules (ORM, migrations) |
| `argcomplete`                                  | `getpass` (only used in secure-input path)    |

`TYPE_CHECKING` imports are free — they're erased at runtime:

```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import argparse           # free: only used for type hints
    from pathlib import Path  # free if Path only appears in annotations
```

## argparse patterns

### Boolean flags

```python
parser.add_argument("--force", default=False, action="store_true",
                    help="overwrite existing files")
parser.add_argument("--no-color", dest="color", default=True,
                    action="store_false", help="disable color output")
```

### Hidden/internal arguments

```python
parser.add_argument("--debug-mode", help=argparse.SUPPRESS)
```

### Typed arguments

```python
parser.add_argument("-n", dest="count", type=int, default=10,
                    metavar="N", help="number of results")
parser.add_argument("--path", type=Path, metavar="PATH")
```

### Choices

```python
parser.add_argument("--format", choices=["json", "csv", "text"],
                    default="text")
```

### Optional positional

```python
parser.add_argument("name", nargs="?", default=None,
                    help="item name, omit to list all")
```

## colorama output conventions

```python
from colorama import Fore

print(f"{Fore.GREEN}Success message")
print(f"{Fore.MAGENTA}User action request")
print(f"{Fore.CYAN}Informational output")
print(f"{Fore.YELLOW}Warning", file=sys.stderr)
print(f"{Fore.RED}Error message", file=sys.stderr)
```

Always call `colorama.init(autoreset=True)` before printing, usually at top of
main. With `autoreset`, color resets after every `print()` call automatically.

## Exit codes

- `0` — success
- `x > 0` - failures (expected exit paths but not successful)
- `x < 0` - errors (unexpected exit paths)
- `sys.exit(-x)` — for unrecoverable errors deep in helpers (avoid in `run()`,
  prefer returning a non-zero int so callers and tests can inspect the result)
