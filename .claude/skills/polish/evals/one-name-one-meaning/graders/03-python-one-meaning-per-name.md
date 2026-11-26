---
type: regex
target:
  source: file
  path: problems/0912-sort-an-array/solution.py
pattern: "def sift_down\\(i: int, n: int\\)"
match: not_contains
---

solution.py's nested function no longer names the heap's end `n`, the name
the method gives the list's length.
