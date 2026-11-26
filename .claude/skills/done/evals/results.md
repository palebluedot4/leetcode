# Results

Summaries of eval runs; raw output is in the gitignored `results/`. The
skill is evaluated on the models it is used with, `claude-opus-5-5` and
`claude-sonnet-5-5`, each at its default effort.

Every cost below is the evaluator's estimate at API list prices. The runs
used a Claude plan login, not an API key, so they drew on the plan's usage
rather than being billed; the estimates still compare runs with each other.

## The cases

The two cases that reach `/polish` load it as a second plugin, through
their `prompt.md`'s `plugins`, so `/done` invokes the real skill. Each
case's `place-files.sh` copies `AGENTS.md` from this repository, and the two
that polish copy `go.mod`, `pyproject.toml` and `.golangci.yml` as well.

| Case                                  | Rule it checks                                                                                                        |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `commits-each-language-with-its-cell` | Clean files are not touched; two commits, Go first, each with its own cell of the list; no push; no doubt of the user |
| `asks-before-keeping-polish-changes`  | When `/polish` changes a file, nothing is committed until the user chooses, and a kept file is resubmitted first      |
| `stops-when-a-file-is-missing`        | With a language missing, nothing is polished or committed, and the missing file is named                              |

## 2026-11-26: after /polish's naming rules

`/polish` gained naming and loop rules, and Go sets became `map[T]bool`, so
`commits-each-language-with-its-cell`'s 0217 changed from `map[int]struct{}`
with a size hint to the repository's own `map[int]bool`; the old form is one
the new `/polish` would rewrite, against the case's premise that the files
are clean.

- **Setup:** as before, with Claude Code 2.1.332.
- **Result:** every case passed every run on both models.

| Model               | Runs passed | Estimated cost |
| ------------------- | ----------- | -------------- |
| `claude-opus-5-5`   | 9/9         | 3.71 USD       |
| `claude-sonnet-5-5` | 9/9         | 1.80 USD       |

The rounds before it found two gaps in the skill, each fixed:

- **A stop that did not say what it left undone.** With `solution.py`
  missing, Sonnet named the file and stopped, but did not say that nothing
  was committed. The skill now says to say it.
- **A commit sent with the cell's edit.** Opus sent the edit to the list and
  the commit in one step; the edit failed on a non-unique match, the commit
  went through without its cell, and an amend followed. The skill now waits
  for the edit to succeed before staging.

## 2026-11-13: final run

- **Setup:** `make eval SKILL=done`: `--ablation none`, three runs per
  case, threshold 1.0, judge `claude-sonnet-5-5`; Claude Code 2.1.323 with
  `DISABLE_AUTOUPDATER=1`.
- **Result:** every case passed every run on both models.

| Model               | Cases | Score | Estimated cost |
| ------------------- | ----- | ----- | -------------- |
| `claude-opus-5-5`   | 3/3   | 1.00  | 3.04 USD       |
| `claude-sonnet-5-5` | 3/3   | 1.00  | 1.65 USD       |

## How it got there

Four rounds. Every failure was in the eval, not the skill:

- **`/polish` never loaded.** A copy of it in the workspace's `.claude/`
  is ignored: an eval run loads only the plugins under test. The cases now
  name it in `plugins`, which can reach only plugins under the target, so
  `make eval` targets `.claude/skills` and picks the suite with
  `--eval-dir`.
- **`git` did not run.** Inside a run the shell resolves `git` to
  `/usr/bin/git` whatever `PATH` says, and the sandbox will not run that
  Xcode shim. Neither a `PATH` entry nor a function in the run's rc file
  changed that; a git called by its full path works. `make eval` passes it
  in as `EVAL_GIT`, and each case's `append_system_prompt` tells the model
  to use it. Without it, Opus worked around the shim and Sonnet stopped.
- **Graders matched the wrong thing.** `input_match` is matched against
  the whole JSON input, so editing the list's cell, whose link names
  `solution.go`, counted as editing the solution; it now matches only
  `file_path`. The commit and push counts accept `"$EVAL_GIT" commit`.
- **Claude Code was upgraded mid-run.** Homebrew replaced 2.1.322 with
  2.1.323 during one Sonnet run, and every run after it failed to start.
  `DISABLE_AUTOUPDATER` does not stop Homebrew.

## Limits

- No hook runs in the eval workspace: it has no `Makefile` and no
  `.githooks/`, so `make check` and the commit-msg check never gate the
  commits there. In real use they do, and `/done` stops when they fail.
- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes.
