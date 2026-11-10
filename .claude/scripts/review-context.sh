#!/usr/bin/env bash
# Usage: review-context.sh <slug> <base>
# Writes the review material, without specs/, to a local folder and prints its path.
set -euo pipefail
slug=${1:?slug}; base=${2:?base}
git rev-parse --verify --quiet "$base^{commit}" >/dev/null || base="origin/$base"
git rev-parse --verify --quiet "$base^{commit}" >/dev/null || { echo "erro: base não encontrada: $2" >&2; exit 1; }
out=".work/reviews/$slug"
mkdir -p "$out"
range="$base...HEAD"
git ls-files > "$out/files.txt"
git log --format='%h %s' "$base..HEAD" > "$out/commits.txt"
git diff --stat "$range" -- . ':(exclude)specs/**' > "$out/diffstat.txt"
git diff "$range" -- . ':(exclude)specs/**' > "$out/diff.patch"
echo "$out"
