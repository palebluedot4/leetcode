#!/usr/bin/env bash
#
# A repository whose only solved problem, 0217, was committed today.

set -eu

cp -R "$(dirname "$0")/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
printf '/.recall/\n' >.gitignore
git add .gitignore lists
git commit --quiet --date="30 days ago" -m "docs: add the list"
git add problems/0217-contains-duplicate
git commit --quiet -m "feat: add 0217 contains duplicate"
