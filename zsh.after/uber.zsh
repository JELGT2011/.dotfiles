
export VAGRANT="shelby-lanos-7"
export ADHOC="adhoc05-sjc1"

projects=("ufs" "kaleidoscope-international" "chariots")

uvagrants() {
  boxer list_vagrants --owner=$UBER_OWNER
}

uussh() {
  ssh uber@$VAGRANT.dev -t 'zsh'
}

utunnel() {
  if [ "$1" != "" ]; then
    ssh -fNL $1:localhost:$1 uber@$VAGRANT.dev
  else
    ssh -fNL 14919:localhost:14919 uber@$VAGRANT.dev
  fi
}

udb() {
  if [ "$1" != "" ]; then
    $1 -uuber -puber
  else
    mysql -uuber -puber
  fi
}

uactivate() {
  source env/bin/activate
}

uenv() {
  uactivate "$*"
}
uvenv() {
  uactivate "$*"
}

usync() {
  local sync=()
  for i in $projects; do
    sync+=("uber/$i")
  done
  boxer sync $VAGRANT $sync
}

ulink() {
  ln -sf ~/Uber/sync/$VAGRANT.dev.uber.com/home/uber/* ~/Repositories/
}

uadhoc() {
  if [ "$1" != "" ]; then
    ssh $1 -t 'exec zsh'
  else
    ssh $ADHOC -t 'exec zsh'
  fi
}
