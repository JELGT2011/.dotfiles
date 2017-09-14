#!/usr/bin/env bash

# only update yadr if flagged
if [[ $* == *-y* ]] || [[ $* == *--yadr* ]]; then
  cd $HOME/.yadr
  git reset --hard
  git pull --rebase
  rake update
fi
