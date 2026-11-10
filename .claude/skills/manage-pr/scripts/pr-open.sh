#!/usr/bin/env bash
# Usage: pr-open.sh <base> <title> <body-file>
# Pushes and opens a PR, requesting review from the first reviewer in reviewers.txt
# who is not the current user.
set -euo pipefail
dir=$(dirname "$0"); source "$dir/lib.sh"
base=${1:?base}; title=${2:?title}; body=${3:?body-file}
require_feature_branch
me=$(gh api user --jq .login)
reviewer=$(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$dir/../reviewers.txt" | grep -vxF "$me" | head -1 || true)
[[ -n "$reviewer" ]] || { echo "erro: nenhum revisor além de $me em reviewers.txt" >&2; exit 1; }
"$dir/pr-push.sh" --current
gh pr create --base "$base" --head "$(current_branch)" --title "$title" --body-file "$body" --reviewer "$reviewer"
