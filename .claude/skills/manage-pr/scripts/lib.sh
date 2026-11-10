# Shared helpers for the manage-pr scripts.
# Branch names come from .claude/workflow.conf; the defaults below apply if it is missing.
BASE_BRANCH="dev"
PROTECTED_BRANCHES="main dev"
_conf="$(git rev-parse --show-toplevel)/.claude/workflow.conf"
# shellcheck source=/dev/null
[[ -f "$_conf" ]] && source "$_conf"
current_branch() { git branch --show-current; }
require_feature_branch() {
  local branch; branch=$(current_branch)
  [[ -n "$branch" ]] || { echo "erro: HEAD destacado" >&2; exit 1; }
  for p in $PROTECTED_BRANCHES; do
    [[ "$branch" != "$p" ]] || { echo "erro: operação proibida em $p" >&2; exit 1; }
  done
}
