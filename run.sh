#!/usr/bin/env bash
set -euo pipefail

MEDIUM_USER_NAME="suman.maity112"

_import_from_medium(){
  bundle exec jekyll import medium --username "${MEDIUM_USER_NAME}" --canonical_link true
}

_commit_as_github_action(){
  git add .
  if ! (git diff --staged --quiet --exit-code); then
      git config --global user.name "GitHub Actions"
      git commit -m 'Import blogs from medium'
  fi
}

_serve(){
  bundle install
  bundle exec jekyll serve -o --livereload --host 0.0.0.0 "$@"
}

_serve_using_docker() {
  docker run --rm -d -p 4000:4000 -p 35729:35729 -v "$PWD":/usr/src/app -w /usr/src/app --name "ruby-$(cat .ruby-version)" "ruby:$(cat .ruby-version)" ./run.sh serve "$@"
  docker logs "ruby-$(cat .ruby-version)" -f
}

_usage() {
    cat <<EOF
Usage: $0 command

commands:
  import-from-medium            Import posts from Medium using RSS feed
  commit-as-github-action       Commit the changes as GitHub action user. This will be used only in workflow
  serve                         Run development server
  serve-using-docker            Use docker to run development server
EOF
  exit 1
}

CMD=${1:-}
shift || true
case ${CMD} in
  import-from-medium) _import_from_medium ;;
  commit-as-github-action) _commit_as_github_action ;;
  serve) _serve "$@" ;;
  serve-using-docker) _serve_using_docker "$@" ;;
  *) _usage ;;
esac
