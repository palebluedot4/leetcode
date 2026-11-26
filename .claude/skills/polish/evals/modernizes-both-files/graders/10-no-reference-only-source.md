---
type: regex
pattern: '^- [^\n]*Source: `?references\/(?:go|python)\.md`?(?![^\n]*(?:Effective Go|Code Review Comments|Google|Decisions|Guide|Best Practices|PEP|pyguide|Tutorial|FAQ|docs|documentation|spec|AGENTS\.md|this repository))[^\n]*$'
flags: m
match: not_contains
---

No bullet cites a reference file alone for a rule the file takes from a
guide; it names the guide. Only a rule marked as this repository's own may
cite the reference file by itself.
