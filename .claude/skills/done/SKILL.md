---
name: done
description: Finishes a problem both of whose solutions LeetCode accepted. Runs /polish, lets the user choose on anything it changed, then commits Go and Python separately, each commit filling its language's cell in lists/. Invoked by the user as /done <problem number>.
disable-model-invocation: true
argument-hint: <problem number, e.g. 0217>
---

# Done

`/done <number>` is the user's word that LeetCode accepted both
`solution.go` and `solution.py`; take it as given. What remains is the last
mile of `AGENTS.md`'s "Working a problem": polish, then one commit per
language, each filling that language's cell in the list.

Paths here are relative to the working directory, the repository's root.

## 1. Check the ground

- Find `problems/<number>-*/` from `$ARGUMENTS`, the number zero-padded to
  four digits. If `solution.go` or `solution.py` is missing, say which and
  stop: each language is accepted on its own, and both come first.
- `git diff --cached --name-only` must print nothing, because the commits
  below hold exactly what this skill stages. If something is staged, name it
  and stop.
- `git status --porcelain -- <directory>` says, for each file, whether it is
  new or changed. If neither solution file is new or changed, there is
  nothing to commit: say so and stop.
- Read both solution files, and keep what they say: if the user turns down a
  polished version, you put their own back.

## 2. Polish

Invoke the `polish` skill with the number and carry it out in full; its
report is for the user.

- **It changed nothing**: the solution is already what it should be. Go on
  to commit without asking.
- **It changed something**: after its report, ask for each changed file
  whether to keep the polished version or the user's own. A polished file
  has not been judged, so for each one kept, ask the user to resubmit it to
  LeetCode and wait for their word that it was accepted. For each one turned
  down, Write the user's original content back. Then commit.

## 3. Commit

One commit per language, Go first; a language whose files did not change
gets none. Finish each commit before starting the next, so that each holds
only its own cell.

1. **Cell.** In the list in `lists/`, find the row whose link carries this
   problem's number. If the language's cell is empty, set it to a link to
   the file, `[✓](../<directory>/solution.go)` or
   `[✓](../<directory>/solution.py)`, and change nothing else in the row.
2. **Stage** the solution file, the list if its cell changed, and what
   belongs to the language: `judge.go` with Go; with Python,
   `__builtins__.pyi` and `pyproject.toml` if they changed for this problem.
3. **Commit** with `git commit -m "<message>"`, the message per `AGENTS.md`'s
   "Commits", with no trailer:
   - A new file is `feat`: `feat(go): add 0217 contains duplicate`, the title
     from the list in lower case, shortened if the header would pass 72
     characters.
   - A file already committed is `perf` if its complexity changed,
     `refactor` if it reads better at the same complexity, `fix` if it
     corrects a wrong solution, and the description says what changed:
     `refactor(python): use counter in 0242 valid anagram`. Ask only if the
     kind is unclear.

The pre-commit hook runs `make check` and the commit-msg hook checks the
header. If either fails, show its output and stop: what to change is the
user's call, and the hooks are the gate, so they always run.

The step is done when `git log` shows one new commit per changed language,
each with its cell, and `git status -- <directory>` is clean.

## 4. Next

Show the new commits (`git log --oneline -<count>`). Then offer the next
problem, and if the user takes it, invoke the `next` skill. Pushing is the
user's to do.
