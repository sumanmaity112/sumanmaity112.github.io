#!/usr/bin/env bash
set -euo pipefail

MEDIUM_USER_NAME="suman.maity112"

_import_from_medium(){
  bundle exec jekyll import medium --username "${MEDIUM_USER_NAME}"
}

_commit_as_github_action(){
  git add .
  if ! (git diff --staged --quiet --exit-code); then
      git config --global user.name "GitHub Actions"
      git commit -m 'Import blogs from medium'
  fi
}

_usage() {
    cat <<EOF
Usage: $0 command

commands:
  import-from-medium            Import posts from Medium using RSS feed
  commit-as-github-action       Commit the changes as GitHub action user. This will be used only in workflow
EOF
  exit 1
}

CMD=${1:-}
shift || true
case ${CMD} in
  import-from-medium) _import_from_medium ;;
  commit-as-github-action) _commit_as_github_action ;;
  *) _usage ;;
esac
