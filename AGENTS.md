# AGENTS.md

LeetCode solutions in Go and Python, worked through a curated list in order
rather than by problem number. Each problem keeps one final solution per
language, written as a maintainer of that language's standard library would
write it. Everything here, code and commits alike, is in English.

## Commands

| Command                  | What it does                                                                                                                                        |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `make check`             | golangci-lint and `go vet`; ruff and pyright; ShellCheck and shfmt; Prettier and markdownlint. The pre-commit hook runs it on what a commit stages. |
| `make fmt`               | Formats Go, Python, shell, Markdown, YAML and JSON in place.                                                                                        |
| `make setup`             | Once per clone: pinned tools and git hooks. The maintainer runs it outside the sandbox.                                                             |
| `make eval SKILL=<name>` | A skill's evals on Opus and Sonnet. Costs plan usage or API credit; the maintainer runs it.                                                         |

If a tool is missing, say so rather than installing it.

## Where things live

| Path                      | Contents                                                                                                    |
| ------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `lists/`                  | The study order, one file per list, with each problem's progress.                                           |
| `problems/<NNNN>-<slug>/` | `solution.go` and `solution.py`, and `judge.go` where the judge provides a type or function.                |
| `__builtins__.pyi`        | Python declarations of the functions and classes the judge implements, for the checkers.                    |
| `.claude/skills/tutor/`   | `/tutor`: graduated hints for the problem being solved; its evals, and their results in `evals/results.md`. |
| `.claude/skills/polish/`  | `/polish`: rewrites an accepted solution to standard-library quality; its evals and results likewise.       |
| `.claude/skills/next/`    | `/next`: scaffolds the next unsolved problem from LeetCode's stubs; its evals likewise.                     |
| `.claude/skills/recall/`  | `/recall`: the day's re-solving of accepted problems, on a 3, 7 and 21 day schedule; its evals likewise.    |
| `.claude/skills/done/`    | `/done`: polishes an accepted problem and commits each language with its cell; its evals likewise.          |
| `.recall/`                | Gitignored: `/recall`'s log, the schedule's only state, and the draft being recalled.                       |

## The core test

> Would this still paste into LeetCode and run?

The judge is the only oracle: there are no tests. A solution that is elegant,
idiomatic and rejected is not a solution. This test outranks every other rule
in this file; where they conflict, "Platform contracts" records it.

## What this repository deliberately does not do

Agents trained on production code will try to add all of these. Do not.

- **No tests**, no `main`, no `if __name__ == "__main__"`, no doctests.
- **No prose in solution files**: no header, doc or inline comments. No
  per-problem README either; the list a problem sits in, under its pattern's
  heading, is the reminder.
- **No defensive code.** LeetCode guarantees the constraints; nil checks and
  input validation are noise.
- **No abstraction across problems**: no shared helpers or packages. Each file
  stands alone, which is what makes it pasteable.
- **No long names for short ideas.** `l`, `r`, `lo`, `hi`, `dp`, `memo`, `n`,
  `k` are the field's vocabulary.
- **No drafts.** Only the final solution is kept.

## Layout and naming

- A directory is the four-digit, zero-padded problem number, `-`, and the slug
  exactly as it appears in the LeetCode URL: `problems/0217-contains-duplicate/`.
- Files are always `solution.go` and `solution.py`. Every problem gets both.
  A problem whose stub relies on something the judge provides has a
  `judge.go` as well (see "Platform contracts").
- Go: `package leetcode` in every directory. Python: no `__init__.py`.
- Solve in place, in the problem's directory; git is the scratch space, and
  only an accepted solution is committed.

## Style authorities

Where they disagree, the higher one wins, within what the core test permits.

- **Go:** the language spec, `gofmt`, `go vet`; Effective Go; Go Code Review
  Comments; then the Google Go Style Guide (Guide, then Decisions, then Best
  Practices).
- **Python:** the language reference and PEP 8; the `typing` documentation;
  then the Google Python Style Guide.

Three rules on top:

- **Idiomatic, not translated.** The two files read as two native solutions.
  If Python's answer is a `set` where Go's is a `map[T]struct{}`, that is
  correct; a Go loop transcribed into Python is a bug.
- **The newest idiom the judge's release allows.** `modernize` in
  golangci-lint and ruff's `UP` and `FURB` rules enforce much of this; the
  rest is review.
- **Python annotates with builtin generics everywhere**, the entry signature
  included: `list[int]`, `ListNode | None`, no `typing` import for them. A
  stub showing `List[int]` or `Optional[ListNode]` is stale: LeetCode owns
  the signature's names, not its spelling.

## Platform contracts

These are places where the core test beats the style authorities. They are
platform requirements, not style; do not imitate them elsewhere.

- **Python's `class Solution:` wrapper and `self` are required.** Everything
  inside it is ordinary modern Python.
- **LeetCode owns the entry function's name and its parameter names**
  (`isPalindrome`, `twoSum`, `numIslands`). Do not rename them. ruff's
  `N802`/`N803` are off for this; camelCase stops at the entry point, and
  every name the solution declares itself is snake_case in Python.
- **Go's `package` clause is repository scaffolding; the import block is
  not.** LeetCode's Go stub has neither, so `package leetcode` is dropped when
  pasting, but every import the pasted code uses goes with it. The package
  clause never counts against pasteability. Everything below it pastes.
- **What the judge provides is declared for the checkers, never
  reimplemented.** A stub's comment shows two kinds, and Python treats them
  differently:
  - **Data types**: `ListNode`, `TreeNode`, and a problem's own `Node` (Copy
    List with Random Pointer, Clone Graph, Construct Quad Tree). In Python
    the class, copied from the comment and annotated, opens `solution.py`
    and is pasted with it: Python allows a class to be redefined, and the
    copy behaves exactly as the judge's does.
  - **APIs the judge implements**: `guess` (Guess Number Higher or Lower),
    `MountainArray` (Find in Mountain Array). A pasted copy would replace the
    judge's implementation with an empty one, so in Python the declaration
    goes in `__builtins__.pyi` at the root, which pyright reads as builtins,
    and the name in `pyproject.toml`'s `[tool.ruff] builtins`; nothing about
    it is pasted.

  In Go, both kinds go in the problem's `judge.go`, which is never pasted:
  the judge declares them already, and a second declaration does not
  compile. A function the judge implements gets a body of
  `panic("provided by the judge")`; a receiver follows Go's naming, not the
  stub's `this`.

- **Every entry function is unused**, since only LeetCode calls it, so
  golangci-lint's `unused` is disabled in `.golangci.yml`.
- **Premium problems are skipped** until there is a LeetCode subscription;
  their rows in `lists/` say so. They are not solved on another judge.

## Multiple solutions

A second solution earns its place only by a genuine difference in complexity
or trade-off: `isPalindrome` reverses half the digits in O(1) space,
`isPalindromeString` allocates but reads more plainly. A slightly different
way to write the same loop does not qualify. Never add one unasked.

- Same file, primary first, under LeetCode's name.
- The alternative is named for its technique, never an index: Go
  `isPalindromeString`; Python a second method on `Solution`, in snake_case,
  `is_palindrome_string`. Two methods may not share a name.

## Judge versions

LeetCode's judge is the hard ceiling; each toolchain is pinned so newer
syntax or library calls fail locally rather than at the judge.

| Language | Judge       | Pinned in                                                     |
| -------- | ----------- | ------------------------------------------------------------- |
| Go       | Go 1.27     | `go.mod` (`go 1.27`)                                          |
| Python   | Python 3.14 | `pyproject.toml` (`requires-python`, pyright `pythonVersion`) |

`go build` does not reject a standard-library API newer than `go.mod`'s go
line, but `go vet`'s `stdversion` analyzer does, and `modernize` suggests only
what that line allows; so the go line must always equal the judge's release.
pyright's `pythonVersion` gates both syntax and library.

The versions drift as LeetCode upgrades. Its
[environments page](https://support.leetcode.com/hc/en-us/articles/360011833974-What-are-the-environments-for-the-programming-languages)
is the source of truth; update this table and the pinned settings together.

The checkers are pinned too (`Makefile`, `pyproject.toml` with `uv.lock`,
`package.json` with `pnpm-lock.yaml`), so a formatter's minor release cannot
rewrite files nobody touched. A bump is a commit of its own.

When the judge moves to a new release, move with it in one change: the
pinned settings above; golangci-lint, ruff and pyright to versions that know
the release, since they are what keeps "the newest idiom" current; and a
reread of `.claude/skills/polish/references/`, which deliberately lists no
version-specific APIs but cites guides that may have changed.

## Working a problem

1. `/recall` first: the accepted problems due today, each re-solved from a
   blank stub, at most five a day.
2. `/next` scaffolds the next unsolved row in the current list.
3. Write `solution.go`. `/tutor <number>` gives hints, one level at a time.
4. Submit to LeetCode. Accepted is the definition of done.
5. Write `solution.py` from scratch in Python's own idiom; submit it.
6. `/done <number>` runs `/polish`, and you resubmit whatever it changed;
   then it commits each language on its own, filling that language's cell
   in the list with a link to the file:
   `[✓](../problems/0217-contains-duplicate/solution.go)`.

## Commits

Conventional Commits 1.0.0, checked by `.githooks/commit-msg`.

- One commit per language, scoped by it, naming the four-digit problem
  number, so `git log --oneline | grep 0217` finds it:
  `feat(go): add 0217 contains duplicate`. The same commit fills the
  language's cell in `lists/`.
- `feat` adds a solution; `fix` corrects one the judge rejected or that is
  wrong; `perf` changes its complexity class; `refactor` makes it more
  idiomatic at the same complexity.
- Repository-wide changes take no scope: `build:`, `chore:`, `docs:`.
- Lowercase description, imperative, no trailing period, at most 72
  characters in the header.

## Deliberately not doing

| Not doing                 | Until                                                          |
| ------------------------- | -------------------------------------------------------------- |
| A third language          | Learning one.                                                  |
| A list after NeetCode 250 | It is finished; then choose, e.g. 0x3F's rating-ordered lists. |
| A generated index         | Hand-filling `lists/` becomes the bottleneck.                  |
| CI                        | Someone other than the maintainer contributes.                 |
