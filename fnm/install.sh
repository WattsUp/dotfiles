#!/bin/sh
set -e

# Install fnm
sudo apt install curl -y
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# Run fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
fi
fnm install --latest

# Install linters
npm install eslint --global
