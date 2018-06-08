#!/usr/bin/env bash

set -x

# install yadr
alias rake='noglob rake'
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# install powerlevel9k terminal theme
git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
ln -sf ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup

# install powerline fonts
if [[ ! -d "~/.fonts" ]]; then
  git clone https://github.com/powerline/fonts.git ~/.fonts
  ~/.fonts/install.sh
fi

# remove yadr created folders
rm -rf ~/.zsh.after
rm -rf ~/.zsh.before

# create symlinks
links=("zsh.after" "gitconfig.user" "khdrc" "chunkwmrc" "profile" "vimrc.after" "tmux.conf.user")
for link in ${links[@]}
do
  ln -sf ~/.dotfiles/${link} ~/.${link}
done
ln -sf ~/.dotfiles/ssh/config ~/.ssh/
