DISABLE_CORRECTION="true"

# shellcheck source=/Users/jlibbey/.secrets.zsh
source "${HOME}/.secrets.zsh"

export PATH="${PATH}:${HOME}/bin/"
export PATH="${PATH}:$(go env GOPATH)/bin"

# give each terminal its own history: https://linux.die.net/man/1/zshoptions
unsetopt inc_append_history
unsetopt share_history
