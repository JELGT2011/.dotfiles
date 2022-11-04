
eval "$(nodenv init -)"

eval "$(pyenv init -)"

eval "$(rbenv init -)"

eval "$(goenv init -)"
export GOENV_ROOT="${HOME}/.goenv"
export PATH="${GOENV_ROOT}/bin:${PATH}"
