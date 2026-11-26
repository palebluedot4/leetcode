---
type: regex
pattern: '## solution\.(?:go|py)\n+(?:- [^\n]*(?:Complexity|Source):[^\n]*\n)*- (?![^\n]*(?:Complexity|Source):)[^\n]*'
match: not_contains
---

Every bullet under a file's heading carries a `Source:` label. A regex, not
a judge: the eval's judge answers in one word, and on this check its votes
split on the same report (see `evals/results.md`).
