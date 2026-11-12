# Python

Authorities, in order; the higher one wins:

1. [The Python Language Reference](https://docs.python.org/3/reference/) and
   [PEP 8](https://peps.python.org/pep-0008/)
2. The [typing documentation](https://docs.python.org/3/library/typing.html)
   and the [standard library documentation](https://docs.python.org/3/library/)
3. The [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

## The newest idiom the judge allows

The judge runs the release in `pyproject.toml`'s `requires-python`. Which
syntax and standard-library APIs are newest changes with every release, so it
is not listed here; the tools track it:

- ruff's `UP` and `FURB` rules (in `make check`) propose the newest form that
  release allows, including builtin generics and `X | None`; pyright, set to
  the same release, rejects syntax or an API newer than it.
- When you consider an API and are not sure the judge's release has it, check
  [What's New in Python](https://docs.python.org/3/whatsnew/index.html) for
  the version that added it.

## What the tools do not check

Each rule names its source, so it can be checked against the source.

- **snake_case for every name the solution declares**: lowercase, words
  separated by underscores. The entry method and its parameters keep
  LeetCode's camelCase (`AGENTS.md`).
  ([PEP 8, Function and Variable Names](https://peps.python.org/pep-0008/#function-and-variable-names))
- **Comprehensions for simple cases only**: one `for` clause and at most one
  filter. Anything more is a loop.
  ([pyguide 2.7, Comprehensions & Generator Expressions](https://google.github.io/styleguide/pyguide.html#27-comprehensions--generator-expressions))
- **A nested function only when it closes over a local** other than `self`,
  as a DFS over the method's arguments does; otherwise it is a separate
  method.
  ([pyguide 2.6, Nested/Local/Inner Classes and Functions](https://google.github.io/styleguide/pyguide.html#26-nestedlocalinner-classes-and-functions))
- **A queue is `collections.deque`**, never a list: popping from a list's
  front is slow.
  ([Tutorial, Using Lists as Queues](https://docs.python.org/3/tutorial/datastructures.html#using-lists-as-queues))
- **Recursion depth is bounded** by
  [`sys.getrecursionlimit()`](https://docs.python.org/3/library/sys.html#sys.getrecursionlimit),
  1000 on a stock CPython. When the input can be deeper, such as a long
  linked list or a skewed tree, write it iteratively. This one is this
  repository's rule, not a style guide's: a solution that overflows the stack
  fails the judge.

Everything else this repository requires of a solution, such as no comments,
`class Solution`, and LeetCode's names untouched, is in `AGENTS.md`.
