---
name: writing-style
description: >
  Style conventions for any human-readable text: prose, documentation, code
  comments, commit messages, docstrings, and source code. Use whenever writing
  or editing text of any kind.
---

## Style conventions

- Single space after a period (or other sentence-terminating punctuation), never
  two. Applies everywhere: prose, comments, docstrings, commit messages,
  documentation.
- Never use Unicode em dashes or en dashes anywhere — code, comments,
  docstrings, string literals, or documentation. In AsciiDoc and Markdown prose,
  use `--` instead; AsciiDoc renders it as an em dash automatically.
- Use ASCII arrows `->` and `<-` not Unicode arrows (`→`, `←`, etc.) in code.
- UTF-8 Greek letters are fine
- Use Ohms `Ω` for resistance units and Omega `Ω` for Greek

## After completing a task

1. Add `// NOTE:` comments to source for any non-obvious corner cases
