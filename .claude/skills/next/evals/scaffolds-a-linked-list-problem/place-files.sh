#!/usr/bin/env bash
#
# A repository where every problem before 206 is committed but 271, which is
# Premium. The solutions' content does not matter to /next, only that they
# are committed. AGENTS.md comes from the repository this case lives in, five
# levels up, so it never drifts.

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

for problem in 1929-concatenation-of-array 0217-contains-duplicate 0242-valid-anagram 0001-two-sum; do
	mkdir -p "problems/${problem}"
	printf 'package leetcode\n' >"problems/${problem}/solution.go"
	printf 'class Solution:\n    pass\n' >"problems/${problem}/solution.py"
	git add "problems/${problem}"
	git commit --quiet -m "feat: add ${problem}"
done
