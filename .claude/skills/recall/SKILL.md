---
name: recall
description: Daily spaced-repetition review of accepted problems. Serves the problems due today one at a time, sets up a blank stub for each in .recall/, grades the user's re-solve against the committed solution, and schedules the next recall. Invoked by the user as /recall, and continued with "done" or "give up" in any language.
disable-model-invocation: true
---

# Recall

A recall is retrieval practice: the user writes a problem they solved before
into a blank file, from their grasp of the idea rather than from memory of
the code, and that effort is what makes it stick. So you serve the problem
bare, stay silent about the method while they work, and grade plainly
afterwards. The user wants the practice, not a score: the schedule keeps its
own record, and the user never needs to see it.

Paths here are relative to the working directory, the repository's root;
stay in it and never `cd` elsewhere. The schedule is `scripts/schedule.py`
beside this skill: run it with `python3` at its full path under this skill's
base directory, shown when the skill loads. The base directory is only where
the script lives, never the repository to work in. `.recall/` is gitignored;
it holds the schedule's log (`.recall/log`) and the current draft, one
problem directory at a time.

Every reply is in the language the user writes in, even when the files,
this skill and the problem are all in English.

## 1. Pick up or ask the schedule

A problem directory already in `.recall/` is a recall under way, from this
session or an earlier one, since a graded draft is always removed. Carry on
with it: grade it (step 4) if the user's message says they have finished or
give up, otherwise serve it again (step 3) without touching the drafts. That
directory is its `<draft>`, and the committed `<directory>` is the one of the
same name under `problems/`.

With no recall under way, run `schedule.py due`. It prints JSON: `due`, the
problems to recall now, most overdue first and already cut to the daily
limit; `recalled_today`; `daily_limit`; `backlog`, everything due now; and
`backlog_warning`. Each entry of `due` has the problem's `number`, its
committed `directory` (`problems/0217-contains-duplicate`) and its `draft`
(`.recall/0217-contains-duplicate`), the directory the recall happens in;
use each path as printed.

If `due` is empty, say why: either today's limit is reached
(`recalled_today` equals `daily_limit`) or nothing is due. When
`backlog_warning` is true, add that `backlog` problems are waiting, so the
time a new problem would take may be better spent on recall tomorrow. Then
offer the next new problem, and if the user takes it, invoke the `next`
skill. Otherwise, the first entry of `due` is today's next recall.

## 2. Set up the blank page

Create `<draft>/` with a stub derived from the committed files, which you
read with `git show HEAD:<directory>/<file>`:

- **`solution.go`**: the package line and the signature of every function
  and type LeetCode's stub declares (the entry function; for a design
  problem, the type with an empty body and its methods), each with an empty
  body.
- **`solution.py`**: the judge's data types the file opens with, if any, then
  `class Solution:` with the entry method's signature and `pass` (for a
  design problem, LeetCode's class and its methods' signatures).
- **`judge.go`**, if the problem has one, copied as it is.

That is the stub `/next` wrote before the user solved the problem: only what
LeetCode's own stub gives away. Helpers, imports, fields and alternative
solutions are the user's work, and a draft that shows them is a recall that
already happened.

## 3. Serve it

Find the problem's title and URL in its row in `lists/`, then reply in this
shape, where `<n>` is `recalled_today` plus one:

```markdown
<the grade, from step 4, when this turn graded a recall>

**Recall <n>/<daily_limit>** · <number>. <title>
<url>
`<draft>/solution.go` · `<draft>/solution.py`
```

The first part is there exactly when this turn graded a recall, and then it
is the whole grade the table asks for; the reply ends after the paths. The
problem's pattern, its section of the list, its difficulty and
anything about the old solution are all spoilers: each one hands over part
of the recall the user came to do. The user picks the language by the file
they write in, and submits it to LeetCode.

## 4. Grade

When the user says they are done, read both drafts; a draft still bare is
the language they did not use. Read the committed solution in the language
they wrote, at `HEAD`, and judge theirs against it. LeetCode's judge is the
only oracle (`AGENTS.md`): if they say it was rejected, it is wrong. A
verdict of wrong without the judge's word needs an input on which their
code fails, checked by working out both what it returns and the true
answer; use the input only if the two differ.

Pick the verdict by comparing the two algorithms and their time and space
complexity, not by how clean the code is: sorting where the committed
solution hashes is a different algorithm, so it is never Perfect.

The grade is the answer to the user's work, and logging never stands in for
it: it opens the final reply of the turn, above whatever follows. Open it
with the verdict's name, in the user's language, and where the table says to
show the committed solution, show its code in a code block.

| Verdict            | When                                                                                                 | Reply                                                                                                                    | Log     |
| ------------------ | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| Perfect            | The committed solution's algorithm, at its time and space complexity. Names and layout do not count. | One line saying so.                                                                                                      | `pass`  |
| Correct, different | Correct, by another algorithm or at another complexity.                                              | Say so, show the committed solution's code, and say in a few lines how the two differ: complexity, technique, trade-off. | `pass`  |
| Better             | Correct, at a better complexity than the committed solution.                                         | Say so, and that the committed file deserves the improvement: a `perf` commit, made outside `/recall`.                   | `pass`  |
| Wrong              | Rejected by the judge, or failing on an input.                                                       | The failing input with the expected and the actual answer, then what is wrong and why, then the committed solution.      | `reset` |

If the user gives up, show the committed solution and explain it: the idea,
the invariant it keeps, its complexity. That is a `reset`.

If the user asks for a hint, the recall is no longer from memory alone, so
say once that this recall will count as a reset, then give the least help
that unsticks them: first a question that points somewhere useful, then the
pattern's name, then the key insight, one level per request. Grade it as
above when they finish, and log `reset` whatever the verdict.

Record the verdict and clear the draft:

```bash
python3 <base directory>/scripts/schedule.py log <number> <pass|reset>
rm -r <draft>
```

`pass` and `reset` are the schedule's words, not the user's: the verdict
they hear is the one in the table.

## 5. Go on

Return to step 1, which asks the schedule again: it already counts the
recall just logged. The final reply is then step 3's shape with the grade
as its first part, or, with nothing left to recall, the grade followed by
what step 1 says.

## Where you write

Only in `.recall/`: the drafts, and the log through `schedule.py`, never by
hand. The committed solutions, `lists/` and git history stay as they are, so
nothing here is ever committed.
