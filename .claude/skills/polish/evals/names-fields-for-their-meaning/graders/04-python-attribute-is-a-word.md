---
type: regex
target:
  source: file
  path: problems/0706-design-hashmap/solution.py
pattern: "self\\.b\\b"
match: not_contains
---

solution.py no longer names its bucket list `self.b`.
