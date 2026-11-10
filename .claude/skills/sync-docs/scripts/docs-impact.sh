#!/usr/bin/env bash
# Usage: docs-impact.sh <base>
# Prints "sem impacto" or "analisar", plus the reasons. Costs no tokens.
# Analyze only if the diff touches a path covered by docs/README.md,
# or adds a file outside tests. specs/ never counts.
set -euo pipefail
base=${1:?base}
git rev-parse --verify --quiet "$base^{commit}" >/dev/null || base="origin/$base"
git rev-parse --verify --quiet "$base^{commit}" >/dev/null || { echo "erro: base não encontrada: $1" >&2; exit 1; }
index=docs/README.md
is_test() { [[ "$1" =~ (^|/)(tests?|__tests__)/ || "$1" =~ \.(test|spec)\.[^/]+$ || "$1" =~ _test\.[^/]+$ ]]; }
reasons=()

# while read instead of mapfile: macOS ships bash 3.2, which has no mapfile.
covered=()
while IFS= read -r c; do covered+=("$c"); done < <(awk -F'|' '/^\|/ && NR>2 {print $4}' "$index" 2>/dev/null | grep -o '`[^`]*`' | tr -d '`' || true)

while IFS=$'\t' read -r status path; do
  [[ -z "${path:-}" || "$path" == specs/* ]] && continue
  if [[ "$status" == A* ]] && ! is_test "$path"; then reasons+=("novo: $path"); continue; fi
  for c in "${covered[@]:-}"; do
    [[ -n "$c" && ( "$path" == "$c" || "$path" == "${c%/}"/* ) ]] && { reasons+=("coberto por $c: $path"); break; }
  done
done <<<"$(git diff --name-status --no-renames "$base...HEAD")"

if ((${#reasons[@]})); then echo analisar; printf '%s\n' "${reasons[@]}"; else echo "sem impacto"; fi
