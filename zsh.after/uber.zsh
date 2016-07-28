
export VAGRANTNAME="spyker-journey-4"
export PROJECTNAME="ufs"

alias uber-list-vagrants="boxer list_vagrants --owner=$UBER_OWNER"
alias uber-dev-ssh="boxer v $VAGRANTNAME"
alias uber-dev-sql="mysql -uuber -puber"
alias uber-adhoc-ssh="boxer v adhoc05-sjc1"
alias uber-dev="cd $PROJECTNAME && source env/bin/activate"
alias uber-dev-sync="boxer sync $VAGRANTNAME $PROJECTNAME"
alias uber-relink="ln -S ~/Uber/sync/$VAGRANTNAME.dev.uber.com/home/uber/ ~/Repositories/"
