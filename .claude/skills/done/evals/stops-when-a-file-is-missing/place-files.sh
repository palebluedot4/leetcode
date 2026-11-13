#!/usr/bin/env bash
#
# A repository with the rules and the list committed, and 0242 solved in Go
# only. AGENTS.md comes from the repository this case lives in, five levels
# up, so it never drifts.

set -eu

here=$(dirname "$0")
root=$(cd "${here}/../../../../.." && pwd)
cp "${root}/AGENTS.md" .
cp -R "${here}/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
git add AGENTS.md lists
git commit --quiet -m "docs: add the rules and the list"
