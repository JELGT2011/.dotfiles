#!/usr/bin/env bash

# how to use
# from the devbox run:
# sudo download-dotfiles /var/lib/uber/dotfiles/
# install-my-dotfiles jlibbey

# install yadr
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# install rcm
sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update
sudo apt-get install rcm

# clone my dotfiles
git clone git@github.com:JELGT2011/.dotfiles.git

# install dotfiles
./.dotfiles/install.sh
