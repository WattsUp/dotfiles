---
name: git-branch-names
description:
  Git branch naming conventions. Use when creating or naming git branches.
---

## Branch naming

Use a `type/short-description` format with lowercase kebab-case:

| Prefix      | Use for                                    |
| ----------- | ------------------------------------------ |
| `feature/`  | New functionality                          |
| `bugfix/`   | Bug fixes                                  |
| `chore/`    | Maintenance, deps, config, tooling         |
| `docs/`     | Documentation only                         |
| `refactor/` | Code restructuring without behavior change |
| `test/`     | Adding or fixing tests                     |
| `hotfix/`   | Urgent production fixes                    |

Examples:

- `feature/add-login-page`
- `bugfix/fix-null-pointer-on-startup`
- `chore/update-dependencies`
- `docs/api-reference`
