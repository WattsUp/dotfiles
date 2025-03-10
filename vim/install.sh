#!/bin/sh
set -e

# Build and install neovim from source
# ripgrep for searching in vim
sudo apt install ninja-build gettext cmake unzip curl build-essential ripgrep -y
cd /var/tmp
rm -rf neovim-stable
curl -L https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz -o neovim.tar.gz
tar -xzvf neovim.tar.gz
cd neovim-stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux*
