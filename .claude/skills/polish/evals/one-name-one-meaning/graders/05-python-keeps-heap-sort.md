---
type: regex
target:
  source: file
  path: problems/0912-sort-an-array/solution.py
pattern: "sorted\\(|\\.sort\\("
match: not_contains
---

solution.py still sorts by itself; the problem forbids a built-in sort.
