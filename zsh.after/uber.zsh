
export VAGRANTNAME="spyker-journey-4"
export PROJECTNAME="ufs"

alias uber-list-vagrants="boxer list_vagrants --owner=$UBER_OWNER"
alias uber-dev-ssh="boxer v $VAGRANTNAME"
alias uber-dev-sql="mysql -uuber -puber"
alias uber-adhoc-ssh="ssh adhoc05-sjc1"
alias uber-dev="cd $PROJECTNAME && source env/bin/activate"
alias uber-dev-sync="boxer sync $VAGRANTNAME uber/$PROJECTNAME"
alias uber-remote-pycharm="ssh -YC4 uber@$VAGRANTNAME.dev charm"
alias uber-relink="ln -S ~/Uber/sync/$VAGRANTNAME.dev.uber.com/home/uber/ ~/Repositories/"
