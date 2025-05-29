#!/bin/sh
set -e

# Install developer tools

sudo apt install clang-format luarocks fd-find fzf -y

sudo luarocks install luacheck
