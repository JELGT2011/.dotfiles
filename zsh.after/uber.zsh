
# export VAGRANT="millennium-falcon"
export VAGRANT="bentley-monaco-1"
export PROJECTS=("ufs" "kaleidoscope-international")
export PROJECT="ufs"
export ADHOC="adhoc05-sjc1"

uvagrants() {
  boxer list_vagrants --owner=$UBER_OWNER
}

uussh() {
  if [ "$1" != "" ]
  then
    ssh uber@$1.dev -t 'exec zsh'
  else
    ssh uber@$VAGRANT.dev -t 'exec zsh'
  fi
}

udb() {
  if [ "$1" != "" ]
  then
    $1 -uuber -puber
  else
    mysql -uuber -puber
  fi
}

uactivate() {
  if [ "$1" != "" ]
  then
    source ~/$1/env/bin/activate
  else
    source ~/$PROJECT/env/bin/activate
  fi
}

uenv() {
  uactivate "$*"
}
uvenv() {
  uactivate "$*"
}

usync() {
  if [ "$1" != "" ]
  then
    boxer sync $VAGRANT uber/$1
  else
    boxer sync $VAGRANT uber/$PROJECT
  fi
}

ulink() {
  for i in ${PROJECTS[@]}; do
    ln -S ~/Uber/sync/$VAGRANT.dev.uber.com/home/uber/${i} ~/Repositories/
  done
}

uadhoc() {
  if [ "$1" != "" ]
  then
    ssh $1 -t 'exec zsh'
  else
    ssh $ADHOC -t 'exec zsh'
  fi
}
