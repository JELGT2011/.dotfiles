
export VAGRANTNAME="millennium-falcon"
export PROJECTNAME="ufs"
export ADHOCNAME="adhoc05-sjc1"

alias uber-vagrants="boxer list_vagrants --owner=$UBER_OWNER"
alias uber-ssh="ssh uber@$VAGRANTNAME.dev -t 'exec zsh'"
alias uber-db="mysql -uuber -puber"
alias uber-activate="source ~/$PROJECTNAME/env/bin/activate"
alias uber-env="source ~/$PROJECTNAME/env/bin/activate"
alias uber-venv="source ~/$PROJECTNAME/env/bin/activate"
alias uber-sync="boxer sync $VAGRANTNAME uber/$PROJECTNAME"
alias uber-dev-relink="ln -S ~/Uber/sync/$VAGRANTNAME.dev.uber.com/home/uber/ ~/Repositories/"

alias uber-adhoc="ssh $ADHOCNAME -t 'exec zsh'"
