
export HOMEBREW_NO_SANDBOX=1
export PATH="/opt/homebrew/bin:${PATH}"

function brew-upgrade() {
    brew update && brew upgrade
}
