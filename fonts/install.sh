#!/bin/sh
set -e

sudo apt install fonts-noto-color-emoji -y

mkdir -p ~/.local/share/fonts
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FantasqueSansMono.tar.xz | tar -xvJ -C ~/.local/share/fonts --wildcards "*.ttf"
fc-cache -fv
