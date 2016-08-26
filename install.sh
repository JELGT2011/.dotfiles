#!/usr/bin/env bash

here="$(dirname "$0")"

# include common.sh
. "$here/common.sh"

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
