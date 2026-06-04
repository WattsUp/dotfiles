---
name: bash-conventions
description: >-
  Bash command conventions for this environment - load at session start before
  any shell commands. Critical rules: no ../parent paths anywhere, activate venv
  from repo root before cd-ing into subdirectories.
---

## Directory navigation

- **Never use `cd ..` or `../` parent references** in bash commands - parent
  directory traversal breaks the allowed-tools/commands restrictions in this
  environment.
- Always navigate from the repo root or use absolute paths instead. Example:
  instead of `cd ../../sw/app.metrics`, do
  `cd /home/braddavi/Code/half_u_clock/sw/app.metrics`.

## Python venv

- **Activate the venv BEFORE `cd`-ing into a subdirectory**, not after. The venv
  lives at the repo root (`.venv`), so activate it first:
  ```
  cd /home/braddavi/Code/half_u_clock && source .venv/bin/activate && cd sw/...
  ```
  Activating after a `cd` into a subfolder requires `../` navigation to reach
  the venv, which is not allowed.
