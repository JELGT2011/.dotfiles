#!/usr/bin/env bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

IFS=$'\n\t'

brew tap thoughtbot/formulae
brew tap crisidev/homebrew-chunkwm

brew install jenv
brew install nodenv
brew install rbenv
brew install pyenv
brew install nodenv
brew install rcm
brew install chunkwm
brew install koekeishiya/formulae/skhd
