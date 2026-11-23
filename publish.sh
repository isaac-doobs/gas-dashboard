#!/bin/zsh
# Stamp a new app version, commit and push to isaac-doobs/gas-dashboard (personal account),
# then switch gh back to the previously active account.
set -e
cd "$(dirname "$0")"
V=$(date +%Y%m%d%H%M%S)
sed -i '' -E "s/(name=\"app-version\" content=\")[^\"]*\"/\1$V\"/" index.html
grep -q "content=\"$V\"" index.html
git add index.html "$@"
git commit -q -m "${MSG:-Update app} (v$V)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
PREV=$(gh api user --jq .login)
gh auth switch --hostname github.com --user isaac-doobs >/dev/null
git push -q origin main || { gh auth switch --hostname github.com --user "$PREV" >/dev/null; exit 1; }
gh auth switch --hostname github.com --user "$PREV" >/dev/null
echo "published v$V"
