
source ~/.secrets.zsh

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_HOME="/usr/local/share/android-sdk"
export GRADLE_HOME="/usr/local/bin/gradle"

function kill-port() {
  kill $(lsof -t -i :${1})
}
