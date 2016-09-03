
here="$(dirname "$0")"

# include uber.zsh
. "$here/uber.zsh"

# for local, set GOPATH at uber sync folder
case "$ostype" in
  "linux")
    export GOPATH="~/gocode"
  ;;
  "osx")
    export GOPATH="~/Uber/sync/$VAGRANT.dev.uber.com/home/uber/gocode"
  ;;
esac

export PATH=$PATH:$GOPATH/bin
