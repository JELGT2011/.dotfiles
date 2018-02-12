
alias loadjenv='eval "$(jenv init -)"'
alias loadnodenv='eval "$(nodenv init -)"'
alias loadpyenv='eval "$(pyenv init -)"'
alias loadrbenv='eval "$(rbenv init -)"'

loadpyenv

alias act="source env/bin/activate"

# use nvm for now
export NVM_DIR="$HOME/.nvm"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'
