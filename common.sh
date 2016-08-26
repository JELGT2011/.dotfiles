#!/usr/bin/env bash

here="$(dirname "$0")"

unamestr=$(uname)
osenums=("linux" "osx" "windows" "unknown")
ostype=""

exclude=("install.sh" "update.sh" "common.sh" "README.md" "osx")

dotfilesinstall() {
  local rcmexclude=()
  for i in $exclude; do
    rcmexclude+=("-x $i")
  done
  rcup rcmexclude
  zsh
}

osdetect() {
  if [[ "$OSTYPE" == "linux-gnu" ]] ||
     [[ "$OSTYPE" == "cygwin" ]] ||
     [[ "$OSTYPE" == "msys" ]]; then
    ostype="linux"
  elif [[ "$OSTYPE" == "darwin"* ]] ||
       [[ "$OSTYPE" == "freebsd"* ]]; then
    ostype="osx"
  elif [[ "$OSTYPE" == "win32" ]]; then
    ostype="windows"
  else
    ostype="unknown"
  fi
}

osdetect
