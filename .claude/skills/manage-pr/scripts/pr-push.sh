#!/usr/bin/env bash
# Usage: pr-push.sh --current
# Pushes the current branch to origin. Refuses protected branches and never forces.
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_feature_branch
git push --set-upstream origin "HEAD:refs/heads/$(current_branch)"
