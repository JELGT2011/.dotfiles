
# notes

# /usr/local/bin/virtualenvwrapper.sh:50
# VIRTUALENVWRAPPER_PYTHON="$(command \which python)"
# changed to
# VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python"
#
# gitconfig.user may not be imported correctly on uber's config
#
# login to mysql:
# mysql -uuber -puber

export VAGRANTNAME="spyker-journey-4"
export CURRENTPROJECT="ufs"

alias uber-list-vagrants="boxer list_vagrants --owner=$UBER_OWNER"
alias uber-dev-ssh="boxer v $VAGRANTNAME"
alias uber-dev="cd $CURRENTPROJECT && source env/bin/activate"
alias uber-dev-sync="boxer sync $VAGRANTNAME $CURRENTPROJECT"
alias uber-relink="ln -S ~/Uber/sync/$VAGRANTNAME.dev.uber.com/home/uber/ ~/Repositories/"
