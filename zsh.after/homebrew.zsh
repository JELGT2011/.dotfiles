#!/usr/bin/env bash

export HOMEBREW_NO_SANDBOX=1

function brew-upgrade() {
    brew update && brew upgrade
}

export PATH="/usr/local/opt/openssl/bin:$PATH"

