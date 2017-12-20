#!/usr/bin/env bash

set -e  # exit script if a command fails
set -u  # treat unset variables as errors and exit immediately
set -x  # print commands run by script to standard out
set -o pipefail  # exit script if any piped program fails instead of just the last program


# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install gpg

# install rvm, ruby, and rake
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby --latest
gem install rake
alias rake='noglob rake'


# install yadr
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# install powerlevel9k terminal theme
git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
ln -sf ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup

# install powerline fonts
if [[ ! -d "~/.fonts" ]]; then
  git clone https://github.com/powerline/fonts.git ~/.fonts
  ~/.fonts/install.sh
fi

# remove yadr created folders
rm -r ~/.zsh.after
rm -r ~/.zsh.before

# create symlinks
links=("kwm" "zsh.after" "gitconfig.user" "khdrc" "profile" "vimrc.after")
for link in ${links}
do
  ln -sf ~/.dotfiles/${link} ~/
  mv ~/${link} ~/.${link}
done
