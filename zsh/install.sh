#!/bin/sh
sudo apt install zsh -y
chsh -s /bin/zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
