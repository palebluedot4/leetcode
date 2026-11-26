---
type: regex
target:
  source: file
  path: problems/0912-sort-an-array/solution.py
pattern: "range\\(.*, -1\\)"
match: not_contains
---

solution.py no longer counts down with a negative `range` step.
