# 14. Longest Common Prefix

https://leetcode.com/problems/longest-common-prefix/

Read the input as columns rather than as strings: column `i` survives only if
every string agrees there, and the first column that disagrees ends the answer.

| Language   | Time   | Space |
| ---------- | ------ | ----- |
| Go         | O(n·m) | O(1)  |
| Python     | O(n·m) | O(n)  |
| TypeScript | O(n·m) | O(1)  |

`n` is the number of strings and `m` the length of the answer. Confirming a
prefix of length `m` means reading `m` characters of every string, so O(n·m) is
the problem's lower bound and not a cost of scanning by column.

Python reads the columns with `zip`, which materialises one tuple of `n`
characters at a time; Go and TypeScript index in place.
