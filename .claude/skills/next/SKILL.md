---
name: next
description: Scaffolds the next unsolved problem of the study list. It finds the row, fetches LeetCode's Go and Python stubs, and writes problems/<NNNN>-<slug>/ with empty solution files to the repository's conventions. Use when the user asks for the next or a new problem, or accepts the offer of one at the end of /recall or /done.
---

# Next

The user works the study list in order and solves in place. This skill sets
the table: one new problem directory whose files hold LeetCode's stubs,
written the way `AGENTS.md` requires, and nothing of the solution.

Paths here are relative to the working directory, the repository's root. The
script lives beside this skill: run it at its full path under this skill's
base directory, which is shown when the skill loads.

## 1. Find the problem

The study list is the file in `lists/`; if there are several, ask which one
is current. Run:

```bash
python3 <base directory>/scripts/leetcode.py lists/<list>.md
```

It prints JSON. Its `status` decides the rest:

- **`finished`**: every row is solved or skipped. Say so; that is the whole
  reply.
- **`in_progress`**: the problem's directory exists, begun and not yet
  committed. Tell the user which problem it is and that its files are
  untouched, so they can carry on with it. Write nothing.
- **`premium`**: LeetCode reports a Premium problem the list does not mark.
  Add the lock mark right after the row's link, as the other Premium rows
  have it, and run the script again; Premium problems are skipped
  (`AGENTS.md`).
- **`new`**: write the files below from `snippets.golang` and
  `snippets.python3`.

If the script fails, show its error and stop; the stubs come from LeetCode
and nowhere else, since a signature from memory is a guess.

## 2. Write the files

Read `AGENTS.md`'s "Layout and naming" and "Platform contracts" first: they
are the rules these files follow, and this section only applies them to a
stub. Write into the `directory` the script printed:

- **`solution.go`**: `package leetcode`, a blank line, then the Go stub with
  its comment blocks removed and each body left empty. A receiver the stub
  names `this` becomes the type's initial in lower case
  (`func (s *MyHashSet) Add(key int)`), per Go Code Review Comments' Receiver
  Names; the judge does not read receiver names.
- **`solution.py`**: the Python stub with its comments removed, every
  annotation in builtin generics (`list[int]`, `TreeNode | None`), and `pass`
  as each method's body.
- **A data type the stub's comment defines** (`ListNode`, `TreeNode`, a
  problem's own `Node`) goes in two places. In Python, the class from the
  comment, uncommented and fully annotated, opens `solution.py` above
  `class Solution`. In Go, the type goes in `judge.go`, which is
  `package leetcode` and the type, so that `solution.go` pastes without it.
- **An API the judge implements** (`guess`, `MountainArray`: something the
  solution calls rather than receives) goes in `judge.go` for Go, with
  `panic("provided by the judge")` as its body; for Python, its declaration
  goes in `__builtins__.pyi` and its name in `pyproject.toml`'s
  `[tool.ruff] builtins`, unless they are there already.

The stub's usage comment ("Your MyHashSet object will be instantiated and
called as such") is LeetCode's prose and goes nowhere. Every name the stub
declares keeps LeetCode's spelling. For a linked-list problem, the result
looks like this:

```go
package leetcode

type ListNode struct {
	Val  int
	Next *ListNode
}
```

```python
class ListNode:
    def __init__(self, val: int = 0, next: ListNode | None = None) -> None:
        self.val = val
        self.next = next


class Solution:
    def reverseList(self, head: ListNode | None) -> ListNode | None:
        pass
```

The first block is `judge.go`; `solution.go` holds only the package line and
`func reverseList(head *ListNode) *ListNode {}` with its empty body.

The step is done when the directory holds `solution.go`, `solution.py` and,
only if the stub needed one, `judge.go`, and nothing else in the repository
changed apart from the 🔒 or the judge API declarations above.

## 3. Reply

Reply in the language of the conversation, in this shape:

```markdown
**<number>. <title>** · <difficulty>
<url>
`<directory>/`
```

Close with one line saying that `/tutor <number>` gives hints one level at a
time. The problem is the user's to think through: the reply carries the
problem's identity and nothing about how to solve it. Commit nothing; the
files are a blank page until LeetCode accepts what the user writes in them.
