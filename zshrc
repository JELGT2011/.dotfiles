# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme"
source "${HOME}/.secrets.zsh"

export HOMEBREW_NO_SANDBOX=1
export HOMEBREW_NO_ENV_HINTS=1
export DISABLE_CORRECTION="true"

# give each terminal its own history: https://linux.die.net/man/1/zshoptions
unsetopt inc_append_history
unsetopt share_history

export PATH="/usr/local/bin:${PATH}"
export PATH="${HOME}/bin:${PATH}"
export PATH="/opt/homebrew/bin:${PATH}"

export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

eval "$(nodenv init -)"

# pyenv disabled — uncomment if needed
# eval "$(pyenv init -)"
# eval "$(rbenv init -)"

alias gc="git commit"
alias gs="git status"
alias gps="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias ga="git add"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jlibbey/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/path.zsh.inc'; fi

# gcloud completion disabled — uncomment if needed
# if [ -f '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc'; fi
