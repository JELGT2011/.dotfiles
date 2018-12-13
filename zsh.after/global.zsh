
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

source ~/.secrets.zsh

function kill-port() {
  kill $(lsof -t -i :${1})
}
