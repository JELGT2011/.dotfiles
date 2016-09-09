
export DEFAULT_USER="jasonlibbey"

osenums=("linux" "osx" "windows" "unknown")
ostype=""

exclude=("install.sh" "README.md" "update.sh")

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

osdetect
