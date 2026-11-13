#!/usr/bin/env bash
#
# A repository with the rules and the list committed, and 0001's accepted but
# dated solutions not. The rules come from the repository this case lives in,
# five levels up, so they never drift; /polish, which /done invokes, is loaded
# as a second plugin by prompt.md.

set -eu

here=$(dirname "$0")
root=$(cd "${here}/../../../../.." && pwd)
cp "${root}/AGENTS.md" "${root}/go.mod" "${root}/pyproject.toml" "${root}/.golangci.yml" .
cp -R "${here}/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
git add AGENTS.md go.mod pyproject.toml .golangci.yml lists
git commit --quiet -m "docs: add the rules and the list"
