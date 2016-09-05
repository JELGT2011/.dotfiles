#!/usr/bin/env bash

{
  # install yadr
  if [ ! -d "$HOME/.yadr" ]; then
    sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
  fi

  here="$(dirname "$0")"

  # include global.zsh
  . "$here/zsh.after/global.zsh"

  cd $HOME/.dotfiles

  # install rcp
  case "$ostype" in
    "linux")
      sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
      sudo apt-get update
      sudo apt-get install rcm
    ;;
    "osx")
      brew tap thoughtbot/formulae
      brew install rcm
    ;;
  esac

  # install powerlevel9k terminal theme
  git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
  ln -s ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup

  # install powerline fonts
  if [ ! -d "$HOME/.fonts" ]; then
    git clone https://github.com/powerline/fonts.git $HOME/.fonts
    $HOME/.fonts/install.sh
  fi

  dotfilesinstall

  cd $HOME/.dotfiles
}
