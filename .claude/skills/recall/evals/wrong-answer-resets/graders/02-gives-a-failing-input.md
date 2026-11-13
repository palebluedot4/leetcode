---
type: llm
focus: trace
weight: 1
---

The grading reply says the solution is wrong and gives a concrete input on
which `set(s) == set(t)` returns true while the answer is false (the same
letters with different counts, such as s = "aab", t = "abb", or strings of
different lengths), explains that a set loses how often each letter occurs,
and shows the committed solution.
