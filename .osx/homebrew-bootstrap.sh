#!/usr/bin/env bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

IFS=$'\n\t'

brew tap thoughtbot/formulae
brew install rcm

brew install rbenv
brew install pyenv
brew install nodenv && brew install nodenv/nodenv/node-build-update-defs

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

brew install --cask visual-studio-code
brew install --cask karabiner-elements
brew install --cask messenger
brew install --cask spotify
