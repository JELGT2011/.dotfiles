#!/usr/bin/env bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

[[ -d "${HOME}/.ssh/" ]] && mkdir ~/.ssh/

.osx/homebrew-bootstrap.sh

rcup -v \
    -x README.md \
    -x install.sh \
    -x com.googlecode.iterm2.plist \
    -x update.sh
