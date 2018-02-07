
eval "$(jenv init -)"
# conflicts with nvm, which is required at Uber
# eval "$(nodenv init -)"
eval "$(pyenv init -)"
eval "$(rbenv init -)"

alias act="source env/bin/activate"

# use nvm for now
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
