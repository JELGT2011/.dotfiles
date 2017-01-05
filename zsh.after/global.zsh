
export DEFAULT_USER="jlibbey"

osenums=("linux" "osx" "windows" "unknown")
ostype=""

exclude=("install.sh" "README.md" "update.sh" "bin" "com.googlecode.iterm2.plist")

# source local zshrc if it exists
if [[ -a "$HOME/.zshrc.local" ]]; then
  . "$HOME/.zshrc.local"
fi

dotfilesinstall() {
  local rcmexclude=()
  for i in $exclude; do
    rcmexclude+=("-x $i")
  done
  rcup $rcmexclude
  zsh
}

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
