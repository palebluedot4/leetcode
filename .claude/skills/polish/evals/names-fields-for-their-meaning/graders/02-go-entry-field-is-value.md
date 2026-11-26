---
type: regex
target:
  source: file
  path: problems/0706-design-hashmap/solution.go
pattern: "\\bval\\b"
match: not_contains
---

solution.go names the entry's field `value`, as LeetCode names the parameter
it holds, not `val`.
