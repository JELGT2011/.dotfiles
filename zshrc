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
alias claude-chad="CLAUDE_CONFIG_DIR=~/.claude-chad claude"

# opencode profiles — each swaps config + data dirs for isolated auth/billing,
# MCP OAuth, and sessions; plain `opencode` stays the bare default
alias opencode-personal="XDG_CONFIG_HOME=~/.config/opencode-personal XDG_DATA_HOME=~/.local/share/opencode-personal opencode"
alias opencode-chad="env -u GOOGLE_CLOUD_PROJECT -u GCLOUD_PROJECT -u VERTEX_LOCATION -u GOOGLE_CLOUD_LOCATION XDG_CONFIG_HOME=$HOME/.config/opencode-chad XDG_DATA_HOME=$HOME/.local/share/opencode-chad CLOUDSDK_CONFIG=$HOME/.config/gcloud-chad GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud-chad/application_default_credentials.json opencode"
alias opencode-chaima="XDG_CONFIG_HOME=~/.config/opencode-chaima XDG_DATA_HOME=~/.local/share/opencode-chaima XDG_STATE_HOME=~/.local/state/opencode-chaima XDG_CACHE_HOME=~/.cache/opencode-chaima CLOUDSDK_CONFIG=~/.config/gcloud-chaima GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud-chaima/application_default_credentials.json GOOGLE_CLOUD_PROJECT=chaima-agent-orchestrator GCLOUD_PROJECT=chaima-agent-orchestrator VERTEX_LOCATION=global GOOGLE_CLOUD_LOCATION=global opencode"

# azure profiles — each swaps AZURE_CONFIG_DIR for isolated login/token
# cache/config/bicep; bare `az` is blocked so auth is always profile-scoped
alias az-personal="AZURE_CONFIG_DIR=~/.azure-personal command az"
alias az-chad="AZURE_CONFIG_DIR=~/.azure-chad command az"
az() { print -u2 "az: bare use disabled — use az-personal or az-chad"; return 1 }

# gcloud profiles — each swaps CLOUDSDK_CONFIG for isolated credentials, ADC,
# and config; bare `gcloud` is blocked so auth is always profile-scoped
alias gcloud-personal="CLOUDSDK_CONFIG=~/.config/gcloud-personal command gcloud"
alias gcloud-chad="CLOUDSDK_CONFIG=~/.config/gcloud-chad command gcloud"
alias gcloud-chaima="CLOUDSDK_CONFIG=~/.config/gcloud-chaima command gcloud"
gcloud() { print -u2 "gcloud: bare use disabled — use gcloud-personal, gcloud-chad, or gcloud-chaima"; return 1 }

# chad PR sanity reviewer — terse Claude review, fired by a GitHub webhook when
# JELGT2011 is requested on a chad-af PR. `chad-pr-reviewer` for start/stop/status.
alias chad-pr-reviewer="~/.chad-pr-reviewer/bin/ctl.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#gcloud})

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jlibbey/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/path.zsh.inc'; fi

# gcloud completion disabled — uncomment if needed
# if [ -f '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jlibbey/google-cloud-sdk/completion.zsh.inc'; fi

# Read-only local Slack website bridge status.
alias chad-slack="$HOME/.local/bin/chad-slack"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
