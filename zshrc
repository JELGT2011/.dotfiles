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

. "$(brew --prefix z)/etc/profile.d/z.sh"

eval "$(nodenv init -)"
eval "$(pyenv init -)"
# eval "$(rbenv init -)"

alias gc="git commit"
alias gs="git status"
alias gps="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias ga="git add"

alias claude-personal="CLAUDE_CONFIG_DIR=~/.claude-personal claude"
alias claude-clevermore="CLAUDE_CONFIG_DIR=~/.claude-clevermore claude"
alias claude-chad="CLAUDE_CONFIG_DIR=~/.claude-chad claude"

# opencode profiles — each swaps config + data dirs for isolated auth/billing,
# MCP OAuth, and sessions; plain `opencode` stays the bare default
alias opencode-personal="XDG_CONFIG_HOME=~/.config/opencode-personal XDG_DATA_HOME=~/.local/share/opencode-personal opencode"
alias opencode-clevermore="XDG_CONFIG_HOME=~/.config/opencode-clevermore XDG_DATA_HOME=~/.local/share/opencode-clevermore opencode"
alias opencode-chad="XDG_CONFIG_HOME=~/.config/opencode-chad XDG_DATA_HOME=~/.local/share/opencode-chad opencode"

# isolated Azure CLI session for JINZO — separate login/token cache/bicep from ~/.azure
alias az-jinzo="AZURE_CONFIG_DIR=~/.azure-jinzo az"

# chad PR sanity reviewer — terse Claude review, fired by a GitHub webhook when
# JELGT2011 is requested on a chad-af PR. `chad-pr-reviewer` for start/stop/status.
alias chad-pr-reviewer="~/.chad-pr-reviewer/bin/ctl.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jlibbey/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/path.zsh.inc'; fi

# gcloud completion disabled — uncomment if needed
# if [ -f '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc'; fi
