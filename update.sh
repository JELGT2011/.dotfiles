#!/usr/bin/env bash

set -x


# only update yadr if flagged
if [[ $* == *-y* ]] || [[ $* == *--yadr* ]]; then
  cd ~/.yadr
  git reset --hard
  git pull --rebase
  rake update
fi
