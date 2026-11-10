#!/usr/bin/env bash
# Usage: pr-check-approval.sh <pr-number>
# Exit 0 only if someone other than the author approved, nobody has pending
# changes requested, and commits after the approval touch only specs/.
set -euo pipefail
pr=${1:?pr-number}
author=$(gh api "repos/{owner}/{repo}/pulls/$pr" --jq .user.login)
head=$(gh api "repos/{owner}/{repo}/pulls/$pr" --jq .head.sha)
# Latest decisive review per person, in chronological order: login state commit.
latest=$(gh api --paginate "repos/{owner}/{repo}/pulls/$pr/reviews" \
  --jq '.[] | select(.state != "COMMENTED" and .state != "PENDING") | "\(.user.login) \(.state) \(.commit_id)"' \
  | awk '{l[$1]=$0} END {for (k in l) print l[k]}')
if grep -q ' CHANGES_REQUESTED ' <<<"$latest"; then echo "reprovado: há ajustes pedidos"; exit 1; fi
approval=$(awk -v a="$author" '$1 != a && $2 == "APPROVED"' <<<"$latest" | head -1)
[[ -n "$approval" ]] || { echo "reprovado: sem aprovação de alguém que não seja $author"; exit 1; }
approved_sha=$(awk '{print $3}' <<<"$approval")
if [[ "$approved_sha" != "$head" ]]; then
  git cat-file -e "$approved_sha^{commit}" 2>/dev/null || git fetch --quiet origin "pull/$pr/head"
  extra=$(git diff --name-only "$approved_sha" "$head" | grep -v '^specs/' || true)
  [[ -z "$extra" ]] || { echo "reprovado: commits após a aprovação mudaram:"; echo "$extra"; exit 1; }
fi
echo "aprovado por $(awk '{print $1}' <<<"$approval")"
