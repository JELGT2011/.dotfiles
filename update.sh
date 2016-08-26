#!/usr/bin/env bash

unamestr=$(uname)

# update yadr
cd ~/.yadr
git reset --hard
git pull --rebase
rake update

# system updates
if [[ "$unamestr" == 'Linux' ]]; then
  sudo apt-get update
  sudo apt-get upgrade
if [[ "$unamestr" == 'FreeBSD' ]]; then
  brew update
  brew upgrade
fi

# uber update
if [[ "$unamestr" == 'FreeBSD' ]]; then
  update-uber-home.sh
fi

dotfilesinstall
