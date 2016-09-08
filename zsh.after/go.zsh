
here="$(dirname "$0")"

# include uber.zsh
. "$here/uber.zsh"

# for local, set GOPATH at uber sync folder
case "$ostype" in
  "linux")
    GOPATH="$HOME/gocode"
  ;;
  "osx")
    GOPATH="$HOME/Uber/sync/$VAGRANT.dev.uber.com/home/uber/gocode"
  ;;
esac

PATH=$PATH:$GOPATH/bin

unset here
