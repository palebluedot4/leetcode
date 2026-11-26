# Python

Authorities, in order; the higher one wins:

1. [The Python Language Reference](https://docs.python.org/3/reference/) and
   [PEP 8](https://peps.python.org/pep-0008/)
2. The [typing documentation](https://docs.python.org/3/library/typing.html)
   and the [standard library documentation](https://docs.python.org/3/library/),
   and the [Tutorial](https://docs.python.org/3/tutorial/) and
   [FAQ](https://docs.python.org/3/faq/) where they state an idiom
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

- **snake_case for helper functions and their parameters**, which ruff's `N`
  rules leave unchecked because the entry point's camelCase is exempt; ruff
  already catches locals. The entry method and its parameters keep LeetCode's
  names (`AGENTS.md`).
  ([PEP 8, Function and Variable Names](https://peps.python.org/pep-0008/#function-and-variable-names))
- **A name's length follows its scope**: a short name, even one letter, for
  a loop variable or a local read within a few lines of where it is set; a
  word for a name read across a long function. pyguide keeps one letter to
  counters and iterators, but `AGENTS.md`'s short names outrank it, so a
  short local in a short method is not a change to make.
  ([pyguide 3.16.1, Names to Avoid](https://google.github.io/styleguide/pyguide.html#3161-names-to-avoid))
- **One name means one thing in a function, and one thing keeps one name.**
  Check every nested function's parameters against the enclosing locals:
  a parameter that shares a name with one must receive that local at every
  call. If any call passes it something else, the two mean different
  things; rename the parameter for what it receives.
  ([PEP 8, A Foolish Consistency is the Hobgoblin of Little Minds](https://peps.python.org/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds);
  [pyguide 2.16, Lexical Scoping](https://google.github.io/styleguide/pyguide.html#216-lexical-scoping))
- **An instance attribute is read in every method**, so it gets a word, not a
  letter, with one leading underscore: `self._buckets`.
  ([PEP 8, Method Names and Instance Variables](https://peps.python.org/pep-0008/#method-names-and-instance-variables);
  [pyguide 3.16.1, Names to Avoid](https://google.github.io/styleguide/pyguide.html#3161-names-to-avoid))
- **A name does not repeat its type**: `seen`, not `seen_set` or `seen_dict`.
  ([pyguide 3.16.1, Names to Avoid](https://google.github.io/styleguide/pyguide.html#3161-names-to-avoid))
- **Comprehensions for simple cases only**: one `for` clause and at most one
  filter. Anything more is a loop.
  ([pyguide 2.7, Comprehensions & Generator Expressions](https://google.github.io/styleguide/pyguide.html#27-comprehensions--generator-expressions))
- **A nested function only when it closes over a local** other than `self`,
  as a DFS over the method's arguments does; otherwise it is a separate
  method.
  ([pyguide 2.6, Nested/Local/Inner Classes and Functions](https://google.github.io/styleguide/pyguide.html#26-nestedlocalinner-classes-and-functions))
- **Loop over elements, not indices**: `for num in nums`, `enumerate()` when
  the index is needed too, `zip()` for two sequences, and `reversed(range(n))`
  rather than `range(n - 1, -1, -1)` to count down.
  ([Tutorial, Looping Techniques](https://docs.python.org/3/tutorial/datastructures.html#looping-techniques);
  [Programming FAQ, How do I iterate over a sequence in reverse order?](https://docs.python.org/3/faq/programming.html#how-do-i-iterate-over-a-sequence-in-reverse-order))
- **An empty sequence is false**: `if not nums`, never `if len(nums) == 0`.
  Compare an integer that is not a `len()` with `0` explicitly.
  ([PEP 8, Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations);
  [pyguide 2.14, True/False Evaluations](https://google.github.io/styleguide/pyguide.html#214-truefalse-evaluations))
- **Annotate a local only when its type cannot be inferred**, such as an empty
  container, as pyright's strict mode then requires; `n: int = len(nums)` is
  noise.
  ([pyguide 3.19.8, Typing Variables](https://google.github.io/styleguide/pyguide.html#3198-typing-variables))
- **A queue is `collections.deque`**, never a list: popping from a list's
  front is slow.
  ([Tutorial, Using Lists as Queues](https://docs.python.org/3/tutorial/datastructures.html#using-lists-as-queues))
- **Recursion depth is bounded** by
  [`sys.getrecursionlimit()`](https://docs.python.org/3/library/sys.html#sys.getrecursionlimit),
  1000 on a stock CPython, though the page does not state the default. When
  the input can be deeper, such as a long linked list or a skewed tree, write
  it iteratively. This one is this repository's rule, not a style guide's: a
  solution that overflows the stack fails the judge.
- **This repository's vocabulary**: an element of `nums` is `num`; its length,
  when named, is `n`; a result is named for what it holds, such as `top`,
  `groups`, `merged`, and `res` only when nothing better fits. This one is
  this repository's rule, not a style guide's; PEP 8 asks only that a project
  be consistent with itself.
  ([PEP 8, A Foolish Consistency is the Hobgoblin of Little Minds](https://peps.python.org/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds))

Everything else this repository requires of a solution, such as no comments,
`class Solution`, and LeetCode's names untouched, is in `AGENTS.md`.
