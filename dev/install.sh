#!/bin/sh
set -e

# Install developer tools

sudo apt install clang-format luarocks -y

sudo luarocks install luacheck
