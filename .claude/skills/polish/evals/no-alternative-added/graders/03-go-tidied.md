---
type: regex
target:
  source: file
  path: problems/0009-palindrome-number/solution.go
pattern: "else|x = x / 10"
match: not_contains
---

solution.go no longer has the if/else around its result or `x = x / 10`.
