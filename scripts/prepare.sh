#!/bin/sh
# Holt Upstream auf den Commit aus upstream.conf und wendet patches/*.patch an.
# Ergebnis: upstream/ auf Branch netfix, ein Commit pro Patch.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
repo=$(sed -n 's/^repo=//p' "$root/upstream.conf")
commit=$(sed -n 's/^commit=//p' "$root/upstream.conf")
dir="$root/upstream"

if [ ! -d "$dir/.git" ]; then
	git clone --filter=blob:none "$repo" "$dir"
fi

cd "$dir"
if [ -n "$(git status --porcelain)" ]; then
	echo "upstream/ hat lokale Änderungen, erst sichern oder verwerfen." >&2
	exit 1
fi

git cat-file -e "$commit^{commit}" 2>/dev/null || git fetch origin
git checkout -q -B netfix "$commit"

set -- "$root"/patches/*.patch
if [ -e "$1" ]; then
	git am -q --keep-cr --committer-date-is-author-date "$@"
fi

echo "upstream/ auf $(git rev-parse --short "$commit") plus $(git rev-list --count "$commit"..HEAD) Patch(es)."
