---
type: llm
focus: last_message
weight: 1
---

The report lists its changes under a heading per file, and every listed
change carries a justification. An algorithm change states its old and new
complexity. Each other change names an authority: a rule in the repository's
AGENTS.md; a section of the language spec, of Effective Go, of Go Code
Review Comments or of a Google style guide; a PEP; a library documentation
page; a linter by name (such as gocritic, modernize or staticcheck) or a
ruff rule set or rule; or what pyright's strict mode requires. Something
that disappeared only because the algorithm changed, such as an import,
comparator or lambda the new code no longer needs, is covered by the
algorithm change's justification. A check code hedged into something vague
("S1011-style", "S1005-adjacent") does not count. Judge only whether each
change names such a justification, not whether the section cited is the best
one.
