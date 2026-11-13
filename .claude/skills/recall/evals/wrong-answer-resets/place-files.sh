#!/usr/bin/env bash
#
# A repository where 0242 was committed four days ago and a recall of it is
# under way in .recall/.

set -eu

cp -R "$(dirname "$0")/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
printf '/.recall/\n' >.gitignore
git add .gitignore lists
git commit --quiet --date="30 days ago" -m "docs: add the list"
git add problems/0242-valid-anagram
git commit --quiet --date="4 days ago" -m "feat: add 0242 valid anagram"
