#!/usr/bin/env bash
#
# A repository where 1929 is committed and 0217 is begun but not committed.
# AGENTS.md comes from the repository this case lives in, five levels up, so
# it never drifts.

set -eu

here=$(dirname "$0")
root=$(cd "${here}/../../../../.." && pwd)
cp "${root}/AGENTS.md" .
cp -R "${here}/files/." .

git init --quiet
git config user.name eval
git config user.email eval@example.com
git add AGENTS.md lists
git commit --quiet -m "docs: add the list"

mkdir -p problems/1929-concatenation-of-array
printf 'package leetcode\n\nfunc getConcatenation(nums []int) []int {\n\treturn append(nums, nums...)\n}\n' \
	>problems/1929-concatenation-of-array/solution.go
printf 'class Solution:\n    def getConcatenation(self, nums: list[int]) -> list[int]:\n        return nums * 2\n' \
	>problems/1929-concatenation-of-array/solution.py
git add problems/1929-concatenation-of-array
git commit --quiet -m "feat: add 1929 concatenation of array"
