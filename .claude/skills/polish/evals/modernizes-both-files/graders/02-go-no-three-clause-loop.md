---
type: regex
target:
  source: file
  path: problems/0347-top-k-frequent-elements/solution.go
pattern: "for i := 0; i < len"
match: not_contains
---

solution.go no longer counts through nums with a three-clause loop.
