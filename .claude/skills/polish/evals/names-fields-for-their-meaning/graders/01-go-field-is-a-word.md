---
type: regex
target:
  source: file
  path: problems/0706-design-hashmap/solution.go
pattern: "\\.b\\["
match: not_contains
---

solution.go no longer names the struct's bucket array `b`.
