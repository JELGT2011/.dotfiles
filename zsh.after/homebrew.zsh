#!/usr/bin/env bash

export HOMEBREW_NO_SANDBOX=1

function brew-upgrade() {
    brew update && brew upgrade
}

function brew() {
    if [[ "$1" = "install" ]] || [[ "$1" = "tap" ]]; then
        echo "brew $@" >> ~/.dotfiles/.osx/homebrew.sh
    fi
    command brew "$@"
}
