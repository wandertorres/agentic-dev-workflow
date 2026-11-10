#!/usr/bin/env bash
# Usage: state.sh list | read <slug> | write <slug> (content on stdin) | delete <slug>
# Per-slug state, in the git common dir, so every worktree sees the same files.
set -euo pipefail
dir="$(git rev-parse --path-format=absolute --git-common-dir)/orchestration/state"
mkdir -p "$dir"
cmd=${1:?list, read, write or delete}
case "$cmd" in
  list) ls -1 "$dir" | sed 's/\.md$//' ;;
  read) cat "$dir/${2:?slug}.md" ;;
  write) cat > "$dir/${2:?slug}.md" ;;
  delete) rm -f "$dir/${2:?slug}.md" ;;
  *) echo "erro: comando desconhecido: $cmd" >&2; exit 1 ;;
esac
