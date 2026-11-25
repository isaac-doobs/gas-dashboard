#!/bin/zsh
# Stamp a new app version, commit and push to isaac-doobs/gas-dashboard (personal account),
# then switch gh back to the previously active account.
set -e
cd "$(dirname "$0")"
V=$(date +%Y%m%d%H%M%S)
sed -i '' -E "s/^(<meta name=\"app-version\" content=\")[^\"]*(\">)$/\1$V\2/" index.html
grep -q "^<meta name=\"app-version\" content=\"$V\">$" index.html
# refuse to publish if the app code no longer parses
CHECK="${TMPDIR:-/tmp}/gas-app-check-$$.js"
awk '/<script>/{f=1;next}/<\/script>/{f=0}f' index.html > "$CHECK" && node --check "$CHECK"; rm -f "$CHECK"
git add index.html "$@"
git commit -q -m "${MSG:-Update app} (v$V)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
PREV=$(gh api user --jq .login)
trap 'gh auth switch --hostname github.com --user "$PREV" >/dev/null 2>&1' EXIT INT TERM # always switch back, even if interrupted
gh auth switch --hostname github.com --user isaac-doobs >/dev/null
git push -q origin main
echo "published v$V"
