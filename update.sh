#!/usr/bin/env bash

here="$(dirname "$0")"

# include global.zsh
. "zsh.after/global.zsh"

cd $HOME/.dotfiles

# only update yadr if flagged
if [[ $* == *-y* ]] || [[ $* == *--yadr* ]]; then
  cd $HOME/.yadr
  git reset --hard
  git pull --rebase
  rake update
fi

osdetect

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

cd $HOME/.dotfiles

unset here
