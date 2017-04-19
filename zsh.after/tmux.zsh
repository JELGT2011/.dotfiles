
alias tmux="export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock; tmux"

function attach() {
  if [[ "$1" != "" ]]; then
    tmux -CC a -t "$1"
  fi
}
