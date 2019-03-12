
source ~/.secrets.zsh

function kill-port() {
  kill $(lsof -t -i :${1})
}
