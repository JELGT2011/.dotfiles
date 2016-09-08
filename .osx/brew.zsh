
# always log repositories and installs
alias brew() {
  if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
    "brew $1 $2" >> $HOME/.dotfiles/osx/brew-installs.zsh
  elif [[ $1 == "tap" ]] && [[ $2 != "" ]]; then
    "brew $1 $2" >> $HOME/.dotfiles/osx/brew-repositories.zsh
  fi
  command brew "$@"
}

alias i() {
  brew "$@"
}
