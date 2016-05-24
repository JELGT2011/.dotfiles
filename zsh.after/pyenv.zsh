
# Use Homebrew's directories rather than ~/.pyenv
export PYENV_ROOT="/usr/local/var/pyenv"

# Enable shims and autocompletion
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

