
# always log repositories and installs
case "$ostype" in
  "linux")
    alias apt-get() {
      if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
        sudo "apt-get $1 $2" >> $HOME/.dotfiles/.linux/installs.zsh
        command sudo apt-get "$@"
      fi
    }
    alias add-apt-repository() {
      if [[ $1 != "" ]]; then
        sudo "add-apt-repository $1" >> $HOME/.dotfiles/.linux/repositories.zsh
        command sudo add-apt-repository "$@"
      fi
    }
  ;;
  "osx")
    alias brew() {
      if [[ $1 == "install" ]]  && [[ $2 != "" ]]; then
        "brew $1 $2" >> $HOME/.dotfiles/.osx/installs.zsh
        # this line cannot be outside the if/else block or zsh starts executing it after each keystroke
        command brew "$@"
      elif [[ $1 == "tap" ]] && [[ $2 != "" ]]; then
        "brew $1 $2" >> $HOME/.dotfiles/.osx/repositories.zsh
        command brew "$@"
      fi
    }
  ;;
esac
