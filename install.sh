#!/usr/bin/env bash

unamestr=$(uname)
exclude=("install.sh" "update.sh" "README.md" "osx")

dotfilesinstall() {
  local rcmexclude=()
  for i in $exclude; do
    rcmexclude+=("-x $i")
  done
  zsh
}

# install yadr
if [ ! -d "$HOME/.yadr" ]; then
  sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
fi

# install rcp
if [[ "$unamestr" == 'Linux' ]]; then
  sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
  sudo apt-get update
  sudo apt-get install rcm
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  brew tap thoughtbot/formulae
  brew install rcm
fi

# install powerline fonts
if [ ! -d "$HOME/.fonts" ]; then
  git clone https://github.com/powerline/fonts.git $HOME/.fonts
  $HOME/.fonts/install.sh
fi

dotfilesinstall
