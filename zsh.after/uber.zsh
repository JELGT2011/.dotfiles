
export VAGRANTNAME="spyker-journey-4"
export PROJECTNAME="ufs"
export ADHOCNAME="adhoc05-sjc1"

alias uber-dev-vagrants="boxer list_vagrants --owner=$UBER_OWNER"
alias uber-dev-ssh="ssh uber@$VAGRANTNAME.dev -t 'exec zsh'"
alias uber-dev-db="mysql -uuber -puber"
alias uber-dev-activate="source ~/$PROJECTNAME/env/bin/activate"
alias uber-dev-sync="boxer sync $VAGRANTNAME uber/$PROJECTNAME"
alias uber-dev-pycharm="ssh -YC4 uber@$VAGRANTNAME.dev charm"
alias uber-dev-relink="ln -S ~/Uber/sync/$VAGRANTNAME.dev.uber.com/home/uber/ ~/Repositories/"

alias uber-adhoc-ssh="ssh $ADHOCNAME -t 'exec zsh'"
