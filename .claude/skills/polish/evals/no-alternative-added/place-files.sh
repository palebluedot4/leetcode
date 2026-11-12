#!/usr/bin/env bash
#
# The case's solutions, and the repository files /polish reads, copied from
# the repository this case lives in, five levels up, so they never drift.

set -eu

here=$(dirname "$0")
root=$(cd "${here}/../../../../.." && pwd)
cp "${root}/AGENTS.md" "${root}/go.mod" "${root}/pyproject.toml" "${root}/.golangci.yml" .
cp -R "${here}/files/." .
