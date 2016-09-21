
VAGRANT="millennium-falcon"
ADHOC="adhoc05-sjc1"
KSCOPE="kaleidoscope-international"

pyprojects=("ufs" "chariots")
npmprojects=("$KSCOPE")
goprojects=("alfa-romeo")
javaprojects=("AlfaRomeo")
projects=($pyprojects $npmprojects $goprojects $javaprojects)

uvagrantls() {
  boxer list_vagrants --owner=$UBER_OWNER
}

uvagrantcreate() {
  if [[ "$1" != "" ]]; then
    boxer create_vagrant --name "$1" --aws-type m4.4xlarge
  else
    echo "vagrant name is required"
  fi
}

uvagrantdestroy() {
  if [[ "$1" != "" ]]; then
    boxer terminate $1
    boxer delete $1
    rm $HOME/Uber/sync/$1.dev.uber.com.remote_paths
  else
    echo "vagrant name is required"
  fi
}

uussh() {
  boxer extend_vagrant $VAGRANT --lifeguard-token="$LIFEGUARD_TOKEN"
  ssh uber@$VAGRANT.dev -t 'zsh'
}

utunnel() {
  if [[ "$1" != "" ]]; then
    ssh -fNL $1:localhost:$1 uber@$VAGRANT.dev
  else
    ssh -fNL 14919:localhost:14919 uber@$VAGRANT.dev
  fi
}

udb() {
  if [[ "$1" != "" ]]; then
    $1 -uuber -puber
  else
    mysql -uuber -puber
  fi
}

uactivate() {
  . "env/bin/activate"
}

uenv() {
  uactivate "$*"
}

uvenv() {
  uactivate "$*"
}

uproject() {
  if [[ ${pyprojects[(r)$1]} == $1 ]]; then
    cd $HOME/$1/
    uenv $1
  elif [[ ${npmprojects[(r)$1]} == $1 ]]; then
    cd $HOME/$1/
  elif [[ ${javaprojects[(r)$1]} == $1 ]]; then
    cd $HOME/$1/
  elif [[ ${goprojects[(r)$1]} == $1 ]]; then
    cd $GOPATH/src/code.uber.internal/growth/$1
  fi
}

usync() {
  local sync=()
  for i in $pyprojects $npmprojects $javaprojects; do
    sync+=("uber/$i")
  done
  sync+=("uber/gocode/src")
  boxer sync $VAGRANT $sync
}

ulink() {
  for i in $pyprojects $npmprojects $javaprojects; do
    ln -sf $HOME/Uber/sync/$VAGRANT.dev.uber.com/home/uber/$i $HOME/Repositories/
  done
  for i in $goprojects; do
    ln -sf $GOPATH/src/code.uber.internal/growth/$i $HOME/Repositories/
  done
}

uadhoc() {
  if [[ "$1" != "" ]]; then
    ssh $1 -t 'exec zsh'
  else
    ssh $ADHOC -t 'exec zsh'
  fi
}
