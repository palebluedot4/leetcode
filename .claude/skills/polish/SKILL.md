---
name: polish
description: Rewrites an accepted LeetCode solution's solution.go and solution.py to the quality of each language's standard library, using the newest idioms the judge's release allows, and explains every change with the authority behind it. Invoked by the user as /polish <problem number> after the solutions are accepted, and by /done before it commits.
argument-hint: <problem number, e.g. 0217>
---

# Polish

The user has solved a problem and LeetCode accepted it. Your job is to make
each file read as if a maintainer of that language's standard library wrote
it, so that what gets committed is the best version of the idea, not the
first one that passed.

## Before changing anything

1. Find `problems/<number>-*/` from `$ARGUMENTS` and read `solution.go` and
   `solution.py`. If one is missing, polish the one that exists and say so.
   `problems/` and `AGENTS.md` are relative to the working directory, which
   is the repository's root, never to this skill's own directory; only the
   `references/` files below live beside this skill.
2. Read `AGENTS.md`. It holds this repository's rules, and they outrank
   general style advice: the core test (the file must still paste into
   LeetCode and run), the platform contracts (LeetCode owns the entry
   function's name and parameter names, and the types its stub defines;
   Python keeps `class Solution`), the judge's versions, and what never goes
   in a solution (comments, tests, defensive checks). Go's `package` clause
   and `judge.go` are repository scaffolding: leave them as they are.
3. Read the reference for each language you are polishing:
   [references/go.md](references/go.md) and
   [references/python.md](references/python.md). They list what to look for,
   in the order of the authorities in `AGENTS.md`, with the exact section
   names to cite. Open them with Read at their full path under this skill's
   base directory, which is shown when the skill loads; do not search for
   them.
4. Read `.golangci.yml` and the `[tool.ruff]` section of `pyproject.toml`:
   they name the linters and rule sets this repository enables, which are
   the names you may cite.

## What to change

Work through each file on its own terms; the two are separate native
solutions, never translations of each other.

- **Complexity first.** If a better time or space complexity is reachable,
  that matters more than any idiom. Rewrite to it, and say plainly that the
  algorithm changed and from what to what, because the user learned the old
  one. Apply it to both files: an algorithm belongs to the problem, not to
  a language, so sharing one is not translation; writing it in each
  language's own idiom is the job. The one limit: the gain must be real at
  the problem's constraints. One that the constraints bound to a constant
  is not (a 32-bit integer has at most ten digits, so O(log x) space is
  O(1)), and giving up a language's natural form for it is the translation
  `AGENTS.md` forbids. O(n log k) to O(n), with n up to 10⁵, is real.
- **Then idiom and names**: the newest construct the judge's release
  supports, the standard library over hand-rolled code, names in the
  language's own conventions. The reference files say which tools track the
  newest idiom and list, with sources, the rules no tool checks.
- **Keep what is already right.** A change needs a reason a style authority
  would give. If a file is already clean, say so and do not touch it: no
  Edit, and no Write, not even of the same content, since a rewrite is
  indistinguishable from a change until someone diffs it. Churn is not
  polish.
- **Never add a second solution.** If a genuinely different approach (a
  different complexity or trade-off) exists, name it in one line at the end
  and let the user decide.
- **Do not touch** anything outside the two solution files: not `lists/`,
  not other problems, and do not commit.

Edit the files in place. Afterwards run `make check` if the repository's
tools are installed, and fix anything it reports. If it cannot run, do its
job by reading: go through the checks `.golangci.yml` and `pyproject.toml`
enable, such as gocritic's `assignOp` turning `x = x / 10` into `x /= 10`,
and apply what they would report before you finish.

## Report

Keep it short and concrete. Every bullet ends with its justification behind
a fixed label, `Complexity:` or `Source:`, so that a bullet without one
stands out, to you before you send it and to the reader after. A library's
name in the sentence ("replaced with `collections.Counter`") is what
changed, not a source; the source is the label's job.

- **An algorithm change** is justified by the complexity it reaches. What
  goes away only because of it goes in the same bullet: an import, a
  comparator or a lambda the new code no longer needs, and any loop or
  variable that existed only to serve the old algorithm, such as the loop
  that gathered keys for a sort that is gone. Its old flaws need no source
  of their own, since the code that had them no longer exists. A change you would
  make even under the old algorithm, such as `Counter` for a hand-built
  count, is not part of it and gets its own bullet.
- **Every other change** names one authority a reader can look up:
  - a rule in `AGENTS.md`;
  - a section of the language spec, Effective Go, Go Code Review Comments
    or a Google style guide, by the names the reference files use;
  - a PEP, or a library documentation page (`collections.Counter`, not
    "the standard library docs");
  - a linter by the name `.golangci.yml` enables (`gocritic`, `modernize`,
    `staticcheck`), or a ruff rule set by the prefix `pyproject.toml`
    selects (ruff `UP`, pyupgrade);
  - what pyright's strict mode requires.
- **Names, not codes.** Cite a linter by name, never by a check code such as
  S1005 or UP006, unless this session's tool output showed you the code:
  codes are where citations go wrong, and a name is enough to look one up.
  Never hedge one ("S1005-adjacent", "S1011-style"). What a formatter does
  on its own, such as `gofmt -s`, is not an authority; cite the linter that
  reports the same thing.
- **Only what you are sure of.** A wrong citation is worse than a plain
  one; when unsure of a section, name the document alone.

```markdown
## solution.go

- <algorithm change, and what went with it>. Complexity: O(…) → O(…).
- <what changed>. Source: <one authority from the list above>.

## solution.py

- <algorithm change, and what went with it>. Complexity: O(…) → O(…).
- <what changed>. Source: <one authority from the list above>.

<If an alternative is worth knowing: one line.>

Resubmit both files to LeetCode before committing.
```

For example, under `## solution.py`:

```markdown
- A hand-built count dict became `Counter(nums)`. Source: Python library
  docs, `collections.Counter`.
- `List[int]` became `list[int]`, and the `typing` import went. Source:
  `AGENTS.md`, builtin generics; ruff `UP`.
```

A file left as it was gets one line saying so and why, and no bullets.
Anything else worth saying, such as that `make check` could not run, goes
before the last line; nothing comes after it, not even the commit message,
which `AGENTS.md` already covers.

The last line matters: the judge is the only test in this repository, and a
polished file has not been judged yet.
