
eval "$(jenv init -)"
# eval "$(nodenv init -)"
eval "$(pyenv init -)"
eval "$(rbenv init -)"

alias act="source env/bin/activate"

# use nvm for now
export NVM_DIR="$HOME/.nvm"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

