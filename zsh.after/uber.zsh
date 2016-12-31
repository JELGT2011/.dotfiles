
VAGRANT="millennium-falcon"
ADHOC="xchange01-dca1"
KSCOPE="kaleidoscope-international"

pyprojects=("ufs" "chariots")
npmprojects=("$KSCOPE" "maze")
goprojects=("alfa-romeo" "mazebackend")
javaprojects=()
projects=($pyprojects $npmprojects $goprojects $javaprojects)

uvagrantls() {
  boxer list_vagrants --owner=$UBER_OWNER
}

uvagrantcreate() {
  if [[ "$1" != "" ]]; then
    boxer create_vagrant \
    --name "$1" \
    --aws-type m4.4xlarge \
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
  ssh uber@$VAGRANT.dev -t 'zsh'
}

utunnel() {
  if [[ "$1" != "" ]]; then
    ssh -fNL $1:localhost:$1 uber@$VAGRANT.dev
  else
    ssh -fNL 14919:localhost:14919 uber@$VAGRANT.dev
  fi
}

usshrestart() {
  kill $(ps aux | grep ssh)
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
  boxer sync $VAGRANT $sync --prefer local
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

connect-proxy() {
  bastion_connections=$(ps aux | grep -c 'ssh -fCND 8001 bastion01-sjc1.prod.uber.com')
  if [[ $bastion_connections -lt 2 ]] ; then
      ssh -fCND 8001 bastion01-sjc1.prod.uber.com
  else
      echo "Already connected to bastion01-sjc1"
  fi
}

connect-athena() {
  # Start tunnel
  connect-proxy

  # Configure socks proxy
  socksproxy_config=$(networksetup -getsocksfirewallproxy "Wi-Fi")
  proxy_enabled=$(echo $socksproxy_config | grep -c "Enabled: yes")
  proxy_configured=$(echo $socksproxy_config | grep -c "Server: localhost")
  if [[ $proxy_configured -eq 0 ]] ; then
    echo "Need to configure firewall server"
    networksetup -setsocksfirewallproxy "Wi-Fi" localhost 8001
  else
    echo "Firewall server already configured"
  fi

  bypass_domains=$(networksetup -getproxybypassdomains "Wi-Fi")
  bypass_domains_configured=$(echo $bypass_domains | grep -E "\*\.local" | grep -cE "169\.254/16")

  if [[ $bypass_domains_configured -eq 0 ]] ; then
    # Set bypass domains
    echo "Need to configure bypass domains"
    networksetup -setproxybypassdomains "Wi-Fi" *.local 169.254/16
  else
    echo "Bypass domains already configured"
  fi

  if [[ $proxy_enabled -eq 0 ]] ; then
    # Enable proxy
    echo "Need to enable proxy"
    networksetup -setsocksfirewallproxystate "Wi-Fi" on
  else
    echo "Proxy already enabled"
  fi
}

disconnect-athena() {
  # Disable proxy
  networksetup -setsocksfirewallproxystate "Wi-Fi" off
  # Kill running SSH tunnel, if one exists
  pkill -f "ssh -fCND 8001 bastion01-sjc1.prod.uber.com"
}
