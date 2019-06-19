
source ~/.secrets.zsh

export PATH="${PATH}:${HOME}/bin/"

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_HOME="/usr/local/share/android-sdk"
export GRADLE_HOME="/usr/local/bin/gradle"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"

# give each terminal its own history: https://linux.die.net/man/1/zshoptions
unsetopt inc_append_history
unsetopt share_history

function kill-port() {
  kill $(lsof -t -i :${1})
}

function git-prune-local() {
  local branches=$(git branch --no-color --format='%(refname:short)')
}

alias gpl=git-prune-local
