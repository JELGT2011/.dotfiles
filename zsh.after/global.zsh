
source ~/.secrets.zsh

export PATH="${PATH}:${HOME}/bin/"

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_HOME="/usr/local/share/android-sdk"
export GRADLE_HOME="/usr/local/bin/gradle"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"

function kill-port() {
  kill $(lsof -t -i :${1})
}
