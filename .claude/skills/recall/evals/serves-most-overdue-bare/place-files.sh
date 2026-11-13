#!/usr/bin/env bash
#
# A repository where 0217 was committed ten days ago, 0242 four days ago and
# 0001 today, and nothing has been recalled yet.

set -eu

cp -R "$(dirname "$0")/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
printf '/.recall/\n' >.gitignore
git add .gitignore lists
git commit --quiet --date="30 days ago" -m "docs: add the list"
git add problems/0217-contains-duplicate
git commit --quiet --date="10 days ago" -m "feat: add 0217 contains duplicate"
git add problems/0242-valid-anagram
git commit --quiet --date="4 days ago" -m "feat: add 0242 valid anagram"
git add problems/0001-two-sum
git commit --quiet -m "feat: add 0001 two sum"
