
function attach() {
  if [[ "$1" != "" ]]; then
    tmux -CC a -t "$1"
  else
    echo "tmux -CC a -t \$1"
  fi

}
