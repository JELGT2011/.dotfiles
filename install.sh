#!/usr/bin/env bash

# install yadr
if [[ ! -d "$HOME/.yadr" ]]; then
  # install rvm, ruby, and rake
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash
  source /home/uber/.rvm/scripts/rvm
  rvm install ruby --latest
  gem install rake
  sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
fi

here="$(dirname "$0")"

# include global.zsh
. "zsh.after/global.zsh"

cd $HOME/.dotfiles

# install powerlevel9k terminal theme
git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
ln -sf ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup

# install powerline fonts
if [[ ! -d "$HOME/.fonts" ]]; then
  git clone https://github.com/powerline/fonts.git $HOME/.fonts
  $HOME/.fonts/install.sh
fi

ln -sf ~/.dotfiles/ssh/rc ~/.ssh/rc
links=("kwm" "zsh.after" "gitconfig.user" "khdrc" "profile" "tmux.conf.user" "vimrc.after")
for link in $links
do
  ln -sf ~/.dotfiles/$link ~/
  mv ~/$link ~/.$link
done

cd $HOME/.dotfiles

unset here
