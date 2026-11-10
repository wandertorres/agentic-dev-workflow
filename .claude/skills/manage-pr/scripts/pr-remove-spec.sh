#!/usr/bin/env bash
# Usage: pr-remove-spec.sh <slug>
# Last commit before merge: removes only the spec and pushes. Does not run sync-docs.
set -euo pipefail
dir=$(dirname "$0"); source "$dir/lib.sh"
slug=${1:?slug}
require_feature_branch
[[ -z "$(git status --porcelain --untracked-files=no)" ]] || { echo "erro: há mudanças não commitadas" >&2; exit 1; }
if [[ -d "specs/$slug" ]]; then
  git rm -r --quiet "specs/$slug"
  git commit --quiet -m "chore: remove spec $slug before merge"
fi
"$dir/pr-push.sh" --current
