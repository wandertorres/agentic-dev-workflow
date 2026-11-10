#!/usr/bin/env bash
# Usage: pr-merge.sh <pr-number>
# Squash-merges and deletes the branch, only after the approval check passes.
set -euo pipefail
dir=$(dirname "$0")
pr=${1:?pr-number}
"$dir/pr-check-approval.sh" "$pr"
gh pr merge "$pr" --squash --delete-branch
