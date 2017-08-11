
export DEFAULT_USER="jlibbey"

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
export HOMEBREW_NO_SANDBOX=1
export PATH=/usr/local/opt/python/libexec/bin:/Users/jlibbey/.nvm/v0.10.32/bin:node_modules/.bin:/Users/jlibbey/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/munki:/Users/jlibbey/gocode/bin:/Users/jlibbey/.yadr/bin:/Users/jlibbey/.yadr/bin/yadr:/Users/jlibbey/.dotfiles/bin:/Users/jlibbey/Uber/sync/millennium-falcon.dev.uber.com/home/uber/gocode/bin


osenums=("linux" "osx" "windows" "unknown")
ostype=""

# source local zshrc if it exists
if [[ -a "$HOME/.zshrc.local" ]]; then
  . "$HOME/.zshrc.local"
fi

background() {
  if [[ "$1" != "" ]]; then
    nohup "$1" &>/dev/null &
    disown
  fi
}

osdetect() {
  if [[ "$OSTYPE" == "linux-gnu" ]] ||
     [[ "$OSTYPE" == "cygwin" ]] ||
     [[ "$OSTYPE" == "msys" ]]; then
    ostype="linux"
  elif [[ "$OSTYPE" == "darwin"* ]] ||
       [[ "$OSTYPE" == "freebsd"* ]]; then
    ostype="osx"
  elif [[ "$OSTYPE" == "win32" ]]; then
    ostype="windows"
  else
    ostype="unknown"
  fi
}
