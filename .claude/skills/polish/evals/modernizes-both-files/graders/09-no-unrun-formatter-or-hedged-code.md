---
type: regex
pattern: 'Source:[^\n]*(?:gofmt -s|\b\w+-(?:style|adjacent)\b|would be (?:gosimple|staticcheck))|Source:\s*(?:clearer|more readable)\b'
match: not_contains
---

No source is a formatter the repository does not run (`gofmt -s`), a hedged
check code ("S1011-style", "the linter would be gosimple"), or taste alone.
