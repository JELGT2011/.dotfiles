
VAGRANT="serenity"

pyprojects=("chariots")
npmprojects=()
goprojects=()
javaprojects=()
projects=($pyprojects $npmprojects $goprojects $javaprojects)

uvagrantcreate() {
  if [[ "$1" != "" ]]; then
    boxer create_vagrant \
      --name "$1" \
      --aws-type c4.4xlarge \
      --aws-region us-west-1 \
      --distro jessie \
      --allow-rename \
      --with-lifeguard-enroll
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

ussh() {
  command ussh
  boxer extend_vagrant $VAGRANT --lifeguard-token="$LIFEGUARD_TOKEN"
}

uussh() {
  boxer v $VAGRANT
}

uclean() {
  rm `find . -name '*.unison.tmp'`
}

utunnel() {
  if [[ "$1" != "" ]]; then
    ssh -NL $1:localhost:$1 uber@$VAGRANT.dev
  else
    echo "port number is required"
  fi
}

usshrestart() {
  kill $(ps aux | grep ssh)
}

uactivate() {
  source "env/bin/activate"
}

usync() {
  local sync=()
  for i in $pyprojects $npmprojects $javaprojects; do
    sync+=("uber/$i")
  done
  sync+=("uber/gocode/src")
  boxer sync $VAGRANT $sync \
      --allow-path-symlinks \
      --ignore-git \
      --with-node-modules \
      --with-virtualenvs
}

ulink() {
  for i in $pyprojects $npmprojects $javaprojects; do
    ln -sf $HOME/Uber/sync/$VAGRANT.dev.uber.com/home/uber/$i $HOME/Repositories/
  done
  for i in $goprojects; do
    ln -sf $GOPATH/src/code.uber.internal/$i $HOME/Repositories/
  done
}

goclone() {
  mkdir -p $GOPATH/src/code.uber.internal/$1
  git clone gitolite@code.uber.internal:$1 $GOPATH/src/code.uber.internal/$1 --recursive
}
