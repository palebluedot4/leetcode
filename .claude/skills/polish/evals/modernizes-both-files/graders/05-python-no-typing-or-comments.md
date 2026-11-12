---
type: regex
target:
  source: file
  path: problems/0347-top-k-frequent-elements/solution.py
pattern: "from typing|#"
match: not_contains
---

solution.py imports nothing from typing and contains no comments.
