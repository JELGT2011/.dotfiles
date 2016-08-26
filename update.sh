#!/usr/bin/env bash

{
  here="$(dirname "$0")"

  # include global.zsh
  . "$here/zsh.after/global.zsh"

  cd $HOME/.dotfiles

  # only update yadr if flagged
  if [[ $* == *-y* ]] || [[ $* == *--yadr* ]]; then
    cd ~/.yadr
    git reset --hard
    git pull --rebase
    rake update
  fi

  # system updates
  case "$ostype" in
    "linux")
      sudo apt-get update
      sudo apt-get upgrade
    ;;
    "osx")
      brew update
      brew upgrade
    ;;
  esac

  # uber update
  case "$ostype" in
    "osx")
      update-uber-home.sh
    ;;
  esac

  dotfilesinstall

  cd $HOME/.dotfiles
}
