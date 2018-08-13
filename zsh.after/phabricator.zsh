
export PATH="${PATH}:${HOME}/Repositories/arcanist/bin/"

source "${HOME}/Repositories/arcanist/resources/shell"

function ad() {
  arc diff --reviewers=marketplace-experimentation --verbatim
}
