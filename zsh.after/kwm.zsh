
export KWMC_FOCUS_FOLLOWS_MOUSE="on"

alias kwm-restart="brew services restart kwm"

function kwm-toggle-focus() {
  kwmc config focus-follows-mouse $KWMC_FOCUS_FOLLOWS_MOUSE
  if [ "$KWMC_FOCUS_FOLLOWS_MOUSE" == "on" ]; then
    KWMC_FOCUS_FOLLOWS_MOUSE="off"
  else
    KWMC_FOCUS_FOLLOWS_MOUSE="on"
  fi
}
