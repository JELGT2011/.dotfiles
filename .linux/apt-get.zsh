
# always log repositories and installs
alias apt-get() {
  if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
    "apt-get $1 $2" >> $HOME/.dotfiles/linux/apt-get-installs.zsh
  elif [[ $1 == "add" ]] && [[ $2 != "" ]]; then
    "apt-get $1 $2" >> $HOME/.dotfiles/linux/apt-get-repositories.zsh
  fi
  command apt-get "$@"
}

alias i() {
  apt-get "$@"
}
