---
type: regex
target:
  source: file
  path: .recall/0242-valid-anagram/solution.go
pattern: '^package leetcode\s+func isAnagram\(s string, t string\) bool \{\s*\}\s*$'
match: contains
---

The next Go draft holds only the package line and isAnagram's signature with
an empty body.
