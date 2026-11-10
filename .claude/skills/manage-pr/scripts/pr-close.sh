#!/usr/bin/env bash
# Usage: pr-close.sh <pr-number>
set -euo pipefail
gh pr close "${1:?pr-number}"
