#!/bin/sh
set -e

sudo apt install zsh -y
chsh -s /bin/zsh
rm -rf $HOME/.oh-my-zsh/custom/themes/powerlevel10k
rm -rf $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
rm -rf $HOME/.autoenv
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/hyperupcall/autoenv $HOME/.autoenv
