
alias tmux="export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock; tmux"

function attach() {
  tmux -CC a -t "$1"
}
