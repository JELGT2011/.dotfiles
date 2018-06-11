#!/usr/bin/env bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

# install yadr
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# install powerlevel9k terminal theme
git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
ln -sf ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup

rm -rf ~/.fonts/
git clone https://github.com/powerline/fonts.git ~/.fonts
~/.fonts/install.sh

# remove yadr created folders
rm -rf ~/.zsh.after
rm -rf ~/.zsh.before

[[ -d "~/.ssh/" ]] && mdkir ~/.ssh/

source .osx/homebrew.sh
rcup \
    -x README.md \
    -x install.sh \
    -x update.sh
