#!/usr/bin/env bash

here="$(dirname "$0")"

unamestr=$(uname)
exclude=(
  "install.sh"
  "update.sh"
  "common.sh"
  "README.md"
  "osx"
)

dotfilesinstall() {
  local rcmexclude=()
  for i in $exclude; do
    rcmexclude+=("-x $i")
  done
  rcup rcmexclude
  zsh
}
