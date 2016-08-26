#!/usr/bin/env bash

here="$(dirname "$0")"

# include common.sh
. "$here/common.sh"

# only update yadr if flagged
if [[ $* == *-y* ]] || [[ $* == *--yadr* ]]; then
  cd ~/.yadr
  git reset --hard
  git pull --rebase
  rake update
fi

# system updates
if [[ "$unamestr" == 'Linux' ]]; then
  sudo apt-get update
  sudo apt-get upgrade
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  brew update
  brew upgrade
fi

# uber update
if [[ "$unamestr" == 'FreeBSD' ]]; then
  update-uber-home.sh
fi

dotfilesinstall
