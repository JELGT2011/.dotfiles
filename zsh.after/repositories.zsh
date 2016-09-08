
# always log repositories and installs
case "$ostype" in
  "linux")
    alias apt-get() {
      if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
        "apt-get $1 $2" >> $HOME/.dotfiles/linux/installs.zsh
      fi
      command apt-get "$@"
    }
    alias add-apt-repository() {
      if [[ $1 != "" ]]; then
        "add-apt-repository $1" >> $HOME/.dotfiles/linux/repositories.zsh
      fi
      command add-apt-repository "$@"
    }
  ;;
  "osx")
    alias brew() {
      if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
        "brew $1 $2" >> $HOME/.dotfiles/osx/installs.zsh
      elif [[ $1 == "tap" ]] && [[ $2 != "" ]]; then
        "brew $1 $2" >> $HOME/.dotfiles/osx/repositories.zsh
      fi
      command brew "$@"
    }
  ;;
esac
